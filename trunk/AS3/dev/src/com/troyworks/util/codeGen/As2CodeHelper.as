package com.troyworks.util.codeGen {
	import com.troyworks.core.cogs.*;		
	import com.troyworks.util.StringUtil;	
	import com.troyworks.framework.ui.BaseComponent;

	import flash.text.TextField;

	/**
	 * @author Troy Gardner
	 */
	class As2CodeHelper extends BaseComponent {
		public var in_txt : TextField;
		public var out_txt : TextField;
		public var inlines : Array;
		public var outlines : Array;

		public function As2CodeHelper(initialState : String, hsmfName : String, aInit : Boolean) {
			super(initialState, "As2CodeHelper", aInit);
		}

		public function onInputTextChanged() : void {
			trace("onInputTextChanged");
			tran(s1_viewCreated);
	
		}

		public static function swap(str : String) : String {
			var a : Number = 0;
			var b : Number = StringUtil.indexOf(str, StringUtil.WHITE_SPACE, false);
	
			var m : Number = str.indexOf("=");
			var z : Number = str.length - 1;
			var leadingSpace : String = str.substring(a, b);
			var AA : String = str.substring(b, m);
			var BB : String = str.substring(m + 1, z);
			trace("swap AA '" + AA + "' BB '" + BB + "'");
			var res : String = leadingSpace + BB + "=" + AA + ";";
			trace("swap returning " + res);
			return res;
		}

		/*.................................................................*/
		override public function s0_viewAssetsLoaded(e : CogEvent) : Function {
			//	this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e.sig) {
				case SIG_ENTRY :
					{
//					in_txt.addEventListener  = TProxy.create(this, this.onInputTextChanged);
					return null;
				}
			}
			//XXX	return super.s0_viewAssetsLoaded(e);
			return null;
		}
		/*.................................................................*/
		override public function s1_viewCreated( e:CogEvent) : Function
		{
	//		this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					isReady = true;
					inlines = new Array();
					outlines = new Array();
					inlines = String(in_txt.text).split("\r");
					out_txt.text = "";
					//var namespace : String = "";
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
		//XXX	return super.s1_viewCreated(e);
		return null;
		}
	}
}