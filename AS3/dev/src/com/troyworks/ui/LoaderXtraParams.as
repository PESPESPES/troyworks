/**
* The LoaderXtraParams
* acts as Spring like injection to pass params to a loaded piece 
* of content, that is accessible prior to the content being loaded.
* In normal loader there isn't a shared content that is accessible 
* to the loaded piece of content.
* 
* Typically it's used by starter files, to pass optional/default parameters
* to a UI/Engine plus engine. So when it goes 'live' it's has access to the whole
* like it was passed into the constructor.
* 
* http://troyworks.com/blog/?p=91
* 
* An example of it's use is UIStart()
* 
* 
* if(parent != stage && Object(parent).xtraVars != null){
     var img:String = Object(parent).xtraVars["image"];
     visualURL = (img != null)?img:visualURL;
     for (keyStr in Object(parent).xtraVars) {
        valueStr = String(Object(parent).xtraVars[keyStr]);
        loading_txt.appendText("\t" + keyStr + ":\t" + valueStr + "\n");
     }
  }else{
     loading_txt.appendText("\t using DEFAULTS \n");
  }
* 
* @author Troy Gardner
* @version 0.1
*/

package com.troyworks.ui {
	import flash.display.Loader;

	public class LoaderXtraParams extends Loader{
		
		public var xtraVars:Object = new Object();
		
		public function LoaderXtraParams() {
			super();
		}
		
	}
	
}
