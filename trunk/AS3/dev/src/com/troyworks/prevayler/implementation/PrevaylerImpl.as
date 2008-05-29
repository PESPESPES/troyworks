/**
* ..
* @author Default
* @version 0.1
*/

package com.troyworks.prevayler.implementation {
	

	import com.troyworks.prevayler.CPrevayler;
	import com.troyworks.prevayler.Clock;
	import com.troyworks.prevayler.Query;
	import com.troyworks.prevayler.SureTransactionWithQuery;
	import com.troyworks.prevayler.Transaction;
	import com.troyworks.prevayler.TransactionWithQuery;
	import com.troyworks.prevayler.foundation.serialization.Serializer;
	import com.troyworks.prevayler.implementation.publishing.TransactionPublisher;
	import com.troyworks.prevayler.implementation.snapshot.GenericSnapshotManager;
	import flash.errors.IOError;

	public class PrevaylerImpl implements Prevayler{
		//private final _gaurd:PrevalentSystemGuard;
		private final var _clock:Clock;
		private final  var _snapshotManager:GenericShapshotManager;
		private final  var _publisher:TransactionPublisher;
		//private final _journalSerializer:
		
	/** Creates a new Prevayler
	 * 
	 * @param snapshotManager The SnapshotManager that will be used for reading and writing snapshot files.
	 * @param transactionPublisher The TransactionPublisher that will be used for publishing transactions executed with this PrevaylerImpl.
	 * @param prevaylerMonitor The Monitor that will be used to monitor interesting calls to this PrevaylerImpl.
	 * @param journalSerializer
	 */
		public function PrevaylerImpl( snapshotManager:GenericSnapshotManager,  transactionPublisher:TransactionPublisher,  journalSerializer:Serializer)  {//throws IOException, ClassNotFoundException
				_snapshotManager = snapshotManager;
				_guard = _snapshotManager.recoveredPrevalentSystem();
				_publisher = transactionPublisher;
				_clock = _publisher.clock();
				_guard.subscribeTo(_publisher);
				_journalSerializer = journalSerializer;
			}
			public function prevalentSystem():Object {
				return _guard.prevalentSystem(); 
			}	
			public function clock():Clock{
				return _clock;
			}
			public function execute(transaction:Transaction):void{
				  publish(new TransactionCapsule(transaction, _journalSerializer));    //TODO Optimizations: 1) The Censor can use the actual given transaction if it is Immutable instead of deserializing a new one from the byte array. 2) Make the baptism fail-fast feature optional (default is on). If it is off, the given transaction can be used instead of deserializing a new one from the byte array.
			}
			private function publish(capsule:Capsule):void {
				_publisher.publish(capsule);
			}
			public function execute(q:Query): Object {
				if(q is TransactionWithQuery){
					var  capsule:TransactionWithQueryCapsule = new TransactionWithQueryCapsule(transactionWithQuery, _journalSerializer);
					publish(capsule);
					return capsule.result();
				}else{
					try {
						//return execute(TransactionWithQuery(sureTransactionWithQuery));
						return _guard.executeQuery(q, clock());
					} catch (err:Error) {
						throw new Error("Unexpected Exception thrown.", err);
					}	
				}
			}
			public function takeSnapshot(): void {//throws IOException 
				_guard.takeSnapshot(_snapshotManager);
			}
			public function close() :void{ //throws IOException 
				_publisher.close(); 
			}

	}
	
}
