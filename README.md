# RelaxSpot

RelaxSpot is a Rails application for finding community-managed places to
pause, checking in while capacity is available, and reporting place status.
Moderators review places and reports; administrators manage users.

## Prerequisites

- Ruby 4.0.6
- Bundler
- SQLite3
- Node.js is not required for the default importmap setup

The application uses Rails 8.1.3.1, SQLite, Hotwire, Pundit, and PaperTrail.

## Setup

```sh
bundle install
bin/rails db:prepare
```

To reset the development database and load seed data:

```sh
bin/rails db:reset
```

## Run locally

```sh
bin/rails server
```

Open http://localhost:3000. The development log contains the email
confirmation link when a user requests an email change.

## Test

Run the complete test suite with:

```sh
bin/rails test
```

Focused tests can be run by passing a file or directory, for example:

```sh
bin/rails test test/controllers/admin/users_controller_test.rb
bin/rails test test/policies
```

## Main workflows

- Visitors can browse approved places and register an account.
- Signed-in users can suggest places, report status, and check in.
- Moderators can review places and reports through the moderation dashboard.
- Administrators can promote, demote, lock, unlock, and edit users.

## Production notes

Set the required Rails credentials and environment variables for the target
deployment. Do not commit local databases, logs, credentials, or secrets.
