require 'bundler'
Bundler.setup

if RUBY_VERSION.to_f == 1.9
  require 'simplecov'
  SimpleCov.start do
    add_filter "vendor"
  end
end

require 'ball_of_light'

# borrowed from thor's spec_helper

def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
end

