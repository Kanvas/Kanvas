package util
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	
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
		
		public static function drawRect(color:uint, rect:Rectangle):void
		{
			coreMdt.mainUI.autoAlignUI.graphics.lineStyle(1, color);
			coreMdt.mainUI.autoAlignUI.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			coreMdt.mainUI.autoAlignUI.graphics.endFill();
		}
		
		public static function drawCircle(color:uint, point:Point, r:Number):void
		{
			//var x:Number = coreMdt.layoutTransformer.elementXToStageX(point.x);
			//var y:Number = coreMdt.layoutTransformer.elementYToStageY(point.y);
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
		
		public static function elementOutOfCanvasBounds(element:ElementBase):Boolean
		{
			var elementBound:Rectangle = getRectForStage(element);
			var mainUIBound :Rectangle = coreMdt.mainUI.bound;
			return ((elementBound.left < mainUIBound.left && elementBound.right > mainUIBound.right) || 
				(elementBound.top < mainUIBound.top && elementBound.bottom > mainUIBound.bottom));
		}
		
		public static function pointOutOfStageBounds(point:Point, paddingLeft:Number = 0, paddingRight:Number = 0, paddingTop:Number = 0, paddingBottom:Number = 0):Boolean
		{
			point = coreMdt.layoutTransformer.elementPointToStagePoint(point.x, point.y);
			if (point.x > paddingLeft && point.x < coreMdt.mainUI.stage.stageWidth - paddingRight)
			{
				if (point.y > paddingTop && point.y < coreMdt.mainUI.stage.stageHeight - paddingBottom)
					return false;
			}
			return true;
		}
		public static function inAutoGroup(element:ElementBase):Boolean
		{
			if (element is IAutoGroupElement)
			{
				return coreMdt.autoGroupController.hasElement(element);
			}
			else if (element is TemGroupElement || element is GroupElement)
			{
				return true;
			}
			return false;
		}
		
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
					topLeft     = coreMdt.layoutTransformer.elementPointToStagePoint(topLeft    .x, topLeft    .y);
					topRight    = coreMdt.layoutTransformer.elementPointToStagePoint(topRight   .x, topRight   .y);
					bottomLeft  = coreMdt.layoutTransformer.elementPointToStagePoint(bottomLeft .x, bottomLeft .y);
					bottomRight = coreMdt.layoutTransformer.elementPointToStagePoint(bottomRight.x, bottomRight.y);
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
				var point:Point = coreMdt.layoutTransformer.elementPointToStagePoint(element.left, element.top);
				x = point.x;
				w = coreMdt.layoutTransformer.canvasScale * element.scaledWidth;
				y = point.y;
				h = coreMdt.layoutTransformer.canvasScale * element.scaledHeight;
			}
			return new Rectangle(x, y, w, h);
		}
		/*
		public static function getPoint(element:ElementBase, h:String, v:String):Point
		{
			var point:Point = new Point;
			point.x = .5 * getSymbolH(h) * element.vo.scale * element.vo.width;
			point.y = .5 * getSymbolV(v) * element.vo.scale * element.vo.height;
			var cos:Number = Math.cos(MathUtil.angleToRadian(element.vo.rotation));
			var sin:Number = Math.sin(MathUtil.angleToRadian(element.vo.rotation));
			var rx:Number = point.x * cos - point.y * sin;
			var ry:Number = point.x * sin + point.y * cos;
			point.x = rx;
			point.y = ry;
			point.x += element.x;
			point.y += element.y;
			return point;
		}
		
		public static function getElementSide(element:ElementBase, value:String):Number
		{
			var side:int = 0
			var result:Number = 0;
			if (symbolH[value] == undefined)
			{
				if (symbolV[value] != undefined)
				{
					side = symbolV[value];
					result = .5 * side * element.vo.scale * element.vo.height;
				}
			}
			else
			{
				side = symbolH[value];
				result = .5 * side * element.vo.scale * element.vo.width;
			}
			return result;
		}
		
		private static function getSymbolH(value:String):int
		{
			return (symbolH[value] != undefined) ? symbolH[value] : 0;
		}
		
		private static function getSymbolV(value:String):int
		{
			return (symbolV[value] != undefined) ? symbolV[value] : 0;
		}
		private static const symbolH:Object = {left:-1, center:0, right:1};
		private static const symbolV:Object = {top:-1, middle:0, bottom:1};
		*/
		private static function get coreMdt():CoreMediator
		{
			return CoreFacade.coreMediator;
		}
	}
}