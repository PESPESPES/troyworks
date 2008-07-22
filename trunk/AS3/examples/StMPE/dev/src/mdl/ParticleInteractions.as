package mdl {
	import flash.events.EventDispatcher;	
	
	/**
	 * @author Troy Gardner
	 */
	public class ParticleInteractions extends EventDispatcher {
		public var srcA : EightDimensionParticle;
		public var srcB : EightDimensionParticle;
		public var res1 : EightDimensionParticle;
		public var res2 : EightDimensionParticle;
		public function ParticleInteractions() {
			super();
		}
	}
}
