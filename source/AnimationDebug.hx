package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import openfl.net.FileReference;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.addons.ui.FlxUIText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;

/**
	*DEBUG MODE
 */
class AnimationDebug extends FlxState
{
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;
	var bg:FlxSprite;
	var grid:FlxSprite;

	var UI_box:FlxUITabMenu;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.mouse.visible = true;

		FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.music('Haggstrom'));

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		if (daAnim == 'bf')
			isDad = false;

		if (isDad)
		{
			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;

			char = dad;
			dad.flipX = false;
		}
		else
		{
			bf = new Boyfriend(0, 0);
			bf.screenCenter();
			bf.debugMode = true;

			char = bf;
			bf.flipX = false;
			add(bf);
		}

		var devtext1:FlxText = new FlxText(5, FlxG.height - 20, 0, "Press ALT to Main Menu", 20);
		devtext1.scrollFactor.set();
		devtext1.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		var devtext2:FlxText = new FlxText(5, FlxG.height - 40, 0, "Press M to mute song, N to unmute song", 20);
		devtext2.scrollFactor.set();
		devtext2.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		var devtext3:FlxText = new FlxText(5, FlxG.height - 60, 0, "AS switching animations", 20);
		devtext3.scrollFactor.set();
		devtext3.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		var devtext4:FlxText = new FlxText(5, FlxG.height - 80, 0, "IJKL moves camera", 20);
		devtext4.scrollFactor.set();
		devtext4.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		var devtext6:FlxText = new FlxText(5, FlxG.height - 100, 0, "Arrows moves charter", 20);
		devtext6.scrollFactor.set();
		devtext6.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		var devtext5:FlxText = new FlxText(5, FlxG.height - 120, 0, "Q and E camera zoom", 20);
		devtext5.scrollFactor.set();
		devtext5.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		var devtext7:FlxText = new FlxText(5, FlxG.height - 140, 0, "SPACE play animation", 20);
		devtext7.scrollFactor.set();
		devtext7.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		bg = new FlxSprite(-80).loadGraphic(Paths.image('debugBG'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.visible = true;
		bg.antialiasing = true;

		var tabs = [{name: "Character", label: 'Character'}, {name: "Options", label: 'Options'}];
		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(250, 350);
		UI_box.x = 1000;
		UI_box.y = 20;

		// grid = new FlxSprite(-80).loadGraphic(Paths.image('debugGrid'));
		// grid.setGraphicSize(Std.int(grid.width * 1.1));
		// grid.updateHitbox();
		// grid.screenCenter();
		// grid.alpha = 1;
		// grid.visible = true;
		// grid.antialiasing = true;

		add(bg);
		add(devtext1);
		add(devtext2);
		add(devtext3);
		add(devtext4);
		add(devtext5);
		add(devtext6);
		add(devtext7);

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);
		add(dad);
		// add(UI_box);
		// add(grid);

		function addCharacterUI():Void
		{
			var tab_group_character = new FlxUI(null, UI_box);
			tab_group_character.name = "Character";
		}

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.WHITE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);
		var menubind = FlxG.keys.justPressed.ALT;
		var mute = FlxG.keys.justPressed.M;
		var unmute = FlxG.keys.justPressed.N;

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (menubind)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new MainMenuState());
		}

		if (mute)
		{
			FlxG.sound.music.stop();
		}

		if (unmute)
		{
			FlxG.sound.playMusic(Paths.music('Haggstrom'));
		}

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP)
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		super.update(elapsed);
	}
}
