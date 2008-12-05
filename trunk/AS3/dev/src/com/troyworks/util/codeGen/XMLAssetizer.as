package com.troyworks.util.codeGen {
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.util.StringUtil;
	
	import flash.text.TextField;	 

	/**
	 * @author Troy Gardner
	 */

	
	
	public class XMLAssetizer extends BaseComponent {
		public var in_txt : TextField;
		public var out_txt : TextField;
		public var inlines : Array;
		public var outlines : Array;

		public function XMLAssetizer(initialState : String = "s_initial", hsmfName : String = "XMLAssetizer", aInit : Boolean = true) {
			super(initialState, hsmfName, aInit);
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

		/*override function s0_viewAssetsLoaded(e : CogEvent) : Function {
			//this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e.sig) {
				case SIG_ENTRY :
					
					///in_txt.onChanged  = TProxy.create(this, this.onInputTextChanged);
					return null;
				
			}
			return super.s0_viewAssetsLoaded(e);
		}
		override function s1_viewCreated(e:CogEvent) : Function
		{
			///this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					isReady = true;
					inlines = new Array();
					outlines = new Array();
					inlines = String(in_txt.text).split("\r");
					out_txt.text = "";
					var namespaceS : String = "";
					var visibility : String = "";
					outlines.push('<database pathURL="">');
					trace("HIGHLIGHTP parsing " + inlines.length + " lines");
					for (var i : Number = 0; i < inlines.length; i++) {
						var iln : String = StringUtil.trim(String(inlines[i]));
						trace("parsing " + iln);
						var oln : String = iln;
						//parse all objects
						//input them into tree
					
						outlines.push(oln);
					}
					outlines.push('</database>');
	
					out_txt.text = outlines.join("\r");
				
				}//case end
					return null;
			}//switch end
			return super.s1_viewCreated(e);
		}*/
		
	}
}