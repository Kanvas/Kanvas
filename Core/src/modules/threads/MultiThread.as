package modules.threads
{
	import flash.events.EventDispatcher;
	
	import view.interact.CoreMediator;

	public final class MultiThread extends EventDispatcher
	{
		public function MultiThread($coreMdt:CoreMediator)
		{
			super();
			coreMdt = $coreMdt;
			initialize();
		}
		private function initialize():void
		{
			
		}
		
		private var coreMdt:CoreMediator;
	}
}