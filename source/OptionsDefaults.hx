package;

import flixel.FlxG;

class OptionsDefaults
{
    public static function updateOptionsData() 
    {
        if (FlxG.save.data.GhosTtapingOption == null)
			FlxG.save.data.GhosTtapingOption = true;

		if (FlxG.save.data.notesplash == null)
			FlxG.save.data.notesplash = true;

		if (FlxG.save.data.flagmark == null)
			FlxG.save.data.flagmark = true;

		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.glowStrums == null)
			FlxG.save.data.glowStrums = true;

        if (FlxG.save.data.laneTransparency == null)
			FlxG.save.data.laneTransparency = 0;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 60;

		if (FlxG.save.data.arrowsScrollSpeed == null)
			FlxG.save.data.arrowsScrollSpeed = 1;
    }
}