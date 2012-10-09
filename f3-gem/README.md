# To-Do

* Get the initial migration created in f3-rails and have it copied over by the generator
* Figure out what to do about the stuff in /lib
* Figure out how to deal with the Gemfile dependencies...should these be dependencies of the gem???
* Deal with application.rb, routes.rb, and other files that will overwrite the originals if we are not careful
* Deal with mismatched constant names - e.g. the original project will refer to Forge as the application, but
  the new application will have whatever it is called as the application.  E.g. if the new application is called
  MyNewApp, then that will conflict with Forge
* Deal with config/s3.yml and config/settings.yml

# How the gem operates

1. Start by creating a new rails project
2. Add Forge as a gem dependency
3. Run rails generate f3:install and follow the prompts.  This will copy a lot of files over into your project.
4. The files that were copied into your project are the ones from Forge that make your application work.  Additionally,
   some files will be included via the gem, typically the ones in /lib in this project.

# Setting up Forge as a gem

The basic goal is to be able to easily work on Forge as a Rails app, and then grab your changes, put them into the
gem, and release it.

Thus, the structure is as follows:

        F3 Source Repository          Gem Host
                  |                       ^
    -------------------------------       |
    |                             |       |
  Rails App    --            Gem Source --^
    * /app      |               * bin
    * /config   |-------------->* lib
    * etc.     --               * etc.


This means that I need to set up the gem in a subfolder of the Rails project.

In order to be able to work on the parts of the gem locally that will remain in Forge as part of the gem, I will likely
want to be able to include them into the root project, perhaps simply be including them via the include lines in the
application initializers.

When the gem runs, it will be running a generator.  This generator will be responsible for pulling stuff out of itself
and dumping them into the Rails project from which it is running.

In order to get started with this I need to accomplish the following:

1. Include the /app folder inside the gem
2. Set up a generator in the gem
3. Package the gem
4. Fire up a fresh Rails project
5. Run rails generate forge_install: good stuff should happen.

It's not inconceivable that I could run the generator from within this application, but I'll start with a third-party
application first.


# Including portions of the Rails app in the gem

My first attempt at this was as follows:

  s.files        = Dir.glob("{bin,lib}/**/*") + Dir.glob("../app/**/*") + %w(README.md)

Where "..app/**/*" points into the app folder in the Rails portion of the project.  However, when installing the gem
this does not work, since the gem tries to install this folder in one folder up from its current location, which is
disallowed.

I'm going to try symlinking lib/forge-rails to the rails app.  However, this requires that I move the entire rails app
into a separate folder, because otherwise the linking will be circular (recursive).  Having separate folders probably makes
sense, in any case.

* One unpleasant side-effect of this change is that Command-T follows the symlink...I have resolved this temporarily
  by ignoring the folder f3-rails in Command-T's configuration. *

# Development workflow

There are a handful of tasks to assist with development.

The gem depends on the f3-rails folder being accessible via the templates folder, so you need to copy the f3-rails
folder there.  To do this use

  rake copy

To uninstall the gem, build it, and install it, use

  rake fresh

You'll need a Rails project to test things out in as well.  In that project, you will want to provide a local path to
the gem in your Gemfile, e.g.

  gem 'f3', :path => "~/www/forge/f3-gem"
