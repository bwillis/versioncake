require './test/test_helper'

class ExtractionStrategyTest < ActiveSupport::TestCase
  test "execute is required for a strategy" do
    assert_raise(Exception) do
      VersionCake::ExtractionStrategy.new.execute("request")
    end
  end

  test "custom strategy result will be converted to integer" do
    class TestStrategy < VersionCake::ExtractionStrategy
      def execute(request); "123"; end
    end
    assert_equal 123, TestStrategy.new.extract("request")
  end

  test "custom strategy result will be returned" do
    class TestStrategy < VersionCake::ExtractionStrategy
      def execute(request); 123; end
    end
    assert_equal 123, TestStrategy.new.extract("request")
  end

  test "custom strategy will fail if it returns unexpected result" do
    class TestStrategy < VersionCake::ExtractionStrategy
      def execute(request); Object.new; end
    end
    assert_nil TestStrategy.new.extract("request")
  end

  test "it can lookup a strategy" do
    strategy = VersionCake::ExtractionStrategy.lookup(:query_parameter)
    assert_equal VersionCake::QueryParameterStrategy, strategy.class
  end

  test "it creates a custom strategy for a proc" do
    strategy = VersionCake::ExtractionStrategy.lookup(lambda{|req|})
    assert_equal VersionCake::CustomStrategy, strategy.class
  end

  test "it wraps a custom object" do
    class FakeStrategy
      def execute(request);end
    end
    strategy = VersionCake::ExtractionStrategy.lookup(FakeStrategy.new)
    assert_equal VersionCake::CustomStrategy, strategy.class
  end

  test "it calls a custom objects execute method" do
    class FakeStrategy
      def execute(request)
        9999
      end
    end
    strategy = VersionCake::ExtractionStrategy.lookup(FakeStrategy.new)
    assert_equal 9999, strategy.execute(nil)
  end

  test "it fails to create a custom strategy for a proc with no parameters" do
    assert_raise(Exception) do
      VersionCake::ExtractionStrategy.lookup(lambda{})
    end
  end

  test "it raises error when no strategy is found" do
    assert_raise(Exception) do
      VersionCake::ExtractionStrategy.lookup(:fake_extraction)
    end
  end
end
