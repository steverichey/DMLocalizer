# [Don't Move Localizer](http://steverichey.github.io/DMLocalizer/)

A localization tool for Don't Move. Creates static art assets for various languages, which can be read by the game.

# How To

1. Go to http://steverichey.github.io/DMLocalizer/
2. Type in or copy/paste the text for your desired language.
3. Click on the button corresponding to the desired style.
4. Click "get" and save the file using this format. In all cases replace `la` with the applicable [ISO 639-1 language code](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
	* For the main title "DON'T": save as `dont_la.png`
	* For the main title "MOVE": save as `move_la.png`
	* For the "LEVEL UP!" toast: save as `levelup_la.png`
	* For the "ZENITH" toast: save as `zenith_la.png`
	* For the "GAME OVER" text: save as `gameover_la.png`
5. Save the file to the `images` folder, in the same directory as `DontMove.exe`
6. Make sure that `locale/default.language` is set to the proper language code for the image you've added.
7. Start the game and ensure that it works!
8. Want it to be added to the game proper? [Open an issue](./../issues). Thanks for your help!

MIT licensed.

Don't Move is (c) 2013-2014 Steve Richey.
