require 'spec_helper'

describe VersionCake::VersionChecker do

  subject do
    checker = VersionCake::VersionChecker.new(resource, version)
    checker.execute
  end

  describe '#execute' do
    xit {}
  end

end
