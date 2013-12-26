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
	
	public final class Command1ProvideData extends _InernalCommand
	{
		public function Command1ProvideData($isURI:Boolean, $data:Object)
		{
			super();
			initialize($isURI, $data);
		}
		private function initialize($isURI:Boolean, $data:Object):void
		{
			isURI = $isURI;
			data  = $data;
			modelManager = ManagerModel.instance;
		}
		override public function execute():void
		{
			executeStart();
			if (isURI)
			{
				provider.dataURL = data as String;
				modelManager.addEventListener(EventManager.QUENE_END, queneEnd);
				modelManager.execute(new Model1Maps(provider.dataURL));
			}
			else
			{
				try
				{
					provider.dataXML = new XML(data);
				}
				catch (e:Error)
				{
					LogUtil.log(e.getStackTrace());
				}
				executeEnd();
			}
		}
		
		private function queneEnd(e:EventManager):void
		{
			modelManager.removeEventListener(EventManager.QUENE_END, queneEnd);
			executeEnd();
		}
		
		private var isURI:Boolean;
		private var data :Object;
		
		private var modelManager:ManagerModel;
	}
}