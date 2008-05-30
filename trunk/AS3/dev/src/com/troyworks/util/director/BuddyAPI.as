package com.troyworks.util.director { 
	//This is an approximation of the API
	import com.troyworks.events.TProxy;
	
	public class BuddyAPI extends Object{
						/*
						* This works but returns 'undefined'
						* var res = getURL ("lingo: baCreateFolder(\""+ path +"\")");
						_global.log.warn("result " +res);
						*/
	
		public function BuddyAPI(name:String){
			trace("new BuddyAPI " + name);
		}
		public static function createFolder(path:String, obj:Object, fn:Function):void{
			trace ("--CreateFolder---------path'" + path + "'--------------------");
			var evalMe = "baCreateFolder('"+ path +"');";
			DirectorUtils.instance.evalLingoAndCallback(evalMe,TProxy.create (obj, fn));
		}
		public static function deleteFolder(path:String, obj:Object, fn:Function):void{
			trace ("--DeleteFolder---------path'" + path + "'--------------------");
			var evalMe = "baDeleteFolder('"+ path +"');";
			DirectorUtils.instance.evalLingoAndCallback(evalMe,TProxy.create (obj, fn));
		}
		//
		//Overwrite = "Always", "IfNewer", "ifNotExist"
		//MakeDire = true or false
		//BuddyAPI.xCopy( SourceDir, DestDir,  FileSpec, Overwrite, MakeDir, obj, fn);
		public static function xCopy( SourceDir:String, DestDir:String,  FileSpec:String, Overwrite:String, MakeDir:Boolean, obj:Object, fn:Function) : void {
			trace ("--xCopy---------SourceDir'" + SourceDir + "' -- '"+ DestDir + " '------------------");
			var evalMe = "baXCopy('"+ SourceDir+"', '"+DestDir+"', '"+  FileSpec+"', '"+ Overwrite+"', "+ MakeDir+")";
			DirectorUtils.instance.evalLingoAndCallback(evalMe,TProxy.create (obj, fn));
		}
	
	}
}