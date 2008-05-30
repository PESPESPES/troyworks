package  { 
	/**
	 * @author Troy Gardner
	 */
	interface com.troyworks.framework.loader.ILoader {
		public function getAmountLoaded():Number;
		public function getTotalSize():Number;
		public function startLoading(path:String):void;
	}
}