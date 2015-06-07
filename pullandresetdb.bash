#!/bin/bash

echo git fetch --all
git fetch --all
echo git reset --hard origin/master
git reset --hard origin/master
echo git pull
git pull
echo bundle exec rake db:drop
bundle exec rake db:drop
echo bundle exec rake db:create
bundle exec rake db:create
echo bundle exec rake db:migrate
bundle exec rake db:migrate