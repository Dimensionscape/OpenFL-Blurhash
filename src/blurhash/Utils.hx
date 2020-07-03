package blurhash;
import openfl.display.BitmapData;
/**
 * ...
 * @author Christopher Speciale, Dimensionscape LLC 2020
 */
class Utils 
{

	public static inline function sRGBToLinear(value: Float): Float {
			var v: Float = value / 255;
			if (v <= 0.04045) return v / 12.92;
			return Math.pow((v + 0.055) / 1.055, 2.4);
		}

		public static inline function linearTosRGB(value: Float): Float {
			var v: Float = Math.max(0, Math.min(1, value));
			if (v <= 0.0031308) return Math.round(v * 12.92 * 255 + 0.5);
			return Math.round((1.055 * Math.pow(v, 1 / 2.4) - 0.055) * 255 + 0.5);
		}

		public static inline function sign(n: Float): Int {
			return (n < 0 ? -1 : 1);
		}
		
		public static inline function signPow(val:Float, exp:Float):Float{
			return sign(val) * Math.pow(Math.abs(val), exp);
		}
		
		public static inline function pixelsToBitmapData(pixels:Array<Int>, width:Float, height:Float):BitmapData {
			
			var bitmapData: BitmapData = new BitmapData(cast width, cast height);
			
			var length:Int = cast pixels.length / 4;
			var row:Int = 0;
			var column:Int = 0;
			for(i in 0...length){
				var pixel:Int = i*4;
				bitmapData.setPixel(column, row, _rgbToHex(pixels[pixel], pixels[pixel+1], pixels[pixel+2]));
				column++;
				if(column>width-1){
					column = 0;
					row++;
				}
			}		
			return bitmapData;
		}
		
		private static inline function _rgbToHex(r: Int, g: Int, b: Int): UInt {
			var hex: UInt = r << 16 | g << 8 | b;
			return hex;
		}
	
}
