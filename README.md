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

setup:

```
bundle install
bundle exec rake db:migrate
npm install
```

Gotchas
-------
Rails isn't smart enough to reload frozen record objects when the yml or json files are changed (although the asset pipeline is now thanks to some code I added. This can be fixed when I have time)

Same idea when adding brackets - you need to run `rake assets:clobber` before running the bracket render tests
