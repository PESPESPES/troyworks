package com.troyworks.util {

	/**
	 * XMLUtil
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Oct 22, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class XMLUtil {
		
		// useful for processing XHTML e.g trying get just the p tags in
		// the following:
		// <div><p></p><p></p></div> 
		public static function getChildren(parent : XML) : XML {
			trace("getChildren " + parent);
			var body : XML = <span></span>;//new XML();
			var children : XMLList = parent.children();
			
			for each(var child in children) {
				trace("adding child " + child.toString());
				body.appendChild(child);
			}
			trace("returning  " + body);
			return body;
		}
	}
}
