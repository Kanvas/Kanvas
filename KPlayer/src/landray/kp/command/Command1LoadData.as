package landray.kp.command
{
	import cn.vision.events.EventManager;
	import cn.vision.managers.ManagerModel;
	import cn.vision.utils.LogUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import landray.kp.model.*;
	
	public final class Command1LoadData extends _InernalCommand
	{
		public function Command1LoadData()
		{
			super();
			initialize();
		}
		private function initialize():void
		{
			modelManager = ManagerModel.instance;
		}
		override public function execute():void
		{
			executeStart();
			modelManager.addEventListener(EventManager.QUENE_END, queneEnd);
			modelManager.execute(new Model1Maps(provider.dataURL));
		}
		
		private function queneEnd(e:EventManager):void
		{
			executeEnd();
		}
		
		private var modelManager:ManagerModel;
	}
}