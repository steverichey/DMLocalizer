package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextFieldType;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.text.FlxTextField;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;

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
	// Main state visual stuff.
	
	private var info:FlxText;
	private var text:FlxText;
	private var edit:FlxButton;
	private var styleTitle:FlxButton;
	private var styleLevelUp:FlxButton;
	private var styleZenith:FlxButton;
	private var styleGameOver:FlxButton;
	private var export:FlxButton;
	
	// Text entry dialog stuff.
	
	private var textEdit:FlxGroup;
	private var textEntryWindow:FlxSprite;
	private var textEntryBox:FlxTextField;
	private var textOkay:FlxButton;
	private var textCancel:FlxButton;
	
	// Do the bottom buttons work?
	
	private var allowBottomButtons:Bool = true;
	
	// Allow dragging text
	
	private var dragging:Bool = false;
	private var offset:FlxPoint = FlxPoint.get();
	
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
	
	// Colors
	
	inline static private var HORRIBLY_UGLY_BROWN:UInt = 0xff1A0F06;
	inline static private var PAINFUL_RED:UInt = 0xffE5240F;
	inline static private var AWFUL_ORANGE:UInt = 0xffF49F17;
	
	// Scan alignments
	
	inline static private var VERTICAL:UInt = 0;
	inline static private var HORIZONTAL:UInt = 1;
	
	// Maximum allowed length of input text
	
	inline static private var MAX_INPUT_LENGTH:Int = 21;
	
	// Button sizes
	
	inline static private var BUTTON_WIDTH:Int = 32;
	inline static private var BUTTON_HEIGHT:Int = 18;
	
	override public function create():Void
	{
		super.create();
		
		// Disable autopause
		
		FlxG.autoPause = false;
		
		// Don't want black border to be invisible
		
		FlxG.camera.bgColor = HORRIBLY_UGLY_BROWN;
		
		// Reset default font to Nokia FC
		
		FlxAssets.FONT_DEFAULT = flixelFontName;
		
		// Create buttons
		
		edit = new FlxButton(1, 1, "Edit", onClickEdit);
		edit.makeGraphic(BUTTON_WIDTH, BUTTON_HEIGHT, AWFUL_ORANGE);
		
		styleTitle = new FlxButton(1, FlxG.height - BUTTON_HEIGHT - 1, "TITLE", onClickTitle);
		styleTitle.makeGraphic(BUTTON_WIDTH, BUTTON_HEIGHT, PAINFUL_RED);
		
		styleLevelUp = new FlxButton(styleTitle.x + styleTitle.width + 1, FlxG.height - BUTTON_HEIGHT - 1, "LVL", onClickLevelUp);
		styleLevelUp.makeGraphic(BUTTON_WIDTH, BUTTON_HEIGHT, PAINFUL_RED);
		
		styleZenith = new FlxButton(styleLevelUp.x + styleLevelUp.width + 1, FlxG.height - BUTTON_HEIGHT - 1, "ZEN", onClickZenith);
		styleZenith.makeGraphic(BUTTON_WIDTH, BUTTON_HEIGHT, PAINFUL_RED);
		
		styleGameOver = new FlxButton(styleZenith.x + styleLevelUp.width + 1, FlxG.height - BUTTON_HEIGHT - 1, "G.O.", onClickGameOver);
		styleGameOver.makeGraphic(BUTTON_WIDTH, BUTTON_HEIGHT, PAINFUL_RED);
		
		export = new FlxButton(styleGameOver.x + styleGameOver.width + 1, FlxG.height - BUTTON_HEIGHT - 1, "Get", onClickExport);
		export.makeGraphic(FlxG.width - Std.int(export.x) - 1, BUTTON_HEIGHT, AWFUL_ORANGE);
		
		// Info line at the top of the screen
		
		info = new FlxText(edit.x + edit.width + 1, 0, FlxG.width - (edit.x + edit.width + 2), "DM Localizer by STVR");
		info.alignment = "center";
		add(info);
		
		// Create text edit popup
		
		textEdit = new FlxGroup();
		
		textEntryWindow = new FlxSprite(12, 12);
		textEntryWindow.makeGraphic(FlxG.width - 24, 40, PAINFUL_RED);
		
		textEntryBox = new FlxTextField(textEntryWindow.x + 2, textEntryWindow.y + 2, Std.int(textEntryWindow.width) - 4, "Enter");
		textEntryBox.color = FlxColor.BLACK;
		textEntryBox.textField.wordWrap = false;
		textEntryBox.textField.multiline = false;
		textEntryBox.textField.type = TextFieldType.INPUT;
		textEntryBox.textField.backgroundColor = BLUE_MED;
		textEntryBox.textField.background = true;
		
		textOkay = new FlxButton(textEntryBox.x + 8, textEntryBox.y + 16, "OK", onClickOkay);
		textOkay.makeGraphic(32, 18, AWFUL_ORANGE);
		
		textCancel = new FlxButton(textEntryBox.x + textEntryBox.width - 40, textEntryBox.y + 16, "X", onClickCancel);
		textCancel.makeGraphic(32, 18, AWFUL_ORANGE);
		
		textEdit.add(textEntryWindow);
		textEdit.add(textEntryBox);
		textEdit.add(textOkay);
		textEdit.add(textCancel);
		
		textEdit.visible = textEdit.active = false;
		
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
		
		text = new FlxText(0, 0, 0, previousText, size);
		text.font = new Bebas().fontName;
		text.textField.antiAliasType = AntiAliasType.ADVANCED;
		text.textField.sharpness = SHARPNESS;
		add(text);
		
		FlxSpriteUtil.screenCenter(text);
		
		// Buttons should be on top of text, if it runs long
		
		add(edit);
		add(styleTitle);
		add(styleLevelUp);
		add(styleZenith);
		add(styleGameOver);
		add(export);
		
		// Text edit dialog should be on top of everything
		
		add(textEdit);
		
		// Assigns relevant style to text
		
		switch (currentStyle)
		{
			case TextStyle.TITLE: 		styleShift(text, BLUE_MED, BLUE_LITE, BLUE_LITE_MED, BLUE_DARK);
			case TextStyle.LEVELUP: 	styleShift(text, LEVEL_YELLOW, LEVEL_LITE, LEVEL_LITE_MED, LEVEL_DARK);
			case TextStyle.ZENITH: 		styleShift(text, ZENITH_MD, ZENITH_HI, ZENITH_HI, ZENITH_LO);
			case TextStyle.GAMEOVER: 	styleShift(text, GAMEOVER_MD, GAMEOVER_HI, GAMEOVER_HI, GAMEOVER_LO);
		}
	}
	
	override public function update():Void
	{
		// Trim input box to prevent stuff from getting cray-cray
		
		if (textEntryBox.textField.length > MAX_INPUT_LENGTH)
		{
			textEntryBox.text = textEntryBox.text.substr(0, MAX_INPUT_LENGTH);
		}
		
		// Allow repositioning the input box
		
		if (dragging && !FlxG.mouse.justPressed)
		{
			text.setPosition(FlxG.mouse.x - offset.x, FlxG.mouse.y - offset.y);
		}
		
		if (FlxG.mouse.justPressed && !textEdit.visible)
		{
			dragging = true;
			offset.set(FlxG.mouse.x - text.x, FlxG.mouse.y - text.y);
		}
		
		if (FlxG.mouse.justReleased)
		{
			dragging = false;
		}
		
		// Allow pressing "Enter" or "Escape" to exit dialog box
		
		if (textEdit.visible)
		{
			if (FlxG.keys.justPressed.ENTER)
			{
				onClickOkay();
			}
			
			if (FlxG.keys.justPressed.ESCAPE)
			{
				onClickCancel();
			}
		}
		
		super.update();
	}
	
	/**
	 * Allow the user to enter their own text.
	 */
	private function onClickEdit():Void
	{
		if (allowBottomButtons)
		{
			textEntryBox.text = text.text;
			textEdit.active = textEdit.visible = true;
			textEntryBox.textField.selectable = true;
			FlxG.stage.focus = textEntryBox.textField;
			
			if (textEntryBox.textField.length > 0)
			{
				textEntryBox.textField.setSelection(0, textEntryBox.textField.text.length);
			}
			
			allowBottomButtons = false;
		}
	}
	
	/**
	 * Callbacks for style selections.
	 */
	private function onClickTitle():Void    { 	tryAssign(TextStyle.TITLE);    }
	private function onClickLevelUp():Void  { 	tryAssign(TextStyle.LEVELUP);  }
	private function onClickZenith():Void   { 	tryAssign(TextStyle.ZENITH);   }
	private function onClickGameOver():Void { 	tryAssign(TextStyle.GAMEOVER); }
	
	/**
	 * Assigns Style to the current text, but only if the selected style differs from the current one.
	 * Also resets the state so that the style change will take effect, as this is done in create() (which is lazy of me, I know).
	 */
	private function tryAssign(Style:TextStyle):Void
	{
		if (allowBottomButtons && currentStyle != Style)
		{
			currentStyle = Style;
			previousText = text.text;
			FlxG.resetState();
		}
	}
	
	/**
	 * Called when Get is clicked. Crops the current text, encodes it as PNG, and opens the file dialog.
	 */
	private function onClickExport():Void
	{
		var bitmapdata:BitmapData = cropBitmapData(text.pixels);
		var bytearray:ByteArray = encodeBitmapDataToPNG(bitmapdata);
		
		openSaveFileDialog(bytearray, getFileName());
	}
	
	/**
	 * Callback for the text edit OK button.
	 */
	private function onClickOkay():Void
	{
		previousText = textEntryBox.text.toUpperCase();
		FlxG.resetState();
	}
	
	/**
	 * Callback for the text edit X button.
	 */
	private function onClickCancel():Void
	{
		textEntryBox.text = " ";
		FlxG.stage.focus = null;
		textEdit.visible = textEdit.active = false;
		allowBottomButtons = true;
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
	
	/**
	 * Takes BitmapData, crops away empty pixel rows and columns, and returns a new cropped BitmapData.
	 * 
	 * @param	Data	The BitmapData to crop.
	 */
	private function cropBitmapData(Data:BitmapData):BitmapData
	{
		var cropx:Int = 0;
		var cropy:Int = 0;
		var cropwidth:Int = Data.width;
		var cropheight:Int = Data.height;
		
		var hasPixels:Bool = false;
		
		// Scan bitmpadata for initial x and width
		
		var w:Int = Data.width;
		var xPos:Int = 0;
		
		while (xPos < w)
		{
			hasPixels = scanRow(Data, xPos, VERTICAL);
			
			if (hasPixels)
			{
				cropx = xPos;
				break;
			}
			
			xPos++;
		}
		
		xPos = w;
		
		while (xPos > 0)
		{
			xPos--;
			
			hasPixels = scanRow(Data, xPos, VERTICAL);
			
			if (hasPixels)
			{
				cropwidth = 1 + xPos - cropx;
				break;
			}
		}
		
		// Scan bitmapdata for initial y and height
		
		var h:Int = Data.height;
		var yPos:Int = 0;
		
		while (yPos < h)
		{
			hasPixels = scanRow(Data, yPos, HORIZONTAL);
			
			if (hasPixels)
			{
				cropy = yPos;
				break;
			}
			
			yPos++;
		}
		
		yPos = h;
		
		while (yPos > 0)
		{
			yPos--;
			
			hasPixels = scanRow(Data, yPos, HORIZONTAL);
			
			if (hasPixels)
			{
				cropheight = 1 + yPos - cropy;
				break;
			}
		}
		
		var dest:BitmapData = new BitmapData(cropwidth, cropheight, true, 0);
		var rect:Rectangle = new Rectangle(cropx, cropy, cropwidth, cropheight);
		var point:Point = new Point(0, 0);
		dest.copyPixels(Data, rect, point);
		
		return dest;
	}
	
	/**
	 * Scans a single vertical or horizontal row of a BitmapData for pixels. Returns true if any pixels are found.
	 * 
	 * @param	Data		The BitmapData to scan.
	 * @param	Position	The X or Y position to scan.
	 * @param	Alignment	Either VERTICAL or HORIZONTAL, will scan in that direction.
	 */
	private function scanRow(Data:BitmapData, Position:UInt, Alignment:UInt = VERTICAL):Bool
	{
		var result:Bool = false;
		
		var thisPixel:Array<UInt> = [];
		var otherPos:UInt = 0;
		var isVert:Bool = Alignment == VERTICAL;
		var max:UInt = isVert ? Data.height : Data.width;
		
		while (otherPos < max)
		{
			thisPixel = isVert ? [Position, otherPos] : [otherPos, Position];
			
			if (Data.getPixel32(thisPixel[0], thisPixel[1]) != 0)
			{
				result = true;
				break;
			}
			
			otherPos++;
		}
		
		return result;
	}
	
	/**
	 * Returns the appropriate file name for the type of object that is being saved.
	 */
	private function getFileName():String
	{
		switch (currentStyle)
		{
			case TextStyle.TITLE: 		return FlxG.random.bool() ? "dont_la.png" : "move_la.png";
			case TextStyle.LEVELUP: 	return "levelup_la.png";
			case TextStyle.ZENITH: 		return "zenith_la.png";
			case TextStyle.GAMEOVER: 	return "gameover_la.png";
		}
	}
	
	/**
	 * Converts a FlxSprite's pixels data to reflect the style of the selected colors.
	 * 
	 * @param	Obj				The FlxSprite to edit.
	 * @param	NormalColor		The color of the core of the letters.
	 * @param	HiColor			The color of the letter highlights.
	 * @param	MedHiColor		The color that transitions from the highlights to the lowlights.
	 * @param	LowColor		The color of the letter lowlights.
	 */
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

/**
 * Holds the list of potential letter styles.
 */
enum TextStyle
{
	TITLE;
	LEVELUP;
	ZENITH;
	GAMEOVER;
}