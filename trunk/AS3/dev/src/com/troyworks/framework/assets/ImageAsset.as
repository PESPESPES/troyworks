package com.troyworks.framework.assets { 
	
	public class ImageAsset extends Asset   {
	
		public function toString():String{
			return "ImageAsset: gid:" +this.gid + " name:"  + this.name + " path:" + this.path;
		}
	}
}