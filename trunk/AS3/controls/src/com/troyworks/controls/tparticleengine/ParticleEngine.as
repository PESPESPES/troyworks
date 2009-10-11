package com.troyworks.controls.tparticleengine { 
	import com.troyworks.data.graph.MicroCore;
	import flash.geom.Rectangle;
	import com.troyworks.hsmf.CogEventntntnt;
	import com.troyworks.hsmf.Signal;
	
	/**
	 * @author Troy Gardner
	 */
	public class ParticleEngine extends MicroCore {
			//////////// ORIGINAL //////////////
		public var ox:Number = 0;
		public var oy:Number = 0;
		public var oz:Number = 0;
		
		//////////// CURRENT //////////////
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
	
		//////////// LAST /////////////////////
		public var lx:Number = 0;
		public var ly:Number = 0;
		public var lz:Number = 0;
	
		///////////// VELOCITY X ///////////////
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var vz:Number = 0;
		
		public var bounds:Rectangle;
	//	public static var SIG_ASSETS_LOADED:Signal =Signal.getNext("ASSETS_LOADED");
	//	public static var EVT_ASSETS_LCogEventventvenCogEventgEventgEventgEvent(SIG_ASSETS_LOADED);
		
		
		public function ParticleEngine(id : Number, name : String, nType : String) {
			super(id, name, nType);
			bounds = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			initStateMachine();
		}
		public function addParticle(p:Particle):void{
			p.bounds = this.bounds;
			addNode(p);
		}
		/*..PSEUDOSTATE...............................................................*/
		public function s_initial(e:CogEvent) : void
		{
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			onFunctionEnter ("s_initial-", e, []);
			if(e.sig != SIG_TRACE){
				return s0_viewAssetsUnLoaded;
			}
		}
		public function onLoad() : void{
			trace("onLoad");
			if(hasInited== INIT_HAS_INITED){
			dispatchEvent(EVT_ASSETS_LOADED);
			}
		//		
		}	
	
	//////////////////////// LEVEL 0 STATES////////////////////////////
		/*.................................................................*/
		public function s0_viewAssetsUnLoaded(e: CogEvent) : Function
		{
			this.onFunctionEnter ("s0_viewAssetsUnLoaded-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_ASSETS_LOADED:{
					tran0_viewAssetsLoaded);
					return null;
				}
				case Q_INIT_SIG :
				{
					return null;
				}
			}
			return s_root;
		}
		/*.................................................................*/
		public function s0_viewAssetsLoaded(e: : CogEvent) : Function
		{
			this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					trtranviewAssetsUnLoaded);
					return null;
				}
				case Q_INIT_SIG :
				{
					trantraneatingView);
					return null;
				}
			}
			return s_root;
		}
		//////////////////////// LEVEL 1 STATES////////////////////////////
		/*.................................................................*/
		public function s1_viewNotCreated(e : CogEvent) : Function
		{
			this.onFunctionEnter ("s1_viewNotCreated-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
			}
			return s0_viewAssetsLoaded;
		}	
		/*................................................................
		 * 
		 */
		public function s1_creatingView (e : CogEvent) : Function

		 
		{
			this.onFunctionEnter ("s1_creatingView-", e, []);
					switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case Q_INIT_SIG :
				{
					tran(stranCreated);
					return null;
				}
			}
			return s0_viewAssetsLoaded;
		}
		/*.........................................................CogEvent..*/
		public function  s1_viewCreated(e : CogEvent) : Function
		{
			this.onFunctionEnter ("s1_viewCreated-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case SIG_INIT :
				{
					return null;
				}
			}
			return this.s0_viewAssetsLoaded;
		}
		/*......................................................CogEvent.....*/
		public function s1_destroyingView(e : CogEvent) : Function
		{
			this.onFunctionEnter ("s1_destroyingView-", e, []);
					switch (e.sig)
			{
				case SIG_ENTRY :
				{
					return null;
				}
				case SIG_EXIT :
				{
					return null;
				}
				case Q_INIT_SIG :
				{
					return null;
				}
			}
			return s0_viewAssetsLoaded;
		}
		
		
		/*..PSEUDOSTATE....................................CogEvent..............CogEvent.*/
		public function s_final(e : CogEvent) : void
		{
			this.onFunctionEnter ("s_final-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{ 
					return;
				}
			}
		}
		
	
	}
}