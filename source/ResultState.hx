package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class ResultState extends MusicBeatSubstate
{
	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	public function new(x:Float, y:Float)
	{
		super();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		var ratingsInfo:FlxText = new FlxText(5, FlxG.height
			- 530, 0,
			"Misses: "
			+ PlayState.misses
			+ "\nBads: "
			+ PlayState.bads
			+ "\nGoods "
			+ PlayState.goods
			+ "\nSicks: "
			+ PlayState.sicks
			+ "\nMarvelous: "
			+ PlayState.marvs
			+ "\n"
			+ "\nAccuracy: "
			+ truncateFloat(PlayState.accuracy, 2)
			+ "\nMarvelous: "
			+ PlayState.marvs,
			20);
		ratingsInfo.scrollFactor.set();
		ratingsInfo.setFormat("VCR OSD Mono", 60, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		ratingsInfo.borderSize = 4;
		ratingsInfo.borderQuality = 4;
		add(ratingsInfo);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (PlayState.isStoryMode)
		{
			if (controls.BACK)
			{
				FlxG.switchState(new StoryMenuState());
			}
		}
		else
		{
			if (controls.BACK)
			{
				FlxG.switchState(new FreeplayState());
			}
		}
	}
}
