package;

import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class OptionCatagory
{
	private var _options:Array<Option> = new Array<Option>();
	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Catagory";
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}
	private var description:String = "";
	private var display:String;
	public final function getDisplay():String
	{
		return display;
	}

	public final function getDescription():String
	{
		return description;
	}

	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
}

class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		FlxG.save.data.dfjk = !FlxG.save.data.dfjk;
		
		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return  FlxG.save.data.dfjk ? "DFJK QWOP ZXNM Arrows" : "WASD IJKL Arrows";
	}
}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.downscroll ? "Down scroll" : "Up scroll";
	}
}

class TappingOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.GhosTtapingOption = !FlxG.save.data.GhosTtapingOption;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Ghost Tapping o" + (!FlxG.save.data.GhosTtapingOption ? "ff" : "n");
	}
}

class ResetOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.canReset = !FlxG.save.data.canReset;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Reset Keybind " + (!FlxG.save.data.canReset ? "Dis" : "En") + "abled";
	}
}

class CheatOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.canCheat = !FlxG.save.data.canCheat;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Cheating " + (FlxG.save.data.canCheat ? "Allowed" : "Prohibited");
	}
}

class RespawnOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.instaReset = !FlxG.save.data.instaReset;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Instant Respawn O" + (!FlxG.save.data.instaReset ? "ff" : "n");
	}
}

class QuantOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.noteQuant = !FlxG.save.data.noteQuant;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note Quantisation O" + (!FlxG.save.data.noteQuant ? "ff" : "n");
	}
}

class AccuracyOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on");
	}
}

class ReplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	
	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new LoadReplayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Load replays";
	}
}

class JudgementsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.judgements = !FlxG.save.data.judgements;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Judgements " + (!FlxG.save.data.judgements ? "off" : "on");
	}
}

class NotesSplashOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.notesplash = !FlxG.save.data.notesplash;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note Splashes o" + (FlxG.save.data.notesplash ? "n" : "ff");
	}
}

class FlagmarkOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.flagmark = !FlxG.save.data.flagmark;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Flag Engine Mark " + (!FlxG.save.data.flagmark ? "off" : "on");
	}
}

class MiddleScrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}
	public override function press():Bool
	{
		FlxG.save.data.middleScroll = !FlxG.save.data.middleScroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Middle Scroll " + (!FlxG.save.data.middleScroll ? "off" : "on");
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter " + (!FlxG.save.data.fps ? "off" : "on");
	}
}


class FCMod extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.fullcombomod = !FlxG.save.data.fullcombomod;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FC only mod " + (!FlxG.save.data.fullcombomod ? "off" : "on");
	}
}

class PFCMod extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.perfectfullcombomod = !FlxG.save.data.perfectfullcombomod;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "PFC only mod " + (!FlxG.save.data.perfectfullcombomod ? "off" : "on");
	}
}

class PracticeMode extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.PracticeMode = !FlxG.save.data.PracticeMode;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Practice Mode " + (!FlxG.save.data.PracticeMode ? "off" : "on");
	}
}

class ToogleGUI extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.toogleguioption = !FlxG.save.data.toogleguioption;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Show GUI " + (!FlxG.save.data.toogleguioption ? "on" : "off");
	}
}

class DadToogle extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.hidedad = !FlxG.save.data.hidedad;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Show opponent " + (!FlxG.save.data.hidedad ? "on" : "off");
	}
}

class BFToogle extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.hidebf = !FlxG.save.data.hidebf;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Show Boyfriend " + (!FlxG.save.data.hidebf ? "on" : "off");
	}
}

class GFToogle extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.hidegf = !FlxG.save.data.hidegf;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Show Girlfriend " + (!FlxG.save.data.hidegf ? "on" : "off");
	}
}

class Strums extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.glowStrums = !FlxG.save.data.glowStrums;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Glow Opponent Strums " + (!FlxG.save.data.glowStrums ? "on" : "off");
	}
}
