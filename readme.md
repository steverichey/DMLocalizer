# [Don't Move Localizer](http://steverichey.github.io/DMLocalizer/)

A localization tool for [Don't Move](http://www.steverichey.com/dontmove). Creates static art assets for various languages, which can be read by the game.

# How To

1. Go to http://steverichey.github.io/DMLocalizer/
2. Click *Edit*.
3. Type in or copy/paste the text for your desired language, click *OK*.
4. Click on the button corresponding to the desired style.
5. Adjust the alpha threshold with the left/right arrow keys.
6. Click *Get* and save the file using this format. In all cases replace `la` with the applicable [ISO 639-1 language code](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes):
	* For the main title "DON'T": save as `dont_la.png`
	* For the main title "MOVE": save as `move_la.png`
	* For the "LEVEL UP!" toast: save as `levelup_la.png`
	* For the "ZENITH" toast: save as `zenith_la.png`
	* For the "GAME OVER" text: save as `gameover_la.png`
7. Save the file to the `images` folder, in the same directory as `DontMove.exe`.
8. Make sure that `locale/default.language` is set to the proper language code for the image you've added.
9. Start the game and ensure that it works!
10. Want it to be added to the game proper? [Open an issue](./../../issues). You'll get included in the credits below! Thanks for your help!

# Notes

* You can use the mouse to move the words around.
* The left and right arrow keys adjust the alpha threshold, adjust it if the text doesn't look right.

# Building

This is hosted online, but if you run `lime build flash` from the command line you'll have a working copy of this for whatever. Requires Haxe 3.1.3, OpenFL 2, and HaxeFlixel 4. Not tested on other platforms, this is just a cheesy Flash deal.

# Credits

Danish translation: Anders Nissen

# Licenses

This tool is MIT licensed, but Don't Move is (c) 2013-2014 Steve Richey.
