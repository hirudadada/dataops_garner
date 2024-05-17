# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:metasync) do |repo_name|
  "https://github.com/metasync/#{repo_name}.git"
end

gem 'garnet', metasync: 'garnet', branch: 'main'
# gem 'garnet', path: '/gems/garnet'

gem 'pg', '~> 1.5'
gem 'tiny_tds', '~> 2.1'

gem 'async', '~> 2.10'
gem 'elastic-apm', '~> 4.7'

gem 'rdoc', '>= 6.6.3.1'

group :development do
  gem 'byebug', '~>11.1.3'
  gem 'debug'
  gem 'pry', '~>0.14.2'
  gem 'pry-doc', '~>1.4.0'
  gem 'rubocop', '~>1.63.5'
  gem 'ruby-lsp', '~>0.16.4'
end
