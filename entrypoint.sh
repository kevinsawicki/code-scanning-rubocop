#!/bin/sh

set -x

cd $GITHUB_WORKSPACE

# Install correct bundler version
gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"

bundle install

bundle inject code-scanning-rubocop 0.2.0

bundle exec rubocop --require code_scanning --format CodeScanning::SarifFormatter -o rubocop.sarif

if [ ! -f rubocop.sarif ]; then
    exit 1
else
    exit 0
fi
