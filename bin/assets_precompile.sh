#! /bin/bash

# Compile assets
if [ "${ASSETS_PRECOMPILE}" = "true" ]
then
  bundle exec rails assets:precompile
fi