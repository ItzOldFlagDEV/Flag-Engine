package;

import openfl.Lib;
import openfl.display.FPS;
import flixel.FlxG;
import lime.app.Application;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class OverlaysMain extends TextField
{
	public var infoDisplayed:Array<Bool> = [true, true, true];

	public var memPeak:Float = 0;
	public var currentFPS:Int = 0;

	public static var fpsCounter:FPS;

	private var fontType:Int;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000, ?font:String)
	{
		super();

		x = inX;
		y = inY;
		selectable = false;
		defaultTextFormat = new TextFormat(font != null ? font : '_sans', (font == "_sans" ? 13 : 13), inCol);

		fpsCounter = new FPS(10000, 10000, inCol);
		fpsCounter.visible = false;
		Lib.current.addChild(fpsCounter);

		addEventListener(Event.ENTER_FRAME, onEnter);
		width = FlxG.width;
		height = FlxG.height;
	}

	private function onEnter(event:Event)
	{
		currentFPS = fpsCounter.currentFPS;

		if (visible)
		{
			text = "";

			for (i in 0...infoDisplayed.length)
			{
				if (infoDisplayed[i])
				{
					switch (i)
					{
						case 0:
							fps_Function();
						case 1:
							memory_Function();
						case 2:
							version_Function();
						case 3:
							resolution_Function();
					}

					text += "\n";
				}
			}
		}
		else
			text = "";
	}

	function fps_Function()
	{
		text += "FPS: " + currentFPS;
	}

	function resolution_Function()
	{
		text += "Resolution: " + FlxG.width + "x" + FlxG.height + "p " + Application.current.window.displayMode.refreshRate + "Hz";
	}

	function memory_Function()
	{
		var mem:Float = Math.abs(Math.round(System.totalMemory / 1024 / 1024 * 100) / 100);

		if (mem > memPeak)
			memPeak = mem;

		text += "MEM: " + mem + " MB\n" + "MEM peak: " + memPeak + " MB";
	}

	function version_Function()
	{
		text += "Flag Engine: " + MainMenuState.FlagEngine;
	}
}
