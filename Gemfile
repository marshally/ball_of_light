source 'http://rubygems.org'

gem 'rake',          '~> 0.8.7'
platforms :ruby do
  gem 'thor',          '~> 0.15.4'
  gem 'json',          '~> 1.7.3'
  gem 'open_lighting', '~> 0.1.0'
  gem 'bundler',       '~> 1.1.5'
  # gem 'open_lighting', :git => 'https://github.com/marshally/open_lighting_rb.git'
  # gem 'open_lighting', :path => ENV['HOME'] + '/Projects/open_lighting'
  gem 'whenever', :require => false
end

platforms :jruby do
  gem 'ruby-processing'
end

group :test do
  gem 'rspec',         '~> 2.11.0'
  gem 'guard',         '~> 1.2.3'
  gem 'guard-bundler', '~> 1.0.0'
  gem 'guard-rspec',   '~> 1.2.0'
  gem 'simplecov',     '~> 0.6.4'
  gem 'growl',         '~> 1.0.3'
end
