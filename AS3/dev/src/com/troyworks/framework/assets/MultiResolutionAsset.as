package com.troyworks.framework.assets { 
	
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	public class MultiResolutionAsset extends Asset
	{
		public static var Class:Function = com.troyworks.framework.assets.MultiResolutionAsset;
		//the thumbnail equivalent for display in the media gallery
		protected var _thumbnail : ImageAsset;
		protected var _fullScreen : Asset;
		public var className : String = "com.troyworks.framework.assets.MultiResolutionAsset";
		public function MultiResolutionAsset ()
		{
			if (arguments.length > 0)
			{
				var arg1:Object = arguments [0];
				if (arg1 is XMLNode)
				{
					var x:XMLNode = XMLNode (arg1);
					//	//trace("XMLNode" + x);
					this.initFromDiskXML (x);
				} else if (arg1 is XMLDocument)
				{
					var x:XMLNode = XML (arg1);
					//	//trace("XMLDocument" + x);
					this.initFromDiskXML (x);
				}else
				{
					//	//trace("String");
					this.init.apply (this, arguments);
				}
			}
		}
		public function init (path : String, mediaType : MediaType, mediaCategory : MediaGalleryCategory, companyOrUser : AssetCreatorCategory) : void
		{
			super.init (path, mediaType, mediaCategory, companyOrUser);
			this.setFullScreenAsset (this);
			this.setThumbnailAsset (this);
		}
		public function get thumbnail () : ImageAsset
		{
			return this._thumbnail;
		}
		public function setThumbnailAsset (thumbNailStringOrObject : Object, mediaType : MediaType, mediaCategory : MediaGalleryCategory, companyOrUser : AssetCreatorCategory) : void
		{
			if (typeof (thumbNailStringOrObject) == "string")
			{
				this._thumbnail = new ImageAsset (thumbNailStringOrObject, MediaType.JPG, MediaGalleryCategory.IMAGE, this.creatorCategory);
				this._thumbnail.name = this.name;
				this._thumbnail.viewableInGallery = false;
				this._thumbnail.caption = this.caption;
				this._thumbnail.chapterID = this.chapterID;
				this._thumbnail.bookID = this.bookID;
				this._thumbnail.orig_chapterID = this.orig_chapterID;
				var asMan : AssetManager = AssetManager.getInstance ();
				asMan.addAsset (this._thumbnail, true);
			} else if (thumbNailStringOrObject is ImageAsset )
			{
				this._thumbnail = ImageAsset (thumbNailStringOrObject);
				if (this._thumbnail.path != this.path)
				{
					this._thumbnail.viewableInGallery = false;
				}else{
					this._thumbnail.viewableInGallery = this.viewableInGallery;
				}
				if (this._thumbnail.caption == "")
				{
					this._thumbnail.caption = this.caption;
				}
				if (this._thumbnail.chapterID == null || this._thumbnail.chapterID == "tempID")
				{
					this._thumbnail.chapterID = this.chapterID;
					this._thumbnail.orig_chapterID = this.orig_chapterID;
				}
				this._thumbnail.bookID = this.bookID;
			} else
			{
				this._thumbnail = null;
			}
		}
		public function get fullScreen () : Asset
		{
			return this._fullScreen;
		}
		public function setFullScreenAsset (StringOrObject : Object, mediaType : MediaType, mediaCategory : MediaGalleryCategory, companyOrUser : AssetCreatorCategory) : void
		{
			if (typeof (StringOrObject) == "string")
			{
				this._fullScreen = new Asset (StringOrObject, mediaType, mediaCategory, companyOrUser);
				this._fullScreen.name = this.name;
				this._fullScreen.viewableInGallery = false;
				this._fullScreen.caption = this.caption;
				this._fullScreen.chapterID = this.chapterID;
				this._fullScreen.bookID = this.bookID;
				this._fullScreen.orig_chapterID = this.orig_chapterID;
				var asMan : AssetManager = AssetManager.getInstance ();
				asMan.addAsset (this._fullScreen, true);
			} else if (StringOrObject is Asset )
			{
				this._fullScreen = Asset (StringOrObject);
				if (this._fullScreen.path != this.path)
				{
					this._fullScreen.viewableInGallery = true;
				}
				if (this._fullScreen.caption == "")
				{
					this._fullScreen.caption = this.caption;
				}
				if (this._fullScreen.chapterID == null || this._fullScreen.chapterID == "tempID")
				{
					this._fullScreen.chapterID = this.chapterID;
					this._fullScreen.orig_chapterID = this.orig_chapterID;
				}
				this._fullScreen.bookID = this.bookID;
			} else
			{
				this._fullScreen = null;
			}
		}
		/// This is used to deserialize from disk
		public function initFromDiskXML (tree : XMLNode) : void
		{
			//trace("Asset.initFromDiskXML");
			var res : XMLNode = tree;
			for (var m:Number = 0; m < res.childNodes.length; m ++)
			{
				var cnode : XMLNode = res.childNodes [m];
				//	//trace(":node name: "+cnode.nodeName);
				switch (cnode.nodeName)
				{
					case "Nor" :
					var x:XMLNode = cnode.firstChild;
					super.initFromDiskXML (x);
					case "Tmb" :
					this._thumbnail = new ImageAsset (cnode.firstChild);
					break;
					case "Ful" :
					this._fullScreen = new Asset (cnode.firstChild);
					break;
				}
			}
		}
		///////////////////////////////////////////////////////////////////////
		/// This is used to serialize to disk
		public function toDiskXML (tree : XMLDocument, timestamp : Number) : XMLNode
		{
			tree = (tree == null) ?new XMLDocument () : tree;
			var res : XMLNode = tree.createElement ("Mt");
			//////NORMAL/////////////////////////////
			var normal : XMLNode = tree.createElement ("Nor");
			res.appendChild (normal);
			normal.appendChild (super.toDiskXML (tree, timestamp));
			//////THUMBNAIL//////////////////////////
			if (this._thumbnail != this)
			{
				var thumb : XMLNode = tree.createElement ("Tmb");
				res.appendChild (thumb);
				thumb.appendChild (this._thumbnail.toDiskXML (tree, timestamp));
			}else
			{
				var thumb : XMLNode = tree.createElement ("Tmb");
				thumb.attributes.gid = this.gid;
				res.appendChild (thumb);
			}
			//////FULLSCREEN/////////////////////////
			if (this._fullScreen != this && this._fullScreen.gid != null)
			{
				var full : XMLNode = tree.createElement ("Ful");
				res.appendChild (full);
				full.appendChild (this._fullScreen.toDiskXML (tree, timestamp));
			}else
			{
				var full : XMLNode = tree.createElement ("Ful");
				full.attributes.gid = this.gid;
				res.appendChild (full);
			}
			return res;
		}
		public function toString (void) : String
		{
			var thb = (this._thumbnail === this) ?"{self}" : (this._thumbnail.path );
			var fulls = (this._fullScreen === this) ?"{self}" : (this._fullScreen.path );
			return "MultiResolutionAsset: gid:" + this.gid + " name:" + this.name + " chapter: " + chapterID + " path:" + this.path + "  \n\t\t thumbnail:" + thb + " \n\t\t fullscreen:" + fulls;
		}
	}
	
}