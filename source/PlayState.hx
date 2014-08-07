package;

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import openfl.Lib;

import flash.text.Font;
import flash.text.TextFormat;
import flash.text.TextRenderer;
import flash.text.AntiAliasType;
import flash.net.FileReference;
import flash.utils.ByteArray;
import flash.display.PNGEncoderOptions;

@:font("assets/BebasNeue.ttf") private class Bebas extends Font {}

class PlayState extends FlxState
{
	private var info:FlxText;
	private var text:FlxText;
	private var edit:FlxButton;
	private var styleTitle:FlxButton;
	private var styleLevelUp:FlxButton;
	private var styleZenith:FlxButton;
	private var styleGameOver:FlxButton;
	private var export:FlxButton;
	
	// Static, so unaffected by state switch
	
	private static var currentStyle:TextStyle = TextStyle.TITLE;
	private static var previousText:String = "HELLO";
	private static var flixelFontName:String = FlxAssets.FONT_DEFAULT;
	
	inline static private var PADDING_X:Int = -3;
	inline static private var PADDING_Y:Int = -13;
	inline static private var FONT_SIZE_TITLE:UInt = 66;
	inline static private var FONT_SIZE_LEVEL:UInt = 36;
	inline static private var FONT_SIZE_ZENITH:UInt = 24;
	inline static private var FONT_SIZE_GAMEOVER:UInt = 54;
	inline static private var SHARPNESS:Int = 400;
	
	// Title colors
	
	inline static private var BLUE_LITE:UInt = 0xffAFC8DD;
	inline static private var BLUE_LITE_MED:UInt = 0xff89B6DD;
	inline static private var BLUE_MED:UInt = 0xff6EA9E0;
	inline static private var BLUE_DARK:UInt = 0xff507699;
	
	// Level up colors
	
	inline static private var LEVEL_YELLOW:UInt = 0xffE3E310;
	inline static private var LEVEL_LITE:UInt = 0xff949494;
	inline static private var LEVEL_LITE_MED:UInt = 0xff545454;
	inline static private var LEVEL_DARK:UInt = 0xff000000;
	
	// Zenith toast colors
	
	inline static private var ZENITH_HI:UInt = 0xff10E3CA;
	inline static private var ZENITH_MD:UInt = 0xff1EC9B5;
	inline static private var ZENITH_LO:UInt = 0xff1FAD9D;
	
	// Game over text colors
	
	inline static private var GAMEOVER_HI:UInt = 0xffE31041;
	inline static private var GAMEOVER_MD:UInt = 0xffCF1742;
	inline static private var GAMEOVER_LO:UInt = 0xffB3193D;
	
	// BG color
	
	inline static private var HORRIBLY_UGLY_BROWN:UInt = 0xff1A0F06;
	
	// Button colors
	
	inline static private var PAINFUL_RED:UInt = 0xffE5240F;
	inline static private var AWFUL_ORANGE:UInt = 0xffF49F17;
	
	override public function create():Void
	{
		super.create();
		
		// Don't want black border to be invisible
		
		FlxG.camera.bgColor = HORRIBLY_UGLY_BROWN;
		
		// Reset default font to Nokia FC
		
		FlxAssets.FONT_DEFAULT = flixelFontName;
		
		// Info line at the top of the screen
		
		info = new FlxText(0, -1, FlxG.width, "DM Localizer by STVR");
		info.alignment = "center";
		info.alpha = 0.5;
		add(info);
		
		// Create buttons
		
		edit = new FlxButton(1, FlxG.height - 38, "Edit", onClickEdit);
		edit.makeGraphic(32, 18, AWFUL_ORANGE);
		
		styleTitle = new FlxButton(1, FlxG.height - 19, "TITLE", onClickTitle);
		styleTitle.makeGraphic(32, 18, PAINFUL_RED);
		
		styleLevelUp = new FlxButton(styleTitle.x + styleTitle.width + 1, FlxG.height - 19, "LVL", onClickLevelUp);
		styleLevelUp.makeGraphic(32, 18, PAINFUL_RED);
		
		styleZenith = new FlxButton(styleLevelUp.x + styleLevelUp.width + 1, FlxG.height - 19, "ZEN", onClickZenith);
		styleZenith.makeGraphic(32, 18, PAINFUL_RED);
		
		styleGameOver = new FlxButton(styleZenith.x + styleLevelUp.width + 1, FlxG.height - 19, "G.O.", onClickGameOver);
		styleGameOver.makeGraphic(32, 18, PAINFUL_RED);
		
		export = new FlxButton(styleGameOver.x + styleGameOver.width + 1, FlxG.height - 19, "Get", onClickExport);
		export.makeGraphic(FlxG.width - Std.int(export.x) - 1, 18, AWFUL_ORANGE);
		
		add(edit);
		add(styleTitle);
		add(styleLevelUp);
		add(styleZenith);
		add(styleGameOver);
		add(export);
		
		// Set font to Bebas (used for all drawn text in-game)
		
		Font.registerFont(Bebas);
		FlxAssets.FONT_DEFAULT = new Bebas().fontName;
		
		// Create the example text
		
		var size:Int = 0;
		
		switch (currentStyle)
		{
			case TextStyle.TITLE:  		size = FONT_SIZE_TITLE;
			case TextStyle.LEVELUP: 	size = FONT_SIZE_LEVEL;
			case TextStyle.ZENITH: 		size = FONT_SIZE_ZENITH;
			case TextStyle.GAMEOVER:	size = FONT_SIZE_GAMEOVER;
		}
		
		text = new FlxText(PADDING_X, 8, FlxG.width, previousText, size);
		text.font = new Bebas().fontName;
		text.textField.antiAliasType = AntiAliasType.ADVANCED;
		text.textField.sharpness = SHARPNESS;
		add(text);
		
		// assign style to text
		
		switch (currentStyle)
		{
			case TextStyle.TITLE: 		styleShift(text, BLUE_MED, BLUE_LITE, BLUE_LITE_MED, BLUE_DARK);
			case TextStyle.LEVELUP: 	styleShift(text, LEVEL_YELLOW, LEVEL_LITE, LEVEL_LITE_MED, LEVEL_DARK);
			case TextStyle.ZENITH: 		styleShift(text, ZENITH_MD, ZENITH_HI, ZENITH_HI, ZENITH_LO);
			case TextStyle.GAMEOVER: 	styleShift(text, GAMEOVER_MD, GAMEOVER_HI, GAMEOVER_HI, GAMEOVER_LO);
		}
	}
	
	private function onClickEdit():Void
	{
		// allow edit text popup
	}
	
	private function onClickTitle():Void { tryAssign(TextStyle.TITLE); }
	private function onClickLevelUp():Void { tryAssign(TextStyle.LEVELUP); }
	private function onClickZenith():Void { tryAssign(TextStyle.ZENITH); }
	private function onClickGameOver():Void { tryAssign(TextStyle.GAMEOVER); }
	
	private function tryAssign(Style:TextStyle):Void
	{
		if (currentStyle != Style)
		{
			currentStyle = Style;
			previousText = text.text;
			FlxG.resetState();
		}
	}
	
	private function onClickExport():Void
	{
		var bytearray:ByteArray = encodeBitmapDataToPNG(text.pixels);
		
		openSaveFileDialog(bytearray, getFileName());
	}
	
	/**
	 * Just a wrapper for FileReference, this opens a save file dialog in Flash.
	 * 
	 * @param	Data			The data to save, stored as a ByteArray.
	 * @param	DefaultFileName	The default name to be shown in the dialog.
	 */
	private function openSaveFileDialog(Data:ByteArray, DefaultFileName:String):Void
	{
		new FileReference().save(Data, DefaultFileName);
	}
	
	/**
	 * Converts BitmapData to a ByteArray encoded as PNG. Mostly a wrapper for BitmapData.encode()
	 * 
	 * @param	Image	The BitmapData to encode. This could be, for example, a FlxSprite's pixels.
	 */
	private function encodeBitmapDataToPNG(Image:BitmapData):ByteArray
	{
		return Image.clone().encode(Image.rect, new PNGEncoderOptions());
	}
	
	private function getFileName():String
	{
		switch (currentStyle)
		{
			case TextStyle.TITLE: 		return FlxG.random.bool() ? "dont_en.png" : "move_en.png";
			case TextStyle.LEVELUP: 	return "levelup_en.png";
			case TextStyle.ZENITH: 		return "zenith_en.png";
			case TextStyle.GAMEOVER: 	return "gameover_en.png";
		}
	}
	
	private function styleShift(Obj:FlxSprite, NormalColor:UInt, HiColor:UInt, MedHiColor:UInt, LowColor:UInt):Void
	{
		var p:BitmapData = Obj.pixels;
		var w:Int = p.width;
		var h:Int = p.height;
		
		var active:UInt = 0;
		var left:UInt = 0;
		var right:UInt = 0;
		var above:UInt = 0;
		var below:UInt = 0;
		
		var twoAbove:UInt = 0;
		var threeAbove:UInt = 0;
		
		var topleft:UInt = 0;
		var topRight:UInt = 0;
		var bottomLeft:UInt = 0;
		var bottomRight:UInt = 0;
		
		var onRight:Bool = false;
		var onLeft:Bool = false;
		var onBottom:Bool = false;
		var onTop:Bool = false;
		var hasPixel:Bool = false;
		
		var xPos:Int = 0;
		var yPos:Int = 0;
		
		while (yPos < h)
		{
			while (xPos < w)
			{
				active = p.getPixel32(xPos, yPos);
				hasPixel = active != 0;
				
				if (hasPixel)
				{
					left = p.getPixel32(xPos - 1, yPos);
					right = p.getPixel32(xPos + 1, yPos);
					above = p.getPixel32(xPos, yPos - 1);
					below = p.getPixel32(xPos, yPos + 1);
					
					onRight = right == 0;
					onLeft = left == 0;
					onBottom = below == 0;
					onTop = above == 0;
					
					if (onLeft || onTop)
					{
						twoAbove = p.getPixel32(xPos, yPos - 2);
						threeAbove = p.getPixel32(xPos, yPos - 3);
						
						if (threeAbove == HiColor)
						{
							p.setPixel32(xPos, yPos, MedHiColor);
						}
						else if (threeAbove == MedHiColor || threeAbove == LowColor || threeAbove == NormalColor)
						{
							p.setPixel32(xPos, yPos, LowColor);
						}
						else
						{
							p.setPixel32(xPos, yPos, HiColor);
						}
					}
					else if (onRight || onBottom)
					{
						if (above == HiColor)
						{
							p.setPixel32(xPos, yPos, MedHiColor);
						}
						else
						{
							p.setPixel32(xPos, yPos, LowColor);
						}
					}
					else
					{
						p.setPixel32(xPos, yPos, NormalColor);
					}
				}
				
				xPos++;
			}
			
			xPos = 0;
			yPos++;
		}
		
		Obj.pixels = p;
	}
}

enum TextStyle
{
	TITLE;
	LEVELUP;
	ZENITH;
	GAMEOVER;
}