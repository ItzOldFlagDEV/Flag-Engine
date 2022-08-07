package;

import flixel.FlxSprite;

class CreditIcons extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('creditsIcons'), true, 150, 150);

		antialiasing = true;
		animation.add('OldFlag', [0], 0, false, isPlayer);
        animation.add('FunkyPikmin', [1], 0, false, isPlayer);
        animation.add('ninjamuffin99', [2], 0, false, isPlayer);
        animation.add('PhantomArcade', [4], 0, false, isPlayer);
        animation.add('evilsk8r', [3], 0, false, isPlayer);
        animation.add('kawaisprite', [5], 0, false, isPlayer);
		animation.play(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
