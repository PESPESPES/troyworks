package com.troyworks.controls.ttree.tree {
	import flash.events.IEventDispatcher; 

	/**
	import flash.xml.XMLNode;
	 * @author Troy Gardner
	 */
	interface ITreeDataProvider extends IEventDispatcher {
		function toXML(tree : XML) : XML;
	}
}