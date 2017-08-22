default: deploy game-of-life

deploy:
	rsync --exclude-from "exclude-deploy.txt" --delete -vzrle ssh . griffin:/dat/www

GOL_FOLDER=./experiments/game-of-life
game-of-life: gol-packages $(GOL_FOLDER)/src/*
	cd $(GOL_FOLDER)/src; dotnet fable npm-build
	mv $(GOL_FOLDER)/public/* $(GOL_FOLDER)/

gol-packages: gol-npm gol-paket

gol-paket:
	cd $(GOL_FOLDER); dotnet restore

gol-npm:
	cd $(GOL_FOLDER); npm install