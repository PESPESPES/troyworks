package com.troyworks.util {
	import flash.events.EventDispatcher;	
	import flash.events.Event;	
	import flash.display.MovieClip;	
	import flash.display.DisplayObject;	
	import flash.display.DisplayObjectContainer;	

	/**
	 * InitObject
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Oct 1, 2008
	 * DESCRIPTION ::  
	 * A utility to basically help copy references/values from one clip to another 
	 *
	 * 1) Useful for also getting configuration objects/initObjects from view/controller
	 *  via functions like this
	 *  
	 *  
	 *  
	 *  public function SomeControllerClass(viewMC : MovieClip) {
			setView(viewMC);
		}

		public function setView(viewMC : MovieClip) : void {
			view = viewMC;
			initObj = new InitObject(this, view, null, null, null, onLoadedUI );
		}
		public function onLoadedUI() : void {
		}
	 */
	public class InitObject extends Object {
		public var view : MovieClip;
		public var target : Object;
		private var initObjName : String;
		public var  notOneOfFilter : Array = null;
		public var isOneOfFilter : Array = null;
		public var callback : Function;		
		public var bindViewPostInit:Boolean = false;

		public function InitObject(cntroller : Object, viewMC : MovieClip, initObj : String = "initObj", aThatsNot : Array = null, aThatsIsOneOf : Array = null, afterRecievedInitCallback : Function = null, bindView:Boolean = false) {
			view = viewMC;
			initObjName = initObj;
			target = cntroller;
			notOneOfFilter = aThatsNot;
			isOneOfFilter = aThatsIsOneOf;
			callback = afterRecievedInitCallback;
			bindViewPostInit = bindView;
			if(view.hasOwnProperty(initObjName)) {
				if(view[initObjName] != null) {
					trace("recieved " + initObjName);
					onRecievedInit();
				}else {
					trace("waiting on " + initObjName);
					view.addEventListener(Event.ENTER_FRAME, onInitCheck);
				}
			}else{
				trace("no " + initObjName);
				onFinishedInit();
			}
		}

		public function onInitCheck(evt : Event = null) : void {
			trace("InitObject.onInitCheck " + initObjName);
			if(view.hasOwnProperty(initObjName) && view[initObjName] != null) {
				trace("recieved " + initObjName);
				view.removeEventListener(Event.ENTER_FRAME, onInitCheck);
				onRecievedInit();
			}else{
				trace("still waiting on initObj...");
			}
		}

		public function onRecievedInit() : void {
			setInitValues(target, view[initObjName], notOneOfFilter, isOneOfFilter);
			onFinishedInit();
		}
		public function onFinishedInit():void{
			if(bindViewPostInit){
				bindView(target, view, notOneOfFilter, isOneOfFilter);
			}
			trace("InitObject.onFinishedInit" + callback + " for " + view.name);
			if(callback != null) {
				callback();
			}
			view = null;
			target = null;
			callback = null;
		}

		public static function bindView(targetController : Object, viewToBind : DisplayObjectContainer, aThatsNot : Array = null, aThatsIsOneOf : Array = null) : Array {
					
			var errors : Array = new Array() ;
			var i : int = 0;
			var n : int = viewToBind.numChildren;
			var dO : DisplayObject;
			var name : String;
			var k : int = 0;
			var kn : int = 0;
			for (;i < n; ++i) {
				dO = viewToBind.getChildAt(i);
				name = dO.name;
				
				var passes : Boolean = true;
					
				if(aThatsIsOneOf != null || aThatsNot != null) {
					//	trace("filtering");
					if(aThatsNot != null) {
						k = 0;
						kn = aThatsNot.length;
						for (;k < kn; ++k) {
							//black list
							var compareTo : Object = aThatsNot[k];
							if(compareTo == name) {
								passes = false;
							}
						}
					}
					if(aThatsIsOneOf != null) {
						k = 0;
						kn = aThatsNot.length;
						for (;k < kn; ++k) {
							//white list
							var compareTo2 : Object = aThatsIsOneOf[k];
							if(compareTo2 != name) {
								passes = false;
							}
						}
					}
				}		
				if(passes) {
					if(name.indexOf("instance") == 0) {
						trace("ignoring unnamed clip");
					}else {
						if(targetController.hasOwnProperty(name)) {
							trace(i + " trying to bind " + dO.name);
							try {
					
								targetController[name] = dO;
							}catch(er : Error) {
								trace("ERROR InitObject couldn't set " + name);
								errors.push(name);
							}
						}else {
							trace("ignoring binding clip " + name);
						}
					}
				}
			}		
			
			
			return errors;
		}

		
		public static function setInitValues(target : Object, initObj : Object, aThatsNot : Array = null, aThatsIsOneOf : Array = null) : Boolean {
					
			var errors : Boolean = false ;
			var k : int = 0;
			var kn : int = 0;
			for(var c:String in initObj) {
				trace("initObj " + c + " = " + initObj[c]);
				var passes : Boolean = true;
					
				if(aThatsIsOneOf != null || aThatsNot != null) {
					//	trace("filtering");
					if(aThatsNot != null) {
						k = 0;
						kn = aThatsNot.length;
						for (;k < kn; ++k) {
							//black list
							var compareTo : Object = aThatsNot[k];
							if(compareTo == c) {
								passes = false;
							}
						}
					}
					if(aThatsIsOneOf != null) {
						k = 0;
						kn = aThatsNot.length;
						for (;k < kn; ++k) {
							//white list
							var compareTo2 : Object = aThatsIsOneOf[k];
							if(compareTo2 != c) {
								passes = false;
							}
						}
					}
				}		
				if(passes) {
		
					try {
					
						target[c] = initObj[c];
					}catch(er : Error) {
						trace("ERROR InitObject couldn't set " + c);
						errors = true;
					}
				}
			}
			return errors;
		}
	}
}
