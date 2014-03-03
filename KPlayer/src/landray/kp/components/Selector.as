package landray.kp.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import landray.kp.core.kp_internal;
	import landray.kp.view.Viewer;
	
	/**
	 * 选择框
	 */
	public final class Selector extends Sprite
	{
		public function Selector($viewer:Viewer)
		{
			super();
			viewer = $viewer;
			
			visible = false;
		}
		
		public function render($rect:Rectangle=null):void
		{
			if ($rect) 
				rect = $rect;
			if (element) 
			{
				var temp:Rectangle = rect.clone();
				temp.x      *= viewer.canvas.scaleX;
				temp.y      *= viewer.canvas.scaleX;
				temp.width  *= viewer.canvas.scaleX;
				temp.height *= viewer.canvas.scaleX;
				
				var point:Point = viewer.kp_internal::convertElementCoordsToViewer(element.x, element.y);
				x = point.x;
				y = point.y;
				rotation = element.rotation;
			} 
			else 
			{
				temp = new Rectangle(0, 0, 100, 100);
			}
			graphics.clear();
			drawRect(temp, 5);
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
		
		/**
		 * @private
		 */
		public var element:DisplayObject;
		
		/**
		 * @private
		 */
		private var padding:Number = 5;
		
		/**
		 * @private
		 */
		private var viewer:Viewer;
		
		private var rect:Rectangle;
	}
}