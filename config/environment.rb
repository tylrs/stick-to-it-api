# Load the Rails application.
require_relative "application"

local_vars = File.join(Rails.root, "config", "local_vars.rb")
load(local_vars) if File.exist?(local_vars)
# Initialize the Rails application.
Rails.application.initialize!
