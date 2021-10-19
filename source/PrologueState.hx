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
	public static var leftState:Bool = false;
	public static var prologuePlayedAgain:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey there!\n
			It seems you've seen the prologue already\n
			but if you want to see it again click enter!\n
			if not click backspace\n
			then you can play the game without watching.\n
			just a warning the cutscene is unskippable once you play it.",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 0.5, {
						onComplete: function (twn:FlxTween) {
							videoIntro('Week 1 Prologue GAME');
						}
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 0.5, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
							prologuePlayedAgain = true;
						}
					});
				}
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

			(new FlxVideo(fileName)).finishCallback = function() {
				remove(bg);
				MusicBeatState.switchState(new TitleState());
				prologuePlayedAgain = true;
			}
			return;
		} else {
			FlxG.log.warn('Couldnt find video file: ' + fileName);
		}
		#end
		MusicBeatState.switchState(new TitleState());
		prologuePlayedAgain = true;
	}
}
