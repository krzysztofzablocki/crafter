lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'crafter'
  gem.version       = '0.1.39'
  gem.authors       = ['Krzysztof Zabłocki']
  gem.email         = ['merowing2@gmail.com']
  gem.description   = %q{CLI for setting up new Xcode projects. Inspired by thoughtbot liftoff.}
  gem.summary       = %q{Define your craft rules once, then apply it to all your Xcode projects.}
  gem.homepage      = 'https://github.com/krzysztofzablocki/crafter'
  gem.license = 'MIT'

  gem.add_dependency 'xcodeproj', '~> 0.5.5'
  gem.add_dependency 'highline', '~> 1.6'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
