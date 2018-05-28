build: node_modules
	node metalsmith.js

node_modules: package.json
	npm install

serve:
	node node_modules/.bin/metalsmith-start

deploy: build
	rsync --delete -vrzle ssh build/* $(destination)

.PHONY: build