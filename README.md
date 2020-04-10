# ForkBreak exception raise example

This is a small example rails app, showcasing a use case for database locking
that raises an exception if the model has already had an action done on it.

## Requirements

* postgresql (could switch out for another database. sqlite3 is not an option as we need to have multiple processes using the database concurrently)

* Ruby 2.5+

## Setup

Create database and run migrations:

```sh
RAILS_ENV=test rake db:create db:migrate
```

## Run Tests

```sh
rake test
```

With ForkBreak debugging enabled:

```sh
DEBUG=true rake test
```
