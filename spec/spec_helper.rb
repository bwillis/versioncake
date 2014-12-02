require 'coveralls'
Coveralls.wear!

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
