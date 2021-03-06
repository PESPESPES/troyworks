﻿package ui {
	import flash.display.StageScaleMode;	
	import flash.display.SimpleButton;	
	import flash.utils.getDefinitionByName;	
	import flash.filters.BlurFilter;	
	import flash.net.URLRequest;	
	import flash.net.URLLoader;	
	import flash.net.URLLoaderDataFormat;

	import com.troyworks.util.NumberUtil;	

	import flash.filters.GlowFilter;	
	import flash.text.TextField;	
	import flash.events.Event;	
	import flash.events.MouseEvent;	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.display.Sprite;	

	import mdl.*;

	import fl.controls.*;
	import fl.data.DataProvider;

	import com.troyworks.core.tweeny.Tny;	

	/**
	 * @author Troy Gardner
	 */
	public class UI extends MovieClip {
		public var phy_txt : TextField;
		public var rotateHVMode_Btn : MovieClip;
		public var rotateIntoAxisMode_Btn : MovieClip;
		//public var delectAllBtn : Button;
		//public var deselect2Btn : Button;
		///////////TOP NAV ///////////
		////////////BOTTOM NAV ////////
		public var bottom_panel : MovieClip;
		//	public var transparentVertices_cb : CheckBox;
		//	public var showAxis_cb : CheckBox;
		//	public var showVertices_cb : CheckBox;
		//	public var showTriality_cb : CheckBox;
		//	public var showOrigin_cb : CheckBox;
		//		public var hoverInfo : MovieClip;
		//	public var selection1 : MovieClip;
		//	public var selection2 : MovieClip;
		//	public var selection3 : MovieClip;
		//	public var selection4 : MovieClip;
		//	public var interactionsHeader_mc : MovieClip;	
		///////////COMBOS //////////////
		public var points_cmb : ComboBox;
		public var coords_cmb : ComboBox;
		//public var rotations_cmb : ComboBox;
		public var saveRotation_Btn : SimpleButton;
		public var deleteRotation_Btn : SimpleButton;
		public var renameRotation_Btn : SimpleButton;
		public var saveRotationRequester_mc : MovieClip;

		public var rotations_lb : List;

		////////// TOOLTIP /////////////
		public var toolTip : MovieClip;
		public var loading_mc : MovieClip;
		///////////////////////////////

		//////// TEXT ///////////////////
		//	public var zoom_txt : TextField;
		public var H_txt : TextField;
		public var V_txt : TextField;
		public var H_lbl : TextField;
		public var V_lbl : TextField;
		//public var hval_txt:TextField;
		//public var vval_txt:TextField;
		//////// Buttons ////////////////
		public var a_btn : MovieClip;
		public var b_btn : MovieClip;
		public var c_btn : MovieClip;
		public var d_btn : MovieClip;
		public var e_btn : MovieClip;
		public var f_btn : MovieClip;
		public var g_btn : MovieClip;
		public var h_btn : MovieClip;
		var allBtns : Array;

		public var viewport : MovieClip;
		public var center : MovieClip;

		var modl : Model = new Model();
		var pobj : EightDimensionParticle;
		var spobj : EightDimensionParticle;
		var D : Number = 200;
		var ab : Number = 200; 
		//Perspektive

		var tD3 : Number;
		var ax : Number;
		var ay : Number;
		var i : Number;
		var n : Number;
		private var cosY : Number;
		private var sinY : Number;
		private var cosX : Number;
		private var sinX : Number;
		private var scale : Number = 172 * 1.05;// 172;
		private var idxDButton : Dictionary;

		var vpX : Number;
		var vpY : Number ;
		var curRotation : Number = 0;

		
		public var clickX : Number;
		public var clickY : Number;

		private var mouseOverOFilters : Array;
		private var lastRadians : Number = 0;
		var aRot : Sprite = new Sprite();
		var bRot : Sprite = new Sprite();
		var endRot : Sprite = new Sprite();

		var Vsnap : EightDimensionVector = new EightDimensionVector();
		var Hsnap : EightDimensionVector = new EightDimensionVector();
		var lblDef : Object;
		//	private var standardPoints : Boolean;
		private var curPointFilter : EightDimensionParticle = new EightDimensionParticle();
		private var createdParticles : Boolean;
		private var rotationsHaveChanged : Boolean = false;
		private var pointFadeDownTny : Tny;
		private var pointFadeUpTny : Tny;
		///// for the photon hack /////////
		var Ap : EightDimensionParticle;
		var Bp : EightDimensionParticle;
		var Cp : EightDimensionParticle;
		var Dp : EightDimensionParticle;

		public function UI() : void {
			super();
			modl.addEventListener(Model.POINTS_CHANGED, onModelPointsChanged);
			modl.addEventListener(Model.COORDS_CHANGED, onModelCoordinatesChanged);
			modl.addEventListener(Model.ROTATIONS_CHANGED, onModelRotationsChanged);
			lblDef = getDefinitionByName("AllLabels");
			trace("================= UI ========================");
			trace("lblDef " + lblDef);
			//modl.initializePoints();
			//trace("modl " + modl.scene_points);
			addFrameScript(0, onFrame1);
		}

		public function onFrame1() : void {
			trace("onFrame1");
			var loader : URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onLoadedConfigSuccess);
			loader.load(new URLRequest("config.xml"));
			var dp : DataProvider = new DataProvider();
			dp.addItem({label:"loading.."});
			points_cmb.dataProvider = dp;
			coords_cmb.dataProvider = dp;
			rotations_lb.dataProvider = dp;
			bottom_panel.hoverInfo.visible = false;
			bottom_panel.selection1.visible = false;
			bottom_panel.selection2.visible = false;
			//deselect2Btn.visible = false;
			bottom_panel.selection3.visible = false;
			//	bottom_panel.selection4.visible = false;
			bottom_panel.delectAllBtn.addEventListener(MouseEvent.CLICK, onDeselectAllClick);
			//deselect2Btn.addEventListener(MouseEvent.CLICK, onDeselectSecond);
			rotateHVMode_Btn.addEventListener(MouseEvent.CLICK, selectRotateHVMode);
			rotateIntoAxisMode_Btn.addEventListener(MouseEvent.CLICK, selectRotateIntoAxis);
			bottom_panel.showAxis_cb.addEventListener(Event.CHANGE, updateView);
			bottom_panel.showTriality_cb.addEventListener(Event.CHANGE, updateView);
			saveRotation_Btn.addEventListener(MouseEvent.CLICK, openSaveRotation);
			deleteRotation_Btn.addEventListener(MouseEvent.CLICK, deleteRotation);
			//renameRotation_Btn.addEventListener(MouseEvent.CLICK, renameRotation);
			saveRotationRequester_mc.panel_mc.save_btn.addEventListener(MouseEvent.CLICK, saveRotation);
			saveRotationRequester_mc.visible = false;
		}

		private function selectRotateHVMode(e : Event) : void {
			trace("selectRotateHVMode");
			modl.userInteractionMode = Model.MODE_ROTATEHV;
			Vsnap = modl.camera.V.clone();
			Hsnap = modl.camera.H.clone();
			clickX = viewport.mouseX;
			clickY = viewport.mouseY;
		
			updateView();
		}

		private function selectRotateIntoAxis(e : Event) : void {
			trace("selectRotateIntoAxis");
			modl.userInteractionMode = Model.MODE_ROTATEINTOAXIS;
			clickX = viewport.mouseX;
			clickY = viewport.mouseY;
			updateView();
		}

		function nameLabelFunction(item : Object) : String {
			return  item.name;
		}	

		private function pointsChanged(e : Event = null) : void {
			trace("CMB settingPointSystem " + points_cmb.selectedItem.name);
			if(e != null) {
				e.stopImmediatePropagation();
			}
			switch(points_cmb.selectedItem.name) {
	
				case "Standard Model":
					trace("STANDARD POINTS");
					curPointFilter.isE8 = false;
					curPointFilter.isE6 = false;
					curPointFilter.isGeorgi_Glashow = false;
					curPointFilter.isPati_Salam = false;
					curPointFilter.isStandardModel = true;
					//modl.coords = Model.smcoords;
					modl.isGUTmode = false;
					break;					
				case "E6 / SO(10)":
					trace("E6 POINTS");
					curPointFilter.isE8 = false;
					curPointFilter.isE6 = true;
					curPointFilter.isGeorgi_Glashow = false;
					curPointFilter.isPati_Salam = false;
					curPointFilter.isStandardModel = false;
					//	modl.coords = Model.gutcoords;
					modl.isGUTmode = true;
					break;
				
				case "Georgi-Glashow SU(5)":
					trace("Georgi Glashow POINTS");
					curPointFilter.isE8 = false;
					curPointFilter.isE6 = false;
					curPointFilter.isGeorgi_Glashow = true;
					curPointFilter.isPati_Salam = false;
					curPointFilter.isStandardModel = false;
					//	modl.coords = Model.gutcoords;
					modl.isGUTmode = true;
					break;

				case "Pati-Salam":
					trace("Pati Salam POINTS");
					curPointFilter.isE8 = false;
					curPointFilter.isE6 = false;
					curPointFilter.isGeorgi_Glashow = false;
					curPointFilter.isPati_Salam = true;
					curPointFilter.isStandardModel = false;
					//	modl.coords = Model.gutcoords;
					modl.isGUTmode = true;
					break;
				case  "E8":
					trace("E8 POINTS");
					curPointFilter.isE8 = true;
					curPointFilter.isE6 = false;
					curPointFilter.isGeorgi_Glashow = false;
					curPointFilter.isPati_Salam = false;
					curPointFilter.isStandardModel = false;
					//modl.coords = Model.e8coords;
					modl.isGUTmode = false;
					break;	
			}
			
			var ary : Array = modl.curPointSystem.particles;
			var i : int = 0;
			var n : int = ary.length;
			
			for (;i < n;++i) {
				//	trace("poinChagne " + ary[i].name + " " + ary[i].isGUT);
				EightDimensionParticle(ary[i]).redrawUI();
			}
			pointFadeDownTny.alpha = 1;
			pointFadeDownTny.duration = 0;
			pointFadeDownTny.alpha = 0;
								
			pointFadeUpTny.alpha = 0;
			pointFadeUpTny.duration = 0;					
			pointFadeUpTny.alpha = 1;
			
			modl.curPointSystem = PointSystem(points_cmb.selectedItem);
			pointFadeDownTny.duration = 1;
			pointFadeUpTny.duration = 1;
			
			addEventListener(Event.ENTER_FRAME, updateView);
			pointFadeUpTny.onComplete = removeFadeUpdater;
			updateView();
		}

		public function removeFadeUpdater() : void {
			trace("removing fade effect DOWN " + pointFadeDownTny.target.alpha + " UP " + pointFadeUpTny.target.alpha);
			pointFadeDownTny.target.alpha = 0;
			pointFadeUpTny.target.alpha = 1;
			removeEventListener(Event.ENTER_FRAME, updateView);
			updateView();
		}

		private function onModelPointsChanged(e : Event = null) : void {
			trace("UI.onModelPointsChanged " + modl);
			
			if(modl != null && modl.pointSystems != null && modl.pointSystems.length > 0 && points_cmb != null) {
				points_cmb.dataProvider = new DataProvider(modl.pointSystems);
				points_cmb.selectedIndex = points_cmb.dataProvider.getItemIndex(modl.curPointSystem); 
				coords_cmb.removeAll();
				coords_cmb.enabled = false;
				coords_cmb.dropdownWidth = 200;
				rotations_lb.removeAll();
				rotations_lb.enabled = false;
			}
		}

		public static function setAxisLabel(label : MovieClip, lblPos : Number) : void {
			label.gotoAndStop(lblPos);
		}

		private function onCoordComboBoxChanged(e : Event = null) : void {
			trace("CMB  settingModelCoord to " + coords_cmb.selectedItem.name + " " + coords_cmb.selectedItem.data);
			if(e != null) {
				e.stopImmediatePropagation();
			}
				
			var desCoord : Coordinates = Coordinates(coords_cmb.selectedItem);
			modl.curcoords = desCoord;
			//			updateView();
		}

		private function onModelCoordinatesChanged(e : Event = null) : void {
			try {
				coords_cmb.dataProvider = new DataProvider(modl.curPointSystem.coordinates);
				trace("UI.onModelCoordinatesChanged " + coords_cmb.dataProvider.length);
				trace("curCoordinate " + modl.coords);//.curCoordinate.name);
			
				
				/*for(var i:int= 0; i < coords_cmb.dataProvider.length; i++){
				var o:Object = coords_cmb.dataProvider.getItemAt(i);
				trace("found data item " + o.name);
				if(o == modl.coords ){
				trace("FOUND CURRENT COORD!");
				coords_cmb.selectedIndex = i;
						
				}
				}*/
				coords_cmb.enabled = (coords_cmb.dataProvider.length > 0);
				trace("UI.modl.coords " + modl.coords);
				if(modl.coords) {
					coords_cmb.selectedIndex = coords_cmb.dataProvider.getItemIndex(modl.coords);//.curCoordinate);

					trace("bottom_panel.interactionsHeader_mc.aDim_lbl " + modl.coords.coordLabels[0]);
					setAxisLabel(bottom_panel.interactionsHeader_mc.aDim_lbl, modl.coords.lblstart + 0);
					setAxisLabel(a_btn.dimension_lbl, modl.coords.lblstart + 0);
			
					setAxisLabel(bottom_panel.interactionsHeader_mc.bDim_lbl, modl.coords.lblstart + 1);
					setAxisLabel(b_btn.dimension_lbl, modl.coords.lblstart + 1);

					setAxisLabel(bottom_panel.interactionsHeader_mc.cDim_lbl, modl.coords.lblstart + 2);
					setAxisLabel(c_btn.dimension_lbl, modl.coords.lblstart + 2);

					setAxisLabel(bottom_panel.interactionsHeader_mc.dDim_lbl, modl.coords.lblstart + 3);
					setAxisLabel(d_btn.dimension_lbl, modl.coords.lblstart + 3);

					setAxisLabel(bottom_panel.interactionsHeader_mc.eDim_lbl, modl.coords.lblstart + 4);
					setAxisLabel(e_btn.dimension_lbl, modl.coords.lblstart + 4);

					setAxisLabel(bottom_panel.interactionsHeader_mc.fDim_lbl, modl.coords.lblstart + 5);
					setAxisLabel(f_btn.dimension_lbl, modl.coords.lblstart + 5);

					setAxisLabel(bottom_panel.interactionsHeader_mc.gDim_lbl, modl.coords.lblstart + 6);
					setAxisLabel(g_btn.dimension_lbl, modl.coords.lblstart + 6);

					setAxisLabel(bottom_panel.interactionsHeader_mc.hDim_lbl, modl.coords.lblstart + 7);
					setAxisLabel(h_btn.dimension_lbl, modl.coords.lblstart + 7);
			

					/////////////////////////////////////////////////////////////
					// UPDATE THE AXISES PARTICLES 
					/////////////////////////////////////////////////////////////
					i = 0;				
					n = modl.curPointSystem.axises.length;
					var p1 : EightDimensionParticle;
					var p2 : EightDimensionParticle;
					var pary : Array;
					trace("UPDATE THE AXISES PARTICLES.. " + n + " .....................");
					/////////// /////////////////////
					for(;i < n;++i) {
						trace("UPDATE THE AXISES PARTICLES i " + i);
						pary = modl.curPointSystem.axises[i] as Array;
						////////////// p1 ////////////////////
						p1 = pary[0] as EightDimensionParticle;
						trace("p1 " + p1);
						trace("p1.ui " + p1.ui);
						if(p1.ui != null) {
							setAxisLabel(p1.ui.getChildByName("lbl") as MovieClip, modl.coords.lblstart + i);
						}
						////////////// p2 ////////////////////

						p2 = pary[1] as EightDimensionParticle;
						if(p2.ui != null) {		
							setAxisLabel(p2.ui.getChildByName("lbl") as MovieClip, modl.coords.lblstart + i);
						}				
					}	
			
					/////////////////////////////////////////////////////////////
					// UPDATE THE SELECTED PARTICLES 
					/////////////////////////////////////////////////////////////
					trace("UPDATE THE SELECTD PARTICLES.......................");
					if(modl.firstClicked) {
						updateDetails(bottom_panel.selection1, modl.firstClicked);
					}
					if(modl.secondClicked) {
						updateDetails(bottom_panel.selection2, modl.secondClicked);
					}
					if(modl.result1) {
						updateDetails(bottom_panel.selection3, modl.result1);
					}
					if(modl.result2) {
			//		updateDetails(bottom_panel.selection4, modl.result2);
					}
					trace("UPDATE THE MODEL ROTATIONS .......................");
					onModelRotationsChanged(null, true);
					trace("UPDATE THE VIEW .......................");
			
					updateView();
				}
			}catch(err : Error) {
				trace("ERROR " + err.getStackTrace());
			}
		}

		private function openSaveRotation(e : Event = null) : void {
			trace("openSaveRotation ");
			if(modl.curUserRotation != null) {
				saveRotationRequester_mc.panel_mc.input_txt.text = modl.curUserRotation.name; 
				saveRotationRequester_mc.visible = true;
			}
		}

		private function saveRotation(e : Event = null) : void {
			trace("saveRotation ");
			if(saveRotationRequester_mc.visible ) {
				modl.curUserRotation.name = saveRotationRequester_mc.panel_mc.input_txt.text;
				saveRotationRequester_mc.visible = false; 
			}
			if(modl.curUserRotation != null) {
				if(modl.curUserRotation.name.indexOf("*") > -1) {
					modl.curUserRotation.name = modl.curUserRotation.name.split("*").join('');
				} 
				modl.coords.rotations.push(modl.curUserRotation);
				modl.coords.curRotation = modl.curUserRotation;
				modl.curUserRotation = null;
				onModelRotationsChanged();
			}
		}

		private function deleteRotation(e : Event = null) : void {
			trace("delete Rotation ");
			i = 0;				
			n = modl.coords.rotations.length;
			var ary : Array = modl.coords.rotations;
			
			for(;i < n;++i) {
				if(ary[i] == rotations_lb.selectedItem) {
					trace("found rotation to delete");
					ary.splice(i, 1);
					break;
				}
			}
			if(modl.curUserRotation == rotations_lb.selectedItem) {
				modl.curUserRotation = null;
			}
			onModelRotationsChanged();
		}

		private function renameRotation(e : Event = null) : void {
			trace("rename");
			
//			onModelRotationsChanged();
		}

		private function rotationsChanged(e : Event) : void {
			trace("CMB settingModelRotation to " + rotations_lb.selectedItem.name);
			e.stopImmediatePropagation();
			rotationsHaveChanged = true;
			modl.coords.curRotation = Rotations(rotations_lb.selectedItem);
		}

		private function onModelRotationsChanged(e : Event = null, skip : Boolean = false) : void {
			trace("UI.onModelRotationsChanged");
			//return;
			if(!modl.coords) {
				return;
			}

			var dp : DataProvider = new DataProvider(modl.coords.rotations);
			//var userRotation : Rotations = new Rotations();
			//userRotation.name = "My New Rotation";
			if(modl.curUserRotation != null) {
				dp.addItem(modl.curUserRotation);
			}
			rotations_lb.dataProvider = dp;
			rotations_lb.enabled = (rotations_lb.dataProvider.length > 0);
			rotations_lb.selectedIndex = rotations_lb.dataProvider.getItemIndex(modl.coords.curRotation); 
			
			if(skip) {
				return;
			}
			//	var hv : Array = modl.coords.curRotation.hv;

			a_btn.indicator_mc.H_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			a_btn.indicator_mc.V_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			a_btn.indicator_mc.HV_btn.addEventListener(MouseEvent.CLICK, onHV_Click);

			b_btn.indicator_mc.H_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			b_btn.indicator_mc.V_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			b_btn.indicator_mc.HV_btn.addEventListener(MouseEvent.CLICK, onHV_Click);
			
			c_btn.indicator_mc.H_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			c_btn.indicator_mc.V_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			c_btn.indicator_mc.HV_btn.addEventListener(MouseEvent.CLICK, onHV_Click);
			
			d_btn.indicator_mc.H_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			d_btn.indicator_mc.V_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			d_btn.indicator_mc.HV_btn.addEventListener(MouseEvent.CLICK, onHV_Click);
						
						
			e_btn.indicator_mc.H_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			e_btn.indicator_mc.V_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			e_btn.indicator_mc.HV_btn.addEventListener(MouseEvent.CLICK, onHV_Click);
			
			f_btn.indicator_mc.H_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			f_btn.indicator_mc.V_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			f_btn.indicator_mc.HV_btn.addEventListener(MouseEvent.CLICK, onHV_Click);
			
			g_btn.indicator_mc.H_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			g_btn.indicator_mc.V_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			g_btn.indicator_mc.HV_btn.addEventListener(MouseEvent.CLICK, onHV_Click);
			
			h_btn.indicator_mc.H_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			h_btn.indicator_mc.V_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			h_btn.indicator_mc.HV_btn.addEventListener(MouseEvent.CLICK, onHV_Click);
			
			//////////// PASS BY VALUE NOT REFERNECE!! ////////////
			var cr : Rotations = modl.coords.curRotation;
			if(cr) {
				modl.camera.H.d1 = cr.H.d1;
				modl.camera.V.d1 = cr.V.d1;
			
				modl.camera.H.d2 = cr.H.d2;
				modl.camera.V.d2 = cr.V.d2;

				modl.camera.H.d3 = cr.H.d3;
				modl.camera.V.d3 = cr.V.d3;

				modl.camera.H.d4 = cr.H.d4;
				modl.camera.V.d4 = cr.V.d4;

				modl.camera.H.d5 = cr.H.d5;
				modl.camera.V.d5 = cr.V.d5;
			
				modl.camera.H.d6 = cr.H.d6;
				modl.camera.V.d6 = cr.V.d6;
			
				modl.camera.H.d7 = cr.H.d7;
				modl.camera.V.d7 = cr.V.d7;
			
				modl.camera.H.d8 = cr.H.d8;
				modl.camera.V.d8 = cr.V.d8;
			
				modl.curXaxis = Dimension.DIMS[modl.coords.curRotation.selectedHAxisIdx];
				modl.curYaxis = Dimension.DIMS[modl.coords.curRotation.selectedVAxisIdx];
			} else {
				trace("ERROR rotations is blank ");
			}
			onSelectionChanged();
			if(loading_mc.visible == false) {
				updateView();
			}
		}

		public function onMouseMoveOverIndicator(event : MouseEvent) : void {
			var sp : Sprite = Sprite(event.target); 
			trace(sp.mouseX + " " + sp.mouseY);
		}

		
		
		private function onLoadedConfigSuccess(event : Event) : void {
			try {
				var example : XML = new XML(event.target.data);
				modl.initFromXML(example);
				points_cmb.labelFunction = nameLabelFunction;
				points_cmb.addEventListener(Event.CHANGE, pointsChanged);
				coords_cmb.labelFunction = nameLabelFunction;
				coords_cmb.addEventListener(Event.CHANGE, onCoordComboBoxChanged);
				rotations_lb.labelFunction = nameLabelFunction;
				rotations_lb.addEventListener(Event.CHANGE, rotationsChanged);
			}catch (err : Error) {
				trace("Could not parse text into XML " + err.getStackTrace());
				throw new Error("Error in UI.onLoadedConfigSuccess parsing config");
			}
			/*var ary : Array = phy_txt.text.split("\r");
			////////////////////////////////////////
			trace("---------------------------------------");
			trace("phy_txt " + ary.length);
			for(var j:int = 0 ; j < ary.length; j++){
			var ary2:Array = ary[j].split(" ");
			ary2[0] = '<id="'+ ary2[0]+'"';
			trace(" " + ary2.join(" ") + " />");
			}
			var p : EightDimensionParticle = modl.curPointSystem.particles[0] as EightDimensionParticle;
			trace("p1 " + p);
			//		<p id="0" name="w^L" coordlbl="{1/2,SQRT,3/2},1,0,0,0,0,0,0"
			//	coord="1,1,0,0,0,0,0,0" color="mgree" symbol="mcir"
			//	label="spin connection" />
			var px : XML = new XML("<p/>");
			px.@id = p.id;
			px.@name = p.name;
			px.@e8coordlbl = p.d1Lbl + "," + p.d2Lbl + "," + p.d3Lbl + "," + p.d4Lbl + "," + p.d5Lbl + "," + p.d6Lbl + "," + p.d7Lbl + "," + p.d8Lbl;
			px.@e8coord = p.d1 + "," + p.d2 + "," + p.d3 + "," + p.d4 + "," + p.d5 + "," + p.d6 + "," + p.d7 + "," + p.d8;
			px.@color = p.colorObj.name;
			px.@symbol = p.shape.xmlName;	
			px.@label = p.description;
			px.@sm = (p.isStandardModel) ? "1" : "0";
			trace("p2 " + px.toXMLString());*/
			trace("---------------------------------------");
			
			////////////////////////////////////
			// BIND TO UI
			////////////////////////////////////
			allBtns = [a_btn, b_btn, c_btn, d_btn, e_btn, f_btn, g_btn, h_btn];
			idxDButton = new Dictionary();
			idxDButton[a_btn] = Dimension.D1;
			idxDButton[b_btn] = Dimension.D2;
			idxDButton[c_btn] = Dimension.D3;
			idxDButton[d_btn] = Dimension.D4;
			idxDButton[e_btn] = Dimension.D5;
			idxDButton[f_btn] = Dimension.D6;
			idxDButton[g_btn] = Dimension.D7;
			idxDButton[h_btn] = Dimension.D8;
			 
			/*Dimension.D1.ui = a_btn;
			Dimension.D2.ui = b_btn;
			Dimension.D3.ui = c_btn;
			Dimension.D4.ui = d_btn;
			Dimension.D5.ui = e_btn;
			Dimension.D6.ui = f_btn;
			Dimension.D7.ui = g_btn;
			Dimension.D8.ui = h_btn;
		
			a_btn.h_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			a_btn.v_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			b_btn.h_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			b_btn.v_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			c_btn.h_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			c_btn.v_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			d_btn.h_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			d_btn.v_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			e_btn.h_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			e_btn.v_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			f_btn.h_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			f_btn.v_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			g_btn.h_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			g_btn.v_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			h_btn.h_btn.addEventListener(MouseEvent.CLICK, onH_Click);
			h_btn.v_btn.addEventListener(MouseEvent.CLICK, onV_Click);
			 */

			
			
			var cDef : Object = getDefinitionByName("cross");
			
			var crss : MovieClip = new cDef();
			center = crss;
			center.visible = false;
			
			vpX = (viewport.background_mc.width / 2) + 2; ///CENTER OFFSET
			vpY = (viewport.background_mc.height / 2);
			crss.x = vpX;
			crss.y = vpY;
			viewport.addChild(crss);
			/////////////////////////////////////////////////////////////
			// CREATE THE AXISES PARTICLES 
			/////////////////////////////////////////////////////////////
			i = 0;
			n = modl.curPointSystem.axises.length;
			viewport.graphics.lineStyle(1, 0xCCCCCC, .5);
			var p1 : EightDimensionParticle;
			var p2 : EightDimensionParticle;
			var pary : Array;
			/////////// /////////////////////
			var lbl2Def : Object = getDefinitionByName("NodeLabel");
			trace("lbl2Def" + lbl2Def);
			for(;i < n;++i) {
				trace("creating axis i " + i);
				pary = modl.curPointSystem.axises[i] as Array;
				////////////// p1 ////////////////////
				p1 = pary[0] as EightDimensionParticle;
				pntUI = new Sprite();
				lbl = new lbl2Def();
				lbl.scaleX = lbl.scalY = 1.1;
				lbl.gotoAndStop(int(p1.name));
				//setAxisLabel(lbl, modl.coords.coordLabels[i]);
				lbl.name = "lbl";
				pntUI.addChild(lbl);
				p1.ui = pntUI;
				viewport.addChild(pntUI);
				////////////// p2 ////////////////////			
				p2 = pary[1] as EightDimensionParticle;
				pntUI = new Sprite();
				lbl = new lbl2Def();
				lbl.scaleX = lbl.scalY = 1.1;
				lbl.gotoAndStop(int(p1.name));
				//setAxisLabel(lbl, modl.coords.coordLabels[i]);
				lbl.name = "lbl";
				pntUI.visible = false;
				pntUI.addChild(lbl);
				p2.ui = pntUI;
				viewport.addChild(pntUI);
			}
			/////////////////////////////////////////////////////////////
			// CREATE PARTICLE GRAPHICS
			/////////////////////////////////////////////////////////////
			i = 0;
			n = modl.curPointSystem.particles.length;
			var p : EightDimensionParticle;
			var cp : EightDimensionParticle;
			var pntUI : Sprite;
			
			var lbl : MovieClip;
			//var rshapes : Array = [RenderShape.M_SQUARE,RenderShape.M_DIAMOND, RenderShape.M_CIRCLE,  RenderShape.M_TRIANGLE_DOWN,  RenderShape.M_TRIANGLE_UP];
			////////////////////////////////////////////
			//for(;i < n;++i) {
			var half : Sprite;
			var centr : Sprite;
			var pointsAr : Array = new Array();
			while(n--) {
				trace(" adding Child at " + n);
				i = n;
				p = modl.curPointSystem.particles[i];
				//pointsAr.push(p);
				cp = modl.curPointSystem.camera_points[i];
				pntUI = new Sprite();
			
				lbl = new lblDef();
				
				//setAxisLabel(lbl, p.name);

				lbl.name = "lbl";
				//				lbl.index_txt.text = p.name;
				lbl.scaleX = lbl.scaleY = 2;
				lbl.x = -lbl.width / 2 - 10;
				lbl.y = -lbl.height / 2 - 10;
				lbl.visible = false;
				pntUI.addChild(lbl);
				p.labelMC = lbl;
				//trace("placing particle " + p.name);
				var cnv : Sprite = new Sprite();
				cnv.name = "shape";
				var hover : Sprite = new Sprite();
				hover.name = "hover";
				
				pntUI.mouseChildren = false;
				pntUI.buttonMode = true;
				pntUI.addChild(cnv);
				pntUI.addChild(hover);
				//	pntUI.cacheAsBitmap = true;
				pntUI.addEventListener(MouseEvent.ROLL_OVER, rollOverChild);
				pntUI.addEventListener(MouseEvent.ROLL_OUT, rollOutChild);
				pntUI.addEventListener(MouseEvent.CLICK, onClickParticle);
				pntUI.name = "point" + i;
				p.modl = modl; 
				cp.modl = modl;
			
		//		pntUI.x = center.x + (p.curCoords.d1 * modl.zoom);
		//		pntUI.y = center.y + (p.curCoords.d2 * modl.zoom);
				pointsAr.push(p);
				//viewport.addChild(pntUI);
				cp.ui = pntUI; 
				p.ui = pntUI;
				p.redrawUI();
				if(i == 120) {
					half = pntUI;
				}
				if(i == 240) {
					centr = pntUI;
				}
			}
			
			pointsAr.sortOn("id", Array.NUMERIC | Array.DESCENDING);
			while(pointsAr.length > 0) {
				p = pointsAr.pop();
				trace("p.size" + p.nsize);
				viewport.addChild(p.ui);
			}
			var fadeUpSprite : Sprite = new Sprite();
			viewport.addChild(fadeUpSprite);
			var fadeDownSprite : Sprite = new Sprite();
			viewport.addChild(fadeDownSprite);
			pointFadeUpTny = new Tny(fadeUpSprite);
			pointFadeDownTny = new Tny(fadeDownSprite); 
			
			if(centr && half) {
				viewport.swapChildren(centr, half);
			}
			createdParticles = true;
			
			/////////////// SET TO DEFAULTS ///////////////////
			//coords_cmb.selectedIndex = 1;
			/////////////////Afeter we've already set everything from e8
			//points_cmb.selectedIndex  =points_cmb.length;
			
			//onModelPointsChanged();
			modl.curPointSystem = modl.pointSystems[0];
		
			
			////////////////UPDATE VIEW  //////////////////////
			onCoordComboBoxChanged();
			pointsChanged();
			onModelRotationsChanged();
			onSelectionChanged();
			///////////////ACTIVATE UI /////////////////////////////
			viewport.addEventListener(MouseEvent.MOUSE_DOWN, onViewportPress);
			stage.addEventListener(MouseEvent.MOUSE_UP, onViewportRelease);
			//onEnterFrameHandler();
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			updateView();
			loading_mc.visible = false;

			trace("FINISH LOADING ================================================");
		}

		public function onViewportPress(mouseEvent : MouseEvent) : void {
			clickX = viewport.mouseX;
			clickY = viewport.mouseY;
			Vsnap = modl.camera.V.clone();
			Hsnap = modl.camera.H.clone();
			/*			var dx : Number = (viewport.mouseX - center.x);
			var dy : Number = (viewport.mouseY - center.y);
			var radians : Number = Math.atan2(dy, dx)	;	*/
			aRot.rotation = getHVRotationFromClick();
			trace("onViewportPress ON PRESS aRot:" + aRot.rotation);
	
			updateView();
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}

		public function getHVRotation() : Number {
			var dx : Number = (viewport.mouseX - center.x);
			var dy : Number = (viewport.mouseY - center.y) * -1;
			var radians : Number = Math.atan2(dy, dx)	;	
			var res : Number = radians * 180 / Math.PI;
			return res;
		}

		public function getHVRotationFromClick() : Number {
			var dx : Number = (clickX - center.x);
			var dy : Number = (clickY - center.y) * -1;
			var radians : Number = Math.atan2(dy, dx)	;	
			var res : Number = radians * 180 / Math.PI;
			return res;
		}

		public function onViewportRelease(mouseEvent : MouseEvent) : void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			trace("onViewportRelease " + endRot.rotation);
			curRotation = endRot.rotation; 
		}

		private function onDeselectSecond(evt : MouseEvent = null) : void {
			trace("onDeslectSecond");
			if(modl.secondClicked != null) {
				modl.secondClicked.selectedState = EightDimensionParticle.NOT_SELECTED;
				modl.secondClicked = null;
				bottom_panel.selection2.visible = false;
				//deselect2Btn.visible = false;
			} 
			if(modl.result1 != null) {
				modl.result1.selectedState = EightDimensionParticle.NOT_SELECTED;
				modl.result1 = null;
				bottom_panel.selection3.visible = false;
			} 
			if(modl.result2 != null) {
				modl.result2.selectedState = EightDimensionParticle.NOT_SELECTED;
				modl.result2 = null;
				//bottom_panel.selection4.visible = false;
			} 
			updateView();
		}

		private function onDeselectAllClick(evt : MouseEvent = null) : void {
			trace("onDeselectAllClick");
			var i : int = 0;
			var n : int;
			if(modl.firstClicked != null) {
				modl.firstClicked.selectedState = EightDimensionParticle.NOT_SELECTED;
				i = 0;
				n = modl.firstClicked.outboundParticleLinks.length;
				for (;i < n;++i) {
					(modl.firstClicked.outboundParticleLinks[i] as EightDimensionParticle).selectedState = EightDimensionParticle.NOT_SELECTED;
				}
				modl.firstClicked = null;
				bottom_panel.selection1.visible = false;
			}
			if(modl.secondClicked != null) {
				modl.secondClicked.selectedState = EightDimensionParticle.NOT_SELECTED;
				modl.secondClicked = null;
				bottom_panel.selection2.visible = false;
			//	deselect2Btn.visible = false;
			} 
			if(modl.result1 != null) {
				modl.result1.selectedState = EightDimensionParticle.NOT_SELECTED;
				modl.result1 = null;
				bottom_panel.selection3.visible = false;
			} 
			if(modl.result2 != null) {
				modl.result2.selectedState = EightDimensionParticle.NOT_SELECTED;
				modl.result2 = null;
			//	bottom_panel.selection4.visible = false;
			} 
			if(Ap) {
				Ap.selectedState = EightDimensionParticle.NOT_SELECTED;
			}
			if(Bp) {
				Bp.selectedState = EightDimensionParticle.NOT_SELECTED;
			}
			if(Cp) {
				Cp.selectedState = EightDimensionParticle.NOT_SELECTED;
			}
			if(Dp) {
				Dp.selectedState = EightDimensionParticle.NOT_SELECTED;
			}
			i = 0;
			n = modl.curPointSystem.particles.length;
			var ary : Array = modl.curPointSystem.particles;
			
			var p : EightDimensionParticle;
			//trace("clicked Particle");
			for (;i < n;++i) {
				
				p = ary[i];
				p.selectedState = EightDimensionParticle.NOT_SELECTED;
				p.firstClickSelectedState = EightDimensionParticle.NOT_SELECTED;
			}
			updateView();
		}

		public function onClickParticle(mouseEvent : MouseEvent) : void {
			
			trace("onClickParticle " + mouseEvent.target.name);
			var s : Sprite = Sprite(mouseEvent.target);
			var i : int = 0;
			var n : int = modl.curPointSystem.particles.length;
			var ary : Array = modl.curPointSystem.particles;
			
			var p : EightDimensionParticle;
			//trace("clicked Particle");
			for (;i < n;++i) {
				//	trace(i + " " + ary[i].ui.name + "?=   " + s.name);
				if(ary[i].ui == s) {
					//	trace("found Particle");
					p = ary[i];
					break;
				}
			}
			if(p != null) {
				
				if(modl.firstClicked == null || p.selectedState == EightDimensionParticle.NOT_SELECTED) {
					trace("new first click --------------");
					if(modl.firstClicked != null) {
						modl.firstClicked.selectedState = EightDimensionParticle.NOT_SELECTED;
						i = 0;
						n = modl.firstClicked.outboundParticleLinks.length;
						for (;i < n;++i) {
							(modl.firstClicked.outboundParticleLinks[i] as EightDimensionParticle).selectedState = EightDimensionParticle.NOT_SELECTED;
						}
					}
					if(modl.secondClicked != null) {
						modl.secondClicked.selectedState = EightDimensionParticle.NOT_SELECTED;
						modl.secondClicked = null;
						bottom_panel.selection2.visible = false;			
					}
					if(modl.result1 != null) {
						modl.result1.selectedState = EightDimensionParticle.NOT_SELECTED;
						modl.result1 = null;
						bottom_panel.selection3.visible = false;
					}
					if(modl.result2 != null) {
						modl.result2.selectedState = EightDimensionParticle.NOT_SELECTED;
						modl.result2 = null;
					//	bottom_panel.selection4.visible = false;
					}
					modl.firstClicked = p;
					updateDetails(bottom_panel.selection1, p);
					modl.firstClicked.selectedState = EightDimensionParticle.SELECTED_FIRST;
					bottom_panel.selection1.visible = true;
				
					var p2 : EightDimensionParticle;
					var tmp1 : EightDimensionParticle;
					var tmp2 : EightDimensionParticle;
					var key : String;
					var res : Array;
					var revres : Array;
					var revres2 : Array;
					i = 0;
					n = p.outboundParticleLinks.length;
					
					///  now that we have the first particle selected, what is the 2nd particle we can click on?
					// iterate through the firstParticle.outgoing particles
					//
					for (;i < n;++i) {
						
						p2 = (p.outboundParticleLinks[i] as EightDimensionParticle);
						if(p != p2) {
							
						
							key = modl.firstClicked.id + "," + p2.id;
							var itnvis : Boolean = false; 
							trace("looking for " + key + " in interactions");
							res = modl.curPointSystem.interactions[key] as Array;
							revres = modl.curPointSystem.reverseinteractions[key] as Array;
							
							/*revres2 = modl.curPointSystem.reverseinteractions2[key] as Array;
							var res1vis : Boolean = revres[0].ui.visible;//modl.curPointSystem.particles[revres[0]];
							var res2vis : Boolean = revres2[0].ui.visible;
							if(revres != null && revres2 != null ) {
							if(modl.firstClicked.id == revres2[1] && res2vis || !res1vis) {
							revres = revres2;
							}
							//	res = revres;
							}*/

							if(res != null) {
								//////// found interactions between firstClick and outgoing particle, mark and move on.
								trace("found " + res.length + " interactions for " + key + " " + res);
								if(res.length == 1) {
									//single result particle interactions
									tmp2 = (res[0] as EightDimensionParticle);
									itnvis = tmp2.ui.visible;  // not all particles are viewable in all modes
								}else if(res.length == 2) {
									//two result particle interactions
									tmp1 = (res[0] as EightDimensionParticle);
									tmp2 = (res[1] as EightDimensionParticle);
									itnvis = tmp1.ui.visible && tmp2.ui.visible; // not all particles are viewable in all modes 
								}
								if(p2.ui.visible && itnvis) {
									p2.selectedState = EightDimensionParticle.SELECTED_SECOND_POSSIBLE;
									p2.firstClickSelectedState = EightDimensionParticle.SELECTED_SECOND_POSSIBLE;
								}
							} else {
								trace("found no primary iteractions for pair");
							//TODO notify no interactions found
							}
						
							if(revres != null) {
								//////// found interactions between firstClick and outgoing particle, mark and move on.
								trace("found " + revres.length + " interactions for " + key + " " + revres);
								if(revres.length == 2) {
									//single result particle interactions
									tmp2 = (revres[0] as EightDimensionParticle);
									itnvis = tmp2.ui.visible;  // not all particles are viewable in all modes
								}else if(revres.length == 3) {
									//two result particle interactions
									tmp1 = (revres[0] as EightDimensionParticle);
									tmp2 = (revres[1] as EightDimensionParticle);
									itnvis = tmp1.ui.visible && tmp2.ui.visible; // not all particles are viewable in all modes 
								}
								if(p2.ui.visible && itnvis) {
									if(true) {
										p2.selectedState = EightDimensionParticle.SELECTED_SECOND_POSSIBLE;
										p2.firstClickSelectedState = EightDimensionParticle.SELECTED_SECOND_POSSIBLE;
									} else {
										///////// Debugging ///////////
										p2.selectedState = EightDimensionParticle.POSSIBLE_RESULT;
										p2.firstClickSelectedState = EightDimensionParticle.POSSIBLE_RESULT;
									}
								}	
							} else {
								trace("found no reverse iteractions for pair");
							//TODO notify no interactions found
							}
						}
					}
				} else {
					/////////////////////////////////////////////
					// has first click already , Process Second Click
					/////////////////////////////////////////////
					if(modl.secondClicked == null || p.selectedState == EightDimensionParticle.SELECTED_SECOND_POSSIBLE || p.selectedState == EightDimensionParticle.POSSIBLE_RESULT) {
						///////////// CLEAR RESULTS /////////////
						if(modl.secondClicked != null) {
							modl.secondClicked.selectedState = modl.secondClicked.firstClickSelectedState;//EightDimensionParticle.SELECTED_SECOND_POSSIBLE;	
						}
						if(modl.result1 != null) {
							modl.result1.selectedState = modl.result1.firstClickSelectedState;//= EightDimensionParticle.NOT_SELECTED;
							modl.result1 = null;
						}
						if(modl.result2 != null) {
							modl.result2.selectedState = modl.result2.firstClickSelectedState;//= EightDimensionParticle.NOT_SELECTED;
							modl.result2 = null;
						}
						///////////// CLEAR RESULTS /////////////
						//p.selectedState = EightDimensionParticle.SELECTED_FIRST;
						//if(modl.firstClicked.name =="241"){
						modl.secondClicked = p;
						//}
						updateDetails(bottom_panel.selection2, p);
						if(modl.secondClicked.firstClickSelectedState == EightDimensionParticle.SELECTED_SECOND_POSSIBLE) {
							modl.secondClicked.selectedState = EightDimensionParticle.SELECTED_SECOND;							
						} else {
							modl.secondClicked.selectedState = EightDimensionParticle.SELECTED_SECOND;
						}
						//modl.secondClicked.selectedState = EightDimensionParticle.SELECTED_SECOND;
						bottom_panel.selection2.visible = true;
						//deselect2Btn.visible = true;
						
						
						
						//////////// FIND OUR INTERACTION ////////////////////////////////////
						key = modl.firstClicked.id + "," + modl.secondClicked.id;
						trace("looking for " + key + " in interactions");
						res = modl.curPointSystem.interactions[key] as Array;
						
						/// This is our C+A, or C+B
						revres = modl.curPointSystem.reverseinteractions[key] as Array;
						revres2 = modl.curPointSystem.reverseinteractions2[key] as Array;
						modl.curInteractionKey = null;
						
						/*trace(" res " + res);
						trace(" revres " + revres[0].id);
						trace(" revres2 " + revres2[0].id);
						if(revres){
						revres[0].selectedState = EightDimensionParticle.SELECTED_SECOND;
						trace("OPTIONrevres " + modl.secondClicked.id + " " + revres[1]);
						}
						if(revres2){
						revres2[0].selectedState = EightDimensionParticle.SELECTED_SECOND;
						trace("OPTIONrevres2 " + modl.secondClicked.id + " " + revres2[1]);
						}*/
						/// when there is more than one interaction choose the one where 
						// favor the second clicked as the result over the source
						if(revres != null && revres2 != null ) {
							var res1vis : Boolean = revres[0].ui.visible;//modl.curPointSystem.particles[revres[0]];
							var res2vis : Boolean = revres2[0].ui.visible;
							
							if(modl.firstClicked.id == revres2[1] && res2vis || !res1vis) {
								revres = revres2;
							}
							//	res = revres;
						}
						if(res != null) {
							modl.curInteractionKey = key;
							trace("found " + res.length + " interactions for " + key + " " + res);
							if(res.length == 1) {
								//single result particle interactions
								//	if(modl.firstClicked.name == "241") {
								//		modl.result1 = modl.secondClicked;
								//	} else {
								modl.result1 = res[0] as EightDimensionParticle; 
								//	}

								
								updateDetails(bottom_panel.selection3, modl.result1);
								bottom_panel.selection3.visible = true;
							//	bottom_panel.selection4.visible = false;
							}else if(res.length == 2) {
								//two result particle interactions
								modl.result1 = res[0] as EightDimensionParticle;
								modl.result2 = res[1] as EightDimensionParticle;
															
								updateDetails(bottom_panel.selection3, modl.result1);
								updateDetails(bottom_panel.selection4, modl.result2);
								bottom_panel.selection3.visible = true;
							//	bottom_panel.selection4.visible = true;
							}
						} else {
							trace("found no iteractions for pair");
							//TODO notify no interactions found
						}
						if(revres != null) {
							trace("found " + revres.length + " reverse interactions for " + key + " = " + revres);
							modl.curInteractionKey = key;
							if(revres.length == 2) {
								//	if(modl.firstClicked.name == "241") {
								//		modl.result1 = modl.secondClicked;
								//	} else {
								modl.result1 = revres[0] as EightDimensionParticle; 
								//	}
								
								//single result particle interactions
								updateDetails(bottom_panel.selection3, modl.result1);
								bottom_panel.selection3.visible = true;
							//	bottom_panel.selection4.visible = false;
							}else if(revres.length == 3) {
								//two result particle interactions
								modl.result1 = revres[0] as EightDimensionParticle;
								//if(modl.firstClicked.name == "241") {
								//	modl.result1 = modl.secondClicked;
								//} else {
								modl.result2 = revres[1] as EightDimensionParticle;
								
								if( modl.result1.ui.visible) {
									updateDetails(bottom_panel.selection3, modl.result1);
									bottom_panel.selection3.visible = true;
								} else {
									bottom_panel.selection3.visible = false;	
								}
								if( modl.result2.ui.visible) {
									updateDetails(bottom_panel.selection4, modl.result2);
									bottom_panel.result2.visible = true;
								} else {
									bottom_panel.result2.visible = false;	
								}
								
								updateDetails(bottom_panel.selection4, modl.result2);
								bottom_panel.selection3.visible = true;
							//	bottom_panel.selection4.visible = true;
							}
						} else {
							trace("found no reverse iteractions for pair");
							//TODO notify no interactions found
						}
					} else {
						//TODO find p3, and p4
						//updateDetails(selection3, p);
						//updateDetails(selection4, p);
						bottom_panel.selection3.visible = true;
					//	bottom_panel.selection4.visible = true;
					}
				}
				updateView();
			}
		}

		public function rollOverChild(mouseEvent : MouseEvent) : void {
			bottom_panel.hoverInfo.visible = true;
			//////// show label//////////////
			Sprite(mouseEvent.target).getChildAt(0).visible = true;
			//////// highlight //////////////////
			var s : Sprite = Sprite(mouseEvent.target);
			var i : int = 0;
			var n : int = modl.curPointSystem.particles.length;
			var ary : Array = modl.curPointSystem.particles;
			
			var p : EightDimensionParticle;
			//	trace("rollOver Particle");
			for (;i < n;++i) {
				//	trace(i + " " + ary[i].ui.name + "  ?=" + s.name);
				if(ary[i].ui == s) {
					
					p = ary[i];
					//		trace("found Particle  isFocused " + p.isFocused + " isSelected " + p.selectedState );
					p.isFocused = true;
					p.updateUI();
					break;
				}
			}
			if(p != null) {
				updateDetails(bottom_panel.hoverInfo, p);
			}

			mouseOverOFilters = mouseEvent.target.getChildAt(1).filters;
	//		mouseEvent.target.getChildAt(1).filters = [new GlowFilter()];
		//	mouseEvent.target.scaleX *=2;
		//	mouseEvent.target.scaleY *=2;
		}

		public function updateDetails(mc : MovieClip, p : EightDimensionParticle) {
			mc.name_txt.text = p.label;
			mc.shape_mc.graphics.clear();
			mc.dim_lbl.gotoAndStop(int(p.name));
			if(modl.isGUTmode) {
				p.gutshape.draw(mc.shape_mc, p.gutcolor);
			} else {
				p.nshape.draw(mc.shape_mc, p.ncolor);
			}
			mc.shape_mc.filters = p.ui.filters;
				
			//	trace("UPDATE DETAILS " + p.curCoords.d1Lbl + " " + p.curCoords.d2Lbl);			
			updateDetailCoordinate(p.curCoords.d1Lbl, mc.a_txt, mc.ac_mc);
			updateDetailCoordinate(p.curCoords.d2Lbl, mc.b_txt, mc.bc_mc);
			updateDetailCoordinate(p.curCoords.d3Lbl, mc.c_txt, mc.cc_mc);
			updateDetailCoordinate(p.curCoords.d4Lbl, mc.d_txt, mc.dc_mc);
			updateDetailCoordinate(p.curCoords.d5Lbl, mc.e_txt, mc.ec_mc);
			updateDetailCoordinate(p.curCoords.d6Lbl, mc.f_txt, mc.fc_mc);
			updateDetailCoordinate(p.curCoords.d7Lbl, mc.g_txt, mc.gc_mc);
			updateDetailCoordinate(p.curCoords.d8Lbl, mc.h_txt, mc.hc_mc);
		
		
		/*
			mc.c_txt.text = p.curCoords.d3Lbl;
			mc.d_txt.text = p.curCoords.d4Lbl;
			mc.e_txt.text = p.curCoords.d5Lbl;
			mc.f_txt.text = p.curCoords.d6Lbl;
			mc.g_txt.text = p.curCoords.d7Lbl;
			mc.h_txt.text = p.curCoords.d8Lbl;*/
		}

		private function updateDetailCoordinate( lbl : String , txt : TextField ,  mc : MovieClip) : void {
			if(lbl.indexOf("/") == -1 && lbl.indexOf("SQRT") == -1 ) {
				txt.text = lbl;
				txt.visible = true;
				mc.visible = false;
			} else {
				txt.visible = false;
				mc.gotoAndStop("L" + lbl);
				mc.visible = true;
			}
		}

		public function rollOutChild(mouseEvent : MouseEvent) : void {
			bottom_panel.hoverInfo.visible = false;
			//////// show label//////////////
			Sprite(mouseEvent.target).getChildAt(0).visible = false;
			//////// highlight //////////////////
			var s : Sprite = Sprite(mouseEvent.target);
			var i : int = 0;
			var n : int = modl.curPointSystem.particles.length;
			var ary : Array = modl.curPointSystem.particles;
			
			var p : EightDimensionParticle;
			//trace("rollOut Particle");
			for (;i < n;++i) {
				//				trace(i + " " + ary[i].ui.name + "  ?= " + s.name);
				if(ary[i].ui == s) {
				
					p = ary[i];
					//		trace("found Particle  isFocused " + p.isFocused + " isSelected " + p.selectedState );
					p.isFocused = false;
					p.updateUI();
					break;
				}
			}
			if(p != null) {
			}
			//	mouseEvent.target.getChildAt(1).filters = mouseOverOFilters;
		//				mouseEvent.target.scaleX /=2;
		//	mouseEvent.target.scaleY /=2;
		}

		function applyForces() : void {
		}

		function applyConstraints() : void {
		}

		function renderParticles() : void {
		}

		function getUnitV(dim : Dimension) : EightDimensionVector {
			var res : EightDimensionVector;
			switch(dim) {
			}
			return res;
		}

		function onEnterFrameHandler(evt : Event = null) : void {
			//trace("RENDER FRAME -------------------------------------------------------");
			var V : EightDimensionVector = modl.camera.V;
			var H : EightDimensionVector = modl.camera.H;
			if(modl.userInteractionMode == Model.MODE_ROTATEINTOAXIS) {
				/////////////////////////////////////////////
				//  ROTATE INTO AXIS
				/////////////////////////////////////////////
				var mul : Number = .005;
				ax = (viewport.mouseX - clickX) * mul;
				ay = (viewport.mouseY - clickY) * mul * -1;
				//trace("----------------------------------");
				//trace("ax " + ax + " " + ay);			
				if(ax == 0 && ay == 0) {
					return;
				}
				//ax = (viewport.mouseX - viewport.width/2)/viewport.width * Math.PI;
				//	ay = (viewport.mouseY - viewport.height/2)/viewport.height * Math.PI;
				
				//horizontal
				var a : EightDimensionVector;
				//vertical
				var A : EightDimensionVector;
				//				
				var g : EightDimensionVector;
				var G : EightDimensionVector;
				var g1 : EightDimensionVector;
				var G1 : EightDimensionVector;
				//the results from the calculation
				g = new EightDimensionVector();
				g.name = 'g';
				G = new EightDimensionVector();
				G.name = 'G';
					

				var aDotV : Number;
				var aDotH : Number;
				var ADotV : Number;
				var ADotH : Number;
				var dist : Number;
				var Htouched : Boolean;
				var VdotH : Number;
		
				/////////////////////////////////////////////////
				//	trace("rendering with " + modl.curXaxis + " " + modl.curYaxis);
				a = modl.curXaxis.uv;
				A = modl.curYaxis.uv;
				//	trace("a " + a + " A " + A + " \r");
		
			
				//	trace("a" + a);
				//	trace("V" + V);
				//	trace("H" + H);
				//	trace("aDotV");
				aDotV = a.getDotProductFromVector(V, false);
				//	trace("aDotH");
				aDotH = a.getDotProductFromVector(H, false);
				//	trace("ADotV");
				ADotV = A.getDotProductFromVector(V, false);
				//	trace("ADotV");
				ADotH = A.getDotProductFromVector(H, false);
				
				//trace("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
				//trace("aDotV " + aDotV + "  aDotH " + aDotH);
				//	trace("ADotV " + ADotV + "  ADotH " + ADotH);
			
				//g = a - (a . V)* V - (a . H)* H; 

				if(true) {
					//------------------horizontal--------------
					g.d1 = a.d1 - (aDotV * V.d1) - (aDotH * H.d1);	
					g.d2 = a.d2 - (aDotV * V.d2) - (aDotH * H.d2);
					g.d3 = a.d3 - (aDotV * V.d3) - (aDotH * H.d3);
					g.d4 = a.d4 - (aDotV * V.d4) - (aDotH * H.d4);
					g.d5 = a.d5 - (aDotV * V.d5) - (aDotH * H.d5);
					g.d6 = a.d6 - (aDotV * V.d6) - (aDotH * H.d6);
					g.d7 = a.d7 - (aDotV * V.d7) - (aDotH * H.d7);
					g.d8 = a.d8 - (aDotV * V.d8) - (aDotH * H.d8);
			//	trace("g " + g);
				}
				if(true) {

					//------------------||verticle||--------------
					G.d1 = A.d1 - (ADotV * V.d1) - (ADotH * H.d1);	
					G.d2 = A.d2 - (ADotV * V.d2) - (ADotH * H.d2);
					G.d3 = A.d3 - (ADotV * V.d3) - (ADotH * H.d3);
					G.d4 = A.d4 - (ADotV * V.d4) - (ADotH * H.d4);
					G.d5 = A.d5 - (ADotV * V.d5) - (ADotH * H.d5);
					G.d6 = A.d6 - (ADotV * V.d6) - (ADotH * H.d6);
					G.d7 = A.d7 - (ADotV * V.d7) - (ADotH * H.d7);
					G.d8 = A.d8 - (ADotV * V.d8) - (ADotH * H.d8);
				}
				//			trace("G " + G);
				g1 = g.getNormalized();
				G1 = G.getNormalized();
				/*dist = g1.length() -1;
				if(dist > .001){
				throw new Error("g1 not equal to one " + dist);
				}
				
				dist = G1.length() -1;
				if(dist > .001){
				throw new Error("G1 not equal to one " + dist);
				}*/
				//		trace("g1 " + g1);
				//		trace("G1 " + G1);
				if(g1 != null && ax != 0) {
					//			trace("g' " + g1);
					var cosAx : Number = Math.cos(ax);
					var sinAx : Number = Math.sin(ax);
					H.d1 = (H.d1 * cosAx) + (g1.d1 * sinAx);
					H.d2 = (H.d2 * cosAx) + (g1.d2 * sinAx);
					H.d3 = (H.d3 * cosAx) + (g1.d3 * sinAx);
					H.d4 = (H.d4 * cosAx) + (g1.d4 * sinAx);
					H.d5 = (H.d5 * cosAx) + (g1.d5 * sinAx);
					H.d6 = (H.d6 * cosAx) + (g1.d6 * sinAx);
					H.d7 = (H.d7 * cosAx) + (g1.d7 * sinAx);
					H.d8 = (H.d8 * cosAx) + (g1.d8 * sinAx);

					H = H.getNormalized();
					/*dist = H.length() -1;
					if(dist > .001){
					throw new Error("H not equal to one " + dist);
					}*/
					Htouched = true;
			
					//	trace("H normalized " + H);
					modl.camera.H = H;
				}
			
				if(( G1 != null && ay != 0) || Htouched  ) {
					if(G1 == null) {
						G1 = new EightDimensionVector(1, 1, 1, 1, 1, 1, 1, 1);
					}
					/////////// KEEP V ORTHAGONAL TO H ////////////////
					VdotH = V.getDotProductFromVector(H, false);
					var V11 : EightDimensionVector = new EightDimensionVector();
					//	trace("VdotH " + VdotH);
					//	trace("V11 " + V11);
					//	trace("V " + V);
					//	trace("H " + H);
					V11.d1 = V.d1 - VdotH * H.d1;
					V11.d2 = V.d2 - VdotH * H.d2;
					V11.d3 = V.d3 - VdotH * H.d3;
					V11.d4 = V.d4 - VdotH * H.d4;
					V11.d5 = V.d5 - VdotH * H.d5;
					V11.d6 = V.d6 - VdotH * H.d6;
					V11.d7 = V.d7 - VdotH * H.d7;
					V11.d8 = V.d8 - VdotH * H.d8;
					V = V11.getNormalized();
					
					///////////////ROTATE ////////
					//	trace("G' " + G1);
					var cosAy : Number = Math.cos(ay);
					var sinAy : Number = Math.sin(ay);
				
					V.d1 = (V.d1 * cosAy) + (G1.d1 * sinAy);
					V.d2 = (V.d2 * cosAy) + (G1.d2 * sinAy);
					V.d3 = (V.d3 * cosAy) + (G1.d3 * sinAy);
					V.d4 = (V.d4 * cosAy) + (G1.d4 * sinAy);
					V.d5 = (V.d5 * cosAy) + (G1.d5 * sinAy);
					V.d6 = (V.d6 * cosAy) + (G1.d6 * sinAy);
					V.d7 = (V.d7 * cosAy) + (G1.d7 * sinAy);
					V.d8 = (V.d8 * cosAy) + (G1.d8 * sinAy);

					V = V.getNormalized();
					//dist = V.length() -1;
					//	if(dist > .001){
					//		throw new Error("V not equal to one " + dist);
					//	}
					
					
					//		trace("V normalized " + V);
					modl.camera.V = V;
				}
				clickX = viewport.mouseX;
				clickY = viewport.mouseY;

				//	trace("H' " + H);
			} else {
				/////////////////////////////////////////////
				//  ROTATE HV MODE MODE_ROTATEHV
				/////////////////////////////////////////////
				var drad : Number;
				var V1 : EightDimensionVector = new EightDimensionVector();
				var H1 : EightDimensionVector = new EightDimensionVector();
			   
				ax = (  clickX - viewport.mouseX); 
				ay = ( clickY - viewport.mouseY );
				//trace("----------------------------------");
				trace("ax " + ax + " " + ay + " " + getHVRotation());			
				if(ax == 0 && ay == 0) {
					return;
				}
			  
				//var dx : Number = (viewport.mouseX -clickX)- center.x;
				//var dy : Number = (viewport.mouseY -clickY)- center.y ;
	
				//var radians : Number = Math.atan2(dy, dx);
				
				///////////////////////////////////
				//CURRENT ROTATION  where mouse is at
				bRot.rotation = getHVRotation();
				//radians * 180 / Math.PI;
				endRot.rotation = (bRot.rotation - aRot.rotation);// + curRotation;
				trace("ROTATE from bRot  " + bRot.rotation + " to aRot " + aRot.rotation + " == " + endRot.rotation);
				drad = endRot.rotation * Math.PI / 180;
				trace("drad " + drad);
				trace("Hsnap.d1" + Hsnap.d1);
			
			
				//drad = radians ;
				//drad = lastRadians + .08;

				var cosT : Number = Math.cos(drad);
				var sinT : Number = Math.sin(drad);
				H1.d1 = (Hsnap.d1 * cosT) - (Vsnap.d1 * sinT);
				V1.d1 = (Hsnap.d1 * sinT) + (Vsnap.d1 * cosT);
				H1.d2 = (Hsnap.d2 * cosT) - (Vsnap.d2 * sinT);
				V1.d2 = (Hsnap.d2 * sinT) + (Vsnap.d2 * cosT);				
				H1.d3 = (Hsnap.d3 * cosT) - (Vsnap.d3 * sinT);
				V1.d3 = (Hsnap.d3 * sinT) + (Vsnap.d3 * cosT);
				H1.d4 = (Hsnap.d4 * cosT) - (Vsnap.d4 * sinT);
				V1.d4 = (Hsnap.d4 * sinT) + (Vsnap.d4 * cosT);
				H1.d5 = (Hsnap.d5 * cosT) - (Vsnap.d5 * sinT);
				V1.d5 = (Hsnap.d5 * sinT) + (Vsnap.d5 * cosT);
				H1.d6 = (Hsnap.d6 * cosT) - (Vsnap.d6 * sinT);
				V1.d6 = (Hsnap.d6 * sinT) + (Vsnap.d6 * cosT);
				H1.d7 = (Hsnap.d7 * cosT) - (Vsnap.d7 * sinT);
				V1.d7 = (Hsnap.d7 * sinT) + (Vsnap.d7 * cosT);
				H1.d8 = (Hsnap.d8 * cosT) - (Vsnap.d8 * sinT);
				V1.d8 = (Hsnap.d8 * sinT) + (Vsnap.d8 * cosT);
				trace("H1.d1" + H1.d1);
				
				modl.camera.H = H1;
				modl.camera.V = V1;
				H = H1;
				V = V1;
				lastRadians = drad;
			}
			/////////////////// ADJUST USER ROTATIONS ////////////////////////
			//	if(false){
			if(modl.curUserRotation == null || rotationsHaveChanged ) {
				var userRotation : Rotations = new Rotations();
				rotationsHaveChanged = false;
				///////// PASS BY VALUE NOT REFERENCE!!!!////////////
				userRotation.H.d1 = H.d1;
				userRotation.V.d1 = V.d1;
				
				userRotation.H.d2 = H.d2;
				userRotation.V.d2 = V.d2;
	
				userRotation.H.d3 = H.d3;
				userRotation.V.d3 = V.d3;
	
				userRotation.H.d4 = H.d4;
				userRotation.V.d4 = V.d4;
	
				userRotation.H.d5 = H.d5;
				userRotation.V.d5 = V.d5;
				
				userRotation.H.d6 = H.d6;
				userRotation.V.d6 = V.d6;
				
				userRotation.H.d7 = H.d7;
				userRotation.V.d7 = V.d7;
				
				userRotation.H.d8 = H.d8;
				userRotation.V.d8 = V.d8;
				//userRotation.hv = [[H.d1, V.d1],[H.d2, V.d2],[H.d3, V.d3],[H.d4, V.d4],[H.d5, V.d5],[H.d6, V.d6],[H.d7, V.d7],[H.d8, V.d8]];
				userRotation.name = "last rotation";//"My " + modl.coords.curRotation.name + " *";
				userRotation.selectedHAxisIdx = modl.curXaxis.d - 1;
				userRotation.selectedVAxisIdx = modl.curYaxis.d - 1;
				userRotation.isUser = true;
				userRotation.isDirty = true;
				userRotation.isSaved = false;
				modl.curUserRotation = userRotation;
				modl.coords.curRotation = userRotation; 
				onModelRotationsChanged();
			} else {
				///////// PASS BY VALUE NOT REFERENCE!!!!////////////
				modl.curUserRotation.H.d1 = H.d1;
				modl.curUserRotation.V.d1 = V.d1;
				
				modl.curUserRotation.H.d2 = H.d2;
				modl.curUserRotation.V.d2 = V.d2;
	
				modl.curUserRotation.H.d3 = H.d3;
				modl.curUserRotation.V.d3 = V.d3;
	
				modl.curUserRotation.H.d4 = H.d4;
				modl.curUserRotation.V.d4 = V.d4;
	
				modl.curUserRotation.H.d5 = H.d5;
				modl.curUserRotation.V.d5 = V.d5;
				
				modl.curUserRotation.H.d6 = H.d6;
				modl.curUserRotation.V.d6 = V.d6;
				
				modl.curUserRotation.H.d7 = H.d7;
				modl.curUserRotation.V.d7 = V.d7;
				
				modl.curUserRotation.H.d8 = H.d8;
				modl.curUserRotation.V.d8 = V.d8;
				modl.curUserRotation.selectedHAxisIdx = modl.curXaxis.d - 1;
				modl.curUserRotation.selectedVAxisIdx = modl.curYaxis.d - 1;
				//modl.curUserRotation.name = "My " + modl.coords.curRotation.name + " *";
				//modl.curUserRotation.hv = [[H.d1, V.d1],[H.d2, V.d2],[H.d3, V.d3],[H.d4, V.d4],[H.d5, V.d5],[H.d6, V.d6],[H.d7, V.d7],[H.d8, V.d8]];
				modl.coords.curRotation = modl.curUserRotation;
				modl.curUserRotation.isDirty = true;
				modl.curUserRotation.isSaved = false;
			}
			//		}

			
			
			
			updateView();
		}

		function updateView(evt : Event = null) : void {
			if(!createdParticles) {
				trace("Ignoring UpdateView, haven't created particles yet");
				return;
			}
			try {
				//////////////////////////////////////////
				//		trace("CAM____________________________");
				//		trace("Camera H " + modl.camera.H);
				//		trace("Camera V " + modl.camera.V);
				//		trace("CAM____________________________");
				//	////////////////////////////////////////////////////////
				if(modl.userInteractionMode == Model.MODE_ROTATEINTOAXIS) {
					rotateHVMode_Btn.gotoAndStop(1);
					rotateIntoAxisMode_Btn.visible = false;
				} else {
					//MODE_ROTATEHV
					rotateHVMode_Btn.gotoAndStop(2);
					rotateIntoAxisMode_Btn.visible = true;
				}
				//trace("modl.camera.H. " + modl.camera.H);
				a_btn.hval_txt.text = NumberUtil.roundToPrecision(modl.camera.H.d1, 2);
				a_btn.vval_txt.text = NumberUtil.roundToPrecision(modl.camera.V.d1, 2);
				b_btn.hval_txt.text = NumberUtil.roundToPrecision(modl.camera.H.d2, 2);
				b_btn.vval_txt.text = NumberUtil.roundToPrecision(modl.camera.V.d2, 2);
				c_btn.hval_txt.text = NumberUtil.roundToPrecision(modl.camera.H.d3, 2);
				c_btn.vval_txt.text = NumberUtil.roundToPrecision(modl.camera.V.d3, 2);
				d_btn.hval_txt.text = NumberUtil.roundToPrecision(modl.camera.H.d4, 2);
				d_btn.vval_txt.text = NumberUtil.roundToPrecision(modl.camera.V.d4, 2);
				e_btn.hval_txt.text = NumberUtil.roundToPrecision(modl.camera.H.d5, 2);
				e_btn.vval_txt.text = NumberUtil.roundToPrecision(modl.camera.V.d5, 2);
				f_btn.hval_txt.text = NumberUtil.roundToPrecision(modl.camera.H.d6, 2);
				f_btn.vval_txt.text = NumberUtil.roundToPrecision(modl.camera.V.d6, 2);
				g_btn.hval_txt.text = NumberUtil.roundToPrecision(modl.camera.H.d7, 2);
				g_btn.vval_txt.text = NumberUtil.roundToPrecision(modl.camera.V.d7, 2);
				h_btn.hval_txt.text = NumberUtil.roundToPrecision(modl.camera.H.d8, 2);
				h_btn.vval_txt.text = NumberUtil.roundToPrecision(modl.camera.V.d8, 2);
	
				////////////////////////////
				//	trace("ax " + ax + " " + ay);
				i = 0;
				n = modl.curPointSystem.particles.length;
				var clip : Sprite;
					
				var lastPart : EightDimensionParticle;
				if(center != null && bottom_panel.showOrigin_cb != null) {
					center.visible = bottom_panel.showOrigin_cb.selected;
				}
				//trace("rendering " + n + " particles");
	
				///////////////////////////////////////////////////////////
				//   RENDER PARTICLES
				///////////////////////////////////////////////////////////
				var x1 : Number;
				var y1 : Number;
				var isE8 : Boolean ;
				var isE6 : Boolean;
				var isGeorgi_Glashow : Boolean ;
				var isPati_Salam : Boolean ;
				var isStandardModel : Boolean ;
				var isGUT : Boolean ;	
				for(;i < n;++i) {
					pobj = modl.curPointSystem.particles[i];
					isE8 = curPointFilter.isE8 && pobj.isE8 ;
					isE6 = curPointFilter.isE6 && pobj.isE6;
					isGeorgi_Glashow = curPointFilter.isGeorgi_Glashow && pobj.isGeorgi_Glashow;
					isPati_Salam = curPointFilter.isPati_Salam && pobj.isPati_Salam;
					//	trace(" isPati_Salam "+ curPointFilter.isPati_Salam + " " + pobj.isPati_Salam);
					isStandardModel = curPointFilter.isStandardModel && pobj.isStandardModel;
					//trace(" isStandardModel "+ curPointFilter.isStandardModel + " " + pobj.isStandardModel);
					//isGUT = pobj.isGUT && modl.isGUTmode;
					 
					//spobj = modl.curPointSystem.camera_points[i]; 
					clip = pobj.ui; 
					//spobj.ui = clip;
					//spobj.pmdl = pobj;
					//trace("rendering particle  " + pobj.name + "  " + isGUT);

					
					x1 = pobj.curCoords.getDotProductFromVector(modl.camera.H, false);
					y1 = pobj.curCoords.getDotProductFromVector(modl.camera.V, false) * -1;
					//spobj.setX(x1);
					//* modl.zoom);
					//spobj.setY(y1);
					// * modl.zoom);
					//	trace("x1 " + x1 + "  " + spobj.getX() +" " + ( x1== spobj.getX()) +" y1 " + y1 + "  " + spobj.getY()  + " " +  ( y1== spobj.getY()) + " " + (( spobj.getY()!= spobj.getX())));
				
					//if (spobj.getZ() <= -modl.camera.focalLength) {
					//		clip.visible = false;
					//	}else {
					pobj.updateUI();
			
					if(bottom_panel.showVertices_cb != null ) {
						clip.visible = bottom_panel.showVertices_cb.selected;
					}
		
					//	clip.alpha = (transparentVertices_cb.selected) ? .5 : 1;
					//scale = 3.75;
					//Number(zoom_txt.text);//(ab / (D + spobj.getZ()));

					if(clip != null) {
						clip.x = vpX + (x1 * scale);
						//(spobj.getX() * scale);
						clip.y = vpY + (y1 * scale);
						/*
						if(standardPoints ) {
						trace("rendering standard poitns " + pobj.isStandardModel);
						clip.visible = pobj.isStandardModel;
						}else {
						clip.visible = true;
						}*/
						//trace("isE8 " + isE8 + " isStandardModel " + isStandardModel + " " + curPointFilter.isStandardModel);
						//						if(  (!isGUT && (isE8 || isStandardModel  )) || (isGUT &&(isE6 || isGeorgi_Glashow || isPati_Salam )) ) {
						if(  isE8 || isStandardModel || isGUT || isE6 || isGeorgi_Glashow || isPati_Salam ) {
							//FADING UP
							//trace("showing " + pobj.label + " " + pointFadeUpTny.target.alpha);
							if(clip.alpha <= pointFadeUpTny.target.alpha) {
								clip.alpha = pointFadeUpTny.target.alpha;
							}
						//clip.visible = true;
						} else {
							//FADING DOWN
							//	trace("hiding " + pobj.label + " " + pointFadeDownTny.target.alpha);
							if(clip.alpha >= pointFadeDownTny.target.alpha) {
								clip.alpha = pointFadeDownTny.target.alpha;
							}
						}
						if(clip.alpha == 0 ) {
							clip.visible = false;
						} else {
							clip.visible = true;
						}
					}
				//(spobj.getY() * scale);
				//	trace(pobj.name + " " + clip.x + " " + clip.y);
				//clip.scaleX = clip.scaleY = scale;
				//	trace("setting " + clip.scaleX + " " + scale);
			//	spobj.distFromCamera = scale;
				}

				//trace("modl0 " + modl.scene_points);
				//	var cad:MovieClip = viewport.getChildAt(int(-pobj.d3)) as MovieClip;
				//	modl.camera_points.sortOn("d3", Array.NUMERIC);
				//	modl.curPointSystem.camera_points.sortOn("distFromCamera", Array.NUMERIC | Array.DESCENDING);
				//modl.camera_points.reverse();
				//trace("modl1 " + modl.scene_points);
				viewport.graphics.clear();
				//		viewport.graphics.lineStyle(2, 0xFF0000);
				//viewport.graphics.moveTo(center.x, center.y);	
				//	viewport.graphics.lineTo(viewport.mouseX,viewport.mouseY );
				/////////////////////////
				//			
				i = 0;
				n = modl.curPointSystem.axises.length;
				var p1 : EightDimensionParticle;
				var p2 : EightDimensionParticle;
				var p1v : EightDimensionVector;
				var p2v : EightDimensionVector;
				var pary : Array;
				var x2 : Number;
				var y2 : Number;
				///////////////////////////////////////////////////////////
				//  VISUALIZE THE AXISES 
				///////////////////////////////////////////////////////////
				for(;i < n;++i) {
					//	trace("visualing axis i " + i);
					pary = modl.curPointSystem.axises[i] as Array;
					p1 = pary[0] as EightDimensionParticle;
					p2 = pary[1] as EightDimensionParticle;
					if(bottom_panel.showAxis_cb.selected) { 
						var sf : Number = 2;
						x1 = vpX + p1.curCoords.getDotProductFromVector(modl.camera.H, false) * scale * sf;
						y1 = vpY + p1.curCoords.getDotProductFromVector(modl.camera.V, false) * scale * sf * -1;
						x2 = vpX + p2.curCoords.getDotProductFromVector(modl.camera.H, false) * scale * sf;
						y2 = vpY + p2.curCoords.getDotProductFromVector(modl.camera.V, false) * scale * sf * -1;
						if(i == (modl.curXaxis.d - 1) ) {
							viewport.graphics.lineStyle(1, 0x000000, .8);
						}else if(i == (modl.curYaxis.d - 1)) {
							viewport.graphics.lineStyle(1, 0x333333, .8);
						} else {
							viewport.graphics.lineStyle(1, 0xCCCCCC, .5);
						}
					
						viewport.graphics.moveTo(x1, y1);	
						viewport.graphics.lineTo(x2, y2);
						if(p1.ui != null) {
							p1.ui.visible = true;
							p2.ui.visible = false;				
							p1.ui.x = x1;
							p1.ui.y = y1;
							p2.ui.x = x2;
							p2.ui.y = y2;
						}
					} else {
						if(p1.ui != null) {
							p1.ui.visible = false;
							p2.ui.visible = false;
						}
					}
				}
				//}
				///////////////////////////////////////////////////////////
				//   VISUALIZE TRIALITY
				///////////////////////////////////////////////////////////
				if( bottom_panel.showTriality_cb.selected) { 
					try {
						i = 0;
						//TODO delete following line
						n = modl.curPointSystem.trialities.length;
						var p1ui : Sprite;
						var p2ui : Sprite;
						var p3ui : Sprite;
						//	trace(" alpha is " + standardPointTny.target.alpha);
						//if(standardPointTny.target.alpha > 0 ) {
						if(isE8 ) {
							//|| isE6 || isGeorgi_Glashow || isPati_Salam || isStandardModel) {
							//FADING UP
							//trace("showing " + pobj.label + " " + pointFadeUpTny.target.alpha);
							viewport.graphics.lineStyle(.5, 0x666666, pointFadeUpTny.target.alpha * .5);
				
				//		if(clip.alpha <= pointFadeUpTny.target.alpha) {
					//		clip.alpha = pointFadeUpTny.target.alpha;
					//	}
						//clip.visible = true;
						} else {
							//FADING DOWN
							viewport.graphics.lineStyle(.5, 0x666666, pointFadeDownTny.target.alpha * .5);
						//trace("hiding " + pobj.label + " " + pointFadeDownTny.target.alpha);
					//	if(clip.alpha >= pointFadeDownTny.target.alpha) {
						//	clip.alpha = pointFadeDownTny.target.alpha;
						//}
						//clip.visible = false;
						}
						for(;i < n;++i) {
				
							pary = modl.curPointSystem.trialities[i];
							p1ui = (pary[0] as EightDimensionParticle).ui;
							p2ui = (pary[1] as EightDimensionParticle).ui;
							p3ui = (pary[2] as EightDimensionParticle).ui;
							//	trace("p1ui " + p1ui.visible + " " + p1ui.alpha + "p2ui " + p2ui.visible + " " + p2ui.alpha + "p3ui " + p3ui.visible + " " + p3ui.alpha);

							viewport.graphics.moveTo(p1ui.x, p1ui.y);
							
							//if(p2ui.visible && p1ui.visible) {					
							viewport.graphics.lineTo(p2ui.x, p2ui.y);
							//} else {
							//	viewport.graphics.moveTo(p2ui.x, p2ui.y);
							//}
							//if(p3ui.visible && p2ui.visible ) {
							viewport.graphics.lineTo(p3ui.x, p3ui.y);
							//} else {
							//	viewport.graphics.moveTo(p3ui.x, p3ui.y);
							//}
							//if(p1ui.visible && p3ui.visible) {
							viewport.graphics.lineTo(p1ui.x, p1ui.y);
							//}
						}
				//}
					}catch(er : Error) {
						trace("error  in showing trialities");
					}
				}	
				if(true) {
					///////////////////////////////////////////////////////////
					//   VISUALIZE THE RAYS
					///////////////////////////////////////////////////////////
					//modl.reverseLookup = true;
					var newKey : String;
					var rres : Array; 
					try {
						var aKey : String = modl.curInteractionKey;
						var aRes : Array = modl.curPointSystem.interactions[aKey] as Array;
					    
						var bKey : String = modl.curInteractionKey.split(",")[0] + "," + String(modl.result1.id);
						var bRes : Array = modl.curPointSystem.interactions[bKey] as Array;
						
						//	var b2Key : String = String(modl.result1.id) + "," + modl.curInteractionKey.split(",")[0];
						//	var b2Res : Array = modl.curPointSystem.interactions[b2Key] as Array;

						
						var cKey : String = modl.curInteractionKey.split(",")[1] + "," + String(modl.result1.id);
						var cRes : Array = modl.curPointSystem.interactions[cKey] as Array;
						
						//	var c2Key : String = String(modl.result1.id) + "," + modl.curInteractionKey.split(",")[1];
						//	var c2Res : Array = modl.curPointSystem.interactions[c2Key] as Array;	

						trace("selected " + modl.firstClicked.id + " " + modl.secondClicked.id);
						trace("KEYSEARCH " + newKey + " r1 " + modl.result1.id);
						trace(" aKey " + aKey + " " + aRes);
						trace(" bKey " + bKey + " " + bRes);
						//trace(" b2Key " + b2Key + " " + b2Res);
						trace(" cKey " + cKey + " " + cRes);
						//	trace(" c2Key " + c2Key + " " + c2Res);

						if(aRes) {
							trace("using a primary key");
							//////// using a primary interaction
							newKey = aKey;
							rres = aRes;
						} else {
							//////// using a reverse interaction
							trace("using a reverse key");

							if(bRes && cRes) {
								trace("using a reverse key, both in contest");
								if (bRes[0] == modl.secondClicked  ) {
									newKey = bKey;
									rres = bRes;
								} else if (cRes[0] == modl.secondClicked ) {
									newKey = cKey;
									rres = cRes;
								} else {
									trace("NO KEY FOUND1");
								}
							}else if (bRes) {
								trace("using a reverse key1");
								newKey = bKey;
								rres = bRes;
							}else if (cRes) {
								trace("using a reverse key2");
								newKey = cKey;
								rres = cRes;
							} else {
								trace("NO KEY FOUND2");
							}
						}
						
						
						///////////// once we've decided on a key /////////////////
						var AB : Array = newKey.split(",");
						if(Ap) {
							Ap.selectedState = Ap.firstClickSelectedState;
						}
						if(Bp) {
							Bp.selectedState = Bp.firstClickSelectedState;
						}
						if(Cp) {
							Cp.selectedState = Cp.firstClickSelectedState;
						}
						if(Dp) {
							Dp.selectedState = Dp.firstClickSelectedState;
						}
						Ap = modl.curPointSystem.particles[AB[0] - 1];
						Bp = modl.curPointSystem.particles[AB[1] - 1];
						
						Cp = rres[0];
						Dp = rres[1];
						
						if((Ap && Ap.name == "241") || (Bp && Bp.name == "241")) {
							/////////////////// PHOTON HACK /////////////////
							trace("Photon Hack Mode");
							trace(" BEFORE: ", Ap, Bp, Cp, Dp);
							var idOfPhoton : Number;
							var photoP : EightDimensionParticle;
							var a241StartKey : String;
							if(Ap.name == "241") {
								idOfPhoton = Ap.id;
								photoP = Ap;
								a241StartKey = "241," + Bp.id;
							}
							if(Bp.name == "241") {
								idOfPhoton = Bp.id;
								photoP = Bp;
								a241StartKey = "241," + Ap.id;
							}
							aKey = a241StartKey;
							aRes = modl.curPointSystem.interactions[aKey] as Array;
							bRes = modl.curPointSystem.reverseinteractions[aKey] as Array;
							cRes = modl.curPointSystem.reverseinteractions2[aKey] as Array;
						
							trace("3res ", aRes, bRes, cRes);
					
							/*	var aKeyP:Boolean = aKey.indexOf(String(idOfPhoton)) == -1;
							var bKeyP:Boolean = bKey.indexOf(String(idOfPhoton)) == -1;
							var cKeyP:Boolean = cKey.indexOf(String(idOfPhoton)) == -1;
							if(aKeyP){
							trace("using aKey");
							newKey = aKey;	
							}else if(bKeyP){
							trace("using bKey");
							newKey = bKey;	
							}else if(cKeyP){
							trace("using cKey");
							newKey = cKey;	
							}*/
							AB = newKey.split(",");
							Ap = aRes[0];//modl.curPointSystem.particles[AB[0] - 1];
							Bp = bRes[0];// modl.curPointSystem.particles[AB[1] - 1];
							//Cp = rres[0];
							//Dp = rres[1];
							trace(" AFTER: ", Ap, Bp, Cp, Dp);
							////////////////////////// PHOTON HACK MODE /////////////////
							/*if(Ap.name == "241"){
							trace("retargetting A with C" + + Cp.id);
							Ap = Cp;	
							}
							if(Bp.name == "241"){
							trace("retargetting B with C " + Cp.id);
							Bp = Cp;	
							}*/
							trace(Ap.id + " " + Bp.id + " " + Cp.id);
							bottom_panel.selection3.visible = false;
						//	bottom_panel.selection4.visible = false;
							if(Ap != modl.firstClicked) {
								trace("A is not first clicked");
								//	Ap.selectedState = EightDimensionParticle.NOT_SELECTED;
								Ap.selectedState = EightDimensionParticle.SELECTED_SECOND;
							
								if(Bp != modl.firstClicked && Bp != modl.secondClicked && Bp.ui.visible) {
									trace("result1.SET1");		
									modl.result1 = Bp;
									updateDetails(bottom_panel.selection3, modl.result1);
									bottom_panel.selection3.visible = true;
								}
							//	Ap.updateUI();
							}
							if(Bp != modl.firstClicked) {
								trace("B is not first clicked");
								//	Bp.selectedState = EightDimensionParticle.NOT_SELECTED;
								Bp.selectedState = EightDimensionParticle.SELECTED_SECOND;
								
								if(Ap != modl.firstClicked && Ap != modl.secondClicked && Ap.ui.visible) {
									trace("result1.SET2");
									modl.result1 = Ap;
									updateDetails(bottom_panel.selection3, modl.result1);
									bottom_panel.selection3.visible = true;
								}
								
							//	Bp.updateUI();
							}
							modl.firstClicked.selectedState = EightDimensionParticle.SELECTED_FIRST;
							modl.firstClicked.updateUI();
							//if selection1 == result/C particle  + selection2 == photon
							// photon = green
							// else selection1 !=result + selection2 == photon
							// photon == yellow
							if(photoP == modl.secondClicked) {
								if(Bp.ui.visible && Cp.ui.visible) {
									// || modl.firstClicked.id == cRes[1]) { 
									//	photoP.selectedState = EightDimensionParticle.NOT_SELECTED;
									photoP.selectedState = EightDimensionParticle.RESULT;
									if(Bp != modl.firstClicked && Bp != modl.secondClicked && Bp.ui.visible) {
										trace("result1.SET3");		
										modl.result1 = Bp;
										updateDetails(bottom_panel.selection3, modl.result1);
										bottom_panel.selection3.visible = true; 	
									}
									
								//	photoP.updateUI();
								}
							}
							viewport.graphics.lineStyle(10, EightDimensionParticle.SELECTED_SECOND_COLOR, .5);
							if(Bp.ui.visible) {
								viewport.graphics.moveTo(photoP.ui.x, photoP.ui.y);	
								viewport.graphics.lineTo(Bp.ui.x, Bp.ui.y);
							}
							if(Ap.ui.visible) {
								viewport.graphics.moveTo(photoP.ui.x, photoP.ui.y);	
								viewport.graphics.lineTo(Ap.ui.x, Ap.ui.y);
							}
						} else {
							////////////////////////// NORMAL MODE /////////////////
							modl.firstClicked.selectedState = EightDimensionParticle.SELECTED_FIRST;
							modl.firstClicked.updateUI();
							if(modl.secondClicked != null && modl.result1 != null && modl.result1.ui.visible) {
								viewport.graphics.lineStyle(10, EightDimensionParticle.SELECTED_SECOND_COLOR, .5);
								viewport.graphics.moveTo(Ap.ui.x, Ap.ui.y);	
								viewport.graphics.lineTo(Bp.ui.x, Bp.ui.y);
								if(Ap != modl.firstClicked) {
									//Ap.selectedState = EightDimensionParticle.NOT_SELECTED;
									Ap.selectedState = EightDimensionParticle.SELECTED_SECOND;
									Ap.updateUI();
								}
								if(Bp != modl.firstClicked) {
									//Bp.selectedState = EightDimensionParticle.NOT_SELECTED;
									Bp.selectedState = EightDimensionParticle.SELECTED_SECOND;
									Bp.updateUI();
								}
							}
							if(modl.result1 != null && modl.result1.ui.visible) {
								viewport.graphics.lineStyle(10, EightDimensionParticle.RESULT_COLOR, .5);
					
								viewport.graphics.moveTo(center.x, center.y);		
								if(Cp && Cp.ui.visible) {
									viewport.graphics.lineTo(Cp.ui.x, Cp.ui.y);
									if(Cp != modl.firstClicked) {
										//Cp.selectedState = EightDimensionParticle.NOT_SELECTED;
										Cp.selectedState = EightDimensionParticle.RESULT;
										Cp.updateUI();
									}
								} 
								if(Dp && Dp.ui.visible) {
									viewport.graphics.moveTo(center.x, center.y);	
									viewport.graphics.lineTo(Dp.ui.x, Dp.ui.y);
									if(Dp != modl.firstClicked) {
										//Dp.selectedState = EightDimensionParticle.NOT_SELECTED;
										Dp.selectedState = EightDimensionParticle.RESULT;
										Dp.updateUI();
									}
								}
							}
						}
					}catch(er23 : Error) {
					}
				}
				if(false) {
					///////////////////////////////////////////////////////////
					//   VISUALIZE THE ROTATION
					///////////////////////////////////////////////////////////
					//	if(modl.secondClicked != null) {
					viewport.graphics.lineStyle(10, 0xFF0000, .5);
					viewport.graphics.moveTo(clickX, clickY);	
					viewport.graphics.lineTo(viewport.mouseX, viewport.mouseY);
					viewport.graphics.lineTo(center.x, center.y);
					viewport.graphics.lineStyle(10, 0x00FF00, .5);
						
				//}
				}
			}catch(er : Error) {
				trace("ERROR in UI.updateView  " + er.getStackTrace());
			}
		}

		function onH_Click(evt : MouseEvent) : void {
		
			var req : MovieClip = MovieClip(evt.target.parent.parent);
			trace("on H click " + req.name);
			if(idxDButton[req] == modl.curYaxis) {
				modl.curYaxis = modl.curXaxis;
			}
			modl.curXaxis = idxDButton[req];
	
			onSelectionChanged();
		}

		function onV_Click(evt : MouseEvent) : void {

			var req : MovieClip = MovieClip(evt.target.parent.parent);
			trace("on V click " + req.name);
			if(idxDButton[req] == modl.curXaxis) {
				modl.curXaxis = modl.curYaxis;
			}
			modl.curYaxis = idxDButton[req];

			onSelectionChanged();
		}

		function onHV_Click(evt : MouseEvent) : void {

			var req : MovieClip = MovieClip(evt.target.parent.parent);
			trace("on HV click " + req.name);
			modl.curXaxis = idxDButton[req];
			modl.curYaxis = idxDButton[req];
			trace("modl.curXaxis " + modl.curXaxis + " " + modl.curYaxis);
			onSelectionChanged();
		}

		function onSelectionChanged(evt : Event = null) : void {
			if(allBtns != null) {
				for (var i : int = 0;i < allBtns.length;i++) {
					var cb : MovieClip = MovieClip(allBtns[i]);
					var cd : Dimension = idxDButton[cb];
					if (cd != modl.curXaxis && cd != modl.curYaxis) {
						cb.indicator_mc.gotoAndStop("OFF");
					}else if (cd == modl.curXaxis && cd == modl.curYaxis) {
						cb.indicator_mc.gotoAndStop("HV");	
					} else if (cd == modl.curYaxis) {
						cb.indicator_mc.gotoAndStop("V");
				//	V_txt.text = cb._txt.text;
					} else if (cd == modl.curXaxis) {
						cb.indicator_mc.gotoAndStop("H");
				//	H_txt.text = cb._txt.text;
					}
				}
				if(modl.curUserRotation) {
					modl.curUserRotation.selectedHAxisIdx = modl.curXaxis.d - 1;
					modl.curUserRotation.selectedVAxisIdx = modl.curYaxis.d - 1;
				}
			}
			updateView();
		}
	}
}
