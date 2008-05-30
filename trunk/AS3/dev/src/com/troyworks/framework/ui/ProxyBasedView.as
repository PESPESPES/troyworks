/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.framework.ui {
	import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.display.DisplayObject;
	
	
	dynamic public class ProxyBasedView extends Proxy implements IEventDispatcher {
		
		private var eventDispatcher:EventDispatcher;
		protected var _view:*;
		
		public function ProxyBasedView(view:DisplayObject = null) {
			super();
			  eventDispatcher = new EventDispatcher();
			setView(view);
		}
		public function setView(view:DisplayObject):void{
			//trace("Proxy.setView  " + view);
			if(view == null){
				return;
			}else{
				_view = view;
			}
		}
		public function getView():DisplayObject{
			return _view;
		}
		public function getViewClip(name:*):* {
			return flash_proxy::getProperty(name);
		}
		override flash_proxy function getProperty(name:*):* {
			var res:* = _view[name];
			trace("PROXY.getProperty " + _view + " " + name + " = " + res);
			return res;
		}

		override flash_proxy function setProperty(name:*, value:*):void {
			_view[name] = value;
		}
		override flash_proxy function callProperty(methodName:*, ... args):* {
			trace("PROXY.callProperty " + methodName);
			/*var res:*;
			switch (methodName.toString()) {
				default:
					res = _view[methodName].apply(_view, args);
					break;
			}
			return res;*/
			var _item:Object = new Object(); // Hack used to allow callProperty
			return _view[methodName].apply(_view, args);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false):void {
             _view.addEventListener(type, listener, useCapture, priority, weakRef);
        }
               
        public function dispatchEvent(event:Event):Boolean {
            return _view.dispatchEvent(event);
        }
               
        public function hasEventListener(type:String):Boolean {
            return _view.hasEventListener(type);
        }
               
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
             _view.removeEventListener(type, listener, useCapture);
        }
               
        public function willTrigger(type:String):Boolean {
            return _view.willTrigger(type);
        }
	}
	
}
