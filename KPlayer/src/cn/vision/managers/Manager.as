package cn.vision.managers
{
	import cn.vision.core.EventDispatcherVS;
	import cn.vision.core.vs;
	import cn.vision.events.EventManager;
	
	public class Manager extends EventDispatcherVS
	{
		public function Manager()
		{
			super();
		}
		
		protected function stepStart():void
		{
			dispatchEvent(new EventManager(EventManager.STEP_START));
		}
		protected function stepEnd():void
		{
			dispatchEvent(new EventManager(EventManager.STEP_END));
		}
		protected function queneStart():void
		{
			dispatchEvent(new EventManager(EventManager.QUENE_START));
		}
		protected function queneEnd():void
		{
			dispatchEvent(new EventManager(EventManager.QUENE_END));
		}
	}
}