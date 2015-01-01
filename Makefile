all: clean build/

browse: all
	open build/index.html

build/: deps
	time bundle exec middleman build --verbose

clean:
	rm -rf build/

deps:
	which bundle || gem install bundler
	bundle check || bundle install

.PHONY: all browse clean deps
