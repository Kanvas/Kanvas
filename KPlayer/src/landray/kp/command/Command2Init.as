package landray.kp.command
{	
	import flash.events.Event;
	
	import landray.kp.core.kp_internal;
	import landray.kp.view.Viewer;
	
	import util.textFlow.FlowTextManager;
	
	/**
	 */	
	public final class Command2Init extends _InernalCommand
	{
		public function Command2Init()
		{
			super();
		}
		override public function execute():void
		{
			executeStart();
			//init templete
			initTemplete();
			//init views
			initViews();
			
			
		}
		
		private function initTemplete():void
		{
			if(!provider.styleXML) 
				provider.styleXML = StyleEmbeder.styleXML;
		}
		
		private function initViews():void
		{
			//加载字体
			FlowTextManager.loadFont("FontLib.swf");
			
			/*if(!config.kp_internal::debugger)
				config.kp_internal::container.addChild(config.kp_internal::debugger = new Debugger);
			var f:TextFormat = new TextFormat("宋体", 12, 0x000000);
			config.kp_internal::debugger.setTextFormat(f);*/
			if(!config.kp_internal::viewer) 
			{
				config.kp_internal::viewer = new Viewer;
				
				
				
				config.kp_internal::viewer.addEventListener("initialize", function(e:Event):void
				{
					executeEnd();
				}, false, 0, true);
				config.kp_internal::container.addChildAt(config.kp_internal::viewer, 0);
				
			}
			
		}
		
		
	}
}