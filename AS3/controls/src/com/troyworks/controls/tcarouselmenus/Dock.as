package com.troyworks.controls.tcarouselmenus {
	import com.troyworks.framework.ui.BaseComponent;
	
	import flash.display.MovieClip;	

	/*
	
	Free stuff. Do not redistribute.
		http://jrgraphix.net/
		March 8, 2005
	
	*/
	
	
	/**
	 * @author Troy Gardner
	 */

	
	public class Dock  extends BaseComponent{
		public var icon_min : Number;
		public var icon_max : Number;
		public var icon_size : Number;
		public var icon_spacing : Number;
		public var width : Number;
		public var span : Number;
		public var amplitude : Number;
		public var ratio : Number;
		public var scale : Number = Number.NEGATIVE_INFINITY;
		public var trend : Number = 0;
		public var xmouse : Number;
		public var ymouse : Number;
		public var layout : String;
		public var callback : Function;
		public var items : Array;
		public var tray_mc:MovieClip;
	//	public var peng:ParticleEngine;
		
		public function Dock(initialState : Function, hsmfName : String, aInit : Boolean) {
			//super(initialState, hsmfName, aInit);
	//		peng = new ParticleEngine();
		}
		override public function onLoad(init:Boolean = true) : void{
			trace("onLOad");
			view.x = view.stage.stageWidth / 2;
			//y = stage.stageHeight;
			layout= "bottom"; /* top | right | bottom | left | *rotation* */
			icon_size= 100;
			icon_min= 32;
			icon_max=128;
			icon_spacing= 2;
			if(view.name == "a"){
			items= [
				{ id: 'MultiMediaWindow', label: 'Preferences', initObj:{contentPATH:"images/A-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Blog' ,initObj:{ contentPATH:"images/B-thumb.png"}},
				{ id: 'MultiMediaWindow',label: 'Forum', initObj:{contentPATH:"images/C-thumb.png" }},
				{ id: 'MultiMediaWindow', label: 'Store' , initObj:{contentPATH:"images/D-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Tech Support' , initObj:{contentPATH:"images/E-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Search Archives' , initObj:{contentPATH:"images/F-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Contact Us' , initObj:{contentPATH:"images/G-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Trash' , initObj:{contentPATH:"images/H-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Preferences', initObj:{contentPATH:"images/I-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Blog' ,initObj:{ contentPATH:"images/J-thumb.png"}},
				{ id: 'MultiMediaWindow',label: 'Forum', initObj:{contentPATH:"images/K-thumb.png" }},
				{ id: 'MultiMediaWindow', label: 'Store' , initObj:{contentPATH:"images/L-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Tech Support' , initObj:{contentPATH:"images/M-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Search Archives' , initObj:{contentPATH:"images/N-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Contact Us' , initObj:{contentPATH:"images/O-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Trash' , initObj:{contentPATH:"images/P-thumb.png"}},
							{ id: 'MultiMediaWindow', label: 'Preferences', initObj:{contentPATH:"images/Q-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Blog' ,initObj:{ contentPATH:"images/R-thumb.png"}},
				{ id: 'MultiMediaWindow',label: 'Forum', initObj:{contentPATH:"images/S-thumb.png" }},
				{ id: 'MultiMediaWindow', label: 'Store' , initObj:{contentPATH:"images/T-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Tech Support' , initObj:{contentPATH:"images/U-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Search Archives' , initObj:{contentPATH:"images/V-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Contact Us' , initObj:{contentPATH:"images/W-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Trash' , initObj:{contentPATH:"images/X-thumb.png"}},
							{ id: 'MultiMediaWindow', label: 'Contact Us' , initObj:{contentPATH:"images/Y-thumb.png"}},
				{ id: 'MultiMediaWindow', label: 'Trash' , initObj:{contentPATH:"images/Z-thumb.png"}}			
							
				];
			}else{
						items= [
						{ id: 'MultiMediaWindow', label: 'Preferences', initObj:{contentPATH:"images1/thisthat-thumbnail-a.png"}},
				{ id: 'MultiMediaWindow', label: 'Blog' ,initObj:{ contentPATH:"images1/thisthat-thumbnail-b.png"}},
				{ id: 'MultiMediaWindow',label: 'Forum', initObj:{contentPATH:"images1/thisthat-thumbnail-c.png" }},
				{ id: 'MultiMediaWindow', label: 'Store' , initObj:{contentPATH:"images1/thisthat-thumbnail-d.png"}},
				{ id: 'MultiMediaWindow', label: 'Tech Support' , initObj:{contentPATH:"images1/thisthat-thumbnail-e.png"}},
				{ id: 'MultiMediaWindow', label: 'Search Archives' , initObj:{contentPATH:"images1/thisthat-thumbnail-f.png"}},
				{ id: 'MultiMediaWindow', label: 'Contact Us' , initObj:{contentPATH:"images1/thisthat-thumbnail-g.png"}},
				{ id: 'MultiMediaWindow', label: 'Trash' , initObj:{contentPATH:"images1/thisthat-thumbnail-h.png"}},
				{ id: 'MultiMediaWindow', label: 'Preferences', initObj:{contentPATH:"images1/thisthat-thumbnail-i.png"}},
				{ id: 'MultiMediaWindow', label: 'Blog' ,initObj:{ contentPATH:"images1/thisthat-thumbnail-j.png"}},
				{ id: 'MultiMediaWindow',label: 'Forum', initObj:{contentPATH:"images1/thisthat-thumbnail-k.png" }},
				{ id: 'MultiMediaWindow', label: 'Store' , initObj:{contentPATH:"images1/thisthat-thumbnail-l.png"}},
				{ id: 'MultiMediaWindow', label: 'Tech Support' , initObj:{contentPATH:"images1/thisthat-thumbnail-m.png"}},
				{ id: 'MultiMediaWindow', label: 'Search Archives' , initObj:{contentPATH:"images1/thisthat-thumbnail-n.png"}},
				{ id: 'MultiMediaWindow', label: 'Contact Us' , initObj:{contentPATH:"images1/thisthat-thumbnail-o.png"}},
				{ id: 'MultiMediaWindow', label: 'Trash' , initObj:{contentPATH:"images1/thisthat-thumbnail-p.png"}},
							{ id: 'MultiMediaWindow', label: 'Preferences', initObj:{contentPATH:"images1/thisthat-thumbnail-q.png"}},
				{ id: 'MultiMediaWindow', label: 'Blog' ,initObj:{ contentPATH:"images1/thisthat-thumbnail-r.png"}},
				{ id: 'MultiMediaWindow',label: 'Forum', initObj:{contentPATH:"images1/thisthat-thumbnail-s.png" }},
				{ id: 'MultiMediaWindow', label: 'Store' , initObj:{contentPATH:"images1/thisthat-thumbnail-t.png"}},
				{ id: 'MultiMediaWindow', label: 'Tech Support' , initObj:{contentPATH:"images1/thisthat-thumbnail-u.png"}},
				{ id: 'MultiMediaWindow', label: 'Search Archives' , initObj:{contentPATH:"images1/thisthat-thumbnail-v.png"}},
				{ id: 'MultiMediaWindow', label: 'Contact Us' , initObj:{contentPATH:"images1/thisthat-thumbnail-w.png"}},
				{ id: 'MultiMediaWindow', label: 'Trash' , initObj:{contentPATH:"images1/thisthat-thumbnail-x.png"}},
							{ id: 'MultiMediaWindow', label: 'Contact Us' , initObj:{contentPATH:"images1/thisthat-thumbnail-y.png"}},
				{ id: 'MultiMediaWindow', label: 'Trash' , initObj:{contentPATH:"images1/thisthat-thumbnail-z.png"}}			
							
				];
				
			}
			span= NaN;
			amplitude= NaN;
	//	callback: this.dockActions;
			setParameters();
			setLayout();
			createIcons();
			createTray();
			onEnterFrame = monitorDock;
		}
		protected function setParameters() : void {
			this.layout = this.layout ? this.layout : 'bottom';
			this.icon_min = this.icon_min ? this.icon_min : 32;
			this.icon_max = this.icon_max ? this.icon_max : 96;
			this.icon_spacing = this.icon_spacing ? this.icon_spacing : 2;
			this.span = this.span ? this.span : getSpan();
			this.amplitude = this.amplitude ? this.amplitude : getAmplitude();
			this.ratio =  Math.PI / 2 / this.span;
		}
	
		protected function getSpan() : Number {
			return (this.icon_min - 16) * (240 - 60) / (96 - 16) + 60;
		}
	
		protected function getAmplitude() : Number {
			return 2 * (this.icon_max - this.icon_min + this.icon_spacing);
		}
	
		protected function createIcons() : void {
			var i : Number;
			var id : String;
			this.scale = 0;
			this.width = (this.items.length - 1) * this.icon_spacing + this.items.length * this.icon_min;
			var left : Number = (this.icon_min - this.width) / 2;
			for(i = 0; i < this.items.length; i++) {
				this.createEmptyMovieClip(String(i), i + 10).attachMovie(this.items[i].id, '_mc', 1, this.items[i].initObj);
				this[i]._mc.y = -this.icon_size / 2;
				this[i]._mc.rotation = -this.rotation;
				this[i].x = this[i].x = left + i * (this.icon_min + this.icon_spacing) + this.icon_spacing / 2;
				this[i].y = -this.icon_spacing;
				//this[i].onRelease = launchIcon;
				this[i].useHandCursor = false;
			}
		}
	
		protected function launchIcon() : void {
			this.parent.callback(this.parent.items[this.name].label);
		}
	
		protected function createTray() : void {
			var height : Number = this.icon_min + 2 * this.icon_spacing;
			var width : Number = this.width + 2 * this.icon_spacing;
			var mc : MovieClip = this.createEmptyMovieClip('tray_mc', 1);
			mc.graphics.lineStyle(0, 0xcccccc, 80);
			mc.graphics.beginFill(0xe8e8e8, 50);
			mc.graphics.lineTo(0, -height);
			mc.graphics.lineTo(width, -height);
			mc.graphics.lineTo(width, 0);
			mc.graphics.lineTo(0, 0);
			mc.graphics.endFill();
			mc.exploded = true;
			mc.owner = this;
			mc.onRelease = function(){
				trace("tray click" + Object(this).exploded);
				Object(this).exploded = !Object(this).exploded;
				Object(this).owner.updateTray();
			};
		}
	
		protected function setLayout() : void {
			switch(this.layout) {
				case 'left':
					this.rotation = 90;
					break;
				case 'top':
					this.rotation = 180;
					break;
				case 'right':
					this.rotation = 270;
					break;
				default:
					this.rotation = Number(this.layout);
			}
		}
	
		protected function checkBoundary() : Boolean {
			var buffer : Number = 4 * this.scale;
			return (this.ymouse < 0)
				&& (this.ymouse > -2 * this.icon_spacing - this.icon_min + (this.icon_min - this.icon_max) * this.scale)
				&& (this.xmouse > this[0].x - this[0].width / 2 - this.icon_spacing - buffer)
				&& (this.xmouse < this[this.items.length - 1].x + this[this.items.length - 1].width / 2 + this.icon_spacing + buffer);
		}
	
		protected function updateTray() : void {
			if(tray_mc.exploded){
			var x : Number;
			var w : Number;
			x = this[0].x - this[0].width / 2 - this.icon_spacing;
			w = this[this.items.length - 1].x + this[this.items.length - 1].width / 2 + this.icon_spacing;
			tray_mc.x = x;
			tray_mc.width = w - x;
			}else{
				tray_mc.width = 100;
			}
		}
	
		protected function monitorDock() : Boolean {
			var i : Number;
			var x : Number;
			var dx : Number;
			var dim : Number;
	
			// Mouse did not move and Dock is not between states. Skip rest of the block.
			if((this.xmouse == this.mouseX) && (this.ymouse == this.mouseY) && ((this.scale <= 0.01) || (this.scale >= 0.99))) {
				return false; }
	
			// Mouse moved or Dock is between states. Update Dock.
			this.xmouse = this.mouseX;
			this.ymouse = this.mouseY;
	
			// Ensure that inflation does not change direction.
			this.trend = (this.trend == 0 ) ? (checkBoundary() ? 0.25 : -0.25) : (this.trend);
			this.scale += this.trend;
			if( (this.scale < 0.02) || (this.scale > 0.98) ) {
				this.trend = 0; }
	
			// Actual scale is in the range of 0..1
			this.scale = Math.min(1, Math.max(0, this.scale));
	
			// Hard stuff. Calculating position and scale of individual icons.
			for(i = 0; i < this.items.length; i++) {
				dx = this[i].x - this.xmouse;
				dx = Math.min(Math.max(dx, -this.span), this.span);
				dim = this.icon_min + (this.icon_max - this.icon_min) * Math.cos(dx * this.ratio) * (Math.abs(dx) > this.span ? 0 : 1) * this.scale;
				this[i].x = this[i].x + this.scale * this.amplitude * Math.sin(dx * this.ratio);
				this[i].scaleX = this[i].scaleY =  100 * dim / this.icon_size;
			}
	
			// Resize tray to contain icons.
			updateTray();
			return true;
		}
	}
}