package util
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.interact.CoreMediator;
	import view.interact.autoGroup.IAutoGroupElement;
	import view.interact.multiSelect.TemGroupElement;

	public final class CoreUtil
	{
		public static function drawRect(color:uint, rect:Rectangle):void
		{
			coreMdt.mainUI.autoAlignUI.graphics.lineStyle(1, color);
			coreMdt.mainUI.autoAlignUI.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		}

		public static function drawFrame(color:uint, points:Array):void
		{
			coreMdt.mainUI.autoAlignUI.graphics.lineStyle(1, color);
			coreMdt.mainUI.autoAlignUI.graphics.moveTo(points[0].x, points[0].y);
			for (var i:int = 1; i < points.length; i++)
			{
				coreMdt.mainUI.autoAlignUI.graphics.lineTo(points[i].x, points[i].y);
			}
			coreMdt.mainUI.autoAlignUI.graphics.lineTo(points[0].x, points[0].y);
		}
		
		public static function drawCircle(color:uint, point:Point, r:Number):void
		{
			coreMdt.mainUI.autoAlignUI.graphics.lineStyle(0, 0, 0);
			coreMdt.mainUI.autoAlignUI.graphics.beginFill(color);
			coreMdt.mainUI.autoAlignUI.graphics.drawCircle(point.x, point.y, r);
			coreMdt.mainUI.autoAlignUI.graphics.endFill();
		}
		
		public static function drawLine(color:uint, point1:Point, point2:Point):void
		{
			coreMdt.mainUI.autoAlignUI.graphics.lineStyle(1, color);
			coreMdt.mainUI.autoAlignUI.graphics.moveTo(point1.x, point1.y);
			coreMdt.mainUI.autoAlignUI.graphics.lineTo(point2.x, point2.y);
			coreMdt.mainUI.autoAlignUI.graphics.endFill();
		}

		
		public static function clear():void
		{
			coreMdt.mainUI.autoAlignUI.graphics.clear();
		}
		
		/**
		 * element 不在可交互范围内
		 * 有两种情况，一为element尺寸太大，超过了stage尺寸
		 */
		public static function elementOutOfInteract(element:ElementBase):Boolean
		{
			var bound:Rectangle = getRectForStage(element);
			var stage:Rectangle = getStageRect();
			return (bound.width  > stage.width  || 
					bound.height > stage.height ||
					bound.left   > stage.right  || 
					bound.right  < stage.left   || 
					bound.top    > stage.bottom || 
					bound.bottom < stage.top);
		}
		
		/**
		 * 检测element是否在自动群组内
		 * 检测element是否在current群组内
		 */
		public static function inGroup(current:ElementBase, element:ElementBase):Boolean
		{
			var result:Boolean;
			//检测element是否在current临时组合内
			if (current is TemGroupElement)
				result = (coreMdt.multiSelectControl.childElements.indexOf(element) != -1);
			//检测element是否在current群组
			else if (current is GroupElement)
				result = (GroupElement(current).childElements.indexOf(element) != -1);
			//检测element是否在智能组合内
			else if (element is IAutoGroupElement)
				result = coreMdt.autoGroupController.hasElement(element);
			
			return result;
		}
		
		
		/**
		 * 返回一个element的一个矩形
		 * 
		 * @param element
		 * @param elementRotate 是否考虑element的旋转因素
		 * @param canvasRotate 是否考虑canvas的旋转因素
		 * @return 
		 * 
		 */
		public static function getRectForStage(element:ElementBase, elementRotate:Boolean = true, canvasRotate:Boolean = true):Rectangle
		{
			if (elementRotate)
			{
				var topLeft:Point     = element.topLeft;
				var topRight:Point    = element.topRight;
				var bottomLeft:Point  = element.bottomLeft;
				var bottomRight:Point = element.bottomRight;
				if (canvasRotate)
				{
					topLeft     = LayoutUtil.elementPointToStagePoint(topLeft    .x, topLeft    .y, coreMdt.canvas);
					topRight    = LayoutUtil.elementPointToStagePoint(topRight   .x, topRight   .y, coreMdt.canvas);
					bottomLeft  = LayoutUtil.elementPointToStagePoint(bottomLeft .x, bottomLeft .y, coreMdt.canvas);
					bottomRight = LayoutUtil.elementPointToStagePoint(bottomRight.x, bottomRight.y, coreMdt.canvas);
					var minX:Number = Math.min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
					var maxX:Number = Math.max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
					var minY:Number = Math.min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
					var maxY:Number = Math.max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
				}
				else
				{
					minX = Math.min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
					maxX = Math.max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
					minY = Math.min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
					maxY = Math.max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
					
					minX = coreMdt.canvas.x + minX * coreMdt.canvas.scaleX;
					maxX = coreMdt.canvas.x + maxX * coreMdt.canvas.scaleX;
					minY = coreMdt.canvas.y + minY * coreMdt.canvas.scaleY;
					maxY = coreMdt.canvas.y + maxY * coreMdt.canvas.scaleY;
				}
				
				var x:Number = minX;
				var y:Number = minY;
				var w:Number = maxX - minX;
				var h:Number = maxY - minY;
			}
			else
			{
				var point:Point = LayoutUtil.elementPointToStagePoint(element.left, element.top, coreMdt.canvas);
				x = point.x;
				w = coreMdt.layoutTransformer.canvasScale * element.scaledWidth;
				y = point.y;
				h = coreMdt.layoutTransformer.canvasScale * element.scaledHeight;
			}
			return new Rectangle(x, y, w, h);
		}
		
		public static function getStageRect():Rectangle
		{
			return (coreMdt.mainUI.stage) ? new Rectangle(0, 0, coreMdt.mainUI.stage.stageWidth, coreMdt.mainUI.stage.stageHeight) : new Rectangle;
		}
		
		private static function get coreMdt():CoreMediator
		{
			return CoreFacade.coreMediator;
		}
	}
}