# Allure Ruby API

This is a helper library containing the basics for any ruby-based Allure adaptor.
Using it you can easily implement the adaptor for your favourite ruby testing library or
you can just create the report of any other kind using the basic Allure terms.

## Setup

Add the dependency to your Gemfile

```ruby
 gem 'allure-ruby-api'
```

## Advanced options

You can specify the directory where the Allure test results will appear. By default it would be 'allure/data' within
your current directory.

```ruby
    AllureRubyApi.configure do |c|
      c.output_dir = "/whatever/you/like"
    end
```

## Usage examples

```ruby
    AllureRubyApi::Builder.start_suite "some_suite", :severity => :normal
    AllureRubyApi::Builder.start_test "some_suite", "some_test", :feature => "Some feature", :severity => :critical
    AllureRubyApi::Builder.start_step "some_suite", "some_test", "first step"
    AllureRubyApi::Builder.add_attachment "some_suite", "some_test", :file => Tempfile.new("somefile")
    AllureRubyApi::Builder.stop_step "some_suite", "some_test", "first step"
    AllureRubyApi::Builder.start_step "some_suite", "some_test", "second step"
    AllureRubyApi::Builder.add_attachment "some_suite", "some_test", :step => "second step", :file => Tempfile.new("somefile")
    AllureRubyApi::Builder.stop_step "some_suite", "some_test", "second step"
    AllureRubyApi::Builder.start_step "some_suite", "some_test", "third step"
    AllureRubyApi::Builder.stop_step "some_suite", "some_test", "third step", :failed
    AllureRubyApi::Builder.stop_test "some_suite", "some_test", :status => :broken, :exception => Exception.new("some error")
    AllureRubyApi::Builder.stop_suite "some_suite"

    # This will generate the results within your output directory
    AllureRubyApi::Builder.build!
```
