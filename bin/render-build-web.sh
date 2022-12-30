#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install --jobs 4 --retry 5
yarn install

bin/rails assets:clean
bin/rails assets:precompile
bin/rails db:migrate