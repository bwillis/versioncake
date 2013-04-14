require './test/test_helper'

class ExtractionStrategyTest < ActiveSupport::TestCase
  test "execute is required for a strategy" do
    assert_raise(Exception) do
      VersionCake::ExtractionStrategy.new.execute("request")
    end
  end

  test "extract will convert the the result to integer" do
    class TestStrategy < VersionCake::ExtractionStrategy
      def execute(request); "123"; end
    end
    assert_equal TestStrategy.new.extract("request"), 123
  end

  test "it can lookup a strategy" do
    strategy = VersionCake::ExtractionStrategy.lookup(:query_parameter)
    assert_equal VersionCake::QueryParameterStrategy, strategy.class
  end

  test "it creates a custom strategy for a proc" do
    strategy = VersionCake::ExtractionStrategy.lookup(lambda{|req|})
    assert_equal VersionCake::CustomStrategy, strategy.class
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
