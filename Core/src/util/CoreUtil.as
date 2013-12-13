package util
{
	import com.kvs.utils.MathUtil;
	
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
		/*public static function drawFrame(color:uint, points:Array):void
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
			//var x:Number = coreMdt.layoutTransformer.elementXToStageX(point.x);
			//var y:Number = coreMdt.layoutTransformer.elementYToStageY(point.y);
			coreMdt.mainUI.autoAlignUI.graphics.beginFill(color);
			coreMdt.mainUI.autoAlignUI.graphics.drawCircle(point.x, point.y, r);
			coreMdt.mainUI.autoAlignUI.graphics.endFill();
		}
		public static function clear():void
		{
			coreMdt.mainUI.autoAlignUI.graphics.clear();
		}*/
		
		public static function elementOutOfCanvasBounds(element:ElementBase):Boolean
		{
			var elementBound:Rectangle = getRectForStage(element);
			var mainUIBound :Rectangle = coreMdt.mainUI.bound;
			return ((elementBound.left < mainUIBound.left && elementBound.right > mainUIBound.right) || 
				(elementBound.top < mainUIBound.top && elementBound.bottom > mainUIBound.bottom));
		}
		
		public static function pointOutOfStageBounds(point:Point, paddingLeft:Number = 0, paddingRight:Number = 0, paddingTop:Number = 0, paddingBottom:Number = 0):Boolean
		{
			var x:Number = coreMdt.layoutTransformer.elementXToStageX(point.x);
			var y:Number = coreMdt.layoutTransformer.elementYToStageY(point.y);
			if (x > paddingLeft && x < coreMdt.mainUI.stage.stageWidth - paddingRight)
			{
				if (y > paddingTop && y < coreMdt.mainUI.stage.stageHeight - paddingBottom)
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
		
		public static function getRectForStage(element:ElementBase, rotate:Boolean = true):Rectangle
		{
			if (rotate)
			{
				var minX:Number = Math.min(element.topLeft.x, element.topRight.x, element.bottomLeft.x, element.bottomRight.x);
				var maxX:Number = Math.max(element.topLeft.x, element.topRight.x, element.bottomLeft.x, element.bottomRight.x);
				var minY:Number = Math.min(element.topLeft.y, element.topRight.y, element.bottomLeft.y, element.bottomRight.y);
				var maxY:Number = Math.max(element.topLeft.y, element.topRight.y, element.bottomLeft.y, element.bottomRight.y);
			}
			else
			{
				minX = element.left;
				maxX = element.right;
				minY = element.top;
				maxY = element.bottom;
			}
			
			var stageMinX:Number = coreMdt.layoutTransformer.elementXToStageX(minX);
			var stageMaxX:Number = coreMdt.layoutTransformer.elementXToStageX(maxX);
			var stageMinY:Number = coreMdt.layoutTransformer.elementYToStageY(minY);
			var stageMaxY:Number = coreMdt.layoutTransformer.elementYToStageY(maxY);
			return new Rectangle(stageMinX, stageMinY, stageMaxX - stageMinX, stageMaxY - stageMinY);
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
		*/
		private static function get coreMdt():CoreMediator
		{
			return CoreFacade.coreMediator;
		}
		
		private static const symbolH:Object = {left:-1, center:0, right:1};
		private static const symbolV:Object = {top:-1, middle:0, bottom:1};
	}
}