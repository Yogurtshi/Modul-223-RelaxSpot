# RelaxSpot

RelaxSpot is a multi-user community directory for places to pause, such as
seating areas, smoking areas, shade, and toilets. Visitors can discover
approved places. Registered users can suggest places, report changes, and
check in while capacity is available. Moderators review community submissions,
and administrators manage user accounts.

The project documentation, requirements traceability, and test evidence are
available in [`docs/`](docs/).

## Technology stack

- Ruby 4.0.6
- Rails 8.1.3.1
- SQLite 3
- ERB, Hotwire Turbo, and Stimulus
- Pundit for authorization
- PaperTrail for the activity log
- Minitest for automated tests

## Prerequisites

- Ruby 4.0.6 (see [`.ruby-version`](.ruby-version))
- Bundler
- SQLite 3 development libraries

Node.js is not required because the application uses Rails import maps.

## Setup

Clone the repository, enter the project directory, and install the Ruby
dependencies:

```sh
bundle install
```

Create and migrate the development database:

```sh
bin/rails db:prepare
```

Load the local demonstration data:

```sh
bin/rails db:seed
```

To recreate the development database and reload its demonstration data:

```sh
bin/rails db:reset
```

## Run locally

Start the Rails server:

```sh
bin/rails server
```

Open <http://localhost:3000>.

When a user requests an e-mail change, the confirmation URL is written to the
development log. Follow the log in another terminal if needed:

```sh
tail -f log/development.log
```

## Demo accounts

Run `bin/rails db:seed` first, then sign in with one of these local accounts:

| Role | E-mail | Password |
| --- | --- | --- |
| Administrator | `admin@relaxspot.local` | `relaxspot-admin-2026` |
| Moderator | `moderator@relaxspot.local` | `relaxspot-moderator-2026` |
| User | `user.one@relaxspot.local` | `relaxspot-user-one-2026` |
| User | `user.two@relaxspot.local` | `relaxspot-user-two-2026` |

These accounts and passwords are development-only seed data.

## Main workflows

- Browse approved places and see their capacity and current availability.
- Register, sign in, manage a profile, change a password, and confirm an
  e-mail-address change.
- Suggest a new place and submit a status or opening-hours report.
- Check in to an approved place. The application prevents overbooking and
  duplicate active check-ins for the same user and place.
- Review submitted places and reports as a moderator. Moderators use
  time-limited edit locks to avoid conflicting changes.
- Manage user details, roles, and account locks as an administrator.
- View recent core-domain activity in the moderation dashboard.

## Tests

Run the complete test suite:

```sh
bin/rails test
```

Run a focused test file or directory:

```sh
bin/rails test test/controllers/admin/users_controller_test.rb
bin/rails test test/policies
```

The test database is separate from the development database and is configured
in [`config/database.yml`](config/database.yml).

## Documentation

- [`docs/projektantrag_relaxspot.md`](docs/projektantrag_relaxspot.md):
  project proposal, domain, requirements, models, and design material.
- [`docs/requirements-and-testing.md`](docs/requirements-and-testing.md):
  requirement-to-implementation mapping and testing evidence.

## Security and local data

Do not commit credentials, secrets, local SQLite databases, or log files.
Seed-account passwords are intentionally public and must only be used for
local development and demonstrations.
