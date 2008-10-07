package com.troyworks.util {

	/**
	 * LocalConnectionBridge
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jul 22, 2008
	 * DESCRIPTION ::	
	 * Inspired by SWFBridgeAS3 and related chat at www.gskinner.com/blog
	 * 
	 * This is a semi-reliable LocalConnection Utility, that helps with 
	 * dangling and reconnecting clients. 
	 *
	 */
	import flash.display.MovieClip;	
	import flash.utils.clearTimeout;	

	import com.troyworks.data.id.UniqueIDGenerator;	

	import flash.events.TimerEvent;	
	import flash.utils.Timer;	
	import flash.net.LocalConnection;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.utils.setTimeout;	

	public class LocalConnectionBridge extends EventDispatcher {
		public static const EVT_GUEST_WAITING : String = "GUEST_WAITING";
		public static const EVT_GUEST_CONNECTED : String = "GUEST_CONNECTED";
		public static const EVT_GUEST_DISCONNECTED : String = "GUEST_DISCONNECTED";
		public static const EVT_HOST_CONNECTED : String = "HOST_CONNECTED";
		public static const EVT_HOST_DISCONNECTED : String = "HOST_DISCONNECTED";
		public static const EVT_HOST_AND_GUEST_ARE_CONNECTED : String = "HOST_AND_GUEST_ARE_CONNECTED";

		public static var curUID : String;
		private var myUID : String;

		private var baseID : String;
		private var myID : String;
		private var extID : String;
		private var lc : LocalConnection;
		private var _connected : Boolean = false;
		private var host : Boolean = true;
		private var clientObj : Object;
		public var hostInboundID : String;
		public var guestInboundID : String;
		private var isHost : Boolean = true;
		public var currentConnectionID : String;
		public var lastConnectionID : String;

		
		
		public static const NO_CONNECTIONS : Number = 0;
		public static const HOST_IS_CONNECTED : Number = 1;
		public static const GUEST_IS_CONNECTED : Number = 2;
		public static const HOST_AND_GUEST_ARE_CONNECTED : Number = 3;
		public var connectionsState : Number = NO_CONNECTIONS;

		private var heartBeat : Timer;
		private var hostBeat : Timer;
		public var inboundLC : LocalConnection;
		public var inboundLC_used : Boolean = false;

		public var realInboundLC : LocalConnection;
		public var realInboundLC_used : Boolean = false;

		public var outboundLC : LocalConnection;
		private var outboundLC_used : Boolean;

		private var timeoutId : uint;
		public var view : MovieClip;

		public function LocalConnectionBridge(p_id : String,p_clientObj : Object, beHost : Boolean = false) {
			super();

			clientObj = p_clientObj;			

			isHost = beHost;
			myUID = UniqueIDGenerator.getNext() + ((isHost) ? "_host" : "_guest");
			trace("UNIQUE ID " + myUID + " my Mode " + isHost);
			
			baseID = p_id.split(":").join("");				

			hostInboundID = baseID + "_host_TMP";
			guestInboundID = baseID + "_guest_TMP";
			trace("hostInboundID ID " + hostInboundID);
			trace("guestInboundID  " + guestInboundID);
			/////////////// ALLOW INBOUND MESSAGES /////////////////
			//for the tempID serverice
			inboundLC = new LocalConnection();
			inboundLC.allowDomain("*");
			inboundLC.client = this;
			//for the REAL use
			realInboundLC = new LocalConnection();
			realInboundLC.allowDomain("*");
			realInboundLC.client = this;
			realInboundLC.addEventListener(StatusEvent.STATUS, onNormalInboundStatus);
			trace("setting up REAL inbound connection on " + myUID);
			realInboundLC.connect(myUID);
			realInboundLC_used = true;
			
			/////////////// FOR OUTBOUND MESSAGES ////////////////
			outboundLC = new LocalConnection();
			
			if (isHost) {
				/////////// CONNECT TO Shared Memory as Host, polling for guests /////////////
				outboundLC.addEventListener(StatusEvent.STATUS, onHostIDNegotiationSendStatus);
				lookForGuestConnection(myUID);	
			}else {
				outboundLC.addEventListener(StatusEvent.STATUS, onGuestIDNegotiationSendStatus);
				
				/////////// CONNECT To Shared Memory AS GUEST and wait//////////
				currentConnectionID = generateChannelID(guestInboundID);
				
				//wait for callback
				inboundLC.addEventListener(StatusEvent.STATUS, onGuestIDNegotiationSendStatus);
				inboundLC.connect(generateChannelID(guestInboundID));
				trace("-------------------------------");
				trace("inboundLC now listening on " + generateChannelID(guestInboundID) + " for call from HOST");
				trace("-------------------------------");
				connectGUEST_to_HOST();
			}
		}

		public function setView(viewClip : MovieClip) : void {
			this.view = viewClip;
			trace("view1 " + view);
		}

		/* this generates a id based on the current time, currently 
		 * a domain and 1 of 20 slots in a minute for both host and guest
		 *  to try connecting to
		 */
		public function generateChannelID(id : String) : String {
			if(id.indexOf("_TMP") == -1 ){
				return id;
			}
			var res : String = null;
			var dat : Date = new Date();
			var steps : Number = 20;
			var connectionBin : Number = Math.round(dat.secondsUTC / 60 * 20);
			// + ((forHost) ? 0 : 2);
			if(connectionBin > steps) {
				connectionBin -= steps;
			} 
			
			res = id + "_" + connectionBin;
			
			return res; 
		}

		private function closeIN_LC() : void {
			if(inboundLC_used){
			inboundLC.close();
			inboundLC_used = false;
			}
		}

		private function closeOUT_LC() : void {
			if(outboundLC_used){
			outboundLC.close();
			outboundLC_used = false;
			}
		}

		//////////////////////////////// ID NEGOTIATION //////////////////////////////
		public function lookForGuestConnection(fromID : String) : void {
	
			var myChannel : String = generateChannelID(hostInboundID);
			
			//	trace("fromID " + fromID + " curUID " + curUID);
			if(curUID != null && fromID != curUID) {
				trace("ignoring request still in one progress");
				return;
			}
			trace("\rsending as Host to " + generateChannelID(guestInboundID) + " call me back on " + myChannel);
			try {
	
				if(lastConnectionID != myChannel) {
					if(inboundLC_used) {
						trace("host now  closing " + lastConnectionID);
						closeIN_LC();
					}
					///////////////				
					inboundLC.allowDomain("*");
					inboundLC.client = this;
					/////////////////
					inboundLC.connect(myChannel);
					trace("host now  listening to " + myChannel);
					lastConnectionID = myChannel;
					inboundLC_used = true;
				}
			} catch(e : ArgumentError) {
				trace("inboundLC_used ERROR1: " + e);
				try { 
					inboundLC.close(); 
					inboundLC_used = false;
				} catch (e : *) {
					//////probably not connected
					trace("  e2" + e.toString());
				}
			}
			
			
			connectHOST_to_GUEST();
			curUID = myChannel;
		}

		/* attempt for the guest to call out to the host since it's a single direction connection */
		private function connectGUEST_to_HOST() : void {
			try {
				outboundLC.send(generateChannelID(hostInboundID), "onNewGuestConnected", generateChannelID(guestInboundID), myUID);
			} catch(e : ArgumentError) {
				trace("connectGUEST_to_HOST ERROR: " + e);
			}
		}

		/* attempt for the host to call out to the guest since it's a single direction connection */
		private function connectHOST_to_GUEST() : void {
			trace(" ping guest>>>>" + generateChannelID(guestInboundID));
			try {
				outboundLC.send(generateChannelID(guestInboundID), "onHostConnected", generateChannelID(hostInboundID), myUID);
				outboundLC_used = true;
			} catch(e : ArgumentError) {
				trace("connectHOST_to_GUEST ERROR: " + e);
			}
		}

		private function onHostIDNegotiationSendStatus(event : StatusEvent) : void {
			switch (event.level) {
				case "status":
					trace("onHostIDNegotiationSendStatus.send() succeeded");
					//keep alive, wait for
					if(connectionsState == GUEST_IS_CONNECTED){
						onBothConnected(); 
					}
					break;
				case "error":
					trace("onHostIDNegotiationSendStatus.send() failed...no one there, try again");
					
					try { 
						//	inboundLC.close();
						//	inboundLC_used = false;
						curUID = null;
						timeoutId = setTimeout(lookForGuestConnection, 250, myUID); 
					} catch (e : *) {
						//////probably not connected
					//	trace("  e" + e.toString());
					}
					//outboundLC = null;
					break;
			}
		}	

		private function onGuestIDNegotiationSendStatus(event : StatusEvent) : void {
			switch (event.level) {
				case "status":
					trace("onGuestIDNegotiationSendStatus.send() succeeded");
					//keep alive, wait for
					break;
				case "error":
					trace("onGuestIDNegotiationSendStatus.send() failed...no one there, wait for host");
					dispatchEvent(new Event(EVT_GUEST_WAITING));
					trace("GUEST WAITING ");
	
					break;
			}
		}	

		private function onNormalOutboundSendStatus(event : StatusEvent) : void {
			switch (event.level) {
				case "status":
					trace("onOutboundSendStatus.send() succeeded");
					setTimeout(sendKeepAlive, 250);
					//keep alive, wait for
					break;
				case "error":
					trace("onOutboundSendStatus LocalConnection.send() failed...no one there, wait");
					//	dispatchEvent(new Event(EVT_GUEST_WAITING));
					//	trace("GUEST WAITING ");
					lostConnection();
					break;
			}
		}	

		private function onNormalInboundStatus(event : StatusEvent) : void {
			switch (event.level) {
				case "status":
					trace("onOutboundSendStatus.send() succeeded");
					//keep alive, wait for
					break;
				case "error":
					trace("onOutboundSendStatus LocalConnection.send() failed...no one there, wait");
					//	dispatchEvent(new Event(EVT_GUEST_WAITING));
					//	trace("GUEST WAITING ");
		
					lostConnection();
					break;
			}
		}	
		public function keepAlive(fromUID:String):void{
			//intentially keep 
			trace("Hey " + myUID + ", " + fromUID + " is still alive");
		}
		private function sendKeepAlive() : void {
			trace(" keepAlive>>>>" + generateChannelID(guestInboundID));
			try {
				outboundLC.send(((isHost)?guestInboundID : hostInboundID), "keepAlive", myUID);
				outboundLC_used = true;
			} catch(e : ArgumentError) {
				trace("connectHOST_to_GUEST ERROR: " + e);
				lostConnection();
			}
		}
		private function lostConnection():void{
					trace("LOST CONNECTION");
					if(isHost){
						dispatchEvent(new Event(EVT_HOST_DISCONNECTED));
						outboundLC.removeEventListener(StatusEvent.STATUS,onNormalOutboundSendStatus);
						outboundLC.addEventListener(StatusEvent.STATUS, onHostIDNegotiationSendStatus);
						connectionsState = NO_CONNECTIONS;
						lookForGuestConnection(myUID);
					}
		}
		
		//////////////////////////////////////////////////////////////
		/* called from the remote host ~182 line*/
		public function onHostConnected(channelID : String = null, fromGID : String = null) : void {

			trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
			trace(myUID + ".onHostConnected " + fromGID + " on " + channelID);
			trace(">>>>>>>>>>>>>>>>>>>> " + connectionsState + ">>>>>>>>>>>>>>>>>>>>>>>>>>>");
			
			dispatchEvent(new Event(EVT_HOST_CONNECTED));
		//	if(connectionsState == GUEST_IS_CONNECTED) {
				hostInboundID = fromGID;
				onBothConnected();				
		//	}else if(connectionsState == NO_CONNECTIONS) {
				//	view.y +=20;
		//		connectionsState = HOST_IS_CONNECTED;
				trace(" GUEST conntected to HOST waiting on HOST TO connect to GUEST");
				//connectGUEST_to_HOST();
		//	}
		}

		/* called from the remote guest  ~115 line */
		public function onNewGuestConnected(channelID : String = null, fromGID : String = null) : void {
			trace("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
			trace(myUID + ".onNewGuestConnected ( " + fromGID + ") on " + channelID);
			trace("<<<<<<<<<<<<<<< " + connectionsState + "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
			dispatchEvent(new Event(EVT_GUEST_CONNECTED));
			guestInboundID = fromGID;
		//	if(connectionsState == HOST_IS_CONNECTED) {
	
				
				if(connectionsState == NO_CONNECTIONS) {
						connectionsState = GUEST_IS_CONNECTED;
				}
			connectHOST_to_GUEST();
					//	clearTimeout(timeoutId);
				//connectHOST_to_GUEST();
			//}
		}

		private function onBothConnected() : void {
			trace(" NOW PAIRED ");
			connectionsState = HOST_AND_GUEST_ARE_CONNECTED;
			dispatchEvent(new Event(EVT_HOST_AND_GUEST_ARE_CONNECTED));	
			/////////// NOW HAVE BOTH IDS //////////////
			
			//close temp connection
			outboundLC.removeEventListener(StatusEvent.STATUS, onHostIDNegotiationSendStatus);
			inboundLC.removeEventListener(StatusEvent.STATUS, onGuestIDNegotiationSendStatus);			
			closeIN_LC();
			//establish real connection
			outboundLC.addEventListener(StatusEvent.STATUS,onNormalOutboundSendStatus);
			//start polling connection for connectivity
			setTimeout(sendKeepAlive, 250);
		}

		public function send(p_method : String,...p_args : Array) : void {
			if (!connectionsState == HOST_AND_GUEST_ARE_CONNECTED) { 
				throw new ArgumentError("Send failed because the object is not connected."); 
			}
			p_args.unshift(p_method);
			p_args.unshift("com_gskinner_utils_SWFBridge_receive");
			p_args.unshift((isHost)?guestInboundID : hostInboundID);
			try {
				outboundLC.send.apply(outboundLC, p_args);
			}catch(e : Error) {
				trace(e);
			}
		}
		public function com_gskinner_utils_SWFBridge_receive(p_method : String,...p_args : Array) : void {
			try {
				clientObj[p_method].apply(clientObj, p_args);
			} catch (e : *) {
				trace("LocalConnectionBridge ERROR:  " + e + " for " + p_method);
			}
		}
	}
}


