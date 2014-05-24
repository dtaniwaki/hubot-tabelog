MOCHA = ./node_modules/.bin/mocha
.PHONY: test

test:
	$(MOCHA) test

test-coverage:
	$(MOCHA) -R html-cov test > coverage.html

test-coveralls:
	$(MOCHA) test --reporter mocha-lcov-reporter | coveralls
