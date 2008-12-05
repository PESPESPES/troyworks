package com.troyworks.apps.semantica.moby {

	/**
	 * @author Troy Gardner
	 */
	public class Syllable {

		public var syl : String;
		public var phonems : Array = new Array();
		public var stress;
		public static const PRIMARY_STRESS : Number = 1;
		public static const SECONDARY_STRESS : Number = 0;

		public function Syllable() {
		}
	}
}
