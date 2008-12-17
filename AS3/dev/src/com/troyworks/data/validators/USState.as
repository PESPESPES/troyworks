package com.troyworks.data.validators {

	/**
	 * USState
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 21, 2008
	 * DESCRIPTION ::
	 *
	 */
	internal class USState {
		public var abbrev:String;
		public var name:String;
		public function USState(abbrev:String, fullname:String) {
			this.abbrev  = abbrev;
			this.name = fullname;
		}
	}
}
