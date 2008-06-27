package com.troyworks.framework.loader {
	import flash.errors.IOError;	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.*;

	/**
	 * SoundLoaderAS3
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 7, 2008
	 * DESCRIPTION ::
	 *
	  playSound();
	 */
	public class SoundLoaderAS3 {
		
		
		
		var s : Sound;
		var _channel : SoundChannel;
		var audioSwfURL : String = "sound.mp3";
		
		public function playSound(evt : Event = null) {
			
			trace("***************************************************************");
			trace("playSound " + audioSwfURL);
			//trace(" attempting to restore " + audioSwfURL + " into AUDIO");
			try {
				if (_channel != null) {
					_channel.stop();//UNCOMMENT ME TO STOP THE PREVIOUS PLAYING TRACK
					//s.load(); //won't work with progressive
					//s.close(); //won't work with progressive
				}
				var req : URLRequest = new URLRequest(audioSwfURL);
				s = new Sound();
				//speaker_mc.display_txt.text =".";
				s.addEventListener(Event.COMPLETE, onSoundLoaded);
				s.addEventListener(IOErrorEvent.IO_ERROR, onSoundFailedToLoad);
				s.load(req);
			} catch (err : IOError) {
				trace(err.toString());
			} catch (err : Error) {
				trace(err.toString());
			}
		}

		function onSoundFailedToLoad(evt : Event) : void {
			trace("onSoundLoaded **FAILED**");
	//speaker_mc.display_txt.text = "!";
		}

		function onSoundLoaded(event : Event ) : void {

			var localSound : Sound = event.target as Sound;
			_channel = localSound.play();
			localSound.addEventListener(Event.SOUND_COMPLETE, onPlayComplete);
		}

		function onPlayComplete(evt : Event) : void {
	//if has more sounds play them else, move to next slide
	//content_mc.play();
		}

	}
}
