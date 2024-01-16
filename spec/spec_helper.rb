# frozen_string_literal: true

support_glob = File.join(__dir__, "support", "**", "*.rb")
Dir[support_glob].sort.each { |f| require f }
