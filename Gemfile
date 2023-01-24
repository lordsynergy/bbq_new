source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

gem "aws-sdk-s3", require: false
gem "carrierwave"
gem "dotenv-rails"
gem "file_validators"
gem "mailjet"
gem "rmagick"
gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "rails-i18n"
gem "devise"
gem "devise-i18n"
gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"

gem "cssbundling-rails"

gem "jbuilder"

gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

gem "bootsnap", require: false


gem "image_processing", "~> 1.2"
gem "sqlite3", "~> 1.4"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "letter_opener", group: :development
end

group :production do
  gem "pg"
end

group :development do
  gem 'capistrano', '~> 3.8'
  gem 'capistrano-postgresql'
  gem 'capistrano-rails', '~> 1.6'
  gem 'capistrano-passenger', '~> 0.2'
  gem 'capistrano-rbenv', '~> 2.2'
  gem 'capistrano-bundler', '~> 2.1'
  gem 'web-console'
end

