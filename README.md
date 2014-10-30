# Allure Ruby Adaptor API

This is a helper library containing the basics for any ruby-based Allure adaptor.
Using it you can easily implement the adaptor for your favourite ruby testing library or
you can just create the report of any other kind using the basic Allure terms.

## Setup

Add the dependency to your Gemfile

```ruby
 gem 'allure-ruby-adaptor-api'
```

## Advanced options

You can specify the directory where the Allure test results will appear. By default it would be 'gen/allure-results' within
your current directory.

```ruby
    AllureRubyAdaptorApi.configure do |c|
      c.output_dir = "/whatever/you/like"
    end
```

## Usage examples

```ruby
    builder = AllureRubyAdaptorApi::Builder
    builder.start_suite "some_suite", :severity => :normal
    builder.start_test "some_suite", "some_test", :feature => "Some feature", :severity => :critical
    builder.start_step "some_suite", "some_test", "first step"
    builder.add_attachment "some_suite", "some_test", :file => Tempfile.new("somefile")
    builder.stop_step "some_suite", "some_test", "first step"
    builder.start_step "some_suite", "some_test", "second step"
    builder.add_attachment "some_suite", "some_test", :step => "second step", :file => Tempfile.new("somefile")
    builder.stop_step "some_suite", "some_test", "second step"
    builder.start_step "some_suite", "some_test", "third step"
    builder.stop_step "some_suite", "some_test", "third step", :failed
    builder.stop_test "some_suite", "some_test", :status => :broken, :exception => Exception.new("some error")
    builder.stop_suite "some_suite"

    # This will generate the results within your output directory
    builder.build!
```
