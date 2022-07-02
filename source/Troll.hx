
⠀⠀⠀⠀⠀⢀⣤⠖⠒⠒⠒⢒⡒⠒⠒⠒⠒⠒⠲⠦⠤⢤⣤⣄⣀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣠⠟⠀⢀⠠⣐⢭⡐⠂⠬⠭⡁⠐⠒⠀⠀⣀⣒⣒⠐⠈⠙⢦⣄⠀⠀
⠀⠀⠀⣰⠏⠀⠐⠡⠪⠂⣁⣀⣀⣀⡀⠰⠀⠀⠀⢨⠂⠀⠀⠈⢢⠀⠀⢹⠀⠀
⠀⣠⣾⠿⠤⣤⡀⠤⡢⡾⠿⠿⠿⣬⣉⣷⠀⠀⢀⣨⣶⣾⡿⠿⠆⠤⠤⠌⡳⣄
⣰⢫⢁⡾⠋⢹⡙⠓⠦⠤⠴⠛⠀⠀⠈⠁⠀⠀⠀⢹⡀⠀⢠⣄⣤⢶⠲⠍⡎⣾
⢿⠸⠸⡇⠶⢿⡙⠳⢦⣄⣀⠐⠒⠚⣞⢛⣀⡀⠀⠀⢹⣶⢄⡀⠀⣸⡄⠠⣃⣿
⠈⢷⣕⠋⠀⠘⢿⡶⣤⣧⡉⠙⠓⣶⠿⣬⣀⣀⣐⡶⠋⣀⣀⣬⢾⢻⣿⠀⣼⠃
⠀⠀⠙⣦⠀⠀⠈⠳⣄⡟⠛⠿⣶⣯⣤⣀⣀⣏⣉⣙⣏⣉⣸⣧⣼⣾⣿⠀⡇⠀
⠀⠀⠀⠘⢧⡀⠀⠀⠈⠳⣄⡀⣸⠃⠉⠙⢻⠻⠿⢿⡿⢿⡿⢿⢿⣿⡟⠀⣧⠀
⠀⠀⠀⠀⠀⠙⢦⣐⠤⣒⠄⣉⠓⠶⠤⣤⣼⣀⣀⣼⣀⣼⣥⠿⠾⠛⠁⠀⢿⠀
⠀⠀⠀⠀⠀⠀⠀⠈⠙⠦⣭⣐⠉⠴⢂⡤⠀⠐⠀⠒⠒⢀⡀⠀⠄⠁⡠⠀⢸⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠲⢤⣀⣀⠉⠁⠀⠀⠀⠒⠒⠒⠉⠀⢀⡾⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠲⠦⠤⠤⠤⠤⠴⠞⠋⠀

var options:Array<OptionCatagory> = [
    new OptionCatagory("Gameplay", [
        new DFJKOption(controls),
        new TappingOption("Whether pressing a key when no notes are there counts as a miss."),
        new DownscrollOption("Change the layout of the strumline."),
        new MiddleScrollOption("If enabled, BF's notes are centred, with the opponents invisible."),
        new ResetOption("Toggle pressing R to die in game."),
        new RespawnOption("Skips the death screen when you die.")		
    ]),
    new OptionCatagory("Info", [	
        new AccuracyOption("Display accuracy information."),
        new JudgementsOption("Display judgements information."),
        new RankSystem("Switch osu or flag ranking system"),
        new PerfectRate("Toggle perfect rate calculator")
    ]),
    new OptionCatagory("Overlays", [
        new FPSOption("Toggle the FPS Counter."),
        new MEMOption("Toggle the Memory Counter."),
        new VEROption("Toggle the Version text.")
    ]),
    new OptionCatagory("Other", [
        new NotesSplashOption("Add note splashes."),
        new FlagmarkOption("Add flag engine watermark."),
        new ReplayOption("View replays."),
        new ToogleGUI("Toggle GUI."),
        //new QuantOption("Stepmania style note colours."),
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
    new OptionCatagory("Skins",[
        new NoteSkin("Changes note skin"),
        new MenuSkin("Changes menu skin")
    ])
];