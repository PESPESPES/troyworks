package com.troyworks.apps.tgesture {

	/**
	 * DollarGestureTemplate
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 10, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class DollarGestureTemplate {
		public var name:String;
		public var points:Array;
		public function DollarGestureTemplate(name:String, points:Array) // constructor 
		{
			this.name = name;
			this.points = DollarGestureUtil.Resample(points, DollarGestureUtil.NumPoints);
			this.points = DollarGestureUtil.RotateToZero(this.points);
			this.points = DollarGestureUtil.ScaleToSquare(this.points, DollarGestureUtil.SquareSize);
			this.points = DollarGestureUtil.TranslateToOrigin(this.points);
			
		}
	}
}
