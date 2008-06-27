package com.troyworks.framework.loader {
	import flash.net.URLLoaderDataFormat;	

	import com.troyworks.core.events.PlayheadEvent;	

	import flash.text.TextField;	
	import flash.events.Event;	
	import flash.net.URLRequest;	

	import com.troyworks.core.cogs.CogEvent;	

	import flash.display.Sprite;	
	import flash.display.DisplayObject;	
	import flash.net.URLLoader;	

	import com.troyworks.core.chain.UnitOfWork;

	/**
	 * TextLoaderUnit
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 23, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class TextLoaderUnit extends UnitOfWork {
		private var s_loader : URLLoader ;
		private var s_loaderUtil : LoaderUtil;
		public var mediaURL : String = "text.txt"; 

		public var targetClip : Sprite;
		public  var clip : String;
		private var xml : XML;		

		
		public function TextLoaderUnit(initState : String = "s__haventStarted", aMode : Boolean = SEQUENTIAL_MODE) {
			super(initState, aMode);
		}

		override public function getWorkPerformed() : Number {
			trace("getWorkPerformed");
			if(s_loader == null ) {
				
				trace("getWorkPerformed1 NaN");
				return NaN;
			}else {
				
				trace("getWorkPerformed2 " + s_loader.bytesLoaded);
				return s_loader.bytesLoaded;
			}
		}

		override public function getTotalWorkToPerform() : Number {

			if(s_loader == null) {
				return NaN;
			}else {
				return s_loader.bytesTotal;
			}
		}

		override public function s__doing(e : CogEvent) : Function {
			switch (e.sig) {
				//case SIG_INIT:
				//	return (totalPerformed > 0 && totalWork > 0 )? s___partiallyDone:null;
				case SIG_ENTRY :
					/////////////////////////////////////
					s_loader = new URLLoader();
					
					s_loader.dataFormat = URLLoaderDataFormat.TEXT;
					//s_loaderUtil = new LoaderUtil(s_loader);

					s_loader.addEventListener(Event.COMPLETE, completeLoadedHandler);
					var request : URLRequest = new URLRequest(mediaURL);
					
					trace("HIGHLIGHTO starting to load SWF/IMG '" + mediaURL + "'");
					s_loader.load(request);
					break;	
			}
			return super.s__doing(e);
		}		

		
		
		public function completeLoadedHandler(event : Event) : void {
			trace("completeHandler: " + event);
			
			if(event.target.data is XML) {
				
				try {
					//Convert the downloaded text into an XML
					xml = new XML(event.target.data);
					trace(xml);
				} catch (err : TypeError) {
					//Could not convert the data, probavlu because
					//because is not formated correctly
					trace("Could not parse the XML");
					trace(err.message);
				}
			}else{
				
			}
			
			////////// TODO LAYOUT //////////////////

			var clip : TextField = new TextField();
			
			clip.text = event.target.data;
			clip.x = Math.random() * 50;
			clip.y = Math.random() * 50;
			clip.alpha = .3;
			targetClip.addChild(clip);
			dispatchEvent(new PlayheadEvent(EVT_COMPLETE));
			//dispatchEvent(event);
		}
	}
}
