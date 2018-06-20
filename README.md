Ultimate Tournament
===================

[![Circle CI](https://circleci.com/gh/kevinhughes27/ultimate-tournament/tree/master.svg?style=svg&circle-token=4cdbaf7bb8107c054bbb6d22c52aa6bef97eb8e3)](https://circleci.com/gh/kevinhughes27/ultimate-tournament/tree/master)

Contents
--------
* **Setup**
  * [**Ruby**](#ruby)
  * [**Node**](#node)
  * [**Postgres**](#postgres)
  * [**Dependencies**](#dependencies)
* [**Development**](#development)
  * [**Creating a Tournament locally**](#creating-a-tournament-locally)
  * [**API**](#api)
  * [**Clients**](#clients)
  * [**Tests**](#tests)
  * [**Production Check**](#production-check)
* **Clients**
  * [**Admin**](#admin)
  * [**Admin Next**](#admin-next)
  * [**Player App**](#player-app)
* [**Operations**](#operations)

## Setup

### Ruby

You will need a new version of Ruby (system versions are always too old). You can see which version of Ruby a project is currently using by checking the Gemfile.

To install ruby and change between versions I use:
* [ruby-install](https://github.com/postmodern/ruby-install)
* [chruby](https://github.com/postmodern/chruby)

I've automated this for new linux systems in my [setup-script](https://github.com/kevinhughes27/setup-script/blob/master/bootstrap.sh#L129)

You can check your Ruby version by running `ruby -v` in your terminal to make sure everything worked. Note that you'll need to reload your terminal after installing `chruby` for it to work.

After installing a new version of Ruby remember to install `bundler` Ruby's dependency manager. To do this run `gem install bundler`

### Node

You will also need to install Node in order to compile the clients. The older system version might work fine but I like using new shit.

```sh
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install nodejs
```

Node ships with a package manager called `npm` but Facebook released an improved package manager called `yarn` which is superior. Install `yarn` by running:

```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update && sudo apt-get install yarn
```

### Postgres

We use [Postgresql](https://www.postgresql.org/) for our database in both production and development.

```sh
sudo apt-get install postgresql postgresql-server-dev-all postgresql-client
```

In production database access is protected by a password however for development this is not necessary. Postgres (rightly so) defaults to a protected configuration which you'll need to edit.

[This gist](https://gist.github.com/p1nox/4953113) outlines the process. You only need to follow the `Configuration` instructions.

### Dependencies

With all the system requirements taken care of we can install the project specific dependencies for both Ruby and Javascript. In the project directory run:

```
bundle install
```

to install all the Ruby dependencies (gems). Then:

```
yarn install
```

Which will install the javascript dependencies for each client. The clients are configured in the root `package.json` file as `subPackages`.

## Development

Exactly how you run the application will vary depending on what you are working on.

### Creating a Tournament locally

To create a Tournament locally with some data you'll need to build the legacy admin client and run the Rails server:

```sh
cd client && yarn build # or build all the clients with `yarn build` in the root directory
bundle exec rails server
```

Rails will start on `http://localhost:3000` however because the app uses subdomains for tournaments we use `http://lvh.me:3000` to access it since it behaves properly with subdomains.

Visit `lvh.me:3000` and signup for a new tournament. I typically call my test tournament
 `No Borders` with the handle `no-borders` and other documentation may reference `http://no-borders.lvh.me:3000`.

I usually do the following to create a realistic tournament quickly:
* Visit the Teams page and import the `teams.csv` file from `/test/fixtures/files`
* Create a Map, Search for Ultimate Park and pick the one that says Manotick
* Import fields from fields.csv also from `/test/fixtures/files`
* Create a new 8 team division
* Add all the teams to this division by selecting them all on the team page and using the bulk action dropdown
* Go back to the division page and seed the division
* Submit or Edit scores if you need
* Schedule games if you need

### API

To work on the API you only need to run the Rails server:

```
bundle exec rails server
```

GraphQL ships with a console that is accessible at: `http://no-borders.lvh.me:3000/graphiql` or whatever your tournament subdomain is. Graphiql is the best way to explore the API and test new additions or changes.

### Clients

To develop on a client check the client's own readme for instructions on how to  run the development version.

Most clients will have a development server which supports fancy things like hot reloading and helpful crash handling. Generally a client will be started with `yarn start` and the output of this command will say where the app is accessible (e.g. localhost:4000)

Because the development server will run the development version on a new localhost port most clients are configured to proxy API calls back to the Rails server. You'll need to run the rails server as well and make sure the proxy matches the tournament you want (the default will be `no-borders`).

### Tests

Tests for the server or integration tests are run using `rails test`.

This command supports running all tests in a give folder or one test file. A single test can be ran as well by supplying a regex to the command e.g. `rails test test/api/auth_test.rb -n /auth/`

In general I prefer testing everything through the API directly with a handful of unit tests for small things. Currently clients are tested through browser tests but new clients may have their own test suites.

### Debugging

To debug I will place `byebug` in the code where I would like to inspect what is happening.

The Rails console `bundle exec rails console` can also be useful to look at the database through Rails or create fake data manually.

### Production Check

To run the app exactly the way it is run in production:

```
yarn build
foreman start
```

This will build all the clients and start both a web process and worker process

## Clients

### Admin

[[Deprecated]](https://github.com/kevinhughes27/ultimate-tournament/issues/750)

There should be no new development on the old admin client unless it is to maintain a minor compatibility for the API as the new admin client is developed.

This client does not have a development server so you'll need to run `yarn build` after making any changes.

Some of the config here might not make much sense since a) React on Rails is more complicated than it needs to be and b) I removed a bunch of the config since we're not developing on it anymore and I wanted to remove some clutter.

Note - Any new react component needs to be added to clientRegistration.js and registered for use with React On Rails.

### Admin Next

New Admin client under development. See main issue [here](https://github.com/kevinhughes27/ultimate-tournament/issues/750)

### Player App

The public facing client for a tournament. It is developed as a stand alone React application that is compiled and served by Rails in production. Development takes place in a [separate repo](https://github.com/kevinhughes27/ut-player-app)

It is connected using a git `submodule`. To initialize the module run `git submodule update --init`.

If you need to update the player app to deploy a new version first enter the directory `cd clients/player-app`, checkout master `git checkout master` and run `git pull`. Check the status afterwards `git status` and it will show updates that you will need to commit like normal (it will look different than normal commit diff though because git knows it's a submodule).

## Operations

Staff accounts can login to any tournament using their account to debug a tournament

[Internal Dashboard](https://www.ultimate-tournament.io/internal)

**Identity Providers:**
- [Google Developer Console](https://console.developers.google.com/home/dashboard?project=ultimate-tournament)
- [Facebook Developer Dashboard](https://developers.facebook.com/apps/754008491396080/dashboard/)
