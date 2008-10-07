package com.troyworks.util.swfconnect {
	import flash.events.TimerEvent;	
	import flash.utils.Timer;	
	import flash.events.StatusEvent;	
	import flash.net.LocalConnection;
	
	/**
	 * ExpiringLocalConnection
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jul 23, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class ExpiringLocalConnection extends LocalConnection {
		private var baseID : String;
		public var inboundID:String;
		public var outboundID:String;
		private var isHost:Boolean = true;
		
		public var lc:LocalConnection;
		public var connectionState:String;
		
		public const UNBORN:String = "UNBORN";
		public const ALIVE_AND_LONELY:String = "ALIVE_AND_LONELY";
		public const PAIR_BONDED:String = "PAIR_BONDED";
		public const SUICIDAL:String = "SUICIDAL";
		public const EXTINCT:String = "EXTINCT";
		private var heartBeat : Timer;

		public function ExpiringLocalConnection() {
			super();
			connectionState = UNBORN;
			lc = new LocalConnection();
			lc.allowDomain("*");
			lc.client = this;
			lc.addEventListener(StatusEvent.STATUS, onStatusEvent);
			
			try {
				trace("trying to connect LC bridge '" + baseID + "_host'");
				var res = lc.connect(baseID + "_host");
				trace("Connection flag " + res);
				connectionState = ALIVE_AND_LONELY;
			} catch(e : ArgumentError) {
				isHost = false;
			} 
				
			inboundID = baseID + ((isHost) ? "_host" : "_guest");
			outboundID = baseID + ((isHost) ? "_guest" : "_host");
			if (!isHost) {
				try {
					/////////// CONNECT AS GUEST //////////
					lc.connect(inboundID);
					lc.send(outboundID, "onPairBonded");
				} catch(e : ArgumentError) {
					trace("LocalConnectionBridge ERROR: " + e);
				}
			}
			
		}
		public function onPairBonded():void{
			connectionState = PAIR_BONDED;
			//start keep alive/life support
			 heartBeat = new Timer(1000,0);
            heartBeat.addEventListener("timer", keepAlive);
            heartBeat.start();
		}
		public function keepAlive(event:TimerEvent):void {
            trace("timerHandler: " + event);
            lc.send(outboundID, "LCPing");
		}
		public function LCPing():void{
			trace("LCPing -everything good");
		}
		public function closeConnection():void{	
			 lc.close();
			 lc = null;
			 delete lc;
		}
	  
        
        private function onStatusEvent(event:StatusEvent):void {
            switch (event.level) {
                case "status":
                    trace("LocalConnection.send() succeeded");
                    //keep alive
                    break;
                case "error":
                    trace("LocalConnection.send() failed");
                    closeConnection();
                    break;
            }
        }
        
	}
}
