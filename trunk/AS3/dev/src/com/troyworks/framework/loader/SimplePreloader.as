package com.troyworks.framework.loader {
	import flash.events.Event;	
	import flash.display.Sprite;	
	
	/**
	 * SimplePreloader
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 13, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class SimplePreloader {
		public var view : Sprite;
		public var percentLoaded:Number;
		public function SimplePreloader(clipToTrack:Sprite, view:Sprite) {
			this.view = view;
		}

		public function setUp():void{
			view.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		function onEnterFrameHandler(evt:Event):void{
			percentLoaded	= Math.round(view.loaderInfo.bytesLoaded/view.loaderInfo.bytesTotal*100);
			view.loading_txt.text = "Loading " +  percentLoaded+ "%";
	
	}
}
