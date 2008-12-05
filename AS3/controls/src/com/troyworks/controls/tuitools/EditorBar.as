package com.troyworks.controls.tuitools {
	//import fl.controls.Button;import mx.controls.Button;
	
	import flash.events.MouseEvent;	
	
	import mx.controls.Button;	
	import com.troyworks.framework.ui.BaseComponent;	
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.util.Trace; 
	import com.troyworks.data.ArrayX;

	/**
	 * @author Troy Gardner
	 */

	public class EditorBar extends BaseComponent {

		var clips : ArrayX;

		public function EditorBar() {
			super("s1_buildingEditor", "EditorBar", false);
			clips = new ArrayX();
			initStateMachine();
		}

		public function onEditorChanged(evtd : Object) : void {
			var objRef = evtd.activeObject;
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
			view.visible = true;
			//
			var opts : Array = objRef.getSupportedOperations();
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000 HIGHLIGHTB  onEditorChanged 000000000000000000000000");
			trace(Trace.me(opts, "opts", true));
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			trace("000000000000000000000000000000000000000000000000000000");
			for (var i in this.clips) {
				var _mc = this.clips.pop();
				trace("trying to remove " + _mc.name);
				_mc.removeMovieClip();
			}
			trace(opts.length + " supported operations");
			var lasX : Number = 0;
			for (var i = 0;i < opts.length; i++) {
				var opt = opts[i];
				trace("\t" + opt.label + " : " + opt.arg1);
				//var d:Number = this.getNextHighestDepth();
				var _mc:Button = new Button();
				//("Button", , d);
				_mc.name = opt.label + "_btn";
				view.addChild(_mc);
				_mc.label = opt.label;
				//_mc.setLabel(_ary[i].name);
				_mc.x += lasX;
			//	_mc.setSize(120, 40);
				_mc.width = 120;
				_mc.height = 40;		
	 			lasX += _mc.width + 5;
				var obj : Object = new Object();
				obj.opt = opt;
				obj.owner = this;
				obj.click = function() {
					var me : Object = Object(this);
					trace("obj.click! " + me.opt.ptype);
					var res = me.opt.method.apply(me.opt.inst, me.opt.args);
					if(me.opt.help) {
						trace("needing help from owner");
					}
					me.owner.modelChanged();
				};
				_mc.addEventListener(MouseEvent.CLICK, obj.click);
				this.clips.push(_mc);
			}
		}

		function s1_buildingEditor(e : CogEvent) : void {
		}

		function s1_usingEditor(e : CogEvent) : void {
		}

		function s1_destroyingEditor(e : CogEvent) : void {
		}
	}
}