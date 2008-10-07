package com.troyworks.data.id {

	/**
	 * UniqueIDGenerator
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jul 23, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class UniqueIDGenerator {
		
		public static function getNext():String{
			var res:String;
			res = new Date().time +""+ Math.random();
			return res;
		}
	}
}
