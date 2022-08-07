package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import lime.utils.Assets;
import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end
import flixel.addons.display.FlxBackdrop;

using StringTools;

class CreditsMenuState extends MusicBeatState
{
	private var curSelected:Int = 0;
	private var grpCredits:FlxTypedGroup<Alphabet>;
	private var bg:FlxSprite;
	private var descTxt:FlxText;

	private var bgColors = [0xFFE8FD71, 0xFF7328FF, 0xFF633253, 0xFFFFD900, 0xFF65FF29, 0xFF419FF7];

	private var iconArray:Array<CreditIcons> = [];

	public static var credit:Array<SaveData> = [
		// Flag engine team here:
		new SaveData("OldFlag", "Programmer of Flag engine", "OldFlag"),
		new SaveData("FunkyPikmin", "Programmer of Flag engine", "FunkyPikmin"),
		// FNF team here:
		new SaveData("ninjamuffin99", "Programmer of Friday Night Funkin'", "ninjamuffin99"),
		new SaveData("PhantomArcade", "Animator of Friday Night Funkin'", "PhantomArcade"),
		new SaveData("evilsk8r", "Artist of Friday Night Funkin'", "evilsk8r"),
		new SaveData("kawaisprite", "Composer of Friday Night Funkin'", "kawaisprite")
	];

	override function create()
	{
		Application.current.window.title = 'Flag Engine ~ Credits Menu';

		#if desktop
		DiscordClient.changePresence("In the Credits menu", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xffffff;
		add(bg);

		grpCredits = new FlxTypedGroup<Alphabet>();
		add(grpCredits);

		for (i in 0...credit.length)
		{
			var creditText:Alphabet = new Alphabet(0, (70 * i) + 30, credit[i].nm, true, false);
			creditText.isCreditsItem = true;
			creditText.targetY = i;
			grpCredits.add(creditText);

			var icon:CreditIcons = new CreditIcons(credit[i].ico);
			icon.sprTracker = creditText;

			iconArray.push(icon);
			add(icon);
		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		descTxt = new FlxText(textBG.x, textBG.y + 4, FlxG.width, "", 20);
		descTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER);
		descTxt.scrollFactor.set();
		add(descTxt);

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		bg.color = FlxColor.interpolate(bg.color, bgColors[curSelected], CoolUtil.camLerp(0.045));
		descTxt.text = credit[curSelected].desc;

		if (controls.UP_P || FlxG.keys.justPressed.W)
		{
			changeSelection(-1);
		}
		if (controls.DOWN_P || FlxG.keys.justPressed.S)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpCredits.length - 1;
		if (curSelected >= grpCredits.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpCredits.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
			iconArray[i].animation.curAnim.curFrame = 0;
		}

		iconArray[curSelected].alpha = 1;
		iconArray[curSelected].animation.curAnim.curFrame = 2;
		iconArray[curSelected].x += 10;
	}
}

class SaveData
{
	public var nm:String;
	public var desc:String;
	public var ico:String;

	public function new(name:String, description:String, icon:String)
	{
		this.nm = name;
		this.desc = description;
		this.ico = icon;
	}
}
