package;

import flixel.FlxState;
import flixel.FlxG;

class IndyEndStateNew extends FlxState
{
	public var video:FlxVideo;
	public var curVideo:String = '';

	override function create()
	{
		super.create();
		

		playVideo1();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && video != null) 
			switch (curVideo)
			{
				case 'cutscene2':
					playCredits();
				case 'credits':
					trace('no u aint skippin this shit');
			}
	}

	function playVideo1():Void
	{
		trace('Playing vid 1');
		video = new FlxVideo(Paths.video('week2/Week 2 Cutscene 3 GAME'));
		video.finishCallback = playVideo2;
		curVideo = 'cutscene1';
	}

	function playVideo2():Void
	{
		video = new FlxVideo(Paths.video('week2/Week 2 Cutscene 4 GAME'));
		video.finishCallback = playCredits;
		curVideo = 'cutscene2';
	}

	function playCredits():Void
	{
		video = new FlxVideo(Paths.video('week2/Week 2 Credits GAME'));
		video.finishCallback = back2Menu;
		curVideo = 'credits';
	}

	function back2Menu():Void
	{
		video.finishCallback = function(){trace('huh');};
		FlxG.sound.playMusic(Paths.music('menu_variation_0'));
		FlxG.switchState(new StoryMenuState());

	}
}
