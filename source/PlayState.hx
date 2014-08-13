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
import flixel.util.FlxColor;

import flash.text.Font;
import flash.text.TextFormat;
import flash.text.TextRenderer;
import flash.text.AntiAliasType;
import flash.utils.ByteArray;

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
	private var alphaDisplay:FlxText;
	
	// Text entry dialog stuff.
	
	private var textEdit:FlxGroup;
	private var textEntryWindow:FlxSprite;
	private var textEntryBox:FlxTextField;
	private var textLength:FlxText;
	private var textOkay:FlxButton;
	private var textCancel:FlxButton;
	
	// Do the bottom buttons work?
	
	private var allowBottomButtons:Bool = true;
	
	// Should the text be redrawn this frame?
	
	private var textDirty:Bool = false;
	
	// Allow dragging text
	
	private var dragging:Bool = false;
	private var offset:FlxPoint = FlxPoint.get();
	
	// Static, so unaffected by state switch
	
	private static var currentStyle:TextStyle = TextStyle.TITLE;
	private static var previousText:String = "HELLO";
	private static var flixelFontName:String = FlxAssets.FONT_DEFAULT;
	private static var alphaCrop:Float = 0.44;
	
	inline static private var PADDING_X:Int = -3;
	inline static private var PADDING_Y:Int = -13;
	
	inline static private var FONT_SIZE_TITLE:UInt = 62;
	inline static private var FONT_SIZE_LEVEL:UInt = 36;
	inline static private var FONT_SIZE_ZENITH:UInt = 24;
	inline static private var FONT_SIZE_GAMEOVER:UInt = 58;
	
	inline static private var LEAD_SIZE_TITLE:UInt = -19;
	inline static private var LEAD_SIZE_LEVEL:UInt = -8;
	inline static private var LEAD_SIZE_ZENITH:UInt = -4;
	inline static private var LEAD_SIZE_GAMEOVER:UInt = -17;
	
	inline static private var SHARPNESS:Int = 100;
	
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
	
	// Maximum allowed length of input text
	
	inline static private var MAX_INPUT_LENGTH:Int = 42;
	
	// Button sizes
	
	inline static private var BUTTON_WIDTH:Int = 32;
	inline static private var BUTTON_HEIGHT:Int = 18;
	
	// How quickly the alpha threshold changes
	
	inline static private var ALPHA_STEP:Float = 0.01;
	
	#if debug
	/**
	 * Debug stuff
	 */
	private var testInt:Int = 0;
	#end
	
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
		
		// Alpha crop info towards the bottom of ths creen
		
		alphaDisplay = new FlxText(0, FlxG.height - BUTTON_HEIGHT - 13, FlxG.width, alphaText());
		alphaDisplay.alignment = "center";
		
		// Create text edit popup
		
		textEdit = new FlxGroup();
		
		textEntryWindow = new FlxSprite(12, 12);
		textEntryWindow.makeGraphic(FlxG.width - 24, 52, PAINFUL_RED);
		
		textEntryBox = new FlxTextField(textEntryWindow.x + 2, textEntryWindow.y + 2, Std.int(textEntryWindow.width) - 4, "Enter");
		textEntryBox.color = FlxColor.BLACK;
		textEntryBox.textField.wordWrap = true;
		textEntryBox.textField.multiline = true;
		textEntryBox.textField.type = TextFieldType.INPUT;
		textEntryBox.textField.backgroundColor = BLUE_MED;
		textEntryBox.textField.background = true;
		textEntryBox.height *= 2;
		
		textOkay = new FlxButton(textEntryBox.x + 8, textEntryBox.y + textEntryBox.height + 2, "OK", onClickOkay);
		textOkay.makeGraphic(32, 18, AWFUL_ORANGE);
		
		textCancel = new FlxButton(textEntryBox.x + textEntryBox.width - 40, textOkay.y, "X", onClickCancel);
		textCancel.makeGraphic(32, 18, AWFUL_ORANGE);
		
		textLength = new FlxText(textOkay.x, textOkay.y, textCancel.x + textCancel.width - textOkay.x, "0");
		textLength.alignment = "center";
		
		textEdit.add(textEntryWindow);
		textEdit.add(textEntryBox);
		textEdit.add(textOkay);
		textEdit.add(textLength);
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
		text.alignment = "center";
		
		if (Utils.hasReturn(previousText))
		{
			var format:TextFormat = new TextFormat();
			var lead:Int = 0;
			
			switch (currentStyle)
			{
				case TextStyle.TITLE:  		lead = LEAD_SIZE_TITLE;
				case TextStyle.LEVELUP: 	lead = LEAD_SIZE_LEVEL;
				case TextStyle.ZENITH: 		lead = LEAD_SIZE_ZENITH;
				case TextStyle.GAMEOVER:	lead = LEAD_SIZE_GAMEOVER;
			}
			
			format.leading = lead;
			text.textField.setTextFormat(format);
		}
		
		add(text);
		
		FlxSpriteUtil.screenCenter(text);
		
		// Buttons should be on top of text, if it runs long
		
		add(edit);
		add(styleTitle);
		add(styleLevelUp);
		add(styleZenith);
		add(styleGameOver);
		add(export);
		add(info);
		add(alphaDisplay);
		
		// Text edit dialog should be on top of everything
		
		add(textEdit);
		
		textDirty = true;
		
		#if debug
		FlxG.watch.add(this, "testInt");
		#end
	}
	
	override public function update():Void
	{
		// Trim input box to prevent stuff from getting cray-cray
		
		if (textEntryBox.textField.length > MAX_INPUT_LENGTH)
		{
			textEntryBox.text = textEntryBox.text.substr(0, MAX_INPUT_LENGTH);
		}
		
		// Only allow two lines in the input box
		
		if (Utils.occurancesOf(textEntryBox.text, "\r") > 1)
		{
			textEntryBox.text = Utils.removeLastOccuranceOf(textEntryBox.text, "\r");
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
				if (Utils.hasReturn(textEntryBox.text))
				{
					// onClickOkay(); // this doesn't work great
				}
			}
			
			if (FlxG.keys.justPressed.ESCAPE)
			{
				onClickCancel();
			}
			
			// Update textlength object.
			
			textLength.text = Std.string(textEntryBox.textField.length);
		}
		
		if (FlxG.keys.pressed.LEFT)
		{
			alphaCrop -= ALPHA_STEP;
			textDirty = true;
		}
		
		if (FlxG.keys.pressed.RIGHT)
		{
			alphaCrop += ALPHA_STEP;
			textDirty = true;
		}
		
		if (textDirty)
		{
			alphaCrop = FlxMath.bound(alphaCrop, 0.01, 0.99);
			alphaDisplay.text = alphaText();
			text.drawFrame(true);
			applyStyleToText();
		}
		
		super.update();
	}
	
	private function alphaText():String
	{
		return "< Alpha Threshold: " + FlxMath.roundDecimal(alphaCrop, 2) + " >";
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
			textEntryBox.textField.background = true;
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
		var bitmapdata:BitmapData = Utils.cropBitmapData(text.pixels);
		var bytearray:ByteArray = Utils.encodeBitmapDataToPNG(bitmapdata);
		
		Utils.openSaveFileDialog(bytearray, Utils.getFileName(currentStyle));
	}
	
	/**
	 * Callback for the text edit OK button.
	 */
	private function onClickOkay():Void
	{
		if (Utils.lastCharacter(textEntryBox.text) == "\r")
		{
			textEntryBox.text = Utils.removeLastOccuranceOf(textEntryBox.text, "\r");
		}
		
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
		textEntryBox.textField.background = false;
		allowBottomButtons = true;
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
		var family:PixelFamily = new PixelFamily();
		
		var xPos:Int = 0;
		var yPos:Int = 0;
		
		while (yPos < h)
		{
			while (xPos < w)
			{
				family.autoSet(p, xPos, yPos);
				
				if (family.hasPixel)
				{
					applyStyle(currentStyle, family, p, NormalColor, HiColor, MedHiColor, LowColor);
				}
				
				xPos++;
			}
			
			xPos = 0;
			yPos++;
		}
		
		Obj.pixels = p;
	}
	
	private function applyStyle(Style:TextStyle, F:PixelFamily, D:BitmapData, Norm:FlxColor, Hi:FlxColor, MedHi:FlxColor, Lo:FlxColor):Void
	{
		if (isAlphaLessThan(F, alphaCrop))
		{
			D.setPixel32(F.x, F.y, 0);
		}
		else if (isCenter(F))
		{
			D.setPixel32(F.x, F.y, Norm);
		}
		else
		{
			// Highlights vary greatly between styles
			
			switch (Style)
			{
				case TextStyle.TITLE:
					if (isTop(F)) 		set(D, F.x, F.y, Hi);
					else if (isLeft(F))
					{
						if (F.above == Hi || F.twoAbove == Hi)
						{
							set(D, F.x, F.y, MedHi);
						}
						else
						{
							set(D, F.x, F.y, Lo);
						}
					}
					else if (isBottom(F)) 	set(D, F.x, F.y, Lo);
					else if (isRight(F))
					{
						if (!isClear(F.bottomRight) || !isClear(F.rightOneDownTwo))
						{
							set(D, F.x, F.y, MedHi);
						}
						else if (F.twoAbove == Hi)
						{
							set(D, F.x, F.y, MedHi);
						}
						else if (F.twoAbove == 0)
						{
							set(D, F.x, F.y, Hi);
						}
						else
						{
							set(D, F.x, F.y, Lo);
						}
					}
				case TextStyle.LEVELUP:
					if (isTop(F)) set(D, F.x, F.y, Hi);
					else if (isBottom(F)) set(D, F.x, F.y, Lo);
					else if (isLeft(F))
					{
						if (isClear(F.fourAbove))
						{
							set(D, F.x, F.y, Hi);
						}
						else if (F.twoAbove == Hi)
						{
							set(D, F.x, F.y, MedHi);
						}
						else
						{
							set(D, F.x, F.y, Lo);
						}
					}
					else // isRight
					{
						if (F.above == Hi)
						{
							set(D, F.x, F.y, MedHi);
						}
						else
						{
							set(D, F.x, F.y, Lo);
						}
					}
				case TextStyle.ZENITH:
					if (isLeft(F) || isTop(F))
					{
						set(D, F.x, F.y, Hi);
					}
					else
					{
						set(D, F.x, F.y, Lo);
					}
				case TextStyle.GAMEOVER:
					if (isLeft(F) || isTop(F))
					{
						set(D, F.x, F.y, Hi);
					}
					else
					{
						set(D, F.x, F.y, Lo);
					}
			}
		}
	}
	
	private function isCenter(Family:PixelFamily):Bool
	{
		return !isTop(Family) && !isLeft(Family) && !isRight(Family) && !isBottom(Family);
	}
	
	private function isTop(Family:PixelFamily):Bool
	{
		return isClear(Family.above);
	}
	
	private function isLeft(Family:PixelFamily):Bool
	{
		return isClear(Family.left);
	}
	
	private function isRight(Family:PixelFamily):Bool
	{
		return isClear(Family.right);
	}
	
	private function isBottom(Family:PixelFamily):Bool
	{
		return isClear(Family.below);
	}
	
	private function isAlphaLessThan(Family:PixelFamily, Value:Float):Bool
	{
		return Family.active.alphaFloat < Value;
	}
	
	private function isClear(Color:FlxColor):Bool
	{
		return Color.alphaFloat < alphaCrop;
	}
	
	private function set(Data:BitmapData, X:UInt, Y:UInt, Color:UInt):Void
	{
		return Data.setPixel32(X, Y, Color);
	}
	
	private function applyStyleToText():Void
	{
		// Assigns relevant style to text
		
		switch (currentStyle)
		{
			case TextStyle.TITLE: 		styleShift(text, BLUE_MED, BLUE_LITE, BLUE_LITE_MED, BLUE_DARK);
			case TextStyle.LEVELUP: 	styleShift(text, LEVEL_YELLOW, LEVEL_LITE, LEVEL_LITE_MED, LEVEL_DARK);
			case TextStyle.ZENITH: 		styleShift(text, ZENITH_MD, ZENITH_HI, ZENITH_HI, ZENITH_LO);
			case TextStyle.GAMEOVER: 	styleShift(text, GAMEOVER_MD, GAMEOVER_HI, GAMEOVER_HI, GAMEOVER_LO);
		}
	}
}