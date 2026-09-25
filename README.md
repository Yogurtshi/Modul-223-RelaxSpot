# RelaxSpot

RelaxSpot is a Ruby on Rails multi-user application for finding calm and usable rest places in daily life. Users can browse approved places, check in while capacity is available, suggest new locations, and report issues such as closing times or dirty conditions. Moderators review submissions and manage place updates, while administrators manage users and roles.

The project includes a full documentation set, test coverage, and role-based access control for the core domain workflow.

## Features

- User registration and login
- Search and filtering of approved places
- Capacity-aware check-in flow
- Suggestion of new places by users
- Status reporting for problems and availability issues
- Moderator review of submitted places and reports
- Edit locks to avoid conflicting moderation changes
- Admin management of roles and account locks
- Activity-aware moderation dashboard

## Technology stack

- Ruby version: see [.ruby-version](.ruby-version)
- Rails 8.1.x
- SQLite 3
- ERB, Turbo, and Stimulus
- Pundit for authorization
- PaperTrail for activity tracking
- Minitest for automated tests

## Prerequisites

- Ruby version from [.ruby-version](.ruby-version)
- Bundler
- SQLite 3 development libraries

Node.js is not required because the app uses Rails import maps.

## Setup

Clone the project and install dependencies:

```sh
bundle install
```

Prepare the database:

```sh
bin/rails db:prepare
```

Load the seed data for demo accounts and initial records:

```sh
bin/rails db:seed
```

To recreate the database and reload sample data:

```sh
bin/rails db:reset
```

## Run locally

Start the development server:

```sh
bin/rails server
```

Then open:

```text
http://localhost:3000
```

If needed, inspect the development log:

```sh
tail -f log/development.log
```

## Demo accounts

After running `bin/rails db:seed`, you can sign in with the following local accounts:

| Role | E-mail | Password |
| --- | --- | --- |
| Administrator | `admin@relaxspot.local` | `relaxspot-admin-2026` |
| Moderator | `moderator@relaxspot.local` | `relaxspot-moderator-2026` |
| User | `user.one@relaxspot.local` | `relaxspot-user-one-2026` |
| User | `user.two@relaxspot.local` | `relaxspot-user-two-2026` |

These credentials are intended for local development and demonstration only.

## Main workflows

- Browse approved places and inspect their status and available capacity
- Register, log in, manage a profile, and update account details
- Suggest a new place for moderation review
- Report a place issue or temporary condition
- Check in at an approved place while respecting the capacity rule
- Review and approve or reject submissions as a moderator
- Manage user role assignments and locks as an administrator

## Testing

Run the full test suite:

```sh
bin/rails test
```

Run a specific area of the suite:

```sh
bin/rails test test/controllers/check_ins_controller_test.rb
bin/rails test test/policies
```

The test database is configured separately in [config/database.yml](config/database.yml).

## Documentation

The project documentation is stored in the [docs/](docs/) folder and includes:

- [docs/documentation.md](docs/documentation.md): complete project documentation with requirements, ERM, screens, and outcomes

## Project status

The application covers the main MVP flow for the first iteration, including: user login, place browsing, capacity-aware check-in, moderation, and admin role management.
