package com.troyworks.controls.tcarouselmenus { 

	/**
	 * @author Troy Gardner
	 */
	interface CarouselMenuDataProvider {
		function getToolTipText():String;
		function getLabelText():String;
		function getThumbnailMediaPath():String;
	}
}