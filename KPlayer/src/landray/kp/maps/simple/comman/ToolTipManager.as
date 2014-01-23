package landray.kp.maps.simple.comman
{
	import com.kvs.ui.toolTips.ToolTipHolder;
	import com.kvs.ui.toolTips.ToolTipsEvent;
	import com.kvs.utils.RexUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import landray.kp.maps.simple.elements.BaseElement;
	import landray.kp.utils.ExternalUtil;
	import landray.kp.view.Viewer;

	public final class ToolTipManager
	{
		public function ToolTipManager($target:Viewer)
		{
			target = $target;	
			target.addEventListener(MouseEvent.MOUSE_OVER   , showHandler);
			target.addEventListener(MouseEvent.MOUSE_OUT    , hideHandler);
			target.addEventListener(Event.REMOVED_FROM_STAGE, hideHandler);
		}
		
		public function showToolTip(value:String):void
		{
			if (element)
			{
				element.tips = value;
				showTips();
			}
		}
		
		private function showHandler(e:MouseEvent):void
		{
			if (e.target is BaseElement)
			{
				element = BaseElement(e.target);
				tipsVO.metaData = element;
				if (element.related)
				{
					if (element.tips)
						showTips();
					else
						ExternalUtil.kanvasLinkOvered(element.vo.id);
				}
			}
		}
		
		private function hideHandler(e:Event):void
		{
			hideTips();
		}
		
		
		private function showTips():void
		{
			if (enabled &&　! showing && element && ! RexUtil.ifTextNull(element.tips))
			{
				element.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.SHOW_TOOL_TIPS, tipsVO));
				showing = true;
			}
		}
		
		private function hideTips():void
		{
			if (showing)
			{
				element.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.HIDE_TOOL_TIPS));
				showing = false;
			}
		}
		
		/**
		 */		
		public function set enabled(value:Boolean):void
		{
			if (enabled != value)
			{
				__enabled = value;
				if (! enabled)
					hideTips();
			}
			
		}
		/**
		 */		
		public function get enabled():Boolean
		{
			return __enabled;
		}
		
		/**
		 */		
		private var __enabled:Boolean = true;
		
		
		private var target:Viewer;
		
		private var element:BaseElement;
		
		private var tipsVO:ToolTipHolder = new ToolTipHolder;
		
		private var showing:Boolean = false;
	}
}