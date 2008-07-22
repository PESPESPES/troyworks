package com.troyworks.framework.loader {
	import flash.display.MovieClip;	
	import flash.events.IOErrorEvent;	
	import flash.errors.IOError;	
	import flash.system.ApplicationDomain;	
	import flash.system.LoaderContext;	
	
	import com.troyworks.core.events.PlayheadEvent;	
	
	import flash.display.DisplayObject;	
	
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.chain.UnitOfWork;

	import flash.display.Sprite;	
	import flash.events.Event;	
	import flash.net.URLRequest;	
	import flash.display.Loader;	

	import com.troyworks.framework.loader.LoaderUtil;

	/**
	 * SWFLoaderUnit
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 22, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class SWFLoaderUnit extends UnitOfWork {
		private var s_loader : Loader;
		private var s_loaderUtil : LoaderUtil;
		public var mediaURL : String = "B.swf"; 
		//	//"TroyWorks-80x80.jpg"; //
		public var targetClip : Sprite;
		public  var clip : DisplayObject;

		public function SWFLoaderUnit(initState : String = "s__haventStarted", aMode : Boolean = SEQUENTIAL_MODE) {
			super(initState, aMode);
		}

		override public function getWorkPerformed() : Number {
		//	trace("getWorkPerformed");
			if(s_loader == null || s_loader.contentLoaderInfo == null) {
				
			//	trace("getWorkPerformed1 NaN");
				return NaN;
			}else {
				
			//	trace("getWorkPerformed2 " + s_loader.contentLoaderInfo.bytesLoaded );
				return s_loader.contentLoaderInfo.bytesLoaded;
			}
		}

		override public function getTotalWorkToPerform() : Number {

			if(s_loader == null || s_loader.contentLoaderInfo == null) {
				return NaN;
			}else {
				return s_loader.contentLoaderInfo.bytesTotal;
			}
		}

		override public function s__doing(e : CogEvent) : Function {
			switch (e.sig) {
				//case SIG_INIT:
				//	return (totalPerformed > 0 && totalWork > 0 )? s___partiallyDone:null;
				case SIG_ENTRY :
					/////////////////////////////////////
					s_loader = new Loader();
					s_loaderUtil = new LoaderUtil(s_loader.contentLoaderInfo);
					s_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onChildErrored);
					s_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeSWFLoadHandler);
					var request : URLRequest = new URLRequest(mediaURL);
					
					trace("HIGHLIGHTO starting to load SWF/IMG '" + mediaURL + "'");
					
					var loaderContext: LoaderContext = new LoaderContext();
						loaderContext.applicationDomain = ApplicationDomain.currentDomain; 
					s_loader.load(request, loaderContext);
					break;	
			}
			return super.s__doing(e);
		}		

		
		
		public function completeSWFLoadHandler(event : Event) : void {
			trace("completeHandler: " + event);
			clip = DisplayObject(Loader(event.target.loader).content);
			////////// TODO LAYOUT //////////////////
			//clip.x = Math.random() * 50;
			//clip.y = Math.random() * 50;
			//clip.alpha = .3;
			if(clip is MovieClip){
				(clip as MovieClip).stop();
			}
			
			if(targetClip != null){
					targetClip.addChild(clip);
			}
			
			dispatchEvent(new PlayheadEvent(EVT_COMPLETE));
			//dispatchEvent(event);
		}
	}
}
