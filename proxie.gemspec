# encoding: utf-8

require 'lib/proxie/version'

Gem::Specification.new do |gem|
  gem.name    = 'proxie'
  gem.version = Proxie::VERSION
  gem.date    = Time.now.strftime('%Y-%m-%d')

  gem.add_dependency 'sinatra',   '>= 0.9.4'
  gem.add_dependency 'sequel',    '3.19.0'
  gem.add_dependency 'json',      '1.4.6'

  gem.summary = "Proxie - Simple http proxy server"
  gem.description = "Proxie is a HTTP proxy server with sqlite-powered storage and web interface for debugging."

  gem.authors  = ['Dan Sosedoff']
  gem.email    = 'dan.sosedoff@gmail.com'
  gem.homepage = 'http://github.com/sosedoff/proxie'

  gem.rubyforge_project = nil
  gem.has_rdoc = false
  
  
  gem.executables = ['proxie']
  gem.default_executable = 'proxie'
  gem.files = Dir['Rakefile', '{bin,lib}/**/*', 'README*']
end