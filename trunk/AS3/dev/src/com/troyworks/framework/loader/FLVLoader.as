package com.troyworks.framework.loader {
	import fl.video.FLVPlayback;	
	
	import flash.system.Capabilities;
	/**
	 * FLVLoader
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 7, 2008
	 * DESCRIPTION ::
	 *
	 *A basic example of loading a video. This doesn't report progress though :(
	 */
	public class FLVLoader {
		public var FLVplayer:FLVPlayback;
		public var flvURL:String = "movie.flv";
		public var flvURLPrefix:String = "http://flv/";
		public function startLoading():void{
			
			FLVplayer.source = (Capabilities.playerType == "External" || Capabilities.playerType == "StandAlone")?flvURL:flvURLPrefix + flvURL;
		}
	}
}
