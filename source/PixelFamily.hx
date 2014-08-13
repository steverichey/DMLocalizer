package;

import flixel.util.FlxColor;
import openfl.display.BitmapData;

/**
 * Stores data about a pixel and its surrounding pixels.
 */
class PixelFamily
{
	/**
	 * X position of the active pixel.
	 */
	public var x:Int = 0;
	/**
	 * Y position of the active pixel.
	 */
	public var y:Int = 0;
	
	/**
	 * The active, center pixel.
	 */
	public var active:FlxColor = 0;
	
	/**
	 * The pixel to the left of the active pixel.
	 */
	public var left:FlxColor = 0;
	/**
	 * The pixel to the right of the active pixel.
	 */
	public var right:FlxColor = 0;
	/**
	 * The pixel above the active pixel.
	 */
	public var above:FlxColor = 0;
	/**
	 * The pixel below the active pixel.
	 */
	public var below:FlxColor = 0;
	
	/**
	 * The pixel above and to the left of the active pixel.
	 */
	public var topLeft:FlxColor = 0;
	/**
	 * The pixel above and to the right of the active pixel.
	 */
	public var topRight:FlxColor = 0;
	/**
	 * The pixel below and to the left of the active pixel.
	 */
	public var bottomLeft:FlxColor = 0;
	/**
	 * The pixel below and to the right of the active pixel.
	 */
	public var bottomRight:FlxColor = 0;
	
	/**
	 * The pixel two pixels above the active pixel.
	 */
	public var twoAbove:FlxColor = 0;
	/**
	 * The pixel three pixels above the active pixel.
	 */
	public var threeAbove:FlxColor = 0;
	/**
	 * The pixel four pixels above the active pixel.
	 */
	public var fourAbove:FlxColor = 0;
	
	/**
	 * Really specific but needed for some highlighting effects.
	 */
	public var rightOneDownTwo:FlxColor = 0;
	public var rightOneDownThree:FlxColor = 0;
	
	/**
	 * True if the active pixel is non-zero.
	 */
	public var hasPixel:Bool = false;
	/**
	 * True if there is a zero pixel to the left of this one.
	 */
	public var isOnLeft:Bool = false;
	/**
	 * True if there is a zero pixel to the right of this one.
	 */
	public var isOnRight:Bool = false;
	/**
	 * True if there is a zero pixel above this one.
	 */
	public var isOnTop:Bool = false;
	/**
	 * True if there is a zero pixel below this one.
	 */
	public var isOnBottom:Bool = false;
	
	/**
	 * Just allows instantiation. Probably this could be a typedef or something instead?
	 */
	public function new() { }
	
	/**
	 * Set all fields of this PixelFamily from BitmapData, given X and Y coordinates of the active pixel.
	 * 
	 * @param	Data	The BitmapData to use.
	 * @param	X		The X position of the active pixel.
	 * @param	Y		The Y position of the active pixel.
	 * @return	This PixelFamily object.
	 */
	public function autoSet(Data:BitmapData, X:UInt, Y:UInt):PixelFamily
	{
		x = X;
		y = Y;
		
		active = get(Data, X, Y);
		
		left = get(Data, X - 1, Y);
		right = get(Data, X + 1, Y);
		above = get(Data, X, Y - 1);
		below = get(Data, X, Y + 1);
		
		topLeft = get(Data, X - 1, Y - 1);
		topRight = get(Data, X + 1, Y - 1);
		bottomLeft = get(Data, X - 1, Y + 1);
		bottomRight = get(Data, X + 1, Y + 1);
		
		twoAbove = get(Data, X, Y - 2);
		threeAbove = get(Data, X, Y - 3);
		fourAbove = get(Data, X, Y - 4);
		
		hasPixel = active != 0;
		
		isOnTop = above == 0;
		isOnBottom = below == 0;
		isOnLeft = left == 0;
		isOnRight = right == 0;
		
		rightOneDownTwo = get(Data, X + 1, Y + 2);
		rightOneDownThree = get(Data, X + 1, Y + 3);
		
		return this;
	}
	
	/**
	 * Internal function which returns getPixel32 for the given X and Y of Data.
	 */
	private static function get(Data:BitmapData, X:Int, Y:Int):UInt
	{
		return Data.getPixel32(X, Y);
	}
}