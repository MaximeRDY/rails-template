run "if uname | grep -q 'Darwin'; then pgrep spring | xargs kill -9; fi"

# GEMFILE
########################################
run 'rm Gemfile'
file 'Gemfile', <<-RUBY
source 'https://rubygems.org'
ruby '#{RUBY_VERSION}'

gem 'pg', '~> 0.21'
gem 'puma'
gem 'rails', '#{Rails.version}'

gem 'grape'
gem 'grape-entity'
gem 'grape_on_rails_routes'

group :development do
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'

  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'dotenv-rails'

  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-grape'

  gem 'solargraph'
end

group :test do
  gem 'database_cleaner-active_record'
end

RUBY

# Procfile
########################################
file 'Procfile', <<-YAML
web: bundle exec puma -C config/puma.rb
YAML

# README
########################################
markdown_file_content = <<-MARKDOWN
Rails app generated with [https://github.com/MaximeRDY/rails-templates](https://github.com/https://github.com/MaximeRDY/rails-templates), created by the [MaximeRDY](https://github.com/MaximeRDY) team.
MARKDOWN
file 'README.md', markdown_file_content, force: true

# Generators
########################################
generators = <<-RUBY
config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework  :test_unit, fixture: false
    end
RUBY

environment generators

########################################
# AFTER BUNDLE
########################################
after_bundle do
  # Generators: db + simple form + pages controller
  ########################################
  rails_command 'db:drop db:create db:migrate'

  # Git ignore
  ########################################
  append_file '.gitignore', <<-TXT

# Ignore .env file containing credentials.
.env*

# Ignore Mac and Linux file system files
*.swp
.DS_Store
TXT

  # Dotenv
  ########################################
  run 'touch .env'

  # Rubocop
  ########################################
  run 'curl -L https://raw.githubusercontent.com/MaximeRDY/rails-templates/master/.rubocop.yml > .rubocop.yml'

  # Grape in Application
  ########################################
  inject_into_file 'config/application', after: 'class Application < Rails::Application' do <<-Ruby
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
  Ruby
  end

  # Test
  ########################################
  run 'rm ./spec/rails_helper.rb'
  run 'curl -L https://raw.githubusercontent.com/MaximeRDY/rails-templates/master/rails_helper.rb > ./spec/rails_helper.rb'

  # Docker-compose
  ########################################
  run 'curl -L https://raw.githubusercontent.com/MaximeRDY/rails-templates/master/docker-compose.yml > docker-compose.yml'

  # Git
  ########################################
  git :init
  git add: '.'
  git commit: "-m 'Initial commit with grape template from https://github.com/MaximeRDY/rails-templates'"

  # Fix puma config
  gsub_file('config/puma.rb', 'pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }', '# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }')

  run 'echo: "Do not forget to change docker-compose.yml"'
end