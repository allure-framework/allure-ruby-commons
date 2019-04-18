# frozen_string_literal: true

require_relative "../spec_helper"

describe Allure::AllureLifecycle do
  let(:lifecycle) { Allure::AllureLifecycle.new }

  context "without exceptions" do
    before do
      @result_container = Allure::TestResultContainer.new(name: "container name")
      @fixture_result = Allure::FixtureResult.new(name: "Prepare fixture")
      lifecycle.start_test_container(@result_container)
    end

    it "starts prepare fixture" do
      lifecycle.start_prepare_fixture(@fixture_result)

      aggregate_failures "Start and stage should be updated" do
        expect(@fixture_result.start).to be_a(Numeric)
        expect(@fixture_result.stage).to eq(Allure::Stage::RUNNING)
      end
    end

    it "adds prepare fixture to result container" do
      lifecycle.start_prepare_fixture(@fixture_result)

      expect(@result_container.befores.last).to eq(@fixture_result)
    end

    it "starts teardown fixture" do
      lifecycle.start_tear_down_fixture(@fixture_result)

      aggregate_failures "Start and stage should be updated" do
        expect(@fixture_result.start).to be_a(Numeric)
        expect(@fixture_result.stage).to eq(Allure::Stage::RUNNING)
      end
    end

    it "adds teardown fixture to result container" do
      lifecycle.start_tear_down_fixture(@fixture_result)

      expect(@result_container.afters.last).to eq(@fixture_result)
    end

    it "updates fixture" do
      lifecycle.start_prepare_fixture(@fixture_result)

      lifecycle.update_fixture { |fixture| fixture.status = Allure::Status::CANCELED }
      expect(@fixture_result.status).to eq(Allure::Status::CANCELED)
    end

    it "stops fixture" do
      lifecycle.start_prepare_fixture(@fixture_result)
      lifecycle.stop_fixture
      aggregate_failures "Should update parameters" do
        expect(@fixture_result.stop).to be_a(Numeric)
        expect(@fixture_result.stage).to eq(Allure::Stage::FINISHED)
      end
    end
  end

  context "raises exception" do
    it "no running container" do
      expect { lifecycle.start_prepare_fixture(Allure::FixtureResult.new) }.to raise_error(
        /Could not start fixture/,
      )
    end

    it "no running fixture" do
      lifecycle.start_test_container(Allure::TestResultContainer.new)

      aggregate_failures "Should raise exception" do
        expect { lifecycle.stop_fixture }.to raise_error(/Could not stop fixture/)
        expect { lifecycle.update_fixture { |t| t.full_name = "Test" } }.to raise_error(
          /Could not update fixture/,
        )
      end
    end
  end
end
