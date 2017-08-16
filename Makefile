deploy:
	rsync --exclude="/.git*" --delete -vzrle ssh . griffin:/dat/www