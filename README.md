Ultimate Tournament
===================

[![Circle CI](https://circleci.com/gh/kevinhughes27/ultimate-tournament/tree/master.svg?style=svg&circle-token=4cdbaf7bb8107c054bbb6d22c52aa6bef97eb8e3)](https://circleci.com/gh/kevinhughes27/ultimate-tournament/tree/master)

A web application for running ultimate tournaments

[http://ultimate-tournament.io](https://www.ultimate-tournament.io)

[Internal Dashboard](https://www.ultimate-tournament.io/internal)

### Auth Providers

[Google Developer Console](https://console.developers.google.com/home/dashboard?project=ultimate-tournament)

[Facebook Developer Dashboard](https://developers.facebook.com/apps/754008491396080/dashboard/)


Docs
----

[USAU Tournament Formats](http://www.usaultimate.org/assets/1/AssetManager/Format%20Manual%20Version%204.3%20_7.1.08__updated%208.25.10_.pdf)


Development
-----------

postgres from [here](https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-ubuntu-14-04):

```
sudo apt-get install postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser -s ut
sudo -u postgres psql
postgres# \password ut
ut
ut
```

setup:

```
bundle install
bundle exec rake db:migrate
npm install
```


Updating Bracket Templates
--------------------------

**Changing UIDs:**

A bracket_db_diff can be used to update brackets with changed UIDs (but not to change the structure. Changing the structure is not solved yet if the bracket has been used.)

```
bundle exec rake dev:bracket_db:diff
```

inspect the diff and the run it on production:

```
heroku run rake m:process_bracket_db_diff
```

**Adding data:**

Since the UIDs aren't changing they can be used to identify the games and add the new data.


Gotchas
-------
Rails isn't smart enough to reload frozen record objects when the yml or json files are changed

Same issue when adding or changing brackets - you need to run `rake assets:clobber` before the changes will appear in JS.
