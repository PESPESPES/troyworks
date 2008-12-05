package com.troyworks.util.codeGen {
	import com.troyworks.core.cogs.CogEvent;

	import com.troyworks.framework.ui.BaseComponent;
	import com.troyworks.util.StringFormatter;
	import com.troyworks.util.StringUtil;
	
	import flash.events.Event;
	import flash.text.TextField;		

	/**
	 * @author Troy Gardner
	 */

	
	
	class CCodeTranslator extends BaseComponent {
		public var in_txt : TextField;
		public var out_txt : TextField;
		public var inlines : Array;
		public var outlines : Array;

		public function CCodeTranslator(initialState : String, hsmfName : String = "CCodeTranslator", aInit : Boolean = false) {
			super(initialState, hsmfName, aInit);
		}

		public function onInputTextChanged() : void {
			trace("onInputTextChanged");
		//	tran(s1_viewCreated);		
		}

		/*.................................................................*/
		override function s0_viewAssetsLoaded(e : CogEvent) : Function {
			//this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e.sig) {
				case SIG_ENTRY :
					{
					in_txt.addEventListener(Event.CHANGE,this.onInputTextChanged);
					
				//	in_txt.onChanged  = TProxy.create(this, this.onInputTextChanged);
					return null;
				}
			}
			return super.s0_viewAssetsLoaded(e);
		}
		/*.................................................................*/
		override function s1_viewCreated(e : CogEvent) : Function
		{
		//	this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				
					isReady = true;
					inlines = new Array();
					outlines = new Array();
					inlines = String(in_txt.text).split("\r");
					out_txt.text = "";
					var namespaceS:String = "";
					var visibility:String ="";
					trace("HIGHLIGHTP parsing " + inlines.length + " lines");
					for (var i : Number = 0; i < inlines.length; i++) {
						var iln : String = StringUtil.trim(String(inlines[i]));
						trace("parsing " + iln);
						var oln : String = iln;
						if(iln.indexOf("#include <string>")==0){
							oln = "  ";
						}else if(iln.indexOf("#include <iostream>")==0){
							oln = "  ";
						}else if(iln.indexOf("#include")==0){
							oln = iln.replace("#include","import");
							oln = oln.replace(".h","");
							oln = oln.replace("\"","");
							oln += ";";
						}else if(iln.indexOf("#ifndef")==0){
							oln = "  ";
						}else if(iln.indexOf("#ifdef")==0){
							oln = "  ";	
						}else if(iln.indexOf("#else")==0){
							oln = "  ";	
						}else if(iln.indexOf("#endif")==0){
							oln = "  ";			
						}else if(iln.indexOf("#define")==0){
							oln = "  ";
						}else if(iln.indexOf("public")==0){
							oln = "  ";
										visibility = "public";					
						}else if(iln.indexOf("namespace")>-1){
							var a = iln.indexOf("namespace");
							var b = "namespace".length;
							var sb:String = iln.substr(a+b, iln.length-2);
							oln = "";
						
						}else if(iln.indexOf("int")==0){
							var a : Number = iln.indexOf(" ");
							var b : Number = iln.length-1;
							var sb : String = iln.substring(a, b);
							oln = "\t "+visibility+" var" + sb + ":Number;";
					}else if(iln.indexOf("string")==0){
							var a : Number = iln.indexOf(" ");
							var b : Number = iln.length-1;
							var sb : String = iln.substring(a, b);
							oln = "\t "+visibility+" var" + sb + ":String;";
					}else if(iln.indexOf("bool")==0){
							var a : Number = iln.indexOf(" ");
							var b : Number = iln.length-1;
							var sb : String = iln.substring(a, b);
							oln = "\t "+visibility+" var" + sb + ":Boolean;";
					}else if(iln.indexOf("~")==0){
						//Constructor
							var a : Number = iln.indexOf("~");
							var b : Number = iln.indexOf("(");
							var sb : String = iln.substring(a+1, b);
							oln = "\r\t "+visibility+" function " + sb + "() {\r\t}";
					}else if(iln.indexOf("(){};")>-1){
						//Constructor
							/*var a : Number = 0;//iln.indexOf("~");
							var b : Number = iln.indexOf("(");
							var sb : String = iln.substring(a, b);
							oln = "\r\t "+visibility+" function " + sb + "() {\r\t}";				
								*/
								oln ="";
					}
					else if(iln.indexOf("void")==0){
						//fucntion
							var a : Number = iln.indexOf(" ");
							var b : Number = iln.indexOf("(");
							var sb : String = iln.substring(a, b);
							oln = "\t "+visibility+" function " + sb + "():void {\r\t}";
							
					}else if(iln.indexOf("<<") > -1 && iln.indexOf("<<")== iln.length - 2){
						 oln = "var4 " + iln.replace("<<", ":String = ");
						
					}else if(iln.indexOf("<<")> -1){
						 oln = iln.replace("<<", " + ");
					}else if(iln.indexOf("};") ==0){
						oln = " " ;
					}
					if(oln.indexOf(",")>-1){
						//arguments
						var args:Array = oln.split(",");
						var oary:Array = new Array();
						for (var j : Number = 0; j < args.length; j++) {
							var ln:String = StringUtil.trim( String(args[j]));
								trace("HIGHLIGHTb '" + ln+"'");
								var a : Number = Math.max(ln.indexOf("("), 0);
								if(a > 0){
									oary.push(ln.substring(0, a)+"(");
								}
								var b : Number = ln.indexOf(" ");
								var st:String = ln.substring(a, b);
								var type : String = StringFormatter.toTitleCase(st, true);
								var name:String = ln.substring(b, ln.length);
								trace("type '" + type + "' name '" + name + "'");
								var end:String = (j==args.length-1)?"" :", ";
								oary.push(name +":"+type +end);
							
						}
						oln = oary.join("");
					}
					
					//	trace("HIGHLIGHTb " + oln);
					outlines.push(oln);
					out_txt.text = outlines.join("\r");
				
				}//for lines end
				return null;
			//}//case end
			}//switch end
			return super.s1_viewCreated(e);
		}
	}
}