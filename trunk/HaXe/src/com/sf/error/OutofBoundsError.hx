package com.sf.error;
import haxe.PosInfos;

/**
 * ...
 * @author 0b1kn00b
 */

class OutofBoundsError extends Error {

	public function new(?pos:PosInfos) {
		super( "Index out of bounds at " + pos );
	}
}