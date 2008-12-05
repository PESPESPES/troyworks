package com.troyworks.framework.loader {
	import flash.text.TextField;	
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
		public var txt : TextField;
		public var percentLoaded : Number;

		public function SimplePreloader(clipToTrack : Sprite, view : Sprite) {
			this.view = view;
			if(view.hasOwnProperty("loading_txt")) {
				txt = view["loading_txt"] as TextField;
			}
		}

		public function setUp() : void {
			view.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}

		function onEnterFrameHandler(evt : Event) : void {
			percentLoaded = Math.round(view.loaderInfo.bytesLoaded / view.loaderInfo.bytesTotal * 100);
			txt.text = "Loading " + percentLoaded + "%";
			view.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
	}
}
