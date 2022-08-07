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

class FpsCapOptionState extends MusicBeatSubstate
{
	public var textPog:FlxText;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		textPog = new FlxText(5, FlxG.height - 0, 0, "< Fps cap: " + FlxG.save.data.fpsCap + " >", 72);
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
			if (FlxG.save.data.fpsCap < 1000)
			{
				FlxG.save.data.fpsCap += 10;
			}
			updatePogText();

			trace("Pog count:" + FlxG.save.data.fpsCap);
		}

		if (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.SHIFT)
		{
			if (FlxG.save.data.fpsCap > 60)
			{
				FlxG.save.data.fpsCap -= 10;
			}
			updatePogText();

			trace("Pog count:" + FlxG.save.data.fpsCap);
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			if (FlxG.save.data.fpsCap < 1000)
			{
				FlxG.save.data.fpsCap += 10;
			}
			updatePogText();

			trace("Pog count:" + FlxG.save.data.fpsCap);
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			if (FlxG.save.data.fpsCap > 60)
			{
				FlxG.save.data.fpsCap -= 10;
			}
			updatePogText();

			trace("Pog count:" + FlxG.save.data.fpsCap);
		}
		
		if (controls.BACK)
		{
			FlxG.switchState(new OptionsMenu());
		}
	}

	function updatePogText()
	{
		if (FlxG.save.data.fpsCap > 1000)
			FlxG.save.data.fpsCap = 1000;
		if (FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 60;
		FlxG.updateFramerate = FlxG.save.data.fpsCap;
		FlxG.drawFramerate = FlxG.save.data.fpsCap;
		textPog.text = "< Fps cap: " + FlxG.save.data.fpsCap + " >";
		textPog.screenCenter();
	}
}
