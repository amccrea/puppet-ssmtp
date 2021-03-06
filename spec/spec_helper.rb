require 'coveralls'
Coveralls.wear! do
  add_filter '/pkg/'
  add_filter '/spec/'
  add_filter '/tests/'
end

require 'puppetlabs_spec_helper/module_spec_helper'

require 'rspec-puppet'
require 'rspec-puppet-facts'
include RspecPuppetFacts

require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.before :each do
    # Ensure that we don't accidentally cache facts and environment
    # between test cases.
    Facter::Util::Loader.any_instance.stubs(:load_all)
    Facter.clear
    Facter.clear_messages

    # Store any environment variables away to be restored later
    @old_env = {}
    ENV.each_key {|k| @old_env[k] = ENV[k]}

    if ENV['STRICT_VARIABLES'] == 'yes'
      Puppet.settings[:strict_variables]=true
    end
  end

  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.environmentpath = File.join(Dir.pwd, 'spec')

  c.after :each do
    PuppetlabsSpec::Files.cleanup
  end
end
