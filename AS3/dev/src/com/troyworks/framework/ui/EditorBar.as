package com.troyworks.framework.ui { 
	import com.troyworks.hsmf.AEvent;
	import util.IntrospectGraph;
	import com.troyworks.datastructures.Array2;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class EditorBar extends BaseComponent {
		
		public var clips:Array2;
		public function EditorBar() {
			super(s1_buildingEditor, "EditorBar", false);
			clips = new Array2();
			init();
		}
		public function onEditorChanged(evtd:Object):void{
			 public var objRef = evtd.activeObject;
						////////////////////////////////
			/*	var presentation = this.getBookPresentation();
				var slideList:Array = presentation.getSlideList();
				//     var slideList:Array = this.activeObject.getSlideList();
				_root.dataHolder.namesArray = slideList;
				trace("Slide Listing :_---------------");
				for (var i = 0; i<slideList.length; i++) {
					trace("Slide "+i+" "+slideList[i].name + " " + slideList[i].getSlideSWFLinkage());
				}*/
				//var editor:String = objRef.getEditorClipName();
			//	trace("editor mc  "+editor);
			//	var editorMC = (editor != null) ? (this.canvas[editor]) : (this.canvas.genericEditor_mc);
				//set all editors visibility false (remove)
				this.visible = true;
				//
				public var opts:Array = objRef.getSupportedOperations();
				trace("000000000000000000000000000000000000000000000000000000");
	trace("000000000000000000000000000000 HIGHLIGHTB  onEditorChanged 000000000000000000000000");
	trace(util.Trace.me(opts, "opts", true));
	trace("000000000000000000000000000000000000000000000000000000");
	trace("000000000000000000000000000000000000000000000000000000");
	trace("000000000000000000000000000000000000000000000000000000");
				for (public var i in this.clips) {
					public var _mc = this.clips.pop();
					trace("trying to remove "+_mc.name);
					_mc.removeMovieClip();
				}
				trace(opts.length+" supported operations");
				var lasX:Number = 0;
				for (var i = 0; i<opts.length; i++) {
					public var opt = opts[i];
					trace("\t"+opt.label+" : "+opt.arg1);
					public var d:Number = this.getNextHighestDepth();
					public var _mc = this.attachMovie("Button", opt.label+"_btn", d);
					_mc.label = opt.label;
					//_mc.setLabel(_ary[i].name);
					_mc.x += lasX;
					_mc.setSize(120, 40);
					lasX += _mc.width+5;
					public var obj:Object = new Object();
					obj.opt = opt;
					obj.owner = this;
					obj.click =function() {
						public var me:Object = Object(this);
						trace("obj.click! "+me.opt.ptype);
						public var res = me.opt.method.apply(me.opt.inst, me.opt.args);
						if(me.opt.help){
							trace("needing help from owner");
						}
						me.owner.modelChanged();
					};
					_mc.addEventListener("click", obj);
					this.clips.push(_mc);
				}
		}
		
		function s1_buildingEditor(e:AEvent):void{
		}
		function s1_usingEditor(e:AEvent):void{
		}
		function s1_destroyingEditor(e:AEvent):void{
		}
	}
}