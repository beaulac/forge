* Please note: this particular branch is currently unstable. *

Forge 3
=======

Forge 3: Makin' It Work
-----------------------

* have ruby 1.8.7 installed (inside rvm is okay)
* have bundler working

* cd ~/to/parent/directory
* git clone git@github.com:socialtech/forge3.git
* cd forge3
* bundle install --path vendor --without linux
* cp config/database.yml.template config/database.yml
* cp config/settings.yml.template config/settings.yml
* cp config/s3.yml.template config/s3.yml
* edit config/database.yml
* edit config/settings.yml
* (optionally) edit config/s3.yml
* mkdir log
* bundle exec rake db:create
* bundle exec rake db:schema:load
* bundle exec rake db:test:prepare
* bundle exec rake forge:load_help
* bundle exec rake forge:deploy
* bundle exec rails server
* navigate to http://localhost:3000/forge
* login with admin@factore.ca, admin

Stuff You Must Know
-------------------

To use bundle install, use:
  bundle install --path vendor.

On OS X, use:
  bundle install --path vendor --without linux

To run the specs once:

  bundle exec rspec spec/

To run the specs in continuous integration mode:

  bundle exec guard


Stuff You Should Do
-------------------

* edit config/settings.yml
* ensure your 404, 500 and 422 pages have the information you want on them
* add a secret token to config/initializers/secret_token.rb


Project Organization
--------------------

Organization is critical for this version of Forge.  Consistent focus on organized, clean, reusable, maintainable and modular code is key.

* Shared Forge views go in app/views/forge/shared, not app/views/shared/forge
