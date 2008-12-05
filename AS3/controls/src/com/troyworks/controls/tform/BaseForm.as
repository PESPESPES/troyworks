package com.troyworks.controls.tform {
	import com.troyworks.framework.ui.FontManager;	
	
	import mx.managers.IFocusManagerContainer;	
	
	import com.troyworks.controls.ttooltip.ToolTip;	
	import com.troyworks.framework.ui.BaseComponent;	
	import com.troyworks.core.cogs.CogEvent;	
	
	import flash.events.Event; 
	import flash.filters.GlowFilter;
	import mx.managers.FocusManager;
	
	/**
	 * @author Troy Gardner
	 */
	import flash.utils.clearInterval;
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	import flash.text.TextField;
	public class BaseForm extends BaseComponent {
		public var minTabIndex:Number;
		public var maxTabIndex:Number;
		public var requiredFieldAsteriskColor:Number = 0xff0066;
		protected var tooltip : ToolTip;
		protected var errorGlow : GlowFilter;
		public var focusMan : FocusManager;
		protected var filtersArr : Array = new Array();
	
		protected var lastErrorField : MovieClip = null;
	
		protected var currentField : Object;
		protected var errorIndicateIntV : Number;
		protected var modelValid : Boolean;
		public static var  tIdx : Number = 0;
		
		public function BaseForm(initialState : String, hsmfName : String, aInit : Boolean) {
			super(initialState, hsmfName, aInit);
			focusMan = new FocusManager(view as IFocusManagerContainer);
		}

		/***********************************
		 * For any clip with Lbl in it's name
		 * disable it from tabbing.
		 */
		public function disableTabOnLabels():void{
			for( var i:String in this){
				
				 var mc:Object = Object(this[i]);
			//	trace("disabling tab on  " + mc.name);
				if(String(mc.name).indexOf("Lbl") > -1){
				
					MovieClip(mc).tabEnabled =false;
				//	MovieClip(mc).visible =false;
					if(mc is TextField){
						TextField(mc).selectable =false;
					}
					
				}
			}
		}
		/***********************************
		 * Using the FontManager, who has loaded
		 * up fonts dynamically
		 * get the appropriate style
		 */
		public function styleTextFields() : void{
			for (var i : String in this) {
			//	trace(i + " " + this[i]);
				 var o:Object = this[i];
				if(o is TextField){
					var tf:TextField = TextField(o);
					//trace("FOund a TextField");
					FontManager.getInstance().styleMe(this,tf);
				}
				
			}
		}
		public function setTextFieldsToHTML():void{
			for (var i : String in this) {
			//	trace(i + " " + this[i]);
				 var o:Object = this[i];
				if(o is TextField){
					var tf:TextField = TextField(o);
					tf.html = true;
				}
				
			}	
		}
		/***************************************
		 * For a given string e.g. " this * means required"
		 * convert it into the 
		 */
		public function styleAsterisk(str:String, colorOverride:Number):String{
			var color:Number = (colorOverride == null)? requiredFieldAsteriskColor : colorOverride;
			var res:String = null;
			var a:Number = 0;
			var b:Number = str.indexOf("*");
			var c:Number = str.length;
			var AA:String = str.substring(a, b);
			var BB:String = "<font color='#"+color.toString(16)+"'>*</font>";
			var CC:String = str.substring(b+1,c);
			res = AA + BB + CC;
			return res;
		}
		function setTabIndexes(from:Number):void{
		
		}
		public static function passBlankStringIfNull(field:Object):String{
			var res:String = "";
			if(field != null){
				res = String( field);
			}
			return res;
		}
		public function onFieldFocusIn(evt:Event):void{
		trace("HIGHLIGHTO onFieldFocusIn " + MovieClip(evt.target).name);	
			if(evt.target == lastErrorField){
				//going back to correct
				clearInterval(errorIndicateIntV);
			}
		}
		public function activateErrorUI():void{
			tooltip.visible =true;
			lastErrorField.filters = filtersArr;
			clearInterval(errorIndicateIntV);
			//lastErrorField = null;
		}
		public function startErrorCountdown():void{
			   errorIndicateIntV = setInterval(activateErrorUI, 250);
		}
		/* called after a field has lost focus, indicating the user is finished
		 * and if there is an error with the field it should be popped up.
		 */
		public function onFieldFocusOut(evt : Event) : void{
		
			trace("HIGHLIGHTB onFieldFocusOut " + MovieClip(evt.target).name  + " " + lastErrorField);
			///set model
			tooltip.visible = false;
			//perform validation//
			//
			if(lastErrorField == null){
				onFieldDataChanged(evt);
			}
			if(lastErrorField != null){
				startErrorCountdown();
			}
		}
		public function onFieldDataChanged(evt:Event):void{
					clearFormError(MovieClip(evt.target));
			currentField = evt.target;
			///set model
			tooltip.visible = false;
		}
		public function clearFormError(_mc : MovieClip) : void{
				tooltip.visible = false;
				_mc.filters = [];
				lastErrorField = null;
		}
		    // A very simple custom validation method.
	     protected function validateModel():void
	      {
	                modelValid =  true;
	   
	      }
		/*.................................................................*/
		function s0_viewAssetsLoaded(e : CogEvent) : Function
		{//
		//	this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					//XXX TODO tooltip = ToolTip(attachMovie("ValidationErrorBubble","tooltip_mc",getNextHighestDepth()));
				//	tooltip.visible = false;
					disableTabOnLabels();
					styleTextFields();
					return null;
				}
			}
			return super.s0_viewAssetsLoaded(e);
		}
	}
}