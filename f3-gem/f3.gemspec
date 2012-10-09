# encoding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'version'

# this is built using these instructions: http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended/
Gem::Specification.new do |s|
  s.name = "f3"
  s.version = F3::VERSION
  s.homepage = "http://github.com/factore/forge"
  s.license = "MIT"
  s.summary = "The Forge CMS as a gem."
  s.description = "The Forge CMS as a gem."
  s.email = "admin@factore.ca"
  s.authors = ["Sean Roberts", "Brian Potstra", "Adrian Duyzer", "Jamie Allen", "Marc Kelsey", "Martin Eckart"]

  s.required_rubygems_version = ">= 1.5.2"

  s.add_development_dependency 'rack'
  s.add_development_dependency 'rake', '0.9.2'
  s.add_development_dependency 'rails', '= 3.2.1'

  # I no longer know how this is managing to pull in the f3-rails directory...since the symlink does not exist right now!
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  s.require_path = 'lib'
end
