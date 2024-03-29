# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cognito_sync_service/version'

Gem::Specification.new do |spec|
  spec.name          = 'cognito-sync-service'
  spec.version       = CognitoSyncService::VERSION
  spec.authors       = ['Mark Osipenko']
  spec.email         = ['mark.osipenko@gmail.com']

  spec.summary       = 'Aws Cognito user pool synchronizer'
  spec.description   = 'Aws Cognito user pool synchronizer'
  spec.homepage      = 'https://github.com/MarkOsipenko/cognito-sync-service'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/MarkOsipenko/cognito-sync-service'
    spec.metadata['changelog_uri'] = 'https://github.com/MarkOsipenko/cognito-sync-service'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files = Dir.chdir(File.expand_path(__dir__)) do
  #   `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk-cognitoidentity', '~> 1.0.0.rc7'
  spec.add_dependency 'aws-sdk-cognitoidentityprovider', '~> 1.12'
  spec.add_dependency 'aws-sdk-cognitosync', '~> 1.6'
  spec.add_dependency 'aws-sdk-ec2', '~> 1'
  spec.add_dependency 'aws-sdk-s3', '~> 1'
  spec.add_dependency 'aws-sdk-ses', '~> 1.6'

  spec.add_dependency 'pry', '~> 0.10'
  spec.add_dependency 'pry-byebug', '~> 3.4'
  spec.add_dependency 'pry-doc', '~> 1.0.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
