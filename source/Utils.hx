package;

import flixel.FlxG;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import flash.utils.ByteArray;
import flash.display.PNGEncoderOptions;

import flash.net.FileReference;

class Utils
{
	/**
	 * Returns the appropriate file name for the type of object that is being saved.
	 */
	static public function getFileName(Style:TextStyle):String
	{
		switch (Style)
		{
			case TextStyle.TITLE: 		return FlxG.random.bool() ? "dont_la.png" : "move_la.png";
			case TextStyle.LEVELUP: 	return "levelup_la.png";
			case TextStyle.ZENITH: 		return "zenith_la.png";
			case TextStyle.GAMEOVER: 	return "gameover_la.png";
		}
	}
	
	/**
	 * Scans a single vertical or horizontal row of a BitmapData for pixels. Returns true if any pixels are found.
	 * 
	 * @param	Data		The BitmapData to scan.
	 * @param	Position	The X or Y position to scan.
	 * @param	Alignment	Either VERTICAL or HORIZONTAL, will scan in that direction.
	 */
	static public function scanRow(Data:BitmapData, Position:UInt, Alignment:ScanDirection):Bool
	{
		var result:Bool = false;
		
		var thisPixel:Array<UInt> = [];
		var otherPos:UInt = 0;
		var isVert:Bool = Alignment == ScanDirection.VERTICAL;
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
	 * Takes BitmapData, crops away empty pixel rows and columns, and returns a new cropped BitmapData.
	 * 
	 * @param	Data	The BitmapData to crop.
	 */
	static public function cropBitmapData(Data:BitmapData):BitmapData
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
			hasPixels = scanRow(Data, yPos, ScanDirection.HORIZONTAL);
			
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
			
			hasPixels = scanRow(Data, yPos, ScanDirection.HORIZONTAL);
			
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
	 * Counts how often Char appears in Text.
	 */
	static public function occurancesOf(Text:String, Char:String):Int
	{
		return Text != "" && Char != "" ? Text.split(Char).length - 1 : 0;
	}
	
	static public function hasReturn(Text:String):Bool
	{
		return occurancesOf(Text, "\r") > 0;
	}
	
	static public function lastCharacter(Text:String, Length:Int = 1):String
	{
		return Text.substr(Text.length - Length, Length);
	}
	
	/**
	 * Returns a version of Text with the last occurance of Char removed.
	 */
	static public function removeLastOccuranceOf(Text:String, Char:String):String
	{
		var lastindex:Int = Text.lastIndexOf(Char, Text.length);
		
		return lastindex != -1 ? Text.substring(0, lastindex) : Text;
	}
	
	/**
	 * Converts BitmapData to a ByteArray encoded as PNG. Mostly a wrapper for BitmapData.encode()
	 * 
	 * @param	Image	The BitmapData to encode. This could be, for example, a FlxSprite's pixels.
	 */
	static public function encodeBitmapDataToPNG(Image:BitmapData):ByteArray
	{
		return Image.clone().encode(Image.rect, new PNGEncoderOptions());
	}
	
	/**
	 * Just a wrapper for FileReference, this opens a save file dialog in Flash.
	 * 
	 * @param	Data			The data to save, stored as a ByteArray.
	 * @param	DefaultFileName	The default name to be shown in the dialog.
	 */
	static public function openSaveFileDialog(Data:ByteArray, DefaultFileName:String):Void
	{
		new FileReference().save(Data, DefaultFileName);
	}
}