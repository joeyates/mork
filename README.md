# Mork

[![Build Status](https://github.com/joeyates/imap-backup/actions/workflows/main.yml/badge.svg)][CI Status]
![Coverage](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/joeyates/0ad88e9ac5abded0a579daf09b3dbc8f/raw/coverage.json)

[CI Status]: https://github.com/joeyates/imap-backup/actions/workflows/main.yml

Mozilla Thunderbird uses the [Mork database format](https://en.wikipedia.org/wiki/Mork_%28file_format%29) for its folder indexes.

This library reads in a Mork file and produces a `Mork::Data` instance.

This provides:

* `tables` - The top-level tables,
* `rows` - The top-level rows (i.e. rows not contained in tables).

## Usage

```ruby
require "mork/parser"

parser = Mork::Parser.new
content = File.read("MyFolder.msf")
raw = parser.parse(content)
data = raw.data
```

## Development

After checking out the repo, run `bundle` to install dependencies.
Then, run `rake spec` to run the tests.

To release a new version, update the version number in `version.rb`,
and then run `rake release`, which will create a git tag for the version,
push git commits and the created tag,
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joeyates/mork.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the [code of conduct](https://github.com/joeyates/mork/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mork project's codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/joeyates/mork/blob/main/CODE_OF_CONDUCT.md).
