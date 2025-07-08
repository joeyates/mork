# frozen_string_literal: true

require "simplecov"

support_glob = File.join(__dir__, "support", "**", "*.rb")
Dir[support_glob].each { |f| require f }
