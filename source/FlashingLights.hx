package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class FlashingLights extends MusicBeatState
{
	override function create()
	{

		var bg:FlxSprite;

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.visible = true;
		bg.antialiasing = true;
		bg.color = 0x3F3F3F;
		add(bg);

		super.create();

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"If you have a history of epileptic seizures, \nclose the game, it has flashing lights! \n\nYou have been warned!\n\n\n\nPress ESC to ignore this",32);
		txt.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
