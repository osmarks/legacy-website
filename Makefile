site = stack run site

default: build

deploy: build
	rsync --delete -vrzle ssh _site/* $(destination)

clean:
	$(site) clean

build:
	$(site) build

rebuild:
	$(site) rebuild