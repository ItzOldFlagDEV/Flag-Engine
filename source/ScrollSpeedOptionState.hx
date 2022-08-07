package;

import openfl.ui.Keyboard;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ScrollSpeedOptionState extends MusicBeatSubstate
{
	public var textPog:FlxText;

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
		add(bg);

		textPog = new FlxText(5, FlxG.height - 0, 0, "< Scroll speed: " + truncateFloat(FlxG.save.data.arrowsScrollSpeed, 1) + " >", 72);
		textPog.scrollFactor.set();
		textPog.setFormat("VCR OSD Mono", 72, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textPog.screenCenter();
		textPog.borderSize = 4;
		textPog.borderQuality = 4;
		add(textPog);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.pressed.RIGHT && FlxG.keys.pressed.SHIFT)
		{
			if (FlxG.save.data.arrowsScrollSpeed < 10)
			{
				FlxG.save.data.arrowsScrollSpeed += 0.1;
			}
			updatePogText();

			trace("Pog count:" + FlxG.save.data.arrowsScrollSpeed);
		}

		if (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.SHIFT)
		{
			if (FlxG.save.data.arrowsScrollSpeed > 0.1)
			{
				FlxG.save.data.arrowsScrollSpeed -= 0.1;
			}
			updatePogText();

			trace("Pog count:" + FlxG.save.data.arrowsScrollSpeed);
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			if (FlxG.save.data.arrowsScrollSpeed < 10)
			{
				FlxG.save.data.arrowsScrollSpeed += 0.1;
			}
			updatePogText();

			trace("Pog count:" + FlxG.save.data.arrowsScrollSpeed);
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			if (FlxG.save.data.arrowsScrollSpeed > 0.1)
			{
				FlxG.save.data.arrowsScrollSpeed -= 0.1;
			}
			updatePogText();

			trace("Pog count:" + FlxG.save.data.arrowsScrollSpeed);
		}

		if (controls.BACK)
		{
			FlxG.switchState(new OptionsMenu());
		}
	}

	function updatePogText()
	{
		if (FlxG.save.data.arrowsScrollSpeed > 10)
			FlxG.save.data.arrowsScrollSpeed = 10;
		if (FlxG.save.data.arrowsScrollSpeed < 0.1)
			FlxG.save.data.arrowsScrollSpeed = 0.1;
		else if (FlxG.save.data.arrowsScrollSpeed == 1.00000000000002)
			FlxG.save.data.arrowsScrollSpeed = 1;
		textPog.text = "< Scroll speed: " + truncateFloat(FlxG.save.data.arrowsScrollSpeed, 1) + " >";
		textPog.screenCenter();
	}
}
