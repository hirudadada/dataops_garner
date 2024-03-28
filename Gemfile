# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:metasync) do |repo_name|
  "https://github.com/metasync/#{repo_name}.git"
end

gem 'garnet', metasync: 'garnet', branch: 'main'
# gem 'garnet', path: '/gems/garnet'

gem 'dry-initializer', '~>3.1.1'

gem 'tiny_tds', '2.1.7'

gem 'async', '~> 2.8'

gem 'elastic-apm', '4.7.2'

group :development do
  gem 'byebug', '~>11.1.3'
  gem 'pry', '~>0.14.2'
  gem 'rubocop', '~>1.60.2'
  gem 'ruby-lsp', '~>0.14.1'
end
