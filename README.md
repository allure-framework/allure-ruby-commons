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

You can specify the directory where the Allure test results will appear. By default it would be 'allure/data' within
your current directory.

```ruby
    AllureRubyAdaptorApi.configure do |c|
      c.output_dir = "/whatever/you/like"
    end
```

## Usage examples

```ruby
    AllureRubyAdaptorApi::Builder.start_suite "some_suite", :severity => :normal
    AllureRubyAdaptorApi::Builder.start_test "some_suite", "some_test", :feature => "Some feature", :severity => :critical
    AllureRubyAdaptorApi::Builder.start_step "some_suite", "some_test", "first step"
    AllureRubyAdaptorApi::Builder.add_attachment "some_suite", "some_test", :file => Tempfile.new("somefile")
    AllureRubyAdaptorApi::Builder.stop_step "some_suite", "some_test", "first step"
    AllureRubyAdaptorApi::Builder.start_step "some_suite", "some_test", "second step"
    AllureRubyAdaptorApi::Builder.add_attachment "some_suite", "some_test", :step => "second step", :file => Tempfile.new("somefile")
    AllureRubyAdaptorApi::Builder.stop_step "some_suite", "some_test", "second step"
    AllureRubyAdaptorApi::Builder.start_step "some_suite", "some_test", "third step"
    AllureRubyAdaptorApi::Builder.stop_step "some_suite", "some_test", "third step", :failed
    AllureRubyAdaptorApi::Builder.stop_test "some_suite", "some_test", :status => :broken, :exception => Exception.new("some error")
    AllureRubyAdaptorApi::Builder.stop_suite "some_suite"

    # This will generate the results within your output directory
    AllureRubyAdaptorApi::Builder.build!
```
