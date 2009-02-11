package com.troyworks.framework.assets {
	import com.troyworks.framework.controller.CollectionManager; 
	import com.troyworks.framework.BaseObject;

	import com.troyworks.data.ArrayX;
	
	
	import flash.utils.getTimer;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	public class AssetManager extends CollectionManager
	{
		public static var className : String = "com.troyworks.framework.assets.AssetManager";
	//	protected var assets : Array;
		/** Stores the onliest instance existing of this class. */
		protected static var instance : AssetManager;
		protected static var _paths : Object;
		//non-serialized//////
		protected static var currentVOL : Number;
		protected static var mapDefaultThumbnail : ImageAsset;
		protected static var imgDefaultThumbnail : ImageAsset;
		protected static var audioDefaultThumbnail : ImageAsset;
		protected static var interactiveDefaultThumbnail : ImageAsset;
		//protected static var mdlc : MDLClient = MDLClient.getInstance ();
		protected static var assetCat : AssetCreatorCategory = AssetCreatorCategory.USER;
		protected var metricMan : AssetMetricsManager;
		protected var arrGIDs : Array;
		// an index of all the ids' for lookup.
		protected var gidIDX : Object;
	
		protected var currentBookID : String;
	
		protected var pathSep : String = "/";
		/**
		* Private constructor to prevent instantiation from outside of
		* this class.
		*
		* var asMan:AssetManager = AssetManager.getInstance();
		*/
		public function AssetManager ()
		{
			super();
			if (arguments.length > 0)
			{
				this.init ();
				var arg1:Object = arguments [0];
				if (arg1 is XML)
				{
					var x:XML = XML (arg1);
					//	//// trace("XMLNode" + x);
					this.initFromDiskXML (x);
				}else
				{
					//	//// trace("String");
					this.init.apply (this, arguments);
				}
			}
		}
		protected function init () : void {
			//// trace("new AssetManager"  + AssetManager.mapDefaultThumbnail.viewableInGallery);
			c = new ArrayX();//this.assets = new Array ();
			this.gidIDX = new Object ();
			this.metricMan = new AssetMetricsManager ();
			AssetManager._paths = new Object ();
			if (false)
			{
				AssetManager.mapDefaultThumbnail = new ImageAsset ("th_map.jpg", MediaType.JPG, MediaGalleryCategory.IMAGE);
				AssetManager.imgDefaultThumbnail = new ImageAsset ("th_image.jpg", MediaType.JPG, MediaGalleryCategory.IMAGE);
				AssetManager.audioDefaultThumbnail = new ImageAsset ("th_audio.jpg", MediaType.JPG, MediaGalleryCategory.IMAGE);
				AssetManager.interactiveDefaultThumbnail = new ImageAsset ("th_interactive.jpg", MediaType.JPG, MediaGalleryCategory.IMAGE);
				AssetManager.mapDefaultThumbnail.viewableInGallery = false;
				AssetManager.imgDefaultThumbnail.viewableInGallery = false;
				AssetManager.audioDefaultThumbnail.viewableInGallery = false;
				AssetManager.interactiveDefaultThumbnail.viewableInGallery = false;
			}
			MediaGalleryCategory.constructLabels ();
			//	var asset_array = new Array();
			//	asset_array.push({VOL:"USER_ASSETS", name:"image/bf59.jpg", thumb:true, caption:"Detail of Florence in 1480 from <i>Catena Map</i>, Anonymous."});
			//	this.addAssetsFromList(asset_array);
		}
		public function initSampleData () : void {
			var asset_array:Array = new Array ();
			///audio//////////////////
			/*asset_array.push({VOL:"vol_1",name:"audios/WHSv3_32A.mp3", thumb:true});
	
	
			///images/////////////////
			asset_array.push({VOL:"USER_ASSETS", name:"image/bf59.jpg", thumb:true, caption:"Detail of Florence in 1480 from <i>Catena Map</i>, Anonymous."});
	
			///MDL Images
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170104I.jpg", thumb:true, caption:"Detail of Florence in 1480 from <i>Catena Map</i>, Anonymous."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170105I.jpg", thumb:true, caption:"Detail of Venetian jetty from <i>Arrival of the English Ambassadors</i> (1495-1496), \rVittore Carpaccio."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170108I.jpg", thumb:true, caption:"<i>Eleonora of Toledo with her Son Giovanni</i> (1545), Agnolo Bronzino."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170109I.jpg", thumb:true, caption:"<i>The Virgin of the Chancellor Rolin</i> (about 1434), Jan van Eyck."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170110I.jpg", thumb:true, caption:"<i>Mona Lisa</i> (1503-1507), Leonardo da Vinci."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170111I.jpg", thumb:true, caption:"<i>Self-portrait, Painting the Madonna</i> (1556), Sofonisba Anguissola."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170216I.jpg", thumb:true, caption:"<i>Anne of Cleves, Queen of England</i> (1539), Hans Holbein the Younger."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170217I.jpg", thumb:true, caption:"<i>The Arnolfini Wedding</i> (1434), Jan van Eyck."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170221I.jpg", thumb:true, caption:"First printing press in Florence, Italy, in late 15th century, Tito Lessi."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170327I.jpg", thumb:true, caption:"Martin Luther, nailing his “Theses” to the door."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170331I.jpg", thumb:true, caption:"<i>Sir Thomas More</i> (about 1520), Jan Gossaert"});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170436I.jpg", thumb:true, caption:"<i>St. Bartholomew’s Day Massacre</i>, 24 August 1572, François Dubois."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_170439I.jpg", thumb:true, caption:"<i>The Burning of the Books</i> from <i>Stories from the Life of Saint Dominic</i>, Pedro \r		Berruguete."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_17ASI.jpg", thumb:true, caption:"<i>Portrait of Henry VIII, King of England</i> (1539–1540), Hans Holbein the Younger."});
			asset_array.push({VOL:"vol_1", name:"images/WHSv3_17CO01I.jpg", thumb:true, caption:"<i>David</i> (1501–1504), Michelangelo"});
	
	
			///maps///////////////////
			asset_array.push({VOL:"vol_1", name:"maps/WHSv3_170102M/", thumb:true, caption:"Flanders, 1500"});
			asset_array.push({VOL:"vol_1", name:"maps/WHSv3_170104M/", thumb:true, caption:"Italy, 1500"});
			asset_array.push({VOL:"vol_1", name:"maps/WHSv3_170217M/", thumb:true, caption:"Flanders, 1500"});
			*/
			///interactive////////////
			//asset_array.push({VOL:"vol_1", name:"interactives/WHSv3_170440G.swf", thumb:true, caption:"Religions in Europe"});
			//this.addAssetsFromList(asset_array);
			//this.setPath("vol_1", "C:\\");
	
		}
		/**
		* Returns the onliest existing instance of this class.
		*
		* @return the onliest instance of this class
		*/
		public static function getInstance (void) : AssetManager
		{
			//	//// trace("assetmanager get instance");
			// creates a new instance of this class if none exists
			if (AssetManager.instance == null)
			{
				AssetManager.instance = new AssetManager ();
				AssetManager.instance.init ();
			}
			// returns the stored instance
			return AssetManager.instance ;
		}
		///////////////////////////////////////////
		// a dictionary for path information
		// e.g.  "1" turns into the the Director discovered path to the VOL drive's assets e.g. D:\assets\
		//      "MDL_LOCAL_ASSETS" is the local MDL assets eg. C:\Program Files\MDL\World History\assets\
		public function getPath (volumeId : String) : String
		{
			var res : String = AssetManager._paths [volumeId];
			if (res == null)
			{
				res = "";
			}
			return res;
		}
		public function setPath (volumeId : String, path : String) : void
		{
			AssetManager._paths [volumeId] = path;
		}
		////////////////////////////////////////
		// TODO update metrics for customized presenations
		// so that the custom and the original's numbers
		// are combined.
		// eg. Orig.userImages = 1
		//
		public function updateMetrics () : void {
			this.metricMan.clearMetrics ();
			var allBooksMetrics:MediaGalleryAssetMetrics = this.metricMan.getMetrics ("ALL", "*");
			/////////////////////////////////////////////////
			//         construct metrics                   //
			/////////////////////////////////////////////////
			for (var i:String in this.c)
			{
				var ab:Asset = Asset(this.c [i]);
				if (ab.bookID != null)
				{
					var allChaptersForBookMetrics:MediaGalleryAssetMetrics  = this.metricMan.getMetrics (ab.bookID, "*");
					var thisChapterMetrics:MediaGalleryAssetMetrics  = null;
					//var thisChapterMetricsOrig = null;
					if (ab.chapterID != "*")
					{
						// this gets the assets for this chapter.
						thisChapterMetrics = this.metricMan.getMetrics (ab.bookID, ab.chapterID);
						//	if(ab.orig_chapterID != null){
						//	thisChapterMetricsOrig = this.metricMan.getMetrics( ab.bookID, ab.orig_chapterID);
						//}
	
					}
					//////////////////////////
					var mCategory : String = "";
					if (ab.mediaCategory == MediaGalleryCategory.IMAGE && ab.creatorCategory == AssetCreatorCategory.USER )
					{
						mCategory = "USERIMAGE";
					}else
					{
						mCategory = MediaGalleryCategory.getLabel (ab.mediaCategory);
						//MediaGalleryCategory[mCategory];
	
					}
					////////ADD TO METRICS/////////
					allBooksMetrics [mCategory] ++;
					allBooksMetrics ["ALL"] ++;
					allChaptersForBookMetrics [mCategory] ++;
					allChaptersForBookMetrics ["ALL"] ++;
					if (thisChapterMetrics != null)
					{
						thisChapterMetrics [mCategory] ++;
						thisChapterMetrics ["ALL"] ++;
					}
					//	if(thisChapterMetricsOrig != null){
					//		thisChapterMetricsOrig[mCategory]++;
					//		thisChapterMetricsOrig["ALL"]++;
					//	}
					if (mCategory == "USERIMAGE")
					{
						trace ("adding metric " + mCategory + " " + ab.gid + " total = " + thisChapterMetrics [mCategory]);
					}
				} else
				{
					trace ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
					trace ("WARNING!!!!" + ab.gid + " path " + ab.path + "has invalid bookID" );
					trace ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				}
			}
		}
		///////////////////////////////////
		// returns the assets for a given query
		public function getAssets (assetQ : Asset, passNulls : Boolean, returnFirst : Boolean) : Array
		{
			var results:Array = new Array ();
			if (passNulls == null)
			{
				passNulls = false;
			}
			//_global.oPrint(this.assets[i]);
			if (assetQ == null)
			{
				results = this.c.concat ();
			} else
			{
				var i : Number = this.c.length;
				var useSingle:Boolean = (assetQ is Asset);
				while (i --)
				{
					var ast:Asset = this.c [i];
					if (useSingle)
					{
						if (this.checkMatch (assetQ, ast, passNulls, currentBookID))
						{
							results.push (ast);
							if (returnFirst != null && returnFirst == true)
							{
								//  trace("found first matching results of ");
								return results;
							}
						}
					}else
					{
						///////iterate through the results, join in the appropriate fashion.
						//get the first filter results
						var passedFirst : Boolean = this.checkMatch (assetQ [0] , ast, passNulls);
						//get the second filter results
						var passedSecond : Boolean = this.checkMatch (assetQ [2] , ast, passNulls);
						//if join via the operator
						var sum : Boolean = false;
						switch (assetQ [1])
						{
							case "AND" :
							sum = passedFirst && passedSecond;
							break;
							case "OR" :
							sum = passedFirst || passedSecond;
							break;
						}
						if (sum)
						{
							results.push (ast);
							if (returnFirst != null && returnFirst == true)
							{
								//   trace("found first matching results of ");
								return results;
							}
						}
					}
				}
			}
			trace ("found " + results.length + " matching results of " + this.c.length);
			results.reverse ();
			return results;
		}
		public function checkMatch (assetQ : Asset, ast : Asset, passNulls : Boolean, currentBookID : String) : Boolean
		{
			var addRes0:Boolean = false;
			var addRes1:Boolean = false;
			var addRes2:Boolean = false;
			var addRes3:Boolean = false;
			var addRes4:Boolean = false;
			var addRes5:Boolean = false;
			var addRes6:Boolean = false;
			var addRes7:Boolean = false;
			var addRes8:Boolean = false;
			//	trace("0 ast.gid " + ast.gid);
			if (assetQ.gid != null)
			{
				if (("*" == assetQ.gid) || (ast.gid == assetQ.gid))
				{
					addRes4 = true;
					//		trace("found by gid");
					return true;
				}else
				{
					//						trace("");
					return false;
				}
			} else if (assetQ.gid == null && passNulls)
			{
				addRes4 = true;
			} else
			{
				addRes4 = false;
			}
			trace ("aq.path '" + assetQ.path + "' ast '" + ast.path + "' " + (ast.path == assetQ.path) + " lc? " + (ast.path.toLowerCase () == assetQ.path.toLowerCase ()));
			if (assetQ.path != null)
			{
				if ((ast.path == assetQ.path) || (assetQ.path == "*" ))
				{
					addRes0 = true;
					//						return true;
	
				}else
				{
					return false;
				}
			} else if (assetQ.path == null && passNulls)
			{
				addRes0 = true;
			} else
			{
				addRes0 = false;
			}
			//// trace("same instance? "+ assetQ.className + " " + ast.className +" " + (ast.className == assetQ.className));
			//trace("1 sameCategory? Q:'" + assetQ.mediaCategory   + "' A:'" + ast.mediaCategory + "' ? " + (ast.mediaCategory == assetQ.mediaCategory)  );
			if (assetQ.mediaCategory != null)
			{
				if (assetQ.mediaCategory == MediaGalleryCategory.ALL)
				{
					addRes1 = (ast.mediaCategory && assetQ.mediaCategory > 0) ? true : false;
				}else
				{
					addRes1 = (ast.mediaCategory == assetQ.mediaCategory ) ? true : false;
				}
			} else if (assetQ.mediaCategory == null && passNulls)
			{
				addRes1 = true;
			} else
			{
				addRes1 = false;
			}
		//	trace("2 viewable? " +assetQ.viewableInGallery   + " " + ast.viewableInGallery );
			if ((assetQ.viewableInGallery != null) && (ast.viewableInGallery == assetQ.viewableInGallery) || (assetQ.viewableInGallery == null && ast.viewableInGallery == true) || (assetQ.viewableInGallery == undefined))
			{
				addRes2 = true;
			} else
			{
				addRes2 = false;
			}
			//trace("3 sameVOL? " +assetQ.VOL_ID   + " " + ast.VOL_ID );
			if ((assetQ.VOL_ID != null) && (("*" == assetQ.VOL_ID) || (ast.VOL_ID == assetQ.VOL_ID)) || (assetQ.VOL_ID == null && passNulls))
			{
				addRes3 = true;
			} else
			{
				addRes3 = false;
			}
			//trace("5 samechapterID? Q:'" + assetQ.chapterID   + "' A:'" + ast.chapterID + "' ? " + (ast.chapterID == assetQ.chapterID)  );
			if (assetQ.chapterID == undefined)
			{
				addRes5 = false;
			} else if ((assetQ.chapterID != null) && (("*" == assetQ.chapterID) || (ast.chapterID == assetQ.chapterID)) || (assetQ.chapterID == null && passNulls) || (ast.chapterID == "*"))
			{
				addRes5 = true;
			} else
			{
				addRes5 = false;
			}
			//trace("8 same orig_chapterID? Q:'" + assetQ.orig_chapterID   + "' A:'" + ast.orig_chapterID + "' ? " + (ast.orig_chapterID == assetQ.orig_chapterID)  );
			if (assetQ.orig_chapterID != null )
			{
				if (assetQ.orig_chapterID == "IS_NULL" && ast.orig_chapterID == null )
				{
					//		trace("8 passed IS NULL");
					addRes8 = true;
				} else if (assetQ.orig_chapterID == "*")
				{
					//		trace("8 passed *");
					addRes8 = true;
				} else if (ast.orig_chapterID == assetQ.orig_chapterID)
				{
					//		trace("8 passed equal orig chapter id's");
					addRes8 = true;
				} else
				{
					//		trace("failed 8")
					addRes8 = false;
				}
			} else if (assetQ.orig_chapterID == undefined)
			{
				addRes8 = false;
			} else if ((assetQ.orig_chapterID == null && passNulls))
			{
				//	trace(" 8 passed null check ");
				addRes8 = true;
			} else
			{
				addRes8 = false;
			}
			//	trace("6 sameBook? Q:'" + assetQ.bookID    + "' A:'" + currentBookID  + "' ? " + (ast.bookID  == currentBookID)  );
			if (assetQ.bookID != null )
			{
				if ((assetQ.bookID == "*") || (ast.bookID == "*"))
				{
					//		trace("6 passed *");
					addRes6 = true;
				} else if (ast.bookID == currentBookID)
				{
					//		trace("6 passed currentBook");
					addRes6 = true;
				} else if (assetQ.bookID == null && ast.bookID == currentBookID)
				{
					//		trace("6 passed currentBook2");
					addRes6 = true;
				}else
				{
					//		trace("6 Failed");
					addRes6 = false;
				}
				//	//(assetQ.bookID != null) && (("*" == assetQ.bookID)||(ast.bookID == assetQ.bookID))|| ( assetQ.bookID == null && passNulls)){
				addRes6 = true;
			} else
			{
				addRes6 = false;
			}
			//	trace("7 sameCreator? Q:'" + assetQ.creatorCategory    + "' A:'" + ast.creatorCategory   + "' ? " + (assetQ.creatorCategory  == ast.creatorCategory )  );
			if ((assetQ.creatorCategory != null) && (ast.creatorCategory == assetQ.creatorCategory) || (assetQ.creatorCategory == null && passNulls))
			{
				addRes7 = true;
			} else
			{
				addRes7 = false;
			}
			//	trace(addRes0+" "+ addRes1+" "+ addRes2+" "+ addRes3+" "+ addRes4+" "+ addRes5 +  " " + addRes6);
			if (addRes0 && addRes1 && addRes2 && addRes3 && addRes4 && addRes5 && addRes6 && addRes7 && addRes8)
			{
				//		trace(" adding res------------------");
				return true;
			} else
			{
				//	trace(" R=0:" + addRes0+" 1:"+ addRes1+" 2:"+ addRes2+" 3:"+ addRes3+" 4:"+ addRes4+" 5:"+ addRes5 +  " 6:" + addRes6 +  " 7:" + addRes7+" 8:" + addRes8);
				return false;
			}
		}
		/////////////////////
		// add asset handles a few cases,
		// adding images from disk (xml)
		// adding images from user import
		public function addAsset (asset : Asset, duplicateCheck : Boolean = true) : Asset
		{
			if (asset == null)
			{
				//don't add nothing!
				return null;
			}
			//duplicate check
			if (asset.gid != null && asset.path == null)
			{
				var a:Asset = Asset(this.gidIDX [asset.gid]);
				if (a != null)
				{
					trace (" asset " + asset.gid + " already exists ");
					return a;
				}else
				{
					//this shouldn't be an issue as the assets are retrieved by the asset id,
					//and the saving routine makes sure that they get all of them.
					//so
					trace ("Warning requested asset " + asset.gid + " not found and can't add, invalid path");
					return asset;
				}
			} else if (asset.gid != null)
			{
				//Convert to associative array to avoid for..loop
				//	trace("checking asset " + asset.gid + " In " + this.gidIDX);
				var a:Asset = Asset(this.gidIDX [asset.gid]);
				if (a != null)
				{
					//	trace(" asset " + asset.gid +" already exists ");
					return a;
				}else
				{
					this.gidIDX [asset.gid] = asset;
					//	trace("Adding asset " + asset.gid + " addedI: " + this.gidIDX[asset.gid].gid);
				}
				if (duplicateCheck )
				{
					//	trace("starting duplicate check");
					for (var i:String in this.c)
					{
						var ab:Asset = Asset(this.c [i]);
						//try to avoid adding duplicates e.g. thumbnail==fullsreen == normal
						if (asset.gid == ab.gid || (asset.path == ab.path && asset.bookID == ab.bookID && asset.chapterID == ab.chapterID))
						{
							trace ("WARNING ! asset " + asset.gid + " " + asset.path + " Already added!");
							return ab;
						}
					}
				}
			} else
			{
	
				asset.gid = asset.path; //this.getNextAssetID ();
				this.gidIDX [asset.gid] = asset;
				//				trace("Adding asset " + asset.gid + " addedI: " + this.gidIDX[asset.gid].gid);
			}
			//trace("adding asset " + asset.gid + " "+ unescape(asset.path));	
			this.c.push (asset);
			return asset;
		}
		public function getAssetFlagsFromString (args : String) : Number
		{
			//trace("attempting parsing assetFlags");
			var res : Number = 0;
			if (args != null)
			{
				var _ary : Array = args.split (",");
				//	trace("getAssetFlagsFromString " + args + " items: " + _ary.length);
				for (var i:String in _ary)
				{
					var c:String = String( _ary [i]).toUpperCase ();
					//// trace("assembling " + c);
					switch (c)
					{
						case "IMAGE" :
						res = res | MediaGalleryCategory.IMAGE;
						break;
						case "MAP" :
						res = res | MediaGalleryCategory.MAP;
						break;
						case "INTERACTIVE" :
						res = res | MediaGalleryCategory.INTERACTIVE;
						break;
						case "CHART" :
						res = res | MediaGalleryCategory.CHART_GRAPH;
						break;
						case "GRAPH" :
						res = res | MediaGalleryCategory.CHART_GRAPH;
						break;
						case "CHART_GRAPH" :
						res = res | MediaGalleryCategory.CHART_GRAPH;
						break;
						case "AUDIO" :
						res = res | MediaGalleryCategory.AUDIO;
						break;
						case "VIDEO" :
						res = res | MediaGalleryCategory.VIDEO;
						break;
						case "ATLAS" :
						res = res | MediaGalleryCategory.ATLAS;
						break;
						case "HELP" :
						res = res | MediaGalleryCategory.HELP;
						break;
						case "OVERVIEW" :
						res = res | MediaGalleryCategory.OVERVIEW;
						break;
					}
				}
			}
			return res;
		}
		//////////////////////////////////////////////////////////
		// note creation of the asset adds it to the repository
		//////////////////////////////////////////////////////////
		public function addAssetsFromList (asset_array : Array, userAdding : Boolean) : Array
		{
			var i : Number = asset_array.length;
			var res : Array = new Array ();
			trace ("******************************************");
			trace ("******************************************");
			trace ("******************************************");
			trace ("******************************************");
			trace ("******************************************");
			trace ("******************************************");
			trace ("addAssetsFromList " + i + " assets" );
			//		var allBooksMetrics = this.metricMan.getMetrics("ALL","ALL");
			while (i --)
			{
				var item : Object = asset_array [i];
				var normalName : String = item.name;
				var hasThumb : Boolean = item.thumb;
				var galleryTypesStr : String = item.type;
				var galleryTypes : Number = this.getAssetFlagsFromString (galleryTypesStr);
				var fi : Number = normalName.lastIndexOf (pathSep, normalName.length) + 1;
				var li : Number = normalName.lastIndexOf (".", normalName.length);
				var path : String = normalName.substr (0, fi);
				var fileName : String = normalName.substr (fi, (li - fi));
				var fileExt : String = normalName.substr (li + 1, 3).toUpperCase ();
				//	trace("path: '"+path+"' fileName: '"+fileName+"' fileExt: '"+fileExt+"' ");
				var defThumbName : String = (item.thumb_path == null)? path + fileName + "_th.jpg": item.thumb_path;
				//// trace("def thumb: "+defThumbName);
				var mCategoryS:String = String(item.mediaCategory).toUpperCase ();
				var mCategory:MediaGalleryCategory = null;
				if (mCategoryS == "CHART" || mCategoryS == "GRAPH") mCategoryS = "CHART_GRAPH";
				mCategory = MediaGalleryCategory [mCategoryS];
				//////////////////////CONSTRUCT THE ASSET OBJECT//////////////////////////
				switch (fileExt)
				{
					case "JPG" :{
						var mul = new MultiResolutionAsset (normalName, MediaType.JPG, mCategory | galleryTypes);
						mul.VOL_ID = item.VOL;
						mul.bookID = (item.bookID != null) ? item.bookID : currentBookID;
						mul.chapterID = item.chapterID;
						mul.orig_chapterID = item.orig_chapterID;
						mul.caption = (item.caption == null) ?"" : item.caption;
						mul.isSaveable = (item.isSaveable == null) ?true : item.isSaveable;
						mul.viewableInGallery = (item.viewableInGallery == null) ?true : item.viewableInGallery;
						if (userAdding)
						{
							mul.creatorCategory = AssetCreatorCategory.USER;
						}
						//	trace("??????????????????????????????????????");
						//      trace("IsSaveable? " + item.isSaveable + " " + mul.isSaveable);
						if (hasThumb)
						{
							//	//// trace("def thumb: "+defThumbName);
							var thumbnailAsset : ImageAsset = new ImageAsset (defThumbName, MediaType.JPG, MediaGalleryCategory.IMAGE);
							//	thumbnailAsset.path = mul.path;
							thumbnailAsset.VOL_ID = item.VOL;
							if (userAdding)
							{
								thumbnailAsset.creatorCategory = AssetCreatorCategory.USER;
							}
							mul.setThumbnailAsset (thumbnailAsset);
						} else
						{
							mul.setThumbnailAsset (imgDefaultThumbnail);
						}
						res.push (mul);
					}
					break;
					case "MP3" :{
						var mul = new MultiResolutionAsset (normalName, MediaType.MP3, mCategory | galleryTypes);
						mul.VOL_ID = item.VOL;
						mul.bookID = (item.bookID != null) ? item.bookID : currentBookID;
						mul.chapterID = item.chapterID;
						mul.orig_chapterID = item.orig_chapterID;
						mul.caption = (item.caption == null) ?"" : item.caption;
						mul.isSaveable = (item.isSaveable == null) ?true : item.isSaveable;
						mul.viewableInGallery = (item.viewableInGallery == null) ?true : item.viewableInGallery;
						if (userAdding)
						{
							mul.creatorCategory = AssetCreatorCategory.USER;
						}
						if (hasThumb)
						{
							//// trace("def thumb: "+defThumbName);
							var thumbnailAsset : ImageAsset = new ImageAsset (defThumbName, MediaType.JPG, MediaGalleryCategory.IMAGE);
							//thumbnailAsset.path = mul.path;
							thumbnailAsset.VOL_ID = item.VOL;
							if (userAdding)
							{
								thumbnailAsset.creatorCategory = AssetCreatorCategory.USER;
							}
							mul.setThumbnailAsset (thumbnailAsset);
						} else
						{
							mul.setThumbnailAsset (audioDefaultThumbnail);
						}
						res.push (mul);
					}
					break;
					case "SWF" :{
						var mul = new MultiResolutionAsset (normalName, MediaType.SWF, mCategory | galleryTypes);
						mul.VOL_ID = item.VOL;
						mul.bookID = (item.bookID != null) ? item.bookID : currentBookID;
						mul.chapterID = item.chapterID;
						mul.orig_chapterID = item.orig_chapterID;
						mul.caption = (item.caption == null) ?"" : item.caption;
						mul.isSaveable = (item.isSaveable == null) ?true : item.isSaveable;
						mul.viewableInGallery = (item.viewableInGallery == null) ?true : item.viewableInGallery;
						if (userAdding)
						{
							mul.creatorCategory = AssetCreatorCategory.USER;
						}
						if (hasThumb)
						{
							//// trace("def thumb: "+defThumbName);
							var thumbnailAsset : ImageAsset = new ImageAsset (defThumbName, MediaType.JPG, MediaGalleryCategory.IMAGE);
							//thumbnailAsset.path = mul.path;
							thumbnailAsset.VOL_ID = item.VOL;
							if (userAdding)
							{
								thumbnailAsset.creatorCategory = AssetCreatorCategory.USER;
							}
							mul.setThumbnailAsset (thumbnailAsset);
						} else
						{
							mul.setThumbnailAsset (interactiveDefaultThumbnail);
						}
						res.push (mul);
					}
					break;
					case "HTM" :
					case "HTML" :
					default :{
						var mul = new MultiResolutionAsset (normalName, MediaType.HTM, mCategory | galleryTypes);
						mul.VOL_ID = item.VOL;
						mul.bookID = (item.bookID != null) ? item.bookID : currentBookID;
						mul.chapterID = item.chapterID;
						mul.orig_chapterID = item.orig_chapterID;
						mul.caption = (item.caption == null) ?"" : item.caption;
						mul.isSaveable = (item.isSaveable == null) ?true : item.isSaveable;
						mul.viewableInGallery = (item.viewableInGallery == null) ?true : item.viewableInGallery;
						if (userAdding)
						{
							mul.creatorCategory = AssetCreatorCategory.USER;
						}
						if (hasThumb)
						{
							//// trace("def thumb: "+defThumbName);
							var thumbnailAsset : ImageAsset = new ImageAsset (defThumbName, MediaType.JPG, MediaGalleryCategory.IMAGE);
							//thumbnailAsset.path = mul.path;
							thumbnailAsset.VOL_ID = item.VOL;
							if (userAdding)
							{
								thumbnailAsset.creatorCategory = AssetCreatorCategory.USER;
							}
							mul.setThumbnailAsset (thumbnailAsset);
						} else
						{
							mul.setThumbnailAsset (interactiveDefaultThumbnail);
						}
						res.push (mul);
					}
					break;
				}
			}
			//}
			return res;
		}
		public function removeAsset (asset : Asset) : void
		{
			if (asset is MultiResolutionAsset)
			{
				var masset:MultiResolutionAsset = MultiResolutionAsset (asset);
				var nast:String = masset.path;
				var tast:String  = masset.thumbnail.path;
				var fast:String  = masset.fullScreen.path;
				var i : Number = this.c.length;
				while (i --)
				{
					var ast:Asset = this.c [i];
					if (ast.path == nast || ast.path == fast || ast.path == tast )
					{
						//trace("Removing selected Asset");
						//_global.oPrint(ast);
						this.c.splice (i, 1);
						//break;
	
					}
				}
			}else
			{
				var i : Number = this.c.length;
				while (i --)
				{
					var ast:Asset = this.c [i];
					if (ast === asset)
					{
						//trace("Removing selected Asset");
						//_global.oPrint(ast);
						this.c.splice (i, 1);
						break;
					}
				}
			}
		}
		public function removeAssets (assetsToDelete : Array) : void
		{
			var i : Number = assetsToDelete.length;
			while (i --)
			{
				var ast:Asset = assetsToDelete [i];
				this.removeAsset (ast);
			}
			this.updateMetrics ();
		}
		///////////////////////////////////////////////////////////////////////
		/// This is used to deserialize from disk
		public function initFromDiskXML (tree : XML) : void
		{
			//trace("AssetManager.initFromDiskXML");
			var stime:Number = getTimer ();
			var res : XML = tree;
			//////////assets/////////////////////////
			for (var m:Number = 0; m < res.childNodes.length; m ++)
			{
				var cnode : XMLNode = res.childNodes [m];
				//trace("Asset:node name: "+cnode.nodeName);
				switch (cnode.nodeName)
				{
					case "Assets" :
					for (var i:Number = 0; i < cnode.childNodes.length; i ++)
					{
						var ccnode : XML = cnode.childNodes [i];
						//trace("assets content '" +ccnode.nodeName+"'");
						switch (ccnode.nodeName)
						{
							case "At" :
							// trace("adding Asset");
							var a:Asset = new Asset (ccnode);
							this.addAsset (a, false);
							break;
							case "Mt" :
							// trace("adding MulitAsset");
							var a:MultiResolutionAsset = new MultiResolutionAsset (ccnode);
							this.addAsset (a, false);
							break;
							default :
							//trace("WARNING IMPORT unrecognized node1");
							break;
						}
					}
					//this.updateMetrics();
					break;
					/*case "paths":
					for (var i = 0; i<cnode.childNodes.length; i++) {
					var ccnode:XMLNode = cnode.childNodes[i];
					//trace("paths content: '" +ccnode.nodeName+"'");
					switch(ccnode.nodeName){
					case "path":
					var k = null;
					var p = null;
					for (var j = 0; j<ccnode.childNodes.length; j++) {
					var cccnode:XMLNode = ccnode.childNodes[j];
					//trace("paths content: '" +cccnode.nodeName+"'");
					switch(cccnode.nodeName){
					case "id":
					k = unescape(cccnode.firstChild.nodeValue);
					break;
					case "ppath":
					p = unescape(cccnode.firstChild.nodeValue);
					break;
					}
					}
					//trace("found path " + k + " " + p);
					break;
					default:
					//trace("WARNING IMPORT unrecognized node1");
					break;
					}
					}
					break;*/
					default :
					//trace(cnode.nodeName + " not parsedFrom XMLDocument!");
					break;
				}
			}
			trace("initFromDiskXML " + (getTimer () - stime));
		}
		///////////////////////////////////////////////////////////////////////
		/// This is used to serialize to disk
		public function toDiskXML (tree : XMLDocument, selA : AssetCreatorCategory) : XMLNode
		{
			//// trace("Asset.toDiskXML '" + this.name+"'");
			tree = (tree == null) ?new XMLDocument () : tree;
			var res : XMLNode = tree.createElement ("AssetManager");
			//////////assets/////////////////////////
			if (this.c.length > 0)
			{
				var timestamp:Number = getTimer ();
				var ssec : XMLNode = tree.createElement ("Assets");
				res.appendChild (ssec);
				for (var i : Number = 0; i < this.c.length; i ++)
				{
					var ast:Asset = this.c [i];
					//trace("saving ast " + ast.path + " cat: " + ast.creatorCategory + " saveable? " + ast.isSaveable);
					if (ast.isSaveable && (ast.bookID == currentBookID))
					{
						if (ast.creatorCategory == selA)
						{
							//		trace("asset is savable");
							var t1 : XMLNode = ast.toDiskXML (tree, timestamp);
							ssec.appendChild (t1);
						}else
						{
							//		trace("not saving");
	
						}
					}
				}
			}
			/////////paths _paths:Object ///////////////////////////////////////
			/*
			if(AssetManager._paths != null){
			var paths:XMLNode=tree.createElement("paths");
			res.appendChild(paths);
			for(var i in AssetManager._paths){
			var pat:XMLNode=tree.createElement("path");
			paths.appendChild(pat);
			///the id e.g "vol_1"///////////////////////
			var pid:XMLNode=tree.createElement("id");
			pat.appendChild(pid);
			var tt:XMLNode=tree.createTextNode("text");
			tt.nodeValue = escape(String(i));
			pid.appendChild(tt);
			//the path for a particular path e.g.  C:/user/folder/
			var pp:XMLNode=tree.createElement("ppath");
			pat.appendChild(pp);
	
			var t2:XMLNode=tree.createTextNode("text");
			t2.nodeValue = escape(AssetManager._paths[i]);
			pp.appendChild(t2);
			}
			}*/
			return res;
		}
		public function toString () : String
		{
			var str : String = "AssetManager contains: " + this.c.length + " assets-----\n";
			var i : Number = this.c.length;
			while (i --)
			{
				var ast:Asset = Asset (this.c [i]);
				str += "\t" + ast.toString () + "\n";
			}
			return str;
		}
	
	
	}
	
}