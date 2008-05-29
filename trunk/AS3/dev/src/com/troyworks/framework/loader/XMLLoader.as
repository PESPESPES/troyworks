package com.troyworks.framework.loader { 
	import com.troyworks.hsmf.Hsmf;
	import com.troyworks.hsmf.AEvent;
	import com.troyworks.hsmf.Signal;
	import com.troyworks.events.TProxy;
	/**
	 * @author Troy Gardner
	 * hasStarted
	 * notLoaded (normal, errorInLoading) startedLoading,
	 * loadingSuccesfully, finishingLoading isLoaded;
	 * loadedSuccessfully.
	 * loadingCompleted
	 * 
	 * TODO: unloading
	 * 
	 * This allows loaders to be chained
	 * This is extended by sequential loaders e.g A->B->C->D->E
	 *  and parrallel loaders.  A->{B,C,D}->E
	 *  
	 *  Concrete Users adjust the api to the particular media type 
	 *   (XMLDocument,
	 *    Sound,
	 *    Text,
	 *    Font,
	 *    Image
	 *    MovieClip} 
	 *    
	 *   
	///////////////////////////////////////////////////
	// This uses the onData to determine if the connection
	// has been successful or not., then routes it to the appropriate 
	// method via delegate, this is for loading XMLDocument on the either the web or the harddrive.
	 */
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.xml.XMLDocument;
	public class XMLLoader extends Hsmf implements ILoader{
		public static var XMLLOADED_EVT : Signal = new Signal (USER_SIG.value + 0, "XMLLOADED_SIG");
		
		public static var EVT_XML_PARSED:String = "XML_PARSED";
		public var hasStarted:Boolean;
		public var target:MovieClip;
	
		protected var URL : String;
	
		protected var _xml : XMLDocument;
	
		public var autoParse : Boolean = true;
	
	//	public var parentLoader:Loader = null;
		public function XMLLoader (aURL:String, aTarget:MovieClip)
		{
			super (s_initial,"XMLLoader");
			trace("new XMLLoader  for " + aURL + "  " + aTarget);
			URL = aURL;
			target = aTarget;
		//	Q_INIT(s0_notLoaded);
	
		}
		
		public function onLoad():void{
			trace("-------onLOAD------------------");		
			Q_TRAN(s0_isPartiallyLoaded);
		}
		function onUnload():void{
			Q_TRAN(s0_notLoaded);
		}
		/////////////////////////////////////////////////////////
		function calcStats():void{
		}
		function getAmountLoaded():Number{
			return _xml.getBytesLoaded();
		}
		function getTotalSize():Number{
			return _xml.getBytesTotal();
		}
		//////////////////////////////////////////////
		public function onXMLData(src:String):void{
		//successfully recieved data from the server, parse it to see if we need to update.
		//	trace(" onData  -success ?" + src);
			if (src == undefined) {
				trace("XMLLoader.load failed");
				//xml loaded failed (i.e. no connection to the webserver)
				//skip the versipn check and proceed normally
				this._xml.onLoad(false);
				//this.init1_loadAuthorConfig();
			} else {
				//xml was loaded, parse and load.
	
				/////Clean XMLDocument ////////////////
				//
				var cleaned:String = src;
				//////////Parse XMLDocument /////////
				this._xml.parseXML(cleaned);
				this._xml.loaded = true;
				this._xml.onLoad(true);
				trace("waiting on data to be loaded");
				//Q_TRAN(s0_isCompletelyLoaded);
			}
		}
		function onXMLLoad(src:Object):void{  
			
			trace("onXMLLoad onLoad------------------" + src);
			if(src == false){
				Q_TRAN(s1_errorInLoading);
			}else{
				Q_TRAN(s0_isCompletelyLoaded);
				
			}
		}
		public function startLoading(path:String):void{
			_xml = new XMLDocument ();
			Object(_xml).owner = this;
			//This are inline due to a bug in MTASC
			_xml.onData = TProxy.create(this, this.onXMLData);
			_xml.onLoad =  TProxy.create(this, this.onXMLLoad); 
			_xml.ignoreWhite = true;
			trace("****XMLLoader.startLoading("+ URL + " ->" + target + "  _xml:'" + _xml.load +"'");
			
			_xml.load (URL);
			init();
			//	dispatchEvent("STARTED_LOADING");
		}
				/*..PSEUDOSTATE...............................................................*/
		function s_initial(e : AEvent) : void
		{
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			onFunctionEnter ("s_initial-", e, []);
			if(e.sig != Q_TRACE_SIG){
				Q_INIT(s0_notLoaded);
			}
		}
		/*.................................................................*/
		function s0_notLoaded (e : AEvent) : Function
		{
			this.onFunctionEnter ("s_notLoaded-", e, []);
			switch(e.sig)
			{
				case Q_ENTRY_SIG :
				{	
					startPulse(1000/3);
					return null;
				}
				case Q_EXIT_SIG :
				{
					stopPulse();
					return null;
				}
				case Q_INIT_SIG :
				{
					return null;
				}
				case Q_PULSE_SIG:
				{
					
					if(_xml.getBytesTotal() != null && _xml.getBytesTotal() > 0){
						trace("_xml.getBytesTotal() " + _xml.getBytesTotal());
						dispatchEvent("STARTED_GETTING_DATA");
						
						Q_TRAN(s0_isPartiallyLoaded);
					}else {
						trace("_xml.getBytesTotal() " +_xml.getBytesTotal());
					}
					return null;
				}
			}
			return s_top;
		}
	
		/*.................................................................*/
		function s0_isPartiallyLoaded (e : AEvent) : Function
		{
		
			this.onFunctionEnter ("s0_isPartiallyLoaded-", e, []);
			switch(e.sig)
			{
				case Q_ENTRY_SIG :
				{
					trace("Partial enter\\\\\\\\\\\\\\\\\\");
					gotoAndPlay("loading");
					target.alpha = 30;
					startPulse(1000/12);
					return null;
				}
				case Q_EXIT_SIG :
				{
					trace("Partial exit////////////////////");	
					
					return null;
				}
				case Q_INIT_SIG :
				{
					trace("Partial init|||||||||||||||||");
					return null;
				}
				case Q_PULSE_SIG:
				{
					trace("----pulse-----");
					var l = getAmountLoaded();
					var tot = getTotalSize();
					trace("loaded " + l + " /  " + tot);
					if(tot > 0 && l >= tot){
						trace("finished Loading By Size------");
						stopPulse();
						Q_TRAN(s0_isCompletelyLoaded);
					}
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		function s0_isCompletelyLoaded (e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_isCompletelyLoaded-", e, []);
			switch(e.sig)
			{
				case Q_ENTRY_SIG :
				{
		//			trace("XMLDocument is " + _xml.toString());
					if(target != null){
					target.text_txt.text  = _xml.toString();
					}
					gotoAndPlay("loaded");
					dispatchEvent("FINISHED_LOADING");
									trace("^^AA^^^^^^^^^^^^^^^^isCOmpletely Loaded^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
									trace("^^^^^^^^^^^^^^^^^^isCOmpletely Loaded^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
									trace("^^^^^^^^^^^^^^^^^^isCOmpletely Loaded^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
									trace("^^^^^^^^^^^^^^^^^^isCOmpletely Loaded^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
									trace("^^^^^^^^^^^^^^^^^^isCOmpletely Loaded^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
									trace("^^^^^^^^^^^^^^^^^^isCOmpletely Loaded^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
									trace("^^^^^^^^^^^^^^^^^^isCOmpletely Loaded^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
					
					trace("^^^^^^^zz^^^^^^^^^^^isCOmpletely Loaded^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
					return null;
				}
				case Q_EXIT_SIG :
				{
					return null;
				}
				case Q_INIT_SIG :
				{
					if(autoParse){
						Q_TRAN(s2_parsingXML);
					}
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		//Override this in your class
		function s2_parsingXML(e:AEvent):Function{
			this.onFunctionEnter ("s2_parsingXML-", e, []);
			switch(e.sig)
			{
				case Q_ENTRY_SIG :
				{
					trace("HIGHLIGHTP MockParsingXML: " +_xml.toString());
					return null;
				}
				case Q_EXIT_SIG :
				{
					return null;
				}
				case Q_INIT_SIG :
				{	
					Q_TRAN(s2_parsedXML);
					return null;
				}
			}
			return s_top;
			
		}
		/*.................................................................*/
		function s2_parsedXML(e:AEvent):Function{
			this.onFunctionEnter ("s2_parsedXML-", e, []);
			switch(e.sig)
			{
				case Q_ENTRY_SIG :
				{
	trace("PPPPPPPPPPPPPPPPPPPPPPPP PARSD PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
	trace("PPPPPPPPPPPPPPPPPPPPPPPP PARSD PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
	trace("PPPPPPPPPPPPPPPPPPPPPPPP PARSD PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
	trace("PPPPPPPPPPPPPPPPPPPPPPPP PARSD PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
									trace("trying to dispatch xml parsed event" + EVT_XML_PARSED + " " + this.dispatchEvent);
					dispatchEvent({type:EVT_XML_PARSED});
					return null;
				}
				case Q_EXIT_SIG :
				{
					return null;
				}
				case Q_INIT_SIG :
				{
	
					return null;
				}
			}
			return s_top;
			
		}
			/*.................................................................*/
		function s1_errorInLoading (e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_errorInLoading-", e, []);
			switch(e.sig)
			{
				case Q_ENTRY_SIG :
				{	
					stopPulse();
					trace("!!!!!!!!!!!!!!!!!!!!!!! ERROR IN Loader " + hsmID + " LOADING "+ URL +" !!!!!!!!!!!!!!!!!!!!!!!!!!");
					for(var i:String in target){
						trace(" + " + i + " " + target[i]);
					}
					dispatchEvent({type:MCLoader.EVT_ERROR_LOADING});
					return null;
				}
				case Q_EXIT_SIG :
				{
					return null;
				}
				case Q_INIT_SIG :
				{
					return null;
				}
			}
			return this.s0_notLoaded;
		}
	}
}