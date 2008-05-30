package  { 
	//creates a simple rect with formatted text in it.
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	//typically used for UI contextMenu creations
	// requires VirtualMovieClip  and Rectangle Class
	///////////////////////////////////////////
	SimpleTextRectangle = function (x, y, width, height, text) {
		this.Init(x, y, width, height, text);
	};
	SimpleTextRectangle.extend(Rectangle);
	SimpleTextRectangle.prototype.Init = function(x, y, width, height, text) {
		//trace("new simpletextrectangle "+x+" "+y+" "+width+" "+height);
		////// line style ///////////
		public var l = {};
		l.width = 1;
		l.color = 0x9c9a9c;
		l.alpha = 0;
		this.l_Style = l;
		/////fill style//////////////
		public var f = {};
		f.color = 0xffe394;
		f.alpha = 100;
		this.f_Style = f;
		/////////// Text format //////////////
		public var _fmt = new TextFormat();
		_fmt.bold = true;
		_fmt.align = "left";
		_fmt.color = 0x000000;
		_fmt.font = "Myriad Pro";
		_fmt.size = 11;
		this._fmt = _fmt;
		/////////////////////////////
		super.init(0, 0, width, height);
		this.x = x;
		this.y = y;
		this.text = text;
	};
	SimpleTextRectangle.prototype.Render = function() {
		//	this.graphics.clear();
		= this.createTextField("llabel_txt = new TextField();
		= this.createTextField("laddChildAt(= this.createTextField("llabel_txt, 2);
		= this.createTextField("llabel_txt.x = 5;
		= this.createTextField("llabel_txt.width = this.width;
		= this.createTextField("llabel_txt.height = this._fmt.size + 5;
		
		//_txt.autoSize = true;
		//_txt.embedFonts = true;
		_txt.text =  this.text;
		_txt.selectable = false;
		_txt.setTextFormat(this._fmt);
		this.label_txt = _txt;
	
		//this.SetWidth(_txt.textWidth+15);
		this.SetHeight(_txt.textHeight+5);
		this.FixUp();
		with (this) {
			//trace("drawing simple rect"+this.l_Style.width+" "+this.l_Style.alpha);
			graphics.lineStyle(this.l_Style.width, this.l_Style.color, this.l_Style.alpha);
			graphics.beginFill(this.f_Style.color, this.f_Style.alpha);
			//top left corner
			graphics.moveTo(0, 0);
			//across to right corner
			graphics.lineTo(this.width, 0);
			//down
			graphics.lineTo(this.width, this.height);
			//across the bottom
			graphics.lineTo(0, this.height);
			//back to teh startpoint/topleft	
			graphics.lineTo(0, 0);
			graphics.endFill();
		}
	};
}