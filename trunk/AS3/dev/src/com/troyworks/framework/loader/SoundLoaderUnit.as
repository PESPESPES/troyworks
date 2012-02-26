package com.troyworks.framework.loader {
	import com.troyworks.core.chain.UnitOfWork;
	import com.troyworks.core.cogs.CogEvent;

	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	/**
	 * SoundLoaderUnit
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 22, 2010
	 * DESCRIPTION ::
	 *
	 */
	public class SoundLoaderUnit extends UnitOfWork {
		//	private var s_loader : Loader;

		public	var s : Sound;
		public var s_loaderUtil : LoaderUtil;
		public var mediaURL : String = "B.mp3"; 

		//	//"TroyWorks-80x80.jpg"; //
		//public var targetClip : Sprite;
		//public  var clip : DisplayObject;

		public function SoundLoaderUnit(initState : String = "s__haventStarted", aMode : Boolean = SEQUENTIAL_MODE) {
			super(initState, aMode);
			setStateMachineName("SoundLoaderUnit");
		}

		override public function getWorkPerformed() : Number {
			//	trace("getWorkPerformed");
			try {
				if(s == null || isNaN(s.bytesLoaded)) {
				
					//	trace("getWorkPerformed1 NaN");
					return NaN;
				} else {
				
					//	trace("getWorkPerformed2 " + s_loader.contentLoaderInfo.bytesLoaded );
					return s.bytesLoaded ;
				}
			}catch(e : Error) {
				//will throw error if not enough bytes have loaded!!!
			}
			return NaN;
		}

		override public function getTotalWorkToPerform() : Number {
			try {
				if(s == null ||  isNaN(s.bytesLoaded )) {
					return NaN;
				} else {
					return s.bytesTotal;
				}
			}catch(e : Error) {
				//will throw error if not enough bytes have loaded!!!
			}
			return NaN;
		}

		override public function s__doing(e : CogEvent) : Function {
			switch (e.sig) {
				//case SIG_INIT:
				//	return (totalPerformed > 0 && totalWork > 0 )? s___partiallyDone:null;
				case SIG_ENTRY :
					/////////////////////////////////////

					try {
						//if (_channel != null) {
						//		_channel.stop();//UNCOMMENT ME TO STOP THE PREVIOUS PLAYING TRACK
						//s.load(); //won't work with progressive
						//s.close(); //won't work with progressive
						//}
						var req : URLRequest = new URLRequest(mediaURL);
						s = new Sound();
						//speaker_mc.display_txt.text =".";
						s.addEventListener(Event.COMPLETE, onSoundLoaded);
						s.addEventListener(IOErrorEvent.IO_ERROR, onSoundFailedToLoad);
						s.load(req);
				
//					var loaderContext : SoundLoaderContext = new SoundLoaderContext();
//					loaderContext.applicationDomain = ApplicationDomain.currentDomain;
//				s.load(req ,loaderContext);
					} catch (err : IOError) {
						trace(err.toString());
					} catch (err : Error) {
						trace(err.toString());
					}
			
					/*			s_loader = new Loader();
					s_loaderUtil = new LoaderUtil(s_loader.contentLoaderInfo);
					//s_loaderUtil.addEventListener(Event.COMPLETE, completeSWFLoadHandler);
					s_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, calcStats);
					//s_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onChildErrored);
					s_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeSWFLoadHandler);
					var request : URLRequest = new URLRequest(mediaURL);
					
					trace(_smName + "#" + _smID + ".starting to load SWF/IMG '" + mediaURL + "'");
					
					var loaderContext : LoaderContext = new LoaderContext();
					loaderContext.applicationDomain = ApplicationDomain.currentDomain; 
					s_loader.load(request, loaderContext);*/
					break;	
			}
			return super.s__doing(e);
		}		

		public function onSoundFailedToLoad(evt : Event) : void {
			trace("onSoundLoaded **FAILED**");
	//speaker_mc.display_txt.text = "!";
		}

		public function onSoundLoaded(event : Event) : void {
			trace(_smName + "#" + _smID + ".completeHandler: " + event);
			//clip = DisplayObject(Loader(event.target.loader).content);
			trace(_smName + "#" + _smID + ".requestingDone: " + event);
			
			requestTran(s_done);
			//dispatchEvent(new PlayheadEvent(EVT_COMPLETE));
			//dispatchEvent(event);
		}
	}
}
