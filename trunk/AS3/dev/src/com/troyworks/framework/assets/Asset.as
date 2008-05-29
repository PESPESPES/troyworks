package com.troyworks.framework.assets { 
	import com.troyworks.framework.model.BaseModelObject;
	
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	public class Asset extends BaseModelObject{
		public static var Class:Function = com.troyworks.framework.assets.Asset;
		public  var className:String = "com.troyworks.framework.assets.Asset";
	
		//a globally unique id for an asset, used to be a number now it's path, meaning that no two assets with similar path/names can have diffrent captions.
		public var gid:String;
	
		protected var __name:String;
		// a human readable description
		public var description:String;
		//a MDL provided default caption for the asset.
		public var caption:String;
		//book this asset belongs to.
		public var bookID:String;
		//chapter this asset belongs to.
		public var orig_chapterID:String;
		public var chapterID:String;
		//order this was imported into chapter (optional)
		public var chapterOrder:Number;
		// a list of types for calling appropriate handlers (e.g. zoomify, mp3 player)
		public var mediaType:MediaType;
		//indicates whether this is a user or McDougal provided asset
		public var creatorCategory:AssetCreatorCategory;
		//rough categorization for the media gallery.
		public var mediaCategory:MediaGalleryCategory;
		//whether or not this can be viewed and used in the client gallery
		public var viewableInGallery:Boolean;
		//the cd this asset is located on, used for verifying
		//that the cd is available
		public var VOL_ID:String;
		//the path on the cd/filesystem this is loaded from
		public var path:String;
	
	    public var isSaveable:Boolean = true;
		/////// NON SERIALIZED ///////////////
		//timestamp of last save
		public var timeOfLastSave:Number = -1;
		public static var PATH_SEPARATOR:String = "/";
	
		public function Asset(){
			super();
			if(arguments.length >0){
				var arg1:Object = arguments[0];
				if( arg1 is XMLNode){
					var x:XMLNode = XMLNode(arg1);
				//	//trace("XMLNode" + x);
				  this.initFromDiskXML(x);
				}else if( arg1 is XMLDocument){
					var x:XMLNode = XML(arg1);
				//	//trace("XMLDocument" + x);
				  this.initFromDiskXML(x);
				}else{
				//	//trace("String");
				  this.init.apply(this, arguments);
				}
	
			}
		}
		public function init(path:String, mediaType:MediaType,  mediaCategory:MediaGalleryCategory, companyOrUser:AssetCreatorCategory):void{
			//trace("init asset " +path + "  " +mediaType );
	
			this.path =  path;
			this.mediaType = mediaType;
			this.mediaCategory = (mediaCategory == null)? MediaGalleryCategory.UNDEFINED : mediaCategory;
			this.creatorCategory = (companyOrUser == null)? AssetCreatorCategory.APPLICATION : companyOrUser;
			this.viewableInGallery = true;
			this.caption = "";
			if(this.gid == null && path != null){
				var asMan:AssetManager = AssetManager.getInstance();
				asMan.addAsset(this);
			}
		}
		public function get name():String {
			return this.__name;
		}
		public function set name(name:String):void {
			this.__name = name;
		}
		public function get fullPath():String {
	
	
			var tmpPath:String = AssetManager.getInstance().getPath(this.VOL_ID)+ this.path;
			var path:String  = tmpPath.indexOf("/") != -1 ? tmpPath.split( "/" ).join(PATH_SEPARATOR) : tmpPath;//
	
			//path  = path.indexOf("%5C") != -1 ? path.split( "%5C" ).join(DirectorUtils.instance.pathSeparator) : path;//
	
		//	DirectorUtils.instance.sendAlert("VOL_ID: " + this.VOL_ID + ", getPath: " + AssetManager.getInstance().getPath(this.VOL_ID) );
	
			return  path;
		}
		///////////////////
		///////////////////////////////////////////////////////////////////////
		/// This is used to deserialize from disk
		public function initFromDiskXML(tree:XMLNode):void{
		//trace("Asset.initFromDiskXML");
			var res:XMLNode = tree;
		//////////gid//////////////////
			this.gid = String(res.attributes.gid);
		/////////name///////////////////////////////////////
	
		/////////description///////////////////////////////////////
	
		/////////caption///////////////////////////////////////
		/////////chapterOrder///////////////////////////////////////
		//	this.chapterOrder =  res.attributes.chapterOrder;
		/////////chapterID///////////////////////////////////////
		//	trace("bookID" + res.attributes.bookID + " gid: " + this.gid );
		this.bookID =  res.attributes.bID;
		/////////chapterID///////////////////////////////////////
	
	        if(res.attributes.oID != null){
				this.orig_chapterID =  res.attributes.oID;
			}
			this.chapterID =  res.attributes.cID;
		///////////media type/////////////////////////////////
			this.mediaType = MediaType.parse(res.attributes.mt);
		///////////creator Category/////////////////////////////////
			this.creatorCategory = AssetCreatorCategory.parse(res.attributes.cc);
		///////////media  Category/////////////////////////////////MediaGalleryCategory
			this.mediaCategory = MediaGalleryCategory.parse(res.attributes.mc);
		///////////viewableInGallery/////////////////////////////////
			this.viewableInGallery = (String(res.attributes.vg)=="true")?true:false;
		/////////VOL_ID///////////////////////////////////////
	
		/////////path///////////////////////////////////////
	
			for (var m:Number = 0; m<res.childNodes.length; m++) {
				var cnode:XMLNode = res.childNodes[m];
				//trace("Asset:node name: "+cnode.nodeName);
				switch (cnode.nodeName) {
					//case "name" :
					case "n":
					//n= name
						this.name = unescape(cnode.firstChild.nodeValue) ;
						break;
					case "d":
						this.description =	unescape(cnode.firstChild.nodeValue) ;
						break;
					case "c":
						//trace(cnode.nodeName + " = " + cnode.nodeValue);
						this.caption =	unescape(cnode.firstChild.nodeValue) ;
						break;
					//case "description" :
					//case "bookID":
					//case "caption":
						//trace("CAPTION>>>>"+cnode.firstChild.nodeValue);
					case "VOL_ID":
					case "path":
						//trace(cnode.nodeName + " = " + cnode.nodeValue);
						this[cnode.nodeName] =	unescape(cnode.firstChild.nodeValue) ;
						break;
					default:
					//trace(cnode.nodeName + " not parsedFrom XMLDocument!");
					break;
				}
			}
		}
		///////////////////////////////////////////////////////////////////////
		/// This is used to serialize to disk
		public function toDiskXML(tree:XML, timestamp:Number):XMLNode{
			//trace("Asset.toDiskXML '" + this.name+"'");
			tree = (tree == null)?new XMLDocument():tree;
			var res:XMLNode = tree.createElement("At");
			//////////gid//////////////////
			res.attributes.gid = this.gid;
			if(this.timeOfLastSave != timestamp){
				/////////name///////////////////////////////////////
				if(this.name != null){
					var t1:XMLNode=tree.createElement("n");
					res.appendChild(t1);
					var tt:XMLNode=tree.createTextNode("text");
					tt.nodeValue = escape(this.name);
					t1.appendChild(tt);
				}
				/////////description///////////////////////////////////////
				if(this.description != null){
					var t1:XMLNode=tree.createElement("d");
					res.appendChild(t1);
					var tt:XMLNode=tree.createTextNode("text");
					tt.nodeValue = escape(this.description);
					t1.appendChild(tt);
				}
				/////////caption///////////////////////////////////////
					if(this.caption != null){
	
					var t1:XMLNode=tree.createElement("c");
					res.appendChild(t1);
					var tt:XMLNode=tree.createTextNode("text");
					tt.nodeValue = escape(this.caption);
					t1.appendChild(tt);
				}
					///////////chapterID/////////////////////////////////
				//	res.attributes.chapterOrder = this.chapterOrder;
					///////////chapterID/////////////////////////////////
					res.attributes.bID = this.bookID;
				///////////chapterID/////////////////////////////////
					if(this.orig_chapterID != null){
						res.attributes.oID = this.orig_chapterID;
					}
					res.attributes.cID = this.chapterID;
				///////////media type/////////////////////////////////
					res.attributes.mt = this.mediaType;
				///////////creator Category/////////////////////////////////
					res.attributes.cc = this.creatorCategory;
				///////////media  Category/////////////////////////////////
					res.attributes.mc = this.mediaCategory;
				///////////viewableInGallery/////////////////////////////////
					res.attributes.vg = this.viewableInGallery;
				/////////VOL_ID///////////////////////////////////////
					if(this.VOL_ID != null){
	
					var t1:XMLNode=tree.createElement("VOL_ID");
					res.appendChild(t1);
					var tt:XMLNode=tree.createTextNode("text");
					tt.nodeValue = escape(this.VOL_ID);
					t1.appendChild(tt);
				}
				/////////path///////////////////////////////////////
					if(this.path != null){
	
					var t1:XMLNode=tree.createElement("path");
					res.appendChild(t1);
					var tt:XMLNode=tree.createTextNode("text");
					tt.nodeValue = escape(this.path);
					t1.appendChild(tt);
				}
			}
			this.timeOfLastSave = timestamp;
			return res;
		}
		public function toString():String{
			return "Asset: gid:" +this.gid + " name:"  + this.__name + " path:" + this.path + " bookID: " + this.bookID  + " chapterID: " + this.chapterID + " type: " + this.mediaType + " ";
		}
	}
}