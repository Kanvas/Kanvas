package landray.kp.components
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import landray.kp.core.KPConfig;
	import landray.kp.core.kp_internal;
	import landray.kp.maps.main.elements.BaseElement;
	import landray.kp.view.Viewer;
	
	import util.LayoutUtil;
	
	/**
	 * 选择框
	 */
	public final class Selector extends Sprite
	{
		public function Selector()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			config = KPConfig.instance;
			visible = false;
		}
		
		public function render($element:BaseElement = null, $rect:Rectangle=null):void
		{
			element = $element;
			
			visible = Boolean(element);
			if (visible)
			{
				graphics.clear();
				
				rect = element.getRectangleForViewer();
				var temp:Rectangle = rect.clone();
				temp.x      *= viewer.canvas.scaleX;
				temp.y      *= viewer.canvas.scaleX;
				temp.width  *= viewer.canvas.scaleX;
				temp.height *= viewer.canvas.scaleX;
				
				drawRect(temp, 5);
				
				var point:Point = LayoutUtil.elementPointToStagePoint(element.x, element.y, viewer.canvas);
				
				x = point.x;
				y = point.y;
				
				rotation = element.rotation + viewer.canvas.rotation;
			}
		}
		
		/**
		 * @private
		 */
		private function drawRect(rect:Rectangle, padding:Number):void
		{
			var x:Number = rect.x - padding;
			var y:Number = rect.y - padding;
			var w:Number = rect.width  + padding * 2;
			var h:Number = rect.height + padding * 2;
			
			graphics.lineStyle(3, 0x00AFFF);
			graphics.drawRect(x, y, w, h);
			graphics.lineStyle(1, 0xEEEEEE);
			graphics.drawRect(x, y, w, h);
		}
		
		private function get viewer():Viewer
		{
			return config.kp_internal::viewer;
		}
		
		/**
		 * @private
		 */
		private var element:BaseElement;
		
		/**
		 * @private
		 */
		private var padding:Number = 5;
		
		private var config:KPConfig;
		
		private var rect:Rectangle;
	}
}