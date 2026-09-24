# Requirements and Test Evidence

## Requirement mapping

| Requirement | Implementation | Tests |
| --- | --- | --- |
| Registration and login | `UsersController`, `SessionsController`, `User` | `test/controllers/users_controller_test.rb`, `test/controllers/sessions_controller_test.rb`, `test/models/user_test.rb` |
| Approved place directory | `PlacesController`, `Place` | `test/controllers/places_controller_test.rb`, `test/models/place_test.rb` |
| Capacity-limited check-in | `CheckIn.create_with_capacity!` with a locked place transaction | `test/models/check_in_test.rb`, `test/controllers/check_ins_controller_test.rb` |
| Check-in ownership | `CheckInPolicy` and scoped lookup in `CheckInsController` | `test/policies/check_in_policy_test.rb`, `test/controllers/check_ins_controller_test.rb` |
| Place suggestions and status reports | `PlacesController`, `StatusReportsController` | `test/controllers/places_controller_test.rb`, `test/controllers/status_reports_controller_test.rb` |
| Moderation approval and edit locks | `Moderation::PlacesController`, `PlacePolicy` | `test/controllers/moderation/places_controller_test.rb`, `test/policies/place_policy_test.rb` |
| Status report review | `Moderation::StatusReportsController`, `StatusReportPolicy` | `test/controllers/moderation/status_reports_controller_test.rb`, `test/policies/status_report_policy_test.rb` |
| User administration | `Admin::UsersController`, `UserPolicy` | `test/controllers/admin/users_controller_test.rb`, `test/policies/user_policy_test.rb` |
| Profile and email confirmation | `ProfileController`, `ProfilePolicy` | `test/controllers/profile_controller_test.rb`, `test/policies/profile_policy_test.rb` |
| Role-based access and HTTP 403 responses | Pundit authorization and forbidden error view | controller authorization tests and policy tests |
| Activity history | PaperTrail on places, check-ins, and status reports | moderation controller tests |

## Latest test run

The complete suite was run with:

```sh
bin/rails test
```

Result: 71 tests, 188 assertions, 0 failures, 0 errors, 0 skips.

## Test effectiveness exercise

The `CheckInPolicy#create?` rule was temporarily changed to always return
`false`. The focused check-in and policy tests then failed with 5 failures.
The rule was restored and the same command passed with 9 tests, 15
assertions, and 0 failures.