require './spec/spec_helper'
require './lib/versioncake/strategies/extraction_strategy'
require './lib/versioncake/strategies/query_parameter_strategy'
require './lib/versioncake/strategies/custom_strategy'

# TODO: make better!!!
describe VersionCake::ExtractionStrategy do
  it "execute is required for a strategy" do
    expect do
      VersionCake::ExtractionStrategy.new.execute("request")
    end.to raise_error(Exception)
  end

  it "custom strategy result will be converted to integer" do
    class TestStrategy < VersionCake::ExtractionStrategy
      def execute(request); "123"; end
    end

    expect(TestStrategy.new.extract("request")).to eq 123
  end

  it "custom strategy result will be returned" do
    class TestStrategy < VersionCake::ExtractionStrategy
      def execute(request); 123; end
    end
    expect(TestStrategy.new.extract("request")).to eq 123
  end

  it "custom strategy will fail if it returns unexpected result" do
    class TestStrategy < VersionCake::ExtractionStrategy
      def execute(request); Object.new; end
    end
    expect { TestStrategy.new.extract("request") }.to raise_error(Exception)
  end

  context '#query_parameter' do
    subject(:lookedup_strategy) { VersionCake::ExtractionStrategy.lookup(:query_parameter) }

    it { expect(lookedup_strategy.class).to eq VersionCake::QueryParameterStrategy }
  end

  it "it creates a custom strategy for a proc" do
    strategy = VersionCake::ExtractionStrategy.lookup(lambda{|req|})
    expect(strategy.class).to eq VersionCake::CustomStrategy
  end

  it "it wraps a custom object" do
    class FakeStrategy
      def execute(request);end
    end
    strategy = VersionCake::ExtractionStrategy.lookup(FakeStrategy.new)
    expect(strategy.class).to eq VersionCake::CustomStrategy
  end

  it "it calls a custom objects execute method" do
    class FakeStrategy
      def execute(request); 9999; end
    end
    strategy = VersionCake::ExtractionStrategy.lookup(FakeStrategy.new)
    expect(strategy.execute(nil)).to eq 9999
  end

  it "it fails to create a custom strategy for a proc with no parameters" do
    expect do
      VersionCake::ExtractionStrategy.lookup(lambda{})
    end.to raise_error(Exception)
  end

  it "it raises error when no strategy is found" do
    expect do
      VersionCake::ExtractionStrategy.lookup(:fake_extraction)
    end.to raise_error(Exception)
  end
end
