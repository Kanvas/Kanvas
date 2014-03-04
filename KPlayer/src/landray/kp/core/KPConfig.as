package landray.kp.core
{
	import com.kvs.utils.Map;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	
	import flash.display.DisplayObjectContainer;
	
	import landray.kp.components.Debugger;
	import landray.kp.components.Selector;
	import landray.kp.components.ZoomToolBar;
	import landray.kp.manager.ManagerPage;
	import landray.kp.maps.main.comman.ElementToolTip;
	import landray.kp.mediator.MediatorViewer;
	import landray.kp.view.*;
	
	import model.vo.BgVO;
	
	import view.interact.zoomMove.ZoomMoveControl;
	
	public final class KPConfig
	{
		public  static const instance:KPConfig = new KPConfig;
		private static var   created :Boolean;
		
		
		public function KPConfig()
		{
			if(!created) 
			{
				created = true;
				super();
				initialize();
			} 
			else 
			{
				throw new Error("Single Ton!");
			}
		}
		
		private function initialize():void
		{
			kp_internal::graphs = new Vector.<Graph>;
			kp_internal::themes = new Map;
			kp_internal::lib    = new XMLVOLib;
			kp_internal::bgVO   = new BgVO;
		}
		
		public var id:String;
		
		/**
		 * 自动布局时，画布保持原比例，不缩放 
		 */		
		public var originalScale:Boolean;
		
		kp_internal var container  :DisplayObjectContainer;
		kp_internal var viewer     :Viewer;
		kp_internal var mediator   :MediatorViewer;
		kp_internal var controller :ZoomMoveControl;
		kp_internal var selector   :Selector;
		kp_internal var zoomToolBar:ZoomToolBar;
		kp_internal var toolTip    :ElementToolTip;
		kp_internal var pageManager:ManagerPage;
		kp_internal var debugger   :Debugger;
		
		kp_internal var graphs     :Vector.<Graph>;
		kp_internal var themes     :Map;
		kp_internal var lib        :XMLVOLib;
		kp_internal var theme      :String;
		kp_internal var bgVO       :BgVO;
	}
}