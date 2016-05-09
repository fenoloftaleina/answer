# Answer

A json-renderable result object working well with AR, AM Serializers, and Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'answer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install answer

## Usage

```ruby
Answer.new(object, success, status, serializer)
```

Best way to use it? Return it from your service object, call `#render` on it right inside your controller action, and never care about another thing.

```ruby
class Controller < ApplicationController
  def create
    Answer.new(Model.create).render(self)
  end
end
```

You can supply your success or success and status, etc., but the best thing is that those can be inferred for you because of what your object really is. If saving failed, Answer knows it. You don't have to care about that. You can ask if the object represents a `#success?` and what http `#status` it has, but if you call `#render` on it, you'll get your json with errors rendered automatically. It works best with ActiveRecord models, but you can use it with any objects you want.

And, btw, you can also supply ActiveModel serializers of your choice if they don't match the naming convention.

## More

Check the spec here: https://github.com/fenoloftaleina/answer/blob/master/spec/answer_spec.rb.

And the example app here: https://github.com/fenoloftaleina/example-answer-app.

## Contributing

Pull requests are very much welcome.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

