package blurhash;

/**
 * ...
 * @author Christopher Speciale, Dimensionscape LLC
 */
class Base83 
{
	private static var digitCharacters:Array<String> = [
			"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
			"A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
			"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
			"U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d",
			"e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
			"o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
			"y", "z", "#", "$", "%", "*", "+", ",", "-", ".",
			":", ";", "=", "?", "@", "[", "]", "^", "_", "{",
			"|", "}", "~"
		];
		
		public static function decode83(str:String):Float{
			var value: Float = 0;
			for(i in 0...str.length){
				var c:String = str.charAt(i);
				var digit:Int = digitCharacters.indexOf(c);
				value = value * 83 + digit;
			}
			return value;
		}
		
		public static function encode83(n:Float, length:Int):String{
			var result:String = "";
			for(i in 1...length){
				var digit:Float = (Math.floor(n) / Math.pow(83, length - i)) % 83;
				result += digitCharacters[Math.floor(digit)];
			}
			return result;
		} 
	
}
