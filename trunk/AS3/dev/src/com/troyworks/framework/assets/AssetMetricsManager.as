package com.troyworks.framework.assets { 
	public class AssetMetricsManager extends Object {
		public var metrics:Object;
	
		public function AssetMetricsManager (){
			this.metrics = new Object();
	
		}
		public function setMetrics(bookID:String, chapterID:String, metric:MediaGalleryAssetMetrics) : void {
			var key = this.constructKey(bookID, chapterID);
			this.metrics [key] = metric;
	
		}
	    public function clearMetrics() : void {
			delete(this.metrics);
			this.metrics = new Object();
		}
		public function removeMetrics(bookID:String, chapterID:String) : void {
			var key = this.constructKey(bookID, chapterID);
			delete(this.metrics [key] );
		}
		public function constructKey(bookID:String, chapterID:String):String{
			return bookID+"_"+chapterID;
		}
	
		public function getMetrics(bookID:String, chapterID:String):MediaGalleryAssetMetrics{
			var key = this.constructKey(bookID, chapterID);
			var p : Object = this.metrics[key];
			if (p != null)
			{
			//	trace(" found metrics for "+ key);
				return MediaGalleryAssetMetrics(p);
			} else
			{
			//	trace(" creating metrics for "+ key);
				var tkey:String = this.constructKey(bookID, chapterID);
				var metric:MediaGalleryAssetMetrics = new MediaGalleryAssetMetrics();
				this.metrics[tkey] = metric;
				return metric;
			}
		}
	}
}