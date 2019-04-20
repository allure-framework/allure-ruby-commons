# frozen_string_literal: true

describe Allure::AllureLifecycle do
  let(:lifecycle) { Allure::AllureLifecycle.new }

  context "without exceptions" do
    before do
      @result_container = start_test_container(lifecycle, "Test container")
    end

    it "starts prepare fixture" do
      fixture_result = start_fixture(lifecycle, "Prepare fixture", "prepare")

      aggregate_failures "Fixture should be started" do
        expect(fixture_result.start).to be_a(Numeric)
        expect(fixture_result.stage).to eq(Allure::Stage::RUNNING)
        expect(@result_container.befores.last).to eq(fixture_result)
      end
    end

    it "starts teardown fixture" do
      fixture_result = start_fixture(lifecycle, "Teardown fixture", "tear_down")

      aggregate_failures "Fixture should be started" do
        expect(fixture_result.start).to be_a(Numeric)
        expect(fixture_result.stage).to eq(Allure::Stage::RUNNING)
        expect(@result_container.afters.last).to eq(fixture_result)
      end
    end

    it "updates fixture" do
      fixture_result = start_fixture(lifecycle, "Prepare fixture", "prepare")
      lifecycle.update_fixture { |fixture| fixture.status = Allure::Status::CANCELED }

      expect(fixture_result.status).to eq(Allure::Status::CANCELED)
    end

    it "stops fixture" do
      fixture_result = start_fixture(lifecycle, "Prepare fixture", "prepare")
      lifecycle.stop_fixture

      aggregate_failures "Should update parameters" do
        expect(fixture_result.stop).to be_a(Numeric)
        expect(fixture_result.stage).to eq(Allure::Stage::FINISHED)
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
