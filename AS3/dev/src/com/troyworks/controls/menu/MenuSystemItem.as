package com.troyworks.controls.menu {
	import flash.utils.Dictionary;	

	import com.troyworks.data.iterators.IIterator;	
	import com.troyworks.controls.menu.IMenuDataItem;

	/**
	 * @author Troy Gardner
	 */
	public class MenuSystemItem implements IMenuDataItem {
		public static var IDz : int = 0;
		private var _menuDepth:Number = 0;
		public var id : Number = MenuSystemItem.IDz++;
		public static var _ALL : Dictionary = new Dictionary();
		public static var _ALLDEEPLINKS : Dictionary = new Dictionary();
		public static var _ALLHREFLINKS : Dictionary = new Dictionary();
		private var _name : String;
		public var target : String;
		public var href : String;
		public var mcStyle:String;
		public var deeplink : String;
		private var _isSelected : Boolean = false;
		private var _parent : IMenuDataItem;
		public var selectedBullet : String = "<img src='selectedIcon' width='10' height='10'>";

		public function MenuSystemItem() {
			super();
			//	trace('MenuSystemItem');
			_ALL[id] = this;
		}

		public function iterator() : IIterator {
			return null;
		}

		public function addItem(item : IMenuDataItem) : void {
		}

		public function removeItem(item : IMenuDataItem) : void {
		}

		public function getName() : String {
			return _name;
		}
		public function setName(name : String) : void {
			_name = name;
		}
		public function getMenuDepth() : int {
			return _menuDepth;
		}
		public function setMenuDepth(name : int) : void {
			_menuDepth = name;
		}
		public function set isSelected(val : Boolean) : void {
			_isSelected = val;
		}

		public function get isSelected() : Boolean {
			return _isSelected;
		}


		public function getParent() : IMenuDataItem {
			return _parent;
		}

		public function setAnchor(a : XMLList) : void {
		//	trace("MenuSystemItem.setAnchor " + a.toXMLString());
			href = a.@href;
			target = a.@target;
			deeplink = a.@name;
			mcStyle = a.@mcStyle;
			if(_ALLDEEPLINKS[deeplink] == null) {
				_ALLDEEPLINKS[deeplink] = this;
			}
			if(_ALLHREFLINKS[href] == null){
				trace("adding anchor for href " + href);
				_ALLHREFLINKS[href] = this;
			}
			var children:XMLList =a.children(); 
			if(children.length() > 0 ) {
				//trace(" menu name is " + children[0].toXMLString());
				_name = children[0].toXMLString();//a.text()[0];
			}else {
			//trace(" menu name is blank " + a.text().length());
				
				_name = "";
			}
		}

		public function setParent(parent : IMenuDataItem) : void {
			_parent = parent;
		}

		public function getDeepLink() : String {
			return String(deeplink);
		}

		public function getHyperLink() : String {
			var lnkr:Array = new Array();
			var hasDeeplink:Boolean = deeplink != null && deeplink != "";
			if(hasDeeplink){
			lnkr.push("<a name='");
			lnkr.push(deeplink);
			lnkr.push("' href='event:");
			lnkr.push(deeplink);
			lnkr.push("' target='mainFrame'>");
			}
			lnkr.push(_name);
			if(hasDeeplink){
				lnkr.push("</a>");
			}
			var res:String = (isSelected) ? _name : lnkr.join('');
			//trace("getHyperLink " + _name + " == " + res);
			return res;
		}

		public function getHref() : String {
			return String(href);
		}

		public function getTarget() : String {
			return String(target);
		}

		public function getMenuLinks() : Array {
			var curNav : Array = new Array();
			var iter : IIterator = iterator();
			if(iter != null) {
				var mI : MenuSystemItem;
				while(iter.hasNext()) {
					mI = MenuSystemItem(iter.next());
					trace(mI.getHyperLink());
					curNav.push(mI.getHyperLink());
				} 
				return curNav;
			}else {
				return [];
			}
		}

		public function getMovieClipName() : String {
			return mcStyle;
		}
		public function toString():String{
		
			return _name + " ";
		}
	}
}
