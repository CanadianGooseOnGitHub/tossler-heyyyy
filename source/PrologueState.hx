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
import openfl.utils.Assets as OpenFlAssets;

#if sys
import sys.FileSystem;
#end


class PrologueState extends MusicBeatState
{
    private var videoCurrentlyPlaying:FlxVideo;
	private var isVideoCurrentlyPlaying:Bool;

	override function create()                                                        
	{
		super.create();

        videoIntro('Week 1 Prologue GAME');

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
	}

	override function update(elapsed:Float)
	{
            //stole this from aikoyori :p
		if(isVideoCurrentlyPlaying)
        {
            if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ESCAPE)
            {
                videoCurrentlyPlaying.skipVideo();
                isVideoCurrentlyPlaying = false;
            }
        }
        super.update(elapsed);
	}

	public function videoIntro(name:String):Void {
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.mods('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
		#if sys
		if(FileSystem.exists(fileName)) {
			foundFile = true;
		}
		#end

		if(!foundFile) {
			fileName = Paths.video(name);
			#if sys
			if(FileSystem.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
			}
		}

        if(foundFile) {
			var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			bg.scrollFactor.set();
			add(bg);
			videoCurrentlyPlaying = new FlxVideo(fileName);
			isVideoCurrentlyPlaying = true;

			(videoCurrentlyPlaying).finishCallback = function() {
				remove(bg);
				MusicBeatState.switchState(new TitleState());
                isVideoCurrentlyPlaying = false;
                TitleState.lol = false;
			}
			return;
		} else {
			FlxG.log.warn('Couldnt find video file: ' + fileName);
		}
		#end
		MusicBeatState.switchState(new TitleState());
        isVideoCurrentlyPlaying = false;
        TitleState.lol = false;
	}
}