package;

import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import lime.app.Application;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var options:Array<OptionCatagory> = [
		new OptionCatagory("Gameplay", [
			new DFJKOption(controls),
			new TappingOption("Whether pressing a key when no notes are there counts as a miss."),
			new DownscrollOption("Change the layout of the strumline."),
			new MiddleScrollOption("If enabled, BF's notes are centred, with the opponents invisible."),
			new ScrollSpeedOption("Custom scroll speed"),
			new ResetOption("Toggle pressing R to die in game."),
			new RespawnOption("Skips the death screen when you die.")
		]),
		new OptionCatagory("Info", [
			new AccuracyOption("Display accuracy information."),
			new JudgementsOption("Judgements option menu"),
			new RankSystem("Switch osu or flag ranking system"),
			new PerfectRate("Toggle perfect rate calculator"),
			new SongResult("Toggle end song result screen")
		]),
		new OptionCatagory("Overlays", [
			new FPSOption("Toggle the FPS Counter."),
			new MEMOption("Toggle the Memory Counter."),
			new VEROption("Toggle the Version text."),
			new ResolutionOption("Toogle the Resolution display")
		]),
		new OptionCatagory("Other", [
			new NotesSplashOption("Add note splashes."),
			new LaneBGOption("Custom lane transparency"),
			new FpsCapOption("Custom FPS cap"),
			new FlagmarkOption("Add flag engine watermark."),
			new ReplayOption("View replays."),
			new ToogleGUI("Toggle GUI."),
			// new QuantOption("Stepmania style note colours."),
			new Strums("Toggle if opponent strums glow on note hits."),
			new HitSounds("Toggle hit sounds")
		]),
		new OptionCatagory("Optimization", [
			new DadToogle("Hiding Dad."),
			new BFToogle("Hiding Boyfriend."),
			new GFToogle("Hiding Girlfriend.")
		]),
		new OptionCatagory("Gameplay Modifiers", [
			new PracticeMode("You can no longer die. Sets score to 0."),
			new FCMod("If you miss, you will die"),
			new PFCMod("If you get below 100% accuracy, you will die"),
			new CheatOption("Toggles the ability to cheat without consequences. You know you want to.")
		]),
		new OptionCatagory("Skins", [
			new NoteSkin("Changes note skin")
		])
	];

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;

	var bg:FlxSprite;

	var currentSelectedCat:OptionCatagory;
	var isCat:Bool = false;

	override function create()
	{
		Application.current.window.title = 'Flag Engine ~ Options Menu';
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.visible = true;
		bg.antialiasing = true;
		bg.color = 0x929292;
		add(bg);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		currentDescription = "Please select a category";

		versionShit = new FlxText(5, FlxG.height - 18, 0, "Offset (Left, Right): " + FlxG.save.data.offset + " - Description - " + currentDescription, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK && !isCat)
			FlxG.switchState(new MainMenuState());
		else if (controls.BACK)
		{
			isCat = false;
			grpControls.clear();
			for (i in 0...options.length)
			{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
				// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			}
			curSelected = 0;
		}
		if (controls.DOWN_P || FlxG.keys.justPressed.S)
			changeSelection(1);

		if (controls.UP_P || FlxG.keys.justPressed.W)
			changeSelection(-1);

		if (isCat)
		{
		}
		else
		{
			if (FlxG.keys.pressed.RIGHT)
				FlxG.save.data.offset += 0.01;

			if (FlxG.keys.pressed.LEFT)
				FlxG.save.data.offset -= 0.01;

			versionShit.text = "Offset (Left, Right): " + truncateFloat(FlxG.save.data.offset, 2) + " - Description - " + currentDescription;
		}

		if (controls.ACCEPT)
		{
			if (isCat)
			{
				if (currentSelectedCat.getOptions()[curSelected].press())
				{
					grpControls.remove(grpControls.members[curSelected]);
					var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, currentSelectedCat.getOptions()[curSelected].getDisplay(), true, false);
					ctrl.isMenuItem = true;
					grpControls.add(ctrl);
				}
			}
			else
			{
				currentSelectedCat = options[curSelected];
				isCat = true;
				grpControls.clear();
				for (i in 0...currentSelectedCat.getOptions().length)
				{
					var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), true, false);
					controlLabel.isMenuItem = true;
					controlLabel.targetY = i;
					grpControls.add(controlLabel);
					// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				}
				curSelected = 0;
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end

		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (isCat)
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
		else
			currentDescription = "Please select a category";
		versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset + " - Description - " + currentDescription;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
