package;

import Sys.sleep;
import discord_rpc.DiscordRpc;

using StringTools;

class DiscordClient
{
	public function new()
	{
		DiscordRpc.start({
			clientID: "985585871245938709",
		});

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
		}

		DiscordRpc.shutdown();
	}

	static function onReady()
	{
		DiscordRpc.presence({
			details: "Flag Engine",
			state: null,
			largeImageKey: 'icon',
			largeImageText: "Friday Night Funkin': Flag Engine"
		});
	}


	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			largeImageKey: 'icon',
			state: state,
			details: details,
			largeImageText: "Friday Night Funkin': Flag Engine",
			smallImageKey : smallImageKey,
		});
	}
}