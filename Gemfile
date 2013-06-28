source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.13'
gem 'mysql2'
gem 'json'
gem 'jquery-rails'
# gem "therubyracer"
# gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"
gem 'twilio-ruby'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
end

group :test do
  gem 'factory_girl_rails'
end

group :production do
  # pg for heroku
  gem "pg"
end
