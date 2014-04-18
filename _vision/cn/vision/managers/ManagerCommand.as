package cn.vision.managers
{
	import cn.vision.core.vs;
	import cn.vision.events.EventCommand;
	import cn.vision.pattern.Command;
	
	import flash.events.IEventDispatcher;
	
	public class ManagerCommand extends Manager
	{
		public  static const instance:ManagerCommand = new ManagerCommand;
		private static var   created :Boolean;
		public function ManagerCommand()
		{
			if(!created) {
				created = true;
				super();
				quene = [];
			} else throw new Error("Single Ton!");
		}
		
		public function push($command:Command):void
		{
			//model不为空将其加入队列
			if ($command) { quene.push($command); }
		}
		
		public function execute($command:Command=null):void
		{
			//model不为空将其加入队列
			if ($command) { quene.push($command); }
			
			if (quene.length) {
				if (!running) {
					//非运行状态下,进入运行状态,并且开始加载模型进程
					vs::running = true;
					executeCommnd();
					//调用queneStart
					queneStart();
				}
			}
		}
		
		protected function executeCommnd():void
		{
			current = Command(quene.shift());
			current.addEventListener(EventCommand.EXECUTE_START, executeStartHandler);
			current.addEventListener(EventCommand.EXECUTE_END  , executeEndHandler  );
			current.execute();
		}
		
		protected function executeStartHandler(e:EventCommand):void
		{
			current.removeEventListener(EventCommand.EXECUTE_START, executeStartHandler);
			stepStart();
		}
		protected function executeEndHandler  (e:EventCommand):void
		{
			current.removeEventListener(EventCommand.EXECUTE_END  , executeEndHandler  );
			stepEnd();
			if (quene.length) {
				executeCommnd();
			} else {
				vs::running = false;
				queneEnd();
			}
		}
		
		public function get running():Boolean
		{
			return Boolean(vs::running);
		}
		
		vs var running:Boolean;
		
		private var current:Command;
		private var quene:Array;
	}
}