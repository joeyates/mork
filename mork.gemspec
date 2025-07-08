# frozen_string_literal: true

require_relative "lib/mork"

Gem::Specification.new do |spec|
  spec.name = "mork-parser"
  spec.version = Mork::VERSION
  spec.authors = ["Joe Yates"]
  spec.email = ["joe.g.yates@gmail.com"]

  spec.summary = "Parse Mork databases (as used by Mozilla Thunderbird)"
  spec.homepage = "https://github.com/joeyates/mork"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = File.join(spec.homepage, "blob/main/CHANGELOG.md")
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.glob("lib/**/*.rb")
  spec.files += ["mork.gemspec"]
  spec.files += %w[LICENSE.txt README.md]
  spec.bindir = "exe"
  spec.executables = []
  spec.require_paths = ["lib"]

  spec.add_dependency "racc", "~> 1.7"
end
