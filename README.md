Ultimate Tournament
===================

Ultimate Tournament is a side project I worked on from around 2015 to 2019. It was a great avenue to explore all the aspects of building and operating a software as a service (SASS) product on my own. About a dozen tournaments (including several by Ultimate Canada) were organized and ran using Ultimate Tournament before I decided that I no longer wanted to support the application.

During its lifetime I used Ultimate Tournament to explore many different software architectures and patterns. This project helped me gain experience, develop opinions and grow as an engineer. I have no doubt this project helped me arrive to where I am in my career today.

It started off as a very traditional Rails application using turbolinks and javascript as necessary. After the initial backend was complete I became interested in making the user interface very rich in terms of filtering and live updating as scores were submitted. I ran into difficulties achieving what I wanted using what was available at the time for open source Rails UI - this led me to learn React and GraphQL to rebuild the interface. React did allow me to more easily leverage open source UI components but certainly added other complexities.

Using Ultimate Tournament I also explored different approaches for organizing buisness logic. Initially I used ActiveModel callbacks and then transitioned to structured service objects using ActiveOperation before ultimately only having GraphQL mutations. I developed a primarily integration and e2e based testing approach which I still prefer on most projects today.

The project had a couple of other interesting features:
* A custom GeoJSON editor for building field maps. It featured an "orthogonalize" button to square of a hand drawn field and undo/redo functionality
* An offline/spotty connection friendly PWA for players at the tournament. Score submissions were saved to localstorage and marked submitted after the server acknowleded receipt
* The BracketDb DSL for defining complicated tournament structures (from USAU). The frontend could visualize these using a D3 force graph. The structures were also tested in a number of ways including simulations to ensure they could be completed.

By far the most challenging aspect of of Ultimate Tournament was the schedule editor. It underwent many iterations to try and find the best way to express the complexity of the tournament structure while making it easy for a TD to assign games to field and time slots. The original implementation was spreadsheet esque and may have been the best overall. Subsequent versions were more calendar like which was more flexible but less efficient to use. A final version that combined the best of both implementations was designed but never built.

Another difficult aspect of tournament software is balancing the complexity, editability and correctness of tournament formats. Ultimate Tournament never supported user editable formats although it was something I eventually planned to build. This feature is important because often tournaments are adjusted mid-way through for a variety of factors. Without this feature direct support was often required on the final day of the tournament or organizers had to improvise. The lack of this feature is one of the main reasons I decided to halt development.

I've open sourced Ultimate Tournament because in a lot of ways it serves as a reference point for me personally on how I like to work with Rails. I learned a lot about web development on this project and frequently refer to it; now I can more easily share parts of it with others when desired.


Contents
--------
* [**Setup**](#setup)
  * [**Ruby**](#ruby)
  * [**Node**](#node)
  * [**Dependencies**](#dependencies)
  * [**Docker**](#docker)
* [**Development**](#development)
  * [**Creating a Tournament locally**](#creating-a-tournament-locally)
  * [**API**](#api)
  * [**Clients**](#clients)
  * [**Tests**](#tests)
  * [**Production Check**](#production-check)
* [**Clients**](#clients)
  * [**Admin**](#admin)
  * [**Player App**](#player-app)
* [**Operating**](#operating)


## Setup

### Ruby

You will need a new version of Ruby (system versions are always too old). You can see which version of Ruby a project is currently using by checking the Gemfile.

To install ruby and change between versions I use:
* [ruby-install](https://github.com/postmodern/ruby-install)
* [chruby](https://github.com/postmodern/chruby)

You can check your Ruby version by running `ruby -v` in your terminal to make sure everything worked. Note that you'll need to reload your terminal after installing `chruby`.

After installing a new version of Ruby remember to install `bundler` Ruby's dependency manager. To do this run `gem install bundler`


### Node

You will also need to install Node in order to compile the clients. The older system version might work fine but I like using new shit.

```sh
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install nodejs
```

Node ships with a package manager called `npm` but Facebook released an improved package manager called `yarn` which is superior. Install `yarn` by running:

```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update && sudo apt-get install yarn
```


### Dependencies

With all the system requirements taken care of we can install the project specific dependencies for both Ruby and Javascript. In the project directory run:

```
bundle install
```

to install all the Ruby dependencies (gems). Then:

```
yarn install
```

Which will install the javascript dependencies for each client. The clients are configured in the root `package.json` file as `subPackages`. To update yarn dependencies run yarn from the client's directory since the root yarn install specifies `--frozen-lockfile`.


### Docker

We use docker and docker-compose to manage the required services for development:
  
  * [Postgresql](https://www.postgresql.org/) for our database
  * [Redis](https://redis.io/) for a key value store

To start the required services run `docker-compose up -d` (will require `sudo` on linux).

Afterwards run `bundle exec rails db:setup` to have Rails create the database.


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
* Visit the Teams page and import the `teams.csv` file from `test/fixtures/files`
* Create a Map, Search for Ultimate Park and pick the one that says Manotick
* Import fields from fields.csv also from `test/fixtures/files`
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

The API schema differs based on the current user's permissions. Parts of the API are public (for the public clients) and others are only for admins. Graphiql does not support login directly but it will pass credentials from cookies along. If you need to use Graphiql to test these parts then login to the admin locally and refresh Graphiql.


### Clients

To develop on a client check the client's own readme for instructions on how to run the development version.

Most clients will have a development server which supports fancy things like hot reloading and helpful crash handling. Generally a client will be started with `yarn start` and the output of this command will say where the app is accessible (e.g. `localhost:4000`). Convience helpers to start clients may be added to the root `package.json` file (e.g. `yarn dev:admin`).

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

To work on the admin locally you need to run 2 processes: the webpack development server and the Rails server for the GraphQL API.

```
# webpack development server
cd clients/admin
yarn start

# rails server
bundle exec rails server
```

The webpack development server proxies all requests to `no-borders.lvh.me:/3000` which is the default development tournament. The proxy is configurable in the admin `package.json`.

Admin uses Apollo to make queries to the GraphQL API. There is a compile step in order to generate types which consumes the entire schema. To dump the schema run this rake task: `bundle exec rake dump_schema`. There is a test to ensure the committed schema file is up to  date so this is only necessary if you make a change to the schema. Types will be regenerated if you change a query in the client code but the process needs to be restarted if you dump a new version of the schema.

`yarn start` runs the development server and the type generator in parallel. However if the generator fails it may be easier to debug on its own using `yarn generate-types`.


### Player App

The public facing client for a tournament. It is developed as a stand alone React application that is compiled and served by Rails in production.


## Operating

Staff accounts can login to any tournament using their account to debug a tournament

[Internal Dashboard](https://www.ultimate-tournament.io/internal)


**Identity Providers:**
- [Google Developer Console](https://console.developers.google.com/home/dashboard?project=ultimate-tournament)
- [Facebook Developer Dashboard](https://developers.facebook.com/apps/754008491396080/dashboard/)
