---
title: Efficient Uniqueness Validations
date: 2014-12-05 13:31 NZDT
tags:
summary: Use <code>:if => :field_changed?</code> on uniqueness validations to skip unnecessary checks on every save.
featured: true
---

Although ActiveRecord uniqueness validations aren't bullet-proof,[^1] they're often helpful. Unfortunately, they can add overhead to save operations, since they require an extra call to the database. Consider the following simple ActiveRecord class:

~~~ruby
class SubscriptionPlan < ActiveRecord::Base
  validates :code, uniqueness: true
  validates_uniqueness_of :name
end
~~~

When we try to create this we'll see two SELECT queries as we'd expect.

     >> SubscriptionPlan.create! name: 'Starter - 100', code: 'starter-100'
       (0.2ms)  BEGIN
      SubscriptionPlan Exists (2.1ms)  SELECT  1 AS one FROM "subscription_plans"  WHERE "subscription_plans"."code" = 'starter-100' LIMIT 1
      SubscriptionPlan Exists (0.2ms)  SELECT  1 AS one FROM "subscription_plans"  WHERE "subscription_plans"."name" = 'Starter - 100' LIMIT 1
       (0.1ms)  ROLLBACK
    ActiveRecord::RecordInvalid: Validation failed: Code has already been taken, Name has already been taken

But what about when we update an existing record?

    >> plan.update_attributes! quota: 99
       (0.2ms)  BEGIN
        SubscriptionPlan Exists (0.4ms)  SELECT  1 AS one FROM "subscription_plans"  WHERE ("subscription_plans"."code" = 'starter-100' AND "subscription_plans"."id" != 1) LIMIT 1
        SubscriptionPlan Exists (0.2ms)  SELECT  1 AS one FROM "subscription_plans"  WHERE ("subscription_plans"."name" = 'Starter - 100' AND "subscription_plans"."id" != 1) LIMIT 1
      SQL (0.7ms)  UPDATE "subscription_plans" SET "quota" = $1, "updated_at" = $2 WHERE "subscription_plans"."id" = 1  [["quota", 99], ["updated_at", "2014-12-05 00:40:59.969458"]]
       (0.3ms)  COMMIT

We still get two queries to check if the code and name are unique. These are almost certainly pointless, since neither the name or the code have changed, but they're being checked anyway. On massive tables, these can be costly queries, even with well designed indexes.

### ActiveModel::Dirty to the Rescue

Fortunately, it's quite simple to keep these queries in check. [ActiveModel::Dirty][ar-dirty-api] lets us check if any fields were changed since the record was loaded.

~~~ruby
class SubscriptionPlan < ActiveRecord::Base
  validates :code, uniqueness: { if: :code_changed? }
  validates_uniqueness_of :name, if: :name_changed?
end
~~~

Now, create operations behave the same as before, validating the uniqueness of the fields. Likewise if we update one of those fields, it will query only the fields it needs to check.

On the other hand, an update that doesn't affect those fields won't incur the cost of those potentially expensive SELECTS.

    >> plan.update_attributes! quota: 99
       (0.2ms)  BEGIN
      SQL (0.7ms)  UPDATE "subscription_plans" SET "quota" = $1, "updated_at" = $2 WHERE "subscription_plans"."id" = 1  [["quota", 99], ["updated_at", "2014-12-05 00:40:59.969458"]]
       (0.3ms)  COMMIT

This is much better. However, I think we can do better still. In a future post I'll look at ways we can bypass manual uniqueness validations entirely.

[^1]: Application level uniqueness checks are subject to race conditions, since they use separate check and set queries. They should (almost) always be used in conjunction with a unique index at the database level. See the [validates_uniqueness_of docs][ar-uniquness-docs] for more details.

[ar-dirty-api]: http://api.rubyonrails.org/classes/ActiveModel/Dirty.html
[ar-uniquness-docs]: http://api.rubyonrails.org/classes/ActiveRecord/Validations/ClassMethods.html#method-i-validates_uniqueness_of
