source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3", ">= 7.0.3.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
gem "hotwire-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"
gem "sass-rails"

gem "sassc"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem "devise"

gem "i18n"
gem "rails-i18n"
gem "devise-i18n"

gem "aws-sdk-s3", require: false
gem "image_processing", "~> 1.0"
gem "ruby-vips"

gem "mailjet"
gem "dotenv-rails"
gem "ed25519"
gem "bcrypt_pbkdf"

gem "jquery-rails"

# gem "lightbox2-rails"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-passenger', '~> 0.2'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
end

group :development do
  gem "web-console"
end
