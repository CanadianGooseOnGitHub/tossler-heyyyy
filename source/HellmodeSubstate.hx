package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class HellmodeSubstate extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxSprite;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(bg);

		warnText = new FlxSprite().loadGraphic(Paths.image('hellmode'));
		warnText.screenCenter();
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		var back:Bool = controls.BACK;
		if (controls.ACCEPT) {
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-hard', PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = StoryMenuState.curWeek;
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;

			LoadingState.loadAndSwitchState(new PlayState(), true);
			FreeplayState.destroyFreeplayVocals();
			} 
			else if (back){
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new StoryMenuState());
			}
		super.update(elapsed);
	}
}
