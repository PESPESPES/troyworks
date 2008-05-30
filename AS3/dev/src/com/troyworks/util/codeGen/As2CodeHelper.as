package com.troyworks.util.codeGen { 
	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.hsmf.AEvent;
	import util.StringUtil;
	import com.troyworks.events.TProxy;
	import util.StringFormatter;
	
	
	/**
	 * @author Troy Gardner
	 */
	import flash.text.TextField;
	public class As2CodeHelper extends BaseComponent {
		public var in_txt : TextField;
		public var out_txt : TextField;
		public var inlines : Array;
		public var outlines : Array;
	
		public function As2CodeHelper(initialState : Function, hsmfName : String, aInit : Boolean) {
			super(initialState, "As2CodeHelper", aInit);
	
		}
		public function onInputTextChanged() : void{
			trace("onInputTextChanged");
			Q_TRAN(s1_viewCreated);		
		}
		public static function swap(str : String) : String{
			public var a : Number = 0;
			public var b : Number = StringUtil.indexOf(str, StringUtil.WHITE_SPACE, false);
	
			public var m : Number = str.indexOf("=");
			public var z : Number = str.length -1;
			public var leadingSpace : String = str.substring(a,b);
			public var AA : String = str.substring(b, m);
			public var BB : String = str.substring(m+1, z);
			trace("swap AA '" + AA + "' BB '" + BB+ "'");
			public var res : String = leadingSpace + BB + "=" + AA + ";";
			trace("swap returning " +  res);
			return res;
		}
			/*.................................................................*/
		function s0_viewAssetsLoaded(e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					in_txt.onChanged  = TProxy.create(this, this.onInputTextChanged);
					return null;
				}
			}
			return super.s0_viewAssetsLoaded(e);
		}
		/*.................................................................*/
		function s1_viewCreated(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					isReady = true;
					inlines = new Array();
					outlines = new Array();
					inlines = String(in_txt.text).split("\r");
					out_txt.text = "";
					var namespace : String = "";
					var visibility : String = "";
					trace("HIGHLIGHTP parsing " + inlines.length + " lines");
					for (var i : Number = 0; i < inlines.length; i++) {
						var iln : String = StringUtil.trim(String(inlines[i]));
						trace("parsing " + iln);
						var oln : String = iln;
						if(iln.indexOf("=") >-1){
							oln = swap(iln);
						}
						//	trace("HIGHLIGHTb " + oln);
						outlines.push(oln);
					}
	
					out_txt.text = outlines.join("\r");
				
				}//case end
					return null;
			}//switch end
			return super.s1_viewCreated(e);
		}
	};
	
}