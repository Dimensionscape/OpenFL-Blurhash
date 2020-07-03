# OpenFL-Blurhash

OpenFL-Blurhash Decoder for Haxe and OpenFL that allows you to integrate beautiful image placeholders in your apps when the original takes too long to load from an external web service. Simply use one of the backend encoder libraries from https://blurha.sh/ and pass compact, Base83 encoded strings to the client very quickly in order to render Bitmap placeholders while the actual image is loading.

![Image of example](https://cdn.discordapp.com/attachments/310222402674229249/728483366097125386/unknown.png)

Example usage:

```haxe
var placeHolderBitmapData: BitmapData = Decoder.decode("LKO2?V%2Tw=w]~RBVZRi};RPxuwH", 400, 200);
addChild(new Bitmap(placeHolderBitmapData));
```

Starling Usage:

```haxe
var placeHolderBitmapData: BitmapData = Decoder.decode("LKO2?V%2Tw=w]~RBVZRi};RPxuwH", 400, 200);
var image:Image = new Image(Texture.fromBitmapData(placeHolderBitmapData));
addChild(image);
```

Enjoy!

(Currently only works for Neko and HTML5. Cpp in progress.)
