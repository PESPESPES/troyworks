package com.sf.error;

/**
 * ...
 * @author 0b1kn00b
 */
import com.troyworks.core.cogs.CogSignal;
import haxe.PosInfos;

class UnhandledSignalError extends Error{

	public function new(s:CogSignal<Dynamic>,?p:PosInfos) {
		super( "Case " + Std.string(s) + " unhandled at line " + p.lineNumber + " in " + p.fileName );
	}
	
}