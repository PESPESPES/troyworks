package com.troyworks.particleengine { 
	import com.troyworks.datastructures.graph.MicroCore;
	import flash.geom.Rectangle;
	import com.troyworks.hsmf.AEvent;
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
		public static var SIG_ASSETS_LOADED:Signal =Signal.getNext("ASSETS_LOADED");
		public static var EVT_ASSETS_LOADED:AEvent = new AEvent(SIG_ASSETS_LOADED);
		
		
		public function ParticleEngine(id : Number, name : String, nType : String) {
			super(id, name, nType);
			bounds = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			init();
		}
		public function addParticle(p:Particle):void{
			p.bounds = this.bounds;
			addNode(p);
		}
		/*..PSEUDOSTATE...............................................................*/
		public function s_initial(e : AEvent) : void
		{
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			onFunctionEnter ("s_initial-", e, []);
			if(e.sig != Q_TRACE_SIG){
				Q_INIT(s0_viewAssetsUnLoaded);
			}
		}
		public function onLoad() : void{
			trace("onLoad");
			if(hasInited== INIT_HAS_INITED){
			Q_dispatch(EVT_ASSETS_LOADED);
			}
		//		
		}	
	
	//////////////////////// LEVEL 0 STATES////////////////////////////
		/*.................................................................*/
		public function s0_viewAssetsUnLoaded(e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_viewAssetsUnLoaded-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					return null;
				}
				case Q_EXIT_SIG :
				{
					return null;
				}
				case SIG_ASSETS_LOADED:{
					Q_TRAN(s0_viewAssetsLoaded);
					return null;
				}
				case Q_INIT_SIG :
				{
					return null;
				}
			}
			return s_top;
		}
		/*.................................................................*/
		public function s0_viewAssetsLoaded(e : AEvent) : Function
		{
			this.onFunctionEnter ("s0_viewAssetsLoaded-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					return null;
				}
				case Q_EXIT_SIG :
				{
					Q_TRAN(s0_viewAssetsUnLoaded);
					return null;
				}
				case Q_INIT_SIG :
				{
					Q_TRAN(s1_creatingView);
					return null;
				}
			}
			return s_top;
		}
		//////////////////////// LEVEL 1 STATES////////////////////////////
		/*.................................................................*/
		public function s1_viewNotCreated(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_viewNotCreated-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					return null;
				}
				case Q_EXIT_SIG :
				{
					return null;
				}
				case Q_INIT_SIG :
				{
					return null;
				}
			}
			return s0_viewAssetsLoaded;
		}	/*.................................................................*/
		public function s1_creatingView(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_creatingView-", e, []);
					switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					return null;
				}
				case Q_EXIT_SIG :
				{
					return null;
				}
				case Q_INIT_SIG :
				{
					Q_TRAN(s1_viewCreated);
					return null;
				}
			}
			return s0_viewAssetsLoaded;
		}
		/*.................................................................*/
		public function s1_viewCreated(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_creatingView-", e, []);
			switch (e)
			{
				case ENTRY_EVT :
				{
					return null;
				}
				case EXIT_EVT :
				{
					return null;
				}
				case INIT_EVT :
				{
					return null;
				}
			}
			return this.s0_viewAssetsLoaded;
		}
		/*.................................................................*/
		public function s1_destroyingView(e : AEvent) : Function
		{
			this.onFunctionEnter ("s1_destroyingView-", e, []);
					switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{
					return null;
				}
				case Q_EXIT_SIG :
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
		
		
		/*..PSEUDOSTATE...............................................................*/
		public function s_final(e : AEvent) : void
		{
			this.onFunctionEnter ("s_final-", e, []);
			switch (e.sig)
			{
				case Q_ENTRY_SIG :
				{ 
					return;
				}
			}
		}
		
	
	}
}