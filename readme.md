# [Don't Move Localizer](http://steverichey.github.io/DMLocalizer/)

A localization tool for [Don't Move](http://dontmove.co/). Creates static art assets for various languages, which can be read by the game. Go [here](http://steverichey.github.io/DMLocalizer/) to use it. Go [here](https://github.com/steverichey/DMLocalizer/issues) to submit a new translation.

# How To

1. Go [here](http://steverichey.github.io/DMLocalizer/).
2. Click *Edit*.
3. Type in or copy/paste the text for your desired language, click *OK*.
4. Click on the button corresponding to the desired style.
5. Adjust the alpha threshold with the left/right arrow keys.
6. Click *Get* and save the file. Repeat for the title, level up, zenith, and game over translations.
7. [Open an issue](./../../issues) with translations for the rest of the in-game text (see [here](https://github.com/steverichey/DMLocalizer/issues/1) for example).
8. You'll be included in the credits below, and in the game's manual!

# Template

```
lang-en
	press_left_or_right: Press left or right
	release_to_start: Release left and right to start
	release_to_erase: Release left and right to erase
	fill_bar_to_erase: Fill bar to erase save data
	erasing_save_data: Erasing save data
	attempts: attempts
	distance: distance
	seconds: seconds
	medals: medals
	levels: levels
	coins: coins
	trophies: trophies
	zenith: zenith
	zeniths: zeniths
	the_end: the end
	trophy_unlocked: trophy unlocked
	paused: paused
	time: time
	hold_left_or_right: Hold left or right to restart
```

# Notes

* You can use the mouse to move the words around.
* The left and right arrow keys adjust the alpha threshold, adjust it if the text doesn't look right.
* Translations will be added with version 1.4 of Don't Move, which will be the first version released on Steam.

# Building

This is hosted online, but if you run `lime build flash` from the command line you'll have a working copy of this for whatever. Requires Haxe 3.1.3, OpenFL 2, and HaxeFlixel 4. Not tested on other platforms, this is just a cheesy Flash deal.

# Credits

Bulgarian: Proxystar  
Croatian: Darkborn  
Danish: Anders Nissen  
Dutch: Justin Tlozoot Post  
Finnish:  Pietari Kotala  
French: utybo  
German: Tobias "Lordtobi" Heinen  
Italian: Luca Carbone  
Polish: Michał "Godless" Figas  
Portuguese: Luís Alves  
Russian: Ilia "Pebujetti" Golovkin  
Spanish: SillyWalk  
Swedish: Artucino  

# Licenses

This tool and its source code is shared under an [MIT license](https://en.wikipedia.org/wiki/MIT_License). See [license.md](./license.md) for details.  
Don't Move is &copy; 2013-2016 Steve Richey.
