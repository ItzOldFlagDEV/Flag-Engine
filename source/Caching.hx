#if desktop
package;

import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;

using StringTools;

//By KadeDev

class Caching extends MusicBeatState
{
    var toBeDone = 0;
    var done = 0;

    var text:FlxText;
    var logo:FlxSprite;
    var bg:FlxSprite;
    var logoBl:FlxSprite;
    var music:FlxSound;


	override function create()
	{

        FlxG.mouse.visible = false;

        FlxG.worldBounds.set(0,0);

        bg = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.visible = true;
		bg.antialiasing = true;
		bg.color = 0x929292;
		add(bg);

        logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.screenCenter();
        add(logoBl);

        text = new FlxText(5, FlxG.height - 32, 0, "Loading assets...", 20);
		text.scrollFactor.set();
		text.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text);

        trace('starting caching..');
        
        sys.thread.Thread.create(() -> {
            cache();
        });


        super.create();
    }

    var calledDone = false;

    override function update(elapsed) 
    {
        super.update(elapsed);
    }


    function cache()
    {

        var images = [];
        var music = [];
        var data = [];

        trace("caching images...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
        {
            if (!i.endsWith(".png"))
                continue;
            images.push(i);
        }
        

        trace("caching music...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
        {
            music.push(i);
        }

        toBeDone = Lambda.count(images) + Lambda.count(music);

        for (i in images)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image("characters/" + replaced,"shared"));
            trace("cached " + replaced);
            done++;
        }

        for (i in music)
        {
            FlxG.sound.cache(Paths.inst(i));
            FlxG.sound.cache(Paths.voices(i));
            trace("Songs loaded");
            done++;
        }

        trace("Finished caching...");

			FlxG.switchState(new MainMenuState());

    }
}
#end