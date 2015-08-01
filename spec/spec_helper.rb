require 'coveralls'
Coveralls.wear!
require 'versioncake'

# We have to occasionally require test-unit because it was removed as a core
# dependency, so have to explicitly disable it from running automatically
Test::Unit::AutoRunner.need_auto_run = false if defined?(Test::Unit::AutoRunner)

def capture_stdout(flag=true)
  if flag
    out     = StringIO.new
    $stdout = out
  else
    $stdout = STDOUT
  end
end

# Turn off stdout for all specs
def quiet_stdout
  around(:example) do |example|
    capture_stdout true
    example.run
    capture_stdout false
  end
end
