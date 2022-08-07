package;

import Options.FlagmarkOption;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import lime.app.Application;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import vlc.MP4Handler;
#if sys
import sys.FileSystem;
#end
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public static var marvs:Int = 0;

	var currentFrames:Int = 0;
	var notesHitArray:Array<Date> = [];

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	var halloweenLevel:Bool = false;

	#if desktop
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;
	private var shouldSplash:Bool = false;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var opponentStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	public static var misses:Int = 0;

	public static var accuracy:Float = 0.00;

	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;
	var perfectrate:FlxText;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var fc:Bool = true;
	var mfc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var tankWatchtower:BGSprite;
	var tankGround:BGSprite;
	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var foregroundSprites:FlxTypedGroup<BGSprite>;

	var talking:Bool = true;
	var cheating:Bool = false;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	var judgements:FlxText;
	var judgements1:FlxText;
	var judgementscombo:FlxText;

	var rating:String;

	var diffString:String = 'Easy';

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;

	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;
	public static var deathCounter:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	public var laneunderlay:FlxSprite;
	public var laneunderlayOpponent:FlxSprite;

	var video:MP4Handler;

	override public function create()
	{
		theFunne = FlxG.save.data.GhosTtapingOption;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		marvs = 0;
		cheating = false;

		// Say goodbye
		accuracy = 0.00;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		if (storyDifficulty == 1)
			diffString = 'Normal';
		else if (storyDifficulty == 2)
			diffString = 'Hard';
		else if (storyDifficulty == 0)
			diffString = 'Easy';

		Application.current.window.title = 'Flag Engine ~ Currently Playing: ' + SONG.song + ' (' + diffString + ')';

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
		}

		var stageCheck:String = 'stage';

		if (SONG.stage == null)
		{
			switch (storyWeek)
			{
				case 2:
					stageCheck = 'halloween';
				case 3:
					stageCheck = 'philly';
				case 4:
					stageCheck = 'limo';
				case 5:
					if (SONG.song.toLowerCase() == 'winter-horrorland')
					{
						stageCheck = 'mallEvil';
					}
					else
					{
						stageCheck = 'mall';
					}
				case 6:
					if (SONG.song.toLowerCase() == 'thorns')
					{
						stageCheck = 'schoolEvil';
					}
					else
					{
						stageCheck = 'school';
					}
				case 7:
					stageCheck = 'tank';
			}
		}
		else
		{
			stageCheck = SONG.stage;
		}

		switch (stageCheck)
		{
			case 'halloween':
				{
					curStage = 'spooky';
					halloweenLevel = true;

					var hallowTex = Paths.getSparrowAtlas('halloween_bg', 'week2');

					halloweenBG = new FlxSprite(-200, -100);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
					halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
					halloweenBG.animation.play('idle');
					halloweenBG.antialiasing = true;
					add(halloweenBG);

					isHalloween = true;
				}
			case 'philly':
				{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					add(phillyCityLights);

					for (i in 0...5)
					{
						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = true;
						phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain', 'week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train', 'week3'));
					add(phillyTrain);

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes', 'week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street', 'week3'));
					add(street);
				}
			case 'limo':
				{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset', 'week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo', 'week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);
					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay', 'week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive', 'week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol', 'week4'));
					// add(limo);
				}
			case 'mall':
				{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls', 'week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop', 'week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator', 'week5'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree', 'week5'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop', 'week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					add(bottomBoppers);

					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow', 'week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa', 'week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					add(santa);
				}
			case 'mallEvil':
				{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG', 'week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree', 'week5'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow", 'week5'));
					evilSnow.antialiasing = true;
					add(evilSnow);
				}
			case 'school':
				{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky', 'week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool', 'week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet', 'week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack', 'week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees', 'week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals', 'week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (SONG.song.toLowerCase() == 'roses')
					{
						bgGirls.getScared();
					}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}
			case 'schoolEvil':
				{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool', 'week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);
				}
			case 'tank':
				{
					defaultCamZoom = 0.9;

					curStage = 'tank';

					var sky:BGSprite = new BGSprite('stage/tankSky', -400, -400, 0, 0);
					add(sky);

					var clouds:BGSprite = new BGSprite('stage/tankClouds', FlxG.random.int(-700, -100), FlxG.random.int(-20, 20), 0.1, 0.1);
					clouds.active = true;
					clouds.velocity.x = FlxG.random.float(5, 15);
					add(clouds);

					var mountains:BGSprite = new BGSprite('stage/tankMountains', -300, -20, 0.2, 0.2);
					mountains.setGraphicSize(Std.int(mountains.width * 1.2));
					mountains.updateHitbox();
					add(mountains);

					var buildings:BGSprite = new BGSprite('stage/tankBuildings', -200, 0, 0.3, 0.3);
					buildings.setGraphicSize(Std.int(buildings.width * 1.1));
					buildings.updateHitbox();
					add(buildings);

					var ruins:BGSprite = new BGSprite('stage/tankRuins', -200, 0, 0.35, 0.35);
					ruins.setGraphicSize(Std.int(ruins.width * 1.1));
					ruins.updateHitbox();
					add(ruins);

					var smokeL:BGSprite = new BGSprite('stage/smokeLeft', -200, -100, 0.4, 0.4, ['SmokeBlurLeft'], true);
					add(smokeL);

					var smokeR:BGSprite = new BGSprite('stage/smokeRight', 1100, -100, 0.4, 0.4, ['SmokeRight'], true);
					add(smokeR);

					tankWatchtower = new BGSprite('stage/tankWatchtower', 100, 50, 0.5, 0.5, ['watchtower gradient color']);
					add(tankWatchtower);

					tankGround = new BGSprite('tank/tankRolling', 300, 300, 0.5, 0.5, ['BG tank w lighting'], true);
					add(tankGround);

					tankmanRun = new FlxTypedGroup<TankmenBG>();
					add(tankmanRun);

					var ground:BGSprite = new BGSprite('stage/tankGround', -420, -150);
					ground.setGraphicSize(Std.int(ground.width * 1.15));
					ground.updateHitbox();
					add(ground);
					moveTank();

					foregroundSprites = new FlxTypedGroup<BGSprite>();
					foregroundSprites.add(new BGSprite('tank/tank0', -500, 650, 1.7, 1.5, ['idle']));
					foregroundSprites.add(new BGSprite('tank/tank1', -300, 750, 2, 0.2, ['idle']));
					foregroundSprites.add(new BGSprite('tank/tank2', 450, 940, 1.5, 1.5, ['idle']));
					foregroundSprites.add(new BGSprite('tank/tank4', 1300, 900, 1.5, 1.5, ['idle']));
					foregroundSprites.add(new BGSprite('tank/tank5', 1620, 700, 1.5, 1.5, ['idle']));
					foregroundSprites.add(new BGSprite('tank/tank3', 1300, 1200, 3.5, 2.5, ['idle']));
				}
			case 'stage':
				{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
				}
			default:
				{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
				}
		}

		var gfCheck:String = 'gf';

		if (SONG.gfVersion == null)
		{
			switch (storyWeek)
			{
				case 4:
					gfCheck = 'gf-car';
				case 5:
					gfCheck = 'gf-christmas';
				case 6:
					gfCheck = 'gf-pixel';
				case 7:
					if (SONG.song.toLowerCase() == 'Stress')
					{
						gfCheck = 'pico-speaker';
					}
					else
					{
						gfCheck = 'gf-tankmen';
					}
			}
		}
		else
		{
			gfCheck = SONG.gfVersion;
		}

		var curGf:String = '';
		switch (gfCheck)
		{
			case 'gf-car':
				curGf = 'gf-car';
			case 'gf-christmas':
				curGf = 'gf-christmas';
			case 'gf-pixel':
				curGf = 'gf-pixel';
			case 'gf-tankmen':
				curGf = 'gf-tankmen';
			default:
				curGf = 'gf';
		}

		if (SONG.song.toLowerCase() == 'stress')
			curGf = 'pico-speaker';

		gf = new Character(400, 130, curGf);
		gf.scrollFactor.set(0.95, 0.95);
		if (curGf == 'pico-speaker')
		{
			gf.x -= 50;
			gf.y -= 200;
			var tankmen:TankmenBG = new TankmenBG(20, 500, true);
			tankmen.strumTime = 10;
			tankmen.resetShit(20, 600, true);
			tankmanRun.add(tankmen);
			for (i in 0...TankmenBG.animationNotes.length)
			{
				if (FlxG.random.bool(16))
				{
					var man:TankmenBG = tankmanRun.recycle(TankmenBG);
					man.strumTime = TankmenBG.animationNotes[i][0];
					man.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
					tankmanRun.add(man);
				}
			}
		}

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'tankman':
				dad.y += 180;
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'tank':
				gf.y += 10;
				gf.x -= 30;
				boyfriend.x += 40;
				boyfriend.y += 0;
				dad.y += 60;
				dad.x -= 80;

				if (curGf != 'pico-speaker')
				{
					gf.x -= 170;
					gf.y -= 75;
				}
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);

		if (curStage == 'tank')
			add(foregroundSprites);

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		laneunderlayOpponent = new FlxSprite(0, 0).makeGraphic(110 * 4 + 50, FlxG.height * 2);
		laneunderlayOpponent.alpha = FlxG.save.data.laneTransparency;
		laneunderlayOpponent.color = FlxColor.BLACK;
		laneunderlayOpponent.scrollFactor.set();
		laneunderlayOpponent.cameras = [camHUD];

		laneunderlay = new FlxSprite(0, 0).makeGraphic(110 * 4 + 50, FlxG.height * 2);
		laneunderlay.alpha = FlxG.save.data.laneTransparency;
		laneunderlay.color = FlxColor.BLACK;
		laneunderlay.scrollFactor.set();
		laneunderlay.cameras = [camHUD];

		if (FlxG.save.data.middleScroll)
		{
			add(laneunderlay);
		}
		else
		{
			add(laneunderlayOpponent);
			add(laneunderlay);
		}

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		opponentStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / FlxG.save.data.fpsCap));
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(Character.opponentColor, Character.playerColor);
		add(healthBar);

		var flagmark = new FlxText(16, FlxG.height - 16, 12, " " + " Version of FlagEngine: " + MainMenuState.FlagEngine, 16);
		flagmark.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		flagmark.scrollFactor.set();
		flagmark.cameras = [camHUD];

		if (FlxG.save.data.flagmark)
		{
			add(flagmark);
		}

		if (FlxG.save.data.toogleguioption)
		{
			flagmark.visible = false;
		}

		judgements = new FlxText(20, 0, 0, "", 20);
		judgements.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		if (FlxG.save.data.judoutline)
		{
			judgements.borderSize = 1;
			judgements.borderQuality = 1;
		}
		if (FlxG.save.data.judalpha)
		{
			judgements.alpha = 0.5;
		}
		judgements.scrollFactor.set();
		judgements.cameras = [camHUD];
		judgements.screenCenter(Y);
		judgements.text = 'Marvelous: ${marvs}\nSicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nMisses: ${misses}\nmisses: ${misses}';
		if (FlxG.save.data.judgements)
		{
			add(judgements);
		}

		judgements1 = new FlxText(20, 0, 0, "", 20);
		judgements1.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		if (FlxG.save.data.judoutline)
		{
			judgements1.borderSize = 1;
			judgements1.borderQuality = 1;
		}
		if (FlxG.save.data.judalpha)
		{
			judgements1.alpha = 0.5;
		}
		judgements1.scrollFactor.set();
		judgements1.cameras = [camHUD];
		judgements1.screenCenter(Y);
		judgements1.y -= -110;
		judgements1.text = 'Total note hits: ${marvs + sicks + goods + bads + shits}\nmisses: ${misses}';
		if (FlxG.save.data.judgementstotal)
		{
			add(judgements1);
		}

		judgementscombo = new FlxText(20, 0, 0, "", 20);
		judgementscombo.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		if (FlxG.save.data.judoutline)
		{
			judgementscombo.borderSize = 1;
			judgementscombo.borderQuality = 1;
		}
		if (FlxG.save.data.judalpha)
		{
			judgementscombo.alpha = 0.5;
		}
		judgementscombo.scrollFactor.set();
		judgementscombo.cameras = [camHUD];
		judgementscombo.screenCenter(Y);
		judgementscombo.y -= -90;
		judgementscombo.text = 'Combo: ${combo}\nmisses: ${misses}';
		if (FlxG.save.data.judgementscombo)
		{
			add(judgementscombo);
		}

		/*
			var nowPlaying:FlxSprite;
			var nowPlayingTxt:FlxSprite;

			var nowPlaying:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('flagsimages/nowPlaying'));
			nowPlaying.updateHitbox();
			nowPlaying.y = 80;
			nowPlaying.x += 80;
			nowPlaying.antialiasing = true;
			nowPlaying.cameras = [camHUD];
			add(nowPlaying);

			var nowPlayingTxt:FlxText = new FlxText(5, FlxG.height - 640, 0, "Now playing: " + curSong, 20);
			nowPlayingTxt.cameras = [camHUD];
			nowPlayingTxt.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			add(nowPlayingTxt);

			new FlxTimer().start(3, function(tmr:FlxTimer)
			{
				nowPlaying.velocity.set(-330, 0);
				nowPlayingTxt.velocity.set(-330, 0);
			});
		 */

		perfectrate = new FlxText(20, 0, 0, "", 20);
		perfectrate.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		perfectrate.borderSize = 1;
		perfectrate.borderQuality = 1;
		perfectrate.scrollFactor.set();
		perfectrate.cameras = [camHUD];
		perfectrate.screenCenter(X);
		if (FlxG.save.data.downscroll)
		{
			perfectrate.y += 700;
		}
		perfectrate.x -= 35;
		perfectrate.text = 'PR: ${"N/A"}\nSicks: ${sicks}';
		if (FlxG.save.data.perfectrate)
		{
			add(perfectrate);
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 21, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		#if desktop
		DiscordClient.changePresence("Playing " + curSong + " " + diffString, null);
		#end
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'ugh':
					playCutscene('tank1');
				case 'guns':
					playCutscene('tank2');
				case 'stress':
					playCutscene('tank3');
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		laneunderlay.x = playerStrums.members[0].x - 25;
		laneunderlayOpponent.x = opponentStrums.members[0].x - 25;

		laneunderlay.screenCenter(Y);
		laneunderlayOpponent.screenCenter(Y);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			if (FlxG.save.data.toogleguioption)
			{
				// HPBar;
				healthBar.visible = false;
				healthBarBG.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				// Scores
				judgements.visible = false;
				scoreTxt.visible = false;
			}

			if (FlxG.save.data.hidedad)
			{
				dad.visible = false;
			}

			if (FlxG.save.data.hidebf)
			{
				boyfriend.visible = false;
			}

			if (FlxG.save.data.hidegf)
			{
				gf.visible = false;
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, songNotes[3]);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
					else if (!swagNote.mustPress && FlxG.save.data.middleScroll)
					{
						sustainNote.alpha = 0; // general offset
					}

					if (sustainNote.mustPress && FlxG.save.data.middleScroll)
					{
						sustainNote.x += -270; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if (!swagNote.mustPress && FlxG.save.data.middleScroll)
				{
					swagNote.alpha = 0; // general offset
				}

				if (swagNote.mustPress && FlxG.save.data.middleScroll)
				{
					swagNote.x += -270; // general offset
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			var noteTypeCheck:String = 'normal';

			if (SONG.noteStyle == null)
			{
				switch (storyWeek)
				{
					case 6:
						noteTypeCheck = 'pixel';
				}
			}
			else
			{
				noteTypeCheck = SONG.noteStyle;
			}

			switch (noteTypeCheck)
			{
				case 'pixel':
					if (FlxG.save.data.noteskin)
					{
						babyArrow.loadGraphic(Paths.image('Circles/Circles-pixel', 'shared'), true, 17, 17);
					}
					else
					{
						babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					}
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				case 'normal':
					if (FlxG.save.data.noteskin)
					{
						babyArrow.frames = Paths.getSparrowAtlas('Circles/Circles', 'shared');
					}
					else
					{
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					}

					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

				default:
					if (FlxG.save.data.noteskin)
					{
						babyArrow.frames = Paths.getSparrowAtlas('Circles/Circles', 'shared');
					}
					else
					{
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					}

					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				if (!FlxG.save.data.middleScroll || player != 0)
					FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					opponentStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			if (FlxG.save.data.middleScroll && player == 1)
			{
				babyArrow.x -= 270;
			}

			if (FlxG.save.data.middleScroll && player == 0)
			{
				babyArrow.x -= 2000;
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			opponentStrums.forEach(function(spr:FlxSprite)
			{
				spr.centerOffsets();
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;

			case 'tank':
				moveTank();
		}

		super.update(elapsed);

		if (FlxG.save.data.accuracyDisplay)
		{
			scoreTxt.screenCenter(X);
			scoreTxt.text = "Score:"
				+ songScore
				+ " | "
				+ "Misses:"
				+ misses
				+ " | "
				+ "Accuracy:"
				+ truncateFloat(accuracy, 2)
				+ "% "
				+ "| "
				+ rating;
		}
		else
		{
			scoreTxt.text = "Score:" + songScore;
			scoreTxt.screenCenter(X);
		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else if (healthBar.percent > 80)
			iconP1.animation.curAnim.curFrame = 2;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else if (healthBar.percent < 20)
			iconP2.animation.curAnim.curFrame = 2;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (FlxG.save.data.osuranking)
		{
			if (accuracy >= 100)
			{
				rating = "SS";
			}
			else if (accuracy >= 95)
			{
				rating = "S";
			}
			else if (accuracy >= 90)
			{
				rating = "A";
			}
			else if (accuracy >= 80)
			{
				rating = "B";
			}
			else if (accuracy >= 60)
			{
				rating = "C";
			}
			else if (accuracy <= 60)
			{
				rating = "D";
			}
			else
			{
				rating = "";
			}
		}
		else
		{
			if (accuracy == 100)
			{
				rating = "PFC";
			}

			if (goods >= 1)
			{
				rating = "GFC";
			}

			if (bads >= 1)
			{
				rating = "FC";
			}

			if (misses >= 1)
			{
				rating = "Nice";
			}

			if (misses >= 10)
			{
				rating = "BAD";
			}

			if (misses >= 50)
			{
				rating = "You suck";
			}

			if (accuracy == 0.00)
			{
				rating = "";
			}
		}
		opponentStrums.forEach(function(spr:FlxSprite)
		{
			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		// #if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		// #end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		if (loadRep) // rep debug
		{
			FlxG.watch.addQuick('rep rpesses', repPresses);
			FlxG.watch.addQuick('rep releases', repReleases);
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (curSong == 'Tutorial')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
			}
		}

		if (FlxG.save.data.PracticeMode)
		{
			health = 2;
			songScore = 0;
		}

		// RESET = Quick Game Over Screen
		if (controls.RESET && FlxG.save.data.canReset && !inCutscene)
		{
			health = 0;
			trace("RESET = True");
		}

		if (controls.CHEAT)
		{
			health = 2;
			misses = 0;
			songScore = 9999999;
			accuracy = 100;
			new FlxTimer().start(3, function(tmr:FlxTimer)
			{
				if (!FlxG.save.data.canCheat)
				{
					cheating = true;
				}
			});
		}

		if (cheating) // anticheat for when you do cheat.
		{
			trace("User is cheating!");
			health -= 0.02;
			accuracy -= 1;
			misses += 1;
			songScore -= 9999999;
			gf.playAnim('scared', true);
			boyfriend.playAnim('scared', true);
			vocals.stop();
			FlxG.sound.music.stop();
		}

		if (health <= 0)
		{
			if (cheating)
			{
				// this not error, ignore this
				#if desktop
				Sys.exit(0);
				#end
			}
			else if (FlxG.save.data.instaReset)
			{
				FlxG.camera.flash(FlxColor.RED, 3);
				deathCounter++;
				FlxG.resetState();
			}
			else
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				deathCounter++;
			}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (Math.abs(daNote.noteData))
					{
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
					}

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					if (FlxG.save.data.glowStrums)
					{
						opponentStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(daNote.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
							if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
							else
								spr.centerOffsets();
						});
					}

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				if (FlxG.save.data.downscroll)
					daNote.y = (strumLine.y
						- (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(FlxG.save.data.arrowsScrollSpeed == 1 ? SONG.speed : FlxG.save.data.arrowsScrollSpeed,
							2)));
				else
					daNote.y = (strumLine.y
						- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(FlxG.save.data.arrowsScrollSpeed == 1 ? SONG.speed : FlxG.save.data.arrowsScrollSpeed,
							2)));
				// trace(daNote.y);
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if (daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else
					{
						health -= 0.075;
						vocals.volume = 0;
						if (theFunne)
							noteMiss(daNote.noteData);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		if (FlxG.save.data.glowStrums)
		{
			opponentStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay();

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				if (FlxG.save.data.resultsong)
				{
					openSubState(new ResultState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
				else
				{
					FlxG.switchState(new StoryMenuState());
				}

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				LoadingState.loadAndSwitchState(new PlayState());
			}
		}
		else
		{
			if (FlxG.save.data.resultsong)
			{
				openSubState(new ResultState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
			else
			{
				FlxG.switchState(new FreeplayState());
			}
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;
		var daRating:String = "marv";

		if (noteDiff > Conductor.safeZoneOffset * 2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = 0;
			ss = false;
			shits++;
			shouldSplash = false;
			if (FlxG.save.data.hitsounds)
			{
				FlxG.sound.play(Paths.sound('hit'));
			}
		}
		else if (noteDiff < Conductor.safeZoneOffset * -2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = 0;
			ss = false;
			shits++;
			shouldSplash = false;
			if (FlxG.save.data.hitsounds)
			{
				FlxG.sound.play(Paths.sound('hit'));
			}
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.50)
		{
			daRating = 'bad';
			score = 100;
			totalNotesHit += 0.2;
			ss = false;
			bads++;
			shouldSplash = false;
			if (FlxG.save.data.hitsounds)
			{
				FlxG.sound.play(Paths.sound('hit'));
			}
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
			totalNotesHit += 0.65;
			score = 200;
			ss = false;
			goods++;
			shouldSplash = false;
			if (FlxG.save.data.hitsounds)
			{
				FlxG.sound.play(Paths.sound('hit'));
			}
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.27)
		{
			daRating = 'good';
			totalNotesHit += 0.65;
			score = 200;
			ss = false;
			goods++;
			shouldSplash = false;
			if (FlxG.save.data.hitsounds)
			{
				FlxG.sound.play(Paths.sound('hit'));
			}
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.20)
		{
			daRating = 'sick';
			totalNotesHit += 1;
			score = 300;
			sicks++;
			shouldSplash = true;
			if (FlxG.save.data.hitsounds)
			{
				FlxG.sound.play(Paths.sound('hit'));
			}
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.15)
		{
			daRating = 'sick';
			totalNotesHit += 1;
			score = 300;
			sicks++;
			shouldSplash = true;
			if (FlxG.save.data.hitsounds)
			{
				FlxG.sound.play(Paths.sound('hit'));
			}
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'marv';
			totalNotesHit += 1;
			score = 350;
			marvs++;
			shouldSplash = true;
			if (FlxG.save.data.hitsounds)
			{
				FlxG.sound.play(Paths.sound('hit'));
			}
		}
		if (daRating == 'marv')
		{
			totalNotesHit += 1;
			marvs++;
			shouldSplash = true;
			if (FlxG.save.data.hitsounds)
			{
				FlxG.sound.play(Paths.sound('hit'));
			}
		}

		if (FlxG.save.data.fullcombomod)
		{
			if (misses > 0)
			{
				FlxG.camera.flash(FlxColor.RED, 3);
				deathCounter++;
				FlxG.resetState();
			}
		}

		if (FlxG.save.data.perfectfullcombomod)
		{
			if (accuracy <= 99.99)
			{
				FlxG.camera.flash(FlxColor.RED, 3);
				deathCounter++;
				FlxG.resetState();
			}
		}

		if (daRating != 'shit' || daRating != 'shit')
		{
			songScore += score;

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */

			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';

			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.x = coolText.x - 40;
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);

			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			comboSpr.updateHitbox();
			rating.updateHitbox();

			var seperatedScore:Array<Int> = [];

			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for (i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = coolText.x + (43 * daLoop) - 90;
				numScore.y += 80;

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				if (combo >= 10 || combo == 0)
					add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();

					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		if (loadRep) // replay code
		{
			// disable input
			up = false;
			down = false;
			right = false;
			left = false;

			// new input

			// if (rep.replay.keys[repPresses].time == Conductor.songPosition)
			//	trace('DO IT!!!!!');

			// timeCurrently = Math.abs(rep.replay.keyPresses[repPresses].time - Conductor.songPosition);
			// timeCurrentlyR = Math.abs(rep.replay.keyReleases[repReleases].time - Conductor.songPosition);

			if (repPresses < rep.replay.keyPresses.length && repReleases < rep.replay.keyReleases.length)
			{
				upP = NearlyEquals(rep.replay.keyPresses[repPresses].time, Conductor.songPosition)
					&& rep.replay.keyPresses[repPresses].key == "up";
				rightP = NearlyEquals(rep.replay.keyPresses[repPresses].time, Conductor.songPosition)
					&& rep.replay.keyPresses[repPresses].key == "right";
				downP = NearlyEquals(rep.replay.keyPresses[repPresses].time, Conductor.songPosition)
					&& rep.replay.keyPresses[repPresses].key == "down";
				leftP = NearlyEquals(rep.replay.keyPresses[repPresses].time, Conductor.songPosition)
					&& rep.replay.keyPresses[repPresses].key == "left";

				upR = NearlyEquals(rep.replay.keyReleases[repReleases].time, Conductor.songPosition)
					&& rep.replay.keyReleases[repReleases].key == "up";
				rightR = NearlyEquals(rep.replay.keyReleases[repReleases].time, Conductor.songPosition)
					&& rep.replay.keyReleases[repReleases].key == "right";
				downR = NearlyEquals(rep.replay.keyReleases[repReleases].time, Conductor.songPosition)
					&& rep.replay.keyReleases[repReleases].key == "down";
				leftR = NearlyEquals(rep.replay.keyReleases[repReleases].time, Conductor.songPosition)
					&& rep.replay.keyReleases[repReleases].key == "left";

				upHold = upP ? true : upR ? false : true;
				rightHold = rightP ? true : rightR ? false : true;
				downHold = downP ? true : downR ? false : true;
				leftHold = leftP ? true : leftR ? false : true;
			}
		}
		else if (!loadRep) // record replay code
		{
			if (upP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "up"});
			if (rightP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "right"});
			if (downP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "down"});
			if (leftP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "left"});

			if (upR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "up"});
			if (rightR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "right"});
			if (downR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "down"});
			if (leftR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "left"});
		}
		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			repPresses++;
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!inIgnoreList && !theFunne)
									badNoteCheck();
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						if (loadRep)
						{
							if (NearlyEquals(daNote.strumTime, rep.replay.keyPresses[repPresses].time, 30))
							{
								goodNoteHit(daNote);
								trace('force note hit');
							}
							else
								noteCheck(controlArray[daNote.noteData], daNote);
						}
						else
							noteCheck(controlArray[daNote.noteData], daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							if (loadRep)
							{
								if (NearlyEquals(coolNote.strumTime, rep.replay.keyPresses[repPresses].time, 30))
								{
									goodNoteHit(coolNote);
									trace('force note hit');
								}
								else
									noteCheck(controlArray[daNote.noteData], daNote);
							}
							else
								noteCheck(controlArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					if (loadRep)
					{
						if (NearlyEquals(daNote.strumTime, rep.replay.keyPresses[repPresses].time, 30))
						{
							goodNoteHit(daNote);
							trace('force note hit');
						}
						else
							noteCheck(controlArray[daNote.noteData], daNote);
					}
					else
						noteCheck(controlArray[daNote.noteData], daNote);
				}
				/* 
					if (controlArray[daNote.noteData])
						goodNoteHit(daNote);
				 */
				// trace(daNote.noteData);
				/* 
					switch (daNote.noteData)
					{
						case 2: // NOTES YOU JUST PRESSED
							if (upP || rightP || downP || leftP)
								noteCheck(upP, daNote);
						case 3:
							if (upP || rightP || downP || leftP)
								noteCheck(rightP, daNote);
						case 1:
							if (upP || rightP || downP || leftP)
								noteCheck(downP, daNote);
						case 0:
							if (upP || rightP || downP || leftP)
								noteCheck(leftP, daNote);
					}
				 */
				if (daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			}
			else if (!theFunne)
			{
				badNoteCheck();
			}
		}

		if ((up || right || down || left)
			&& generatedMusic
			|| (upHold || downHold || leftHold || rightHold)
			&& loadRep
			&& generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 2:
							if (up || upHold)
								goodNoteHit(daNote);
						case 3:
							if (right || rightHold)
								goodNoteHit(daNote);
						case 1:
							if (down || downHold)
								goodNoteHit(daNote);
						case 0:
							if (left || leftHold)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
					{
						spr.animation.play('pressed');
						trace('play');
					}
					if (upR)
					{
						spr.animation.play('static');
						repReleases++;
					}
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
					{
						spr.animation.play('static');
						repReleases++;
					}
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
					{
						spr.animation.play('static');
						repReleases++;
					}
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
					{
						spr.animation.play('static');
						repReleases++;
					}
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			updateAccuracy();
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if (leftP)
			noteMiss(0);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
		if (downP)
			noteMiss(1);
		updateAccuracy();
	}

	function updateAccuracy()
	{
		if (misses > 0 || accuracy < 96)
			fc = false;
		else
			fc = true;
		totalPlayed += 1;
		accuracy = totalNotesHit / totalPlayed * 100;

		judgements.text = 'Marvelous: ${marvs}\nSicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nMisses: ${misses}\nmisses: ${misses}';
		perfectrate.text = 'PR: ${truncateFloat((marvs + sicks) / (goods + (bads * 1.1) + (misses * 1.3)), 2)}\nSicks: ${sicks}';
		judgementscombo.text = 'Combo: ${combo}\nmisses: ${misses}';
		judgements1.text = 'Total note hits: ${marvs + sicks + goods + bads + shits}\nmisses: ${misses}';
		perfectrate.screenCenter(X);
	}

	function noteCheck(keyP:Bool, note:Note):Void // sorry lol
	{
		if (loadRep)
		{
			if (keyP)
				goodNoteHit(note);
			else if (!theFunne)
				badNoteCheck();
			else if (rep.replay.keyPresses.length > repPresses && !keyP)
			{
				if (NearlyEquals(note.strumTime, rep.replay.keyPresses[repPresses].time, 4))
				{
					goodNoteHit(note);
				}
				else if (!theFunne)
					badNoteCheck();
			}
		}
		else if (keyP)
		{
			goodNoteHit(note);
		}
		else if (!theFunne)
		{
			badNoteCheck();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime);
				combo += 1;
			}
			else
				totalNotesHit += 1;

			var noteSplashTypeCheck:String = 'normal';

			if (SONG.noteSplashStyle == null)
			{
				switch (storyWeek)
				{
					case 6:
						noteSplashTypeCheck = 'pixel';
				}
			}
			else
			{
				noteSplashTypeCheck = SONG.noteSplashStyle;
			}

			switch (noteSplashTypeCheck)
			{
				case 'pixel':
					var sploosh:FlxSprite = new FlxSprite(note.x, playerStrums.members[note.noteData].y);
					var tex:flixel.graphics.frames.FlxAtlasFrames = Paths.getSparrowAtlas('noteSplashes-pixel');
					sploosh.frames = tex;
					sploosh.animation.addByPrefix('splash 0 0', 'note splash purple 1', 24, false);
					sploosh.animation.addByPrefix('splash 0 1', 'note splash blue 1', 24, false);
					sploosh.animation.addByPrefix('splash 0 2', 'note splash green 1', 24, false);
					sploosh.animation.addByPrefix('splash 0 3', 'note splash red 1', 24, false);
					sploosh.animation.addByPrefix('splash 1 0', 'note splash purple 1', 24, false);
					sploosh.animation.addByPrefix('splash 1 1', 'note splash blue 1', 24, false);
					sploosh.animation.addByPrefix('splash 1 2', 'note splash green 1', 24, false);
					sploosh.animation.addByPrefix('splash 1 3', 'note splash red 1', 24, false);
					sploosh.antialiasing = true;
					if (shouldSplash == true && !note.isSustainNote)
					{
						sploosh.cameras = [camHUD];
						sploosh.animation.play('splash ' + FlxG.random.int(0, 1) + " " + note.noteData);
						sploosh.alpha = 1;
						sploosh.offset.x -= -99;
						sploosh.offset.y += 114;
						sploosh.animation.finishCallback = function(name) sploosh.kill();
						if (FlxG.save.data.notesplash)
						{
							add(sploosh);
						}
					}
				case 'normal':
					var sploosh:FlxSprite = new FlxSprite(note.x, playerStrums.members[note.noteData].y);
					var tex:flixel.graphics.frames.FlxAtlasFrames = Paths.getSparrowAtlas('noteSplashes');
					sploosh.frames = tex;
					sploosh.animation.addByPrefix('splash 0 0', 'note splash purple 1', 24, false);
					sploosh.animation.addByPrefix('splash 0 1', 'note splash blue 1', 24, false);
					sploosh.animation.addByPrefix('splash 0 2', 'note splash green 1', 24, false);
					sploosh.animation.addByPrefix('splash 0 3', 'note splash red 1', 24, false);
					sploosh.animation.addByPrefix('splash 1 0', 'note splash purple 2', 24, false);
					sploosh.animation.addByPrefix('splash 1 1', 'note splash blue 2', 24, false);
					sploosh.animation.addByPrefix('splash 1 2', 'note splash green 2', 24, false);
					sploosh.animation.addByPrefix('splash 1 3', 'note splash red 2', 24, false);
					sploosh.antialiasing = true;
					if (shouldSplash == true && !note.isSustainNote)
					{
						sploosh.cameras = [camHUD];
						sploosh.animation.play('splash ' + FlxG.random.int(0, 1) + " " + note.noteData);
						sploosh.alpha = 1;
						sploosh.offset.x -= -120;
						sploosh.offset.y += 110;
						sploosh.animation.finishCallback = function(name) sploosh.kill();
						if (FlxG.save.data.notesplash)
						{
							add(sploosh);
						}
					}
				default:
					var sploosh:FlxSprite = new FlxSprite(note.x, playerStrums.members[note.noteData].y);
					var tex:flixel.graphics.frames.FlxAtlasFrames = Paths.getSparrowAtlas('noteSplashes');
					sploosh.frames = tex;
					sploosh.animation.addByPrefix('splash 0 0', 'note splash purple 1', 24, false);
					sploosh.animation.addByPrefix('splash 0 1', 'note splash blue 1', 24, false);
					sploosh.animation.addByPrefix('splash 0 2', 'note splash green 1', 24, false);
					sploosh.animation.addByPrefix('splash 0 3', 'note splash red 1', 24, false);
					sploosh.animation.addByPrefix('splash 1 0', 'note splash purple 2', 24, false);
					sploosh.animation.addByPrefix('splash 1 1', 'note splash blue 2', 24, false);
					sploosh.animation.addByPrefix('splash 1 2', 'note splash green 2', 24, false);
					sploosh.animation.addByPrefix('splash 1 3', 'note splash red 2', 24, false);
					sploosh.antialiasing = true;
					if (shouldSplash == true && !note.isSustainNote)
					{
						sploosh.cameras = [camHUD];
						sploosh.animation.play('splash ' + FlxG.random.int(0, 1) + " " + note.noteData);
						sploosh.alpha = 1;
						sploosh.offset.x -= -120;
						sploosh.offset.y += 110;
						sploosh.animation.finishCallback = function(name) sploosh.kill();
						if (FlxG.save.data.notesplash)
						{
							add(sploosh);
						}
					}
			}

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;

			switch (note.noteData)
			{
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 0:
					boyfriend.playAnim('singLEFT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}

	var tankResetShit:Bool = false;
	var tankMoving:Bool = false;
	var tankAngle:Float = FlxG.random.int(-90, 45);
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankX:Float = 400;

	function moveTank():Void
	{
		if (!inCutscene)
		{
			tankAngle += tankSpeed * FlxG.elapsed;
			tankGround.angle = (tankAngle - 90 + 15);
			tankGround.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankGround.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}
	}

	function playCutscene(name:String)
	{
		inCutscene = true;

		video = new MP4Handler();
		video.finishCallback = function()
		{
			startCountdown();
		}
		video.playVideo(Paths.video(name));
	}

	function playEndCutscene(name:String)
	{
		inCutscene = true;

		video = new MP4Handler();
		video.finishCallback = function()
		{
			SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase());
			LoadingState.loadAndSwitchState(new PlayState());
		}
		video.playVideo(Paths.video(name));
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
		if (dad.curCharacter == 'tankman' && SONG.song.toLowerCase() == 'stress')
		{
			if (curStep == 736 || curStep == 737)
			{
				dad.playAnim('prettyGoodAnim', true);
			}
		}

		if (dad.curCharacter == 'tankman' && SONG.song.toLowerCase() == 'ugh')
		{
			if (curStep == 59.5 || curStep == 443.5 || curStep == 523.5 || curStep == 827.5)
			{
				dad.playAnim('ughAnim', true);
			}
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
			gf.playAnim('cheer', true);

			if (SONG.song == 'Tutorial' && dad.curCharacter == 'gf')
			{
				dad.playAnim('cheer', true);
			}
		}

		switch (curStage)
		{
			case 'tank':
				tankWatchtower.dance();

			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	var curLight:Int = 0;
}
