package;

import openfl.display.BlendMode;
import openfl.text.TextFormat;
import openfl.display.Application;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import flixel.FlxObject;
import openfl.Lib;
import flixel.text.FlxText;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
#if CRASH_HANDLER
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import Discord.DiscordClient;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

		game = new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);

		addChild(game);

		#if !mobile
		display = new OverlaysMain(10, 3, 0xFFFFFF);
		addChild(display);

		toggleFPS(FlxG.save.data.fps);
		toggleMem(FlxG.save.data.memory);
		toggleVersion(FlxG.save.data.versionshit);
		toggleResolution(FlxG.save.data.resolutionOverlay);

		FlxG.save.data.MEMOption = true;
		FlxG.save.data.FPSOption = true;
		#end

		// Set options (Ignore this)
		OptionsDefaults.updateOptionsData();
	}

	var game:FlxGame;

	public static var display:OverlaysMain;

	public function toggleFPS(enabled:Bool):Void
	{
		display.infoDisplayed[0] = enabled;
	}

	public function toggleMem(enabled:Bool):Void
	{
		display.infoDisplayed[1] = enabled;
	}

	public function toggleVersion(enabled:Bool):Void
	{
		display.infoDisplayed[2] = enabled;
	}

	public function toggleResolution(enabled:Bool):Void
	{
		display.infoDisplayed[3] = enabled;
	}
}
