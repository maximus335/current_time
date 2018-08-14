install:
	bundle install

console:
	bundle exec bin/console

run:
	ruby app.rb

test:
	bundle exec rspec --fail-fast
