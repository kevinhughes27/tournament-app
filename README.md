Ultimate Tournament
===================

[![Circle CI](https://circleci.com/gh/kevinhughes27/ultimate-tournament/tree/master.svg?style=svg&circle-token=4cdbaf7bb8107c054bbb6d22c52aa6bef97eb8e3)](https://circleci.com/gh/kevinhughes27/ultimate-tournament/tree/master)

A web application for running ultimate tournaments

domain: [http://ultimate-tournament.io](http://ultimate-tournament.io)

production: [http://ultimate-tournament.herokuapp.com/](http://ultimate-tournament.herokuapp.com/)

Links
-----

[![heroku](http://i.imgur.com/5VVREDx.png)](https://dashboard.heroku.com/apps/ultimate-tournament)
[![newrelic](http://i.imgur.com/X4OJe4r.png)](https://rpm.newrelic.com/accounts/1045852/applications/9539779)
[![google-analytics](http://imgur.com/vZmWkmr.png)]https://analytics.google.com/analytics/web/?authuser=0#report/defaultid/a76316112w114919615p120118515/)
[![slack](http://i.imgur.com/FAx0EGq.png)](https://ocua.slack.com)

### Auth Providers

[Google Developer Console](https://console.developers.google.com/home/dashboard?project=ultimate-tournament)

[Facebook Developer Dashboard](https://developers.facebook.com/apps/754008491396080/dashboard/)

Docs
----

[USAU Tournament Formats](http://www.usaultimate.org/assets/1/AssetManager/Format%20Manual%20Version%204.3%20_7.1.08__updated%208.25.10_.pdf)

Gotchas
-------
Rails isn't smart enough to reload frozen record objects when the yml or json files are changed (although the asset pipeline is now thanks to some code I added. This can be fixed when I have time)

Same idea when adding brackets - you need to run `rake assets:clobber` before running the bracket render tests
