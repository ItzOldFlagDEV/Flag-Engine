package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var originColor:Int = 0; // The sustain note's original note's color

	public var beat:Float = 0;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var localAngle:Float = 0; // The angle to be edited inside Note.hx
	public var originAngle:Float = 0; // The angle the OG note of the sus note had (?)

	public var noteScore:Float = 1;

	public var dataColor:Array<String> = ['purple', 'blue', 'green', 'red'];
	public var quantityColor:Array<Int> = [RED_NOTE, 2, BLUE_NOTE, 2, PURP_NOTE, 2, GREEN_NOTE, 2];
	public var arrowAngles:Array<Int> = [180, 90, 270, 0];

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?bet:Float = 0)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		beat = bet;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime + FlxG.save.data.offset;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		var noteTypeCheck:String = 'normal';

		if (PlayState.SONG.noteStyle == null)
		{
			switch (PlayState.storyWeek)
			{
				case 6:
					noteTypeCheck = 'pixel';
			}
		}
		else
		{
			noteTypeCheck = PlayState.SONG.noteStyle;
		}

		switch (noteTypeCheck)
		{
			case 'pixel':
				if (FlxG.save.data.noteskin)
				{
					loadGraphic(Paths.image('Circles/Circles-pixel', 'shared'), true, 17, 17);
					if (isSustainNote)
					{
						loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);
					}
				}
				else
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					if (isSustainNote)
					{
						loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);
					}
				}

				for (i in 0...4)
				{
					animation.add(dataColor[i] + 'Scroll', [i + 4]); // Normal notes
					animation.add(dataColor[i] + 'hold', [i]); // Holds
					animation.add(dataColor[i] + 'holdend', [i + 4]); // Tails
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			case 'normal':
				if (FlxG.save.data.noteskin)
				{
					frames = Paths.getSparrowAtlas('Circles/Circles', 'shared');
				}
				else
				{
					frames = Paths.getSparrowAtlas('NOTE_assets');
				}

				for (i in 0...4)
				{
					animation.addByPrefix(dataColor[i] + 'Scroll', dataColor[i] + '0'); // Normal notes
					animation.addByPrefix(dataColor[i] + 'hold', dataColor[i] + ' hold piece'); // Hold
					animation.addByPrefix(dataColor[i] + 'holdend', dataColor[i] + ' hold end'); // Tails
				}

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;

			default:
				if (FlxG.save.data.noteskin)
				{
					frames = Paths.getSparrowAtlas('Circles/Circles', 'shared');
				}
				else
				{
					frames = Paths.getSparrowAtlas('NOTE_assets');
				}

				for (i in 0...4)
				{
					animation.addByPrefix(dataColor[i] + 'Scroll', dataColor[i] + '0'); // Normal notes
					animation.addByPrefix(dataColor[i] + 'hold', dataColor[i] + ' hold piece'); // Hold
					animation.addByPrefix(dataColor[i] + 'holdend', dataColor[i] + ' hold end'); // Tails
				}

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
		}

		if (FlxG.save.data.downscroll && sustainNote)
		{
			flipY = true;
		}

		x += swagWidth * noteData;
		animation.play(dataColor[noteData] + 'Scroll');
		originColor = noteData; // The note's origin color will be checked by its sustain notes

		if (FlxG.save.data.noteQuant && !isSustainNote)
		{
			var col:Int = 0;

			var beatRow = Math.round(beat * 48);

			// STOLEN KADE ENGINE ETTERNA CODE

			if (beatRow % (192 / 4) == 0)
				col = quantityColor[0];
			else if (beatRow % (192 / 8) == 0)
				col = quantityColor[2];
			else if (beatRow % (192 / 12) == 0)
				col = quantityColor[4];
			else if (beatRow % (192 / 16) == 0)
				col = quantityColor[6];
			else if (beatRow % (192 / 24) == 0)
				col = quantityColor[4];
			else if (beatRow % (192 / 32) == 0)
				col = quantityColor[4];

			animation.play(dataColor[col] + 'Scroll');
			localAngle -= arrowAngles[col];
			localAngle += arrowAngles[noteData];
			originAngle = localAngle;
			originColor = col;
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			originColor = prevNote.originColor;
			originAngle = prevNote.originAngle;

			animation.play(dataColor[originColor] + 'holdend');

			updateHitbox();

			if (FlxG.save.data.downscroll && sustainNote)
			{
				y += 20;
			}

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(dataColor[prevNote.originColor] + 'hold');

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
