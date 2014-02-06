require './test/test_helper'
require './lib/versioncake/cli'

class CliTest < ActiveSupport::TestCase

  setup do
    File.stubs :rename
    capture_stdout(true)
  end

  teardown do
    capture_stdout(false)
  end

  def capture_stdout(flag=true)
    if flag
      out     = StringIO.new
      $stdout = out
    else
      $stdout = STDOUT
    end
  end

  test 'it can detect old file names' do
    renamed_files = VersionCake::Cli.new.migrate('./test/fixtures/templates')
    assert_equal 2, renamed_files.size
  end

  test 'it renames old filenames to new filenames' do
    renamed_files = VersionCake::Cli.new.migrate('./test/fixtures/templates')
    expected_renamed_files = [
        ['./test/fixtures/templates/v1_extension_scheme.v3.html.erb', './test/fixtures/templates/v1_extension_scheme.html.v3.erb'],
        ['./test/fixtures/templates/v1_extension_scheme.v6.json', './test/fixtures/templates/v1_extension_scheme.json.v6']
    ]
    assert_empty expected_renamed_files - renamed_files
  end

  test 'it reports no files changed when new filenames exist' do
    assert_empty VersionCake::Cli.new.migrate('./test/app/views')
  end

  test 'it raises if it cannot find the path' do
    assert_raises ArgumentError do
      VersionCake::Cli.new.migrate('./a/missing/path')
    end
  end

end