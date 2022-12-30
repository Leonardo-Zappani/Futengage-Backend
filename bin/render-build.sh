#!/usr/bin/env bash
# exit on error
set -o errexit

bundle config --local without "development test omit"
bundle install --jobs 4 --retry 5
yarn install

bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate