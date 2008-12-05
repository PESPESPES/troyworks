package  com.troyworks.framework.loader { 

	/**
	 * @author Troy Gardner
	 */
	interface ILoader {
		function getAmountLoaded() : Number;

		function getTotalSize() : Number;

		function startLoading(path : String) : void;
	}
}