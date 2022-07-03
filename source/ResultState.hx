package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;

class ResultState extends MusicBeatSubstate
{
	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	override function create()
	{
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
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
