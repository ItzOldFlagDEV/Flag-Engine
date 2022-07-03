package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var GhosTtapingOption:Bool = true;

	public static var gameVer:String = "0.2.7.1";
	public static var FlagEngine:String = "1.1.1";

	var magenta:FlxSprite;
	var bgGirls:FlxSprite;
	var camFollow:FlxObject;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var bgg:FlxSprite;
	var block:FlxSprite;

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("Browsing menu", null);
		#end

		Application.current.window.title = 'Flag Engine ~ Main Menu';
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		if (FlxG.save.data.menuskin)
		{
			var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
			bg.color = 0x00FF00;
			bg.setGraphicSize(Std.int(bg.width * 1.1));
			bg.updateHitbox();
			bg.screenCenter();
			bg.scrollFactor.set();
			bg.antialiasing = true;
			add(bg);

			var bgg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('flagsimages/fungridStory'));
			bgg.scrollFactor.set();
			bgg.screenCenter();
			bgg.velocity.set(15, 15);
			bgg.antialiasing = true;
			bgg.alpha = 0.15;
			add(bgg);

			var block:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('flagsimages/block'));
			block.setGraphicSize(Std.int(block.width * 1.1));
			block.updateHitbox();
			block.screenCenter();
			block.antialiasing = true;
			block.scrollFactor.set();
			add(block);
		}
		else
		{
			var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
			bg.setGraphicSize(Std.int(bg.width * 1.1));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = true;
			bg.scrollFactor.x = 0;
			bg.scrollFactor.y = 0.18;
			add(bg);
		}

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuCus'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			if (FlxG.save.data.menuskin)
			{
				menuItem.x = 50;
			}
			else
			{
				menuItem.screenCenter(X);
			}
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;

			if (FlxG.save.data.menuskin)
			{
				switch (i)
				{
					case 0:
						menuItem.x += 0;
					case 1:
						menuItem.x += 45;
					case 2:
						menuItem.x += 90;
					case 3:
						menuItem.x += 135;
				}
			}
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 20, 0, "FNF " + gameVer, 20);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 42, 0, FlagEngine + " Flag Engine", 20);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		#if html5
		var versionShit:FlxText = new FlxText(5, FlxG.height - 64, 0, "Html5 versions can have a bugs", 20);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		#end

		// NG.core.calls.event.logEvent('swag').send();

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			// reload textures
			if (FlxG.keys.justPressed.SIX)
			{
				FlxG.switchState(new Caching());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'options':
										FlxG.switchState(new OptionsMenu());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (FlxG.save.data.menuskin)
			{
				//spr.screenCenter(X);
			}
			else
			{
				spr.screenCenter(X);
			}
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
