# Esse Kaminari Plugin

This gem is a [esse](https://github.com/marcosgz/esse) plugin for the [kaminari](https://github.com/amatsuda/kaminari) pagination.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'esse-kaminari'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install esse-kaminari

## Usage

```ruby
@search = UsersIndex.search(params[:q]).page(params[:page]).per(10)

<%= paginate @search.results %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake none` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcosgz/esse-kaminari.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
