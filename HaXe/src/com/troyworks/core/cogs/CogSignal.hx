/**
 * Signals are used to denote/identify various events, during dispatchEvent routing
 * similar in spirit to flash.event.Event.type, except 
 * 
 * these are more granular (they belong in a heirarchy of events)
 * 
 * Here's a sample of how it's typically used
 * 
 * function state_ON(evt:CogEvent){
 * 	switch(evt.sig){
 *     case ENTRY:  /// actually CogSignal.ENTRY, but there are pointers during a statemachine's static initialization to shortcut 
 *      //do something like turn on the lightswitch
 *     break;
 *     case EXIT /// actually CogSignal.EXIT, but there are pointers during a statemachine's static initialization to shortcut 
 *     //do something like turn off the lightswitch
 *     break;
 *    etc...
 * 	}
 * }
 * 
 * * Architecturally they are meant to be typed enumeration, These are fully typed objects, which in switch statements use identity (===) instead of value (==)lookup (1/3 the execution time!)
 * 
 * http://blogs.adobe.com/kiwi/2006/05/as3_programming_101_for_cc_cod_1.html
 * http://weblogs.macromedia.com/sho/archives/2006/04/as3_technique_-.cfm
 * 
 * This strong typing approach of using CogSignals allows authortime compile checking
 * 
 * They are static/const immutable, and reuseable unlike Events which are generated and consumed (and exist over a finite duration)
 *
 * Quite often there is enough signals in a system to operate a statemachine behavior at a basic level, however it's easy to 
 * extend the signal set via the getNextSignal(). Seeing as there is 64 bits, there is a large range of possible signals, unlikely to be
 * exhausted for an entire application.
 * 
 * ID/value :
 * 
 * The Id flag is primarily used for security checks using the | bitflag/mask of the value since this can't be done
 * via identity + masks easily. Note that they use 0,1,2,4,8 etc.. up to user signals, but past user signals they increment by one
 * meaning they can't use that approach by default.
 * 
 * Secondly, the use of the id/value can be handy in short keys for indexing events. e.g. idx[String(CogSignal.EXIT.value)] = something
 * 
 * Note the UserSignals's ID shouldn't be considered serializeable, as the static intialization in which all user
 * signals get their ID might change on re-compilation. Serialization should do a map of class definition
 * instead (see flash.util.describeType);
 * 
INIT - when first polling a state if it has other default transitions when entering (e.g. if I told you to enter your house
ENTRY - the set of actions to perform when the state is being entered (and active
EXIT - the set of actions to perform when the state is being deactivated 
CALLBACK - if you setup a  single time callback with callbackIn();
PULSE - what you should put in if you start a regular pulse with startPulse(); you should generally use stopPulse() when you exit the state. Useful for things like breathing and walking etc.


These aren't used typically by you.

EMPTY used to help elicit the state heirarchy when cogs starts up
ACTIVATE TERMINATE - reserved for when the state machine is turned off an on (e.g to serialize all state vars)
TRACE - used to just show the active heirachy without doing anything.

GETOPS - was an advanced feature not used in the examples, where states contained a set of options of "where can I go here" to propogate to the UI,  e.g. if we had a car with driving and parked, getops in driving might get turn left, turn right, and stop.

 */
package com.troyworks.core.cogs;

import flash.events.Event;

enum CogSignal<T>{
	SigEmpty(?e:CogEvent);
	SigInit(?e:CogEvent);
	SigEntry(?e:CogEvent);
	SigExit(?e:CogEvent);
	SigTrace(?e:CogEvent);
	SigPulse(?e:CogEvent);
	SigCallback(?e:CogEvent);
	SigGetOpts(?e:CogEvent);
	SigChanged(?e:CogEvent);
	SigUser(en:T,id:Int,?e:CogEvent);
}
class CogSignals {
	static var signalUserIDz : Int = 1024;

	static public function cacheEvent(s:CogSignal<Dynamic>) : CogSignal<Dynamic> {
		var evt =  new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT,s);
		return 
			switch(s) {
				case SigUser(name,value,e) : SigUser( name , value , evt );
				default	: Type.createEnum(CogSignal,Std.string(s), [evt]);
			}
	}
	static public function getNextSignal<A>(val:A) : CogSignal<A> {
		return SigUser(val, signalUserIDz++);
	}
	static public function createProtectedEvent(s:CogSignal<Dynamic>) : CogEvent {
		return new CogEvent(CogEvent.EVTD_COG_PROTECTED_EVENT, s);
	}

	static public function createPrivateEvent(s:CogSignal<Dynamic>) : CogEvent {
		return new CogEvent(CogEvent.EVTD_COG_PRIVATE_EVENT, s);
	}

	static public function createStandardEvent(s:CogSignal<Dynamic>) : Event {
		return new Event(Std.string(s));
	}
	static public function getValue(s:CogSignal<Dynamic>):Int{
		return
			switch (s) {
				case SigEmpty(_) 				: 0;
				case SigInit(_)					: 1;
				case SigEntry(_)				: 2;
				case SigExit(_)					: 4;
				case SigTrace(_)				: 8;
				case SigPulse(_)				: 16;
				case SigCallback(_)				: 32;
				case SigGetOpts(_)				: 64;
				case SigChanged(_)				: 128;
				case SigUser(_, value, _)	:	value;
			}
	}
	static public function toString(s:CogSignal<Dynamic>) : String {
		return Std.string(s);
	}
}