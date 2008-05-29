package com.troyworks.mediaplayer.model { 
	import com.troyworks.geom.d1.Line1D;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	public class Track extends com.troyworks.geom.d1.CompoundLine1D
	{
		public static var OVERLAY : Number = 1;
		public static var VIDEO : Number = 2;
		public static var AUDIO : Number = 3;
		public static var IMAGE : Number = 4;
		public var volume : Number = 0;
		public var ID : Number = 0;
		public static var IDz : Number = 0;
		public var size:Number =0;
		////////////
		public function Track (o : Object, type : Number, start : Number, length : Number, end : Number)
		{
			super (o, type, start, length, end);
			this.ID = Track.IDz ++;
		}
		public function init (name : String, type : Number, start : Number, length : Number, end : Number, volume : Number) : void
		{
		//	trace("Track.init vol: ");
			super.init (name, type, start, length, end);
			//this init of hte child array is necessary for some reason else they share a reference to the same one?!
			this.children = new Array ();
			this.calc ();
			this.volume = (volume != null) ? volume : 100;
		}
		///////////////////////////////////////////////////////////////////////
		/// This is used to deserialize from disk
		public function initFromXML (tree : XMLDocument, aType : Number, aStart : Number, aLength : Number, aEnd : Number) : Track
		{
		//		trace ("Track.initFromXML start " + start + " len " + length + " end " + end);
			var res : XMLNode = tree;
			var name = (res.attributes.name != null) ?res.attributes.name + "" : "Unnamed Track";
			var type = (res.attributes.type != null) ?parseInt (res.attributes.type) : aType;
			var volume = (res.attributes.volume != null) ?parseInt (res.attributes.volume) : volume;
			var start = (res.attributes.start != null) ?parseFloat (res.attributes.start) : aStart;
	
			var length = (res.attributes.length != null) ?parseFloat (res.attributes.length) : aLength;
			var end = (res.attributes.end != null) ?parseFloat (res.attributes.end ) : aEnd;
			this.init (name, type, start, length, end, volume);
			var len = tree.childNodes.length;
			for (var i = 0; i < len; i ++)
			{
				var node : XMLNode = tree.childNodes [i];
				//		trace ("Track found node " + node.nodeName);
				switch (node.nodeName)
				{
					case "clip" :
					{
						this.parseClipXML (node);
					}
					break;
				}
			}
			return this;
		}
		public function parseClipXML (tree : XMLNode) : void {
			var res : XMLNode = tree;
			//	trace("res" + res);
			//this.name = res.attributes.name+"";
			//this.type = parseInt(res.attributes.type);
			//this.volume = parseInt(res.attributes.volume);
			var lelen = parseFloat (res.attributes.length);
			if (lelen == null || isNaN (lelen))
			{
				lelen = this.length;
			}
			var len = tree.childNodes.length;
			for (var i = 0; i < len; i ++)
			{
				var node : XMLNode = tree.childNodes [i];
				//trace ("Clip found node " + node.nodeName);
				switch (node.nodeName)
				{
					case "shot" :
					{
						this.parseShotXML (node, lelen);
					}
					break;
					case "audio" :
					{
						this.parseAudio (node, lelen);
					}
					break;
					case "select" :
					{
						this.parseClipXML (node, lelen);
					}
					break;
				}
			}
		}
		public function parseShotXML (tree : XMLNode) : void {
			var res : XMLNode = tree;
			var desc = res.attributes.description + "";
			//trace ("parsing Shot " + desc);
			var lelen = parseFloat (res.attributes.length);
			if (lelen == null || isNaN(lelen))
			{
				lelen = this.length;
			}
			var ref = (this.children.length == 0) ?this.A : this.B;
			var len = tree.childNodes.length;
			if (len > 0)
			{
				var a:Boolean = false;
				var data:Object = new Object();
				var trk:Number;
				//trace ("parsingShot AAA Children ");
				for (var i = 0; i < len; i ++)
				{
					var node : XMLNode = tree.childNodes [i];
					//	trace ("Shot found node " + node.nodeName);
					switch (node.nodeName)
					{
						case "audio" :
						{
							this.parseAudio (node, lelen);
						}
						break;
						case "image" :
						{
							a = true;
							trk = Track.IMAGE;
							data.path = node.attributes.path+ "";
							data.width = parseInt(node.attributes.width);
							data.height = parseInt(node.attributes.height);
							data.size =  parseInt(node.attributes.size);
							this.size += parseInt(node.attributes.size);
	
						}
						break;
						case "frame":
						{
							switch(node.attributes.type){
								case "starting":{
									data.Asize = node.attributes.size +"";
									data.AvertPos = node.attributes.vertPos +"";
									data.AhorzPos = node.attributes.horzPos +"";
								}
								break;
								case "ending":
								{
									data.Bsize = node.attributes.size +"";
									data.BvertPos = node.attributes.vertPos +"";
									data.BhorzPos = node.attributes.horzPos +"";
								}
								break;
							}
	
						}
						break;
						case "video" :
						{
							var l = new Line1D (desc, Track.VIDEO, ref, lelen, null);
							data = new Object();
							data.path = node.attributes.path+"";
							data.size =  parseInt(node.attributes.size);
							this.size +=  parseInt(node.attributes.size);
						//	Intentionally not: a = true;
							l.data = data;
							this.addChild (l);
						}
						break;
						case "text" :
						{
							var l = new Line1D (desc,  Track.OVERLAY, ref, lelen, null);
							data = new Object();
							data.text = node.firstChild.nodeValue+"";
							trace("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
							trace("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
							trace("TTTTTTTTTTTTTTTTTTTTTT " + data.text + " TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
							trace("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
							trace("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
							trace("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
							l.data = data;
						//	Intentionally not: a = true;
	
							this.addChild (l);
						}
						break;
					}
				}
				if(a){
						var l = new Line1D (desc, trk, ref, lelen, null);
						l.data = data;
						//trace(util.Trace.me(l.data, " DATA ", true));
						this.addChild (l);
				}
			} else
			{
				//trace ("parsingShot BBB ");
				var l = new Line1D (desc, - 1, ref, lelen, null);
				this.addChild (l);
			}
		}
		public function parseAudio (node : XMLNode, length : Number) : void
		{
			//		trace ("parseAudio " + node + " " + length);
			var ref = (this.children.length == 0) ?this.A : this.B;
			if (node.attributes.type == "silence")
			{
				//	trace ("found silentAudio clip " + length);
				var l = new Line1D ("SILENCE",  Track.AUDIO, ref, length, null);
				this.addChild (l);
			} else
			{
				//	trace ("found real Audio clip " + length + " " + node.attributes.path);
				var l = new Line1D (node.attributes.path, Track.AUDIO, ref, length, null);
				var data = new Object();
				data.size =  parseInt(node.attributes.size);
				l.data = data;
				this.size +=  parseInt(node.attributes.size);
				this.addChild (l);
			}
		}
		public function toString () : String
		{
			return " Track" + this.ID + " " + super.toString ();
		}
	}
	
}