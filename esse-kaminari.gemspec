# frozen_string_literal: true

require_relative 'lib/esse/kaminari/version'

Gem::Specification.new do |spec|
  spec.name = 'esse-kaminari'
  spec.version = Esse::Kaminari::VERSION
  spec.authors = ['Marcos G. Zimmermann']
  spec.email = ['mgzmaster@gmail.com']

  spec.summary = 'Kaminari extensions for Esse'
  spec.description = 'Kaminari extensions for Esse'
  spec.homepage = 'https://github.com/marcosgz/esse-kaminari'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.4.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/marcosgz/esse-kaminari'
  spec.metadata['changelog_uri'] = 'https://github.com/marcosgz/esse-kaminari/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'esse'
  spec.add_dependency 'kaminari'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'standard', '~> 1.3'
  spec.add_development_dependency 'rubocop', '~> 1.20'
  spec.add_development_dependency 'rubocop-performance', '~> 1.11', '>= 1.11.5'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.4'
end
