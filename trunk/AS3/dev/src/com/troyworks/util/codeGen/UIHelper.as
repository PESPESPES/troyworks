package com.troyworks.util.codeGen { 
	import com.troyworks.framework.ui.MCButton;
	import com.troyworks.framework.ui.MCBackground;
	import mx.controls.TextArea;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.controls.TextInput;
	import mx.controls.Button;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.text.TextField;
	public class UIHelper {
		public static function listClips(_mc : MovieClip) : String{
			var res : Array = new Array();
			res.push("listing clips for " + _mc.name);
			for(var i in _mc){
				res.push(i);
			}
	
			return res.join("\r");
			
		}
		public static function validateSkin(_mc : MovieClip, obj : Object) : String{
			var res : Array = new Array();
			res.push("!!!!!!!! CODE GEN listing clips for " + _mc.name + "!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			var errors : Number = 0;
			
				if(errors>0){
				res.push("!!!!!!!!!!!!! CodeGEN " + errors + " ERRORS EXIST !!!!!!!!!!!!!!!!!!!!!");
				}
			return res.join("\r");
		}
		/******************************************************
		 * Based on a given set of classes help build the constructors
		 *  and possible functions for event binding and such.
		 *  
		 *  null mode - checks for duplicates
		 *  mode == 0 gen functions
		 *  mode == 1 gen labels
		 *  
		 *  SAMPLE CODE:
		 *  public function onLoad():void{
			   trace(com.troyworks.util.codeGen.UIHelper.genCode(this, 0));
	     	}
		 */
		public static function genCode(_mc : MovieClip, mode:Number) : String{
			var res : Array = new Array();
			res.push("!!!!!!!! CODE GEN listing clips for " + _mc.name + "!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			//make sure things are unique
			var un : Object = new Object();
			var errors : Number = 0;
			for(var i:String in _mc){
	
				var o : Object = _mc[i];
				var n : Number = i.indexOf("instance");
				var unnamed : Boolean = (n>-1);
			//	trace("i " + i + " " + o + " " + n + " " + unnamed);
				var adj : String = "";
				if(un[i] == null){
					un[i] = true;
				}else {
					adj= " ***ERROR DUPLICATE ***";
					errors++;
					
				}
				if(unnamed){
					trace(" warning duplicate " + i);
					adj = " *** WARNING Unnamed stage instance *** ";
					errors++;
					
					
				}
				switch(mode){
					case 0:{
						///////////////////////////////////////////////////
						// USED FOR CREATION OF VARIABLE DECLARATIONS
						///////////////////////////////////////////////////
						if(o is MCBackground){
							res.push(" public var "+i+":MCBackground;" + adj);
						}else if(o is MCButton){
							res.push(" public var "+i+":MCButton;"+ adj);
											}else if(o is TextInput){
							res.push(" public var "+i+":TextInput;"+ adj);	
						}else if(o is TextArea){
							res.push(" public var "+i+":TextArea;"+ adj);
						}else if(o is ComboBox){
							res.push(" public var "+i+":ComboBox;"+ adj);
						}else if(o is DateField){
							res.push(" public var "+i+":DateField;"+ adj);		
						}else if(o is Button){
							res.push(" public var "+i+":Button;"+ adj);
							if(String(MovieClip(o).name).indexOf("_btn") == -1){
								trace("*** warning button " + String(MovieClip(o).name)+ " not labelled correctly with _btn ***");
								errors++;
							}
						}else if(o is com.troyworks.ui.controls.DndTree){
							res.push(" public var "+i+":DndTree;"+ adj);
						}else if(o is MovieClip){
							res.push(" public var "+i+":MovieClip;"+ adj);
						}else if(o is TextField){
							res.push(" public var "+i+":TextField;"+ adj);
						}
					}
					break;
					case 1:{
						///////////////////////////////////////////////////
						// USED FOR LABEL CREATION
						///////////////////////////////////////////////////
		
							if(o is MCBackground){
	//						res.push(" "+i+".label = 'XXX';" + adj);
						}else if(o is MCButton){
								res.push(" "+i+".label = 'XXX';" + adj);
	}else if(o is TextInput){
							res.push(" "+i+".text = 'XXX';" + adj);
						}else if(o is TextArea){
							res.push(" "+i+".label = 'XXX';" + adj);
	
						}else if(o is ComboBox){
							res.push(" "+i+".addItem('XXX');");
						}else if(o is DateField){
	//						res.push(" public var "+i+":DateField;"+ adj);		
						}else if(o is MovieClip){
	//						res.push(" public var "+i+":MovieClip;"+ adj);
						}else if(o is TextField){
							res.push("  "+i+".text = 'XXX';");
						}
					}
					break;
				}
				//res.push(i);
			}
				if(errors>0){
					res.push("!!!!!!!!!!!!! CodeGEN " + errors + " ERRORS EXIST !!!!!!!!!!!!!!!!!!!!!");
				}
	
			return res.join("\r");
		}
	}
}