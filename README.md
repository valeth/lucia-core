# Lucia Core

Lucia's Cipher's main API endpoint.


## Requirements

* Ruby >= 2.6
* MongoDB >= 4.1
* Redis >= 4.0 (for Cache and Sidekiq)


## Development

> It is recommended to use `docker-compose` to set up the mongodb and redis instances.

First run `bundle install` to set up all necessary gems.

Copy the `.env.example` file to `.env` and edit the variables to match your setup.

Make sure the database is up and running, then run `bin/rake db:seed` to initialize database content for development.

After that simply run `bin/rails server -u puma` to start the server.


## Setup (Deployment)

Run `bundle install --deployment` to install all necessary gems.

Then there are multiple options to run this app:

* directly with `rails server`
* via an application server, like `Phusion Passenger`
* with `unicorn`
