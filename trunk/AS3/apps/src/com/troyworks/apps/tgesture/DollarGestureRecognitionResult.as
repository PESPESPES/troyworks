package com.troyworks.apps.tgesture {

	/**
	 * DollarGestureRecognitionResult
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 10, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class DollarGestureRecognitionResult {
		public var name:String;
		public var score:Number;
		//
		// Result class
		//
		
		public function DollarGestureRecognitionResult(name:String, score:Number) // constructor 
		{
			this.name = name;
			this.score = score;
		}
		public function toString():String{
			return name + " " + Math.round(score*100) + "%";
		}
		
	}
}
