package com.troyworks.util {

	/**
	 * InitObject
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Oct 1, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class InitObject extends Object {

		public static function setInitValues(target : Object, initObj : Object) : Boolean {
					
			var errors : Boolean = false ;
			for(var c:String in initObj) {
				trace("initObj " + c + " = " + initObj[c]);
				try {
					
					target[c] = initObj[c];
				}catch(er : Error) {
					trace("ERROR InitObject couldn't set " + c);
					errors = true;
				}
			}
			return errors;
		}
	}
}
