package;
import flixel.FlxSprite;

class CustomFlxSprite extends FlxSprite
	{
		public var customHitboxX:Float = 0;
		public var customHitboxY:Float = 0;
		public var customHitboxWidth:Float = -1; // -1 significa usar el ancho original
		public var customHitboxHeight:Float = -1; // -1 significa usar la altura original

		public function new(?x:Float, ?y:Float)
		{
			super(x, y);
		}
	}