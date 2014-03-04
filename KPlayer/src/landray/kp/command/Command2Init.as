package landray.kp.command
{	
	import flash.events.Event;
	import flash.text.TextFormat;
	
	import landray.kp.components.Selector;
	import landray.kp.components.ZoomToolBar;
	import landray.kp.core.kp_internal;
	import landray.kp.manager.ManagerPage;
	import landray.kp.maps.main.comman.ElementToolTip;
	import landray.kp.mediator.MediatorViewer;
	import landray.kp.view.Viewer;
	
	import util.textFlow.FlowTextManager;
	
	import view.interact.zoomMove.ZoomMoveControl;
	
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
			
			config.kp_internal::viewer      = new Viewer;
			config.kp_internal::mediator    = new MediatorViewer;
			config.kp_internal::controller  = new ZoomMoveControl(config.kp_internal::viewer, config.kp_internal::mediator);
			config.kp_internal::selector    = new Selector;
			config.kp_internal::zoomToolBar = new ZoomToolBar;
			config.kp_internal::toolTip     = new ElementToolTip;
			config.kp_internal::pageManager = ManagerPage.instance;
			
			config.kp_internal::viewer.addEventListener("initialize", function(e:Event):void
			{
				executeEnd();
			}, false, 0, true);
			config.kp_internal::container.addChildAt(config.kp_internal::viewer, 0);
		}
	}
}