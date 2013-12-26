package landray.kp.core
{
	import com.kvs.ui.toolTips.ToolTipsManager;
	import com.kvs.utils.Map;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	
	import flash.display.DisplayObjectContainer;
	
	import landray.kp.view.*;
	
	import model.vo.BgVO;
	
	import view.toolBar.Debugger;
	
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
		kp_internal var debugger   :Debugger;
		kp_internal var tipsManager:ToolTipsManager;
		kp_internal var graphs     :Vector.<Graph>;
		kp_internal var templete   :XML;
		kp_internal var themes     :Map;
		kp_internal var lib        :XMLVOLib;
		kp_internal var theme      :String;
		kp_internal var bgVO       :BgVO;
	}
}