package  { 
	/**
	import flash.xml.XMLNode;
	 * @author Troy Gardner
	 */
	interface com.troyworks.ui.tree.ITreeDataProvider {
			public function toXML(tree:XML):XMLNode;
			public function addEventListener(evt:String, arg1:Object, arg2:Object, arg3:Object):void;
	}
}