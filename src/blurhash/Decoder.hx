package blurhash;
import blurhash.Base83;
import openfl.display.BitmapData;
import blurhash.Utils;
/**
 * ...
 * @author Christopher Speciale, Dimensionscape LLC 2020
 */
class Decoder 
{

		private static var _blurhash: String;
		private static var _width: Float;
		private static var _height: Float;
		private static var _punch: Float;

		private static inline function _validateBlurhash(_blurhash: String) {
			if (_blurhash==null || _blurhash.length < 6) throw "The Blurhash string must be at least 6 characters";
		}

		private static inline function _decodeDC(value: Int): Array<Float> {
			var intR = value >> 16;
			var intG = (value >> 8) & 255;
			var intB = value & 255;
			return [Utils.sRGBToLinear(intR), Utils.sRGBToLinear(intG), Utils.sRGBToLinear(intB)];
		}

		private static inline function _decodeAC(value: Float, maximumValue: Float): Array<Float> {
			var quantR = Math.floor(value / (19 * 19));
			var quantG = Math.floor(value / 19) % 19;
			var quantB = value % 19;

			var rgb: Array<Float> = [
				Utils.signPow((quantR - 9) / 9, 2.0) * maximumValue,
				Utils.signPow((quantG - 9) / 9, 2.0) * maximumValue,
				Utils.signPow((quantB - 9) / 9, 2.0) * maximumValue
			];
			return rgb;
		}

		public static inline function decode(blurhash: String, width: Float, height: Float, punch: Float = 1):BitmapData {
			Decoder._blurhash = blurhash;
			Decoder._width = width;
			Decoder._height = height;
			Decoder._punch = punch;

			_validateBlurhash(blurhash);

			var sizeFlag = Base83.decode83(_blurhash.charAt(0));
			var numY = Math.floor(sizeFlag / 9) + 1;
			var numX = (sizeFlag % 9) + 1;

			var quantisedMaximumValue = Base83.decode83(_blurhash.charAt(0));
			var maximumValue = (quantisedMaximumValue + 1) / 168;

			var colors = new Array<Array<Float>>();
			var colorsLength:Int = cast numX * numY;
			for (i in 0...colorsLength) colors.push([0]);
			for(i in 0...colors.length){
				if (i == 0) {
					var value:Float = Base83.decode83(_blurhash.substring(2, 6));
					colors[i] = _decodeDC(cast value);					
				} else {
					var value:Float = Base83.decode83(_blurhash.substring(4 + i * 2, 6 + i * 2));
					colors[i] = _decodeAC(value, maximumValue * punch);
				}
			}

			var bytesPerRow = _width * 4;
			var pixelsLength:Int = cast bytesPerRow * _height;
			var pixels: Array<Int> = new Array();
			for (i in 0...pixelsLength) pixels.push(0);
			for(y in 0...cast _height) {
				for (x in 0...cast _width) {
					var r = 0;
					var g = 0;
					var b = 0;

					for (j in 0...cast numY) {
						for (i in 0...cast numX) {
							var basis = Math.cos((Math.PI * x * i) / width) * Math.cos((Math.PI * y * j) / height);
							
							var color = colors[i + j * cast numX];
							r += cast color[0] * basis;
							g += cast color[1] * basis;
							b += cast color[2] * basis;
							
						}
					}
					
					var intR = Utils.linearTosRGB(r);
					var intG = Utils.linearTosRGB(g);
					var intB = Utils.linearTosRGB(b);
					
					//Todo: convert this to an mulitdimensional array for easer read into bitmapdata
					pixels[Std.int(4 * x + 0 + y * bytesPerRow)] = cast intR;
					pixels[Std.int(4 * x + 1 + y * bytesPerRow)] = cast intG;
					pixels[Std.int(4 * x + 2 + y * bytesPerRow)] = cast intB;
					pixels[Std.int(4 * x + 3 + y * bytesPerRow)] = 255;//Do we really need the alpha channel? Todo: Make this optional					
				}
			}
			return Utils.pixelsToBitmapData(pixels, _width, _height);
		}
	
}
