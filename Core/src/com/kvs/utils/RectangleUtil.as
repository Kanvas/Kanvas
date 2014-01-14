package com.kvs.utils
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import util.CoreUtil;

	public class RectangleUtil
	{
		public static function rotateRectangle(rectangle:Rectangle, origPoint:Point, rotation:Number):Rectangle
		{
			var topLeft:Point = rectangle.topLeft.clone();
			var topRight:Point = new Point(rectangle.right, rectangle.top);
			var bottomLeft:Point = new Point(rectangle.left, rectangle.bottom);
			var bottomRight:Point = rectangle.bottomRight.clone();
			var radian:Number = MathUtil.angleToRadian(rotation);
			topLeft = PointUtil.rotatePointAround(topLeft, origPoint, radian);
			topRight = PointUtil.rotatePointAround(topRight, origPoint, radian);
			bottomLeft = PointUtil.rotatePointAround(bottomLeft, origPoint, radian);
			bottomRight = PointUtil.rotatePointAround(bottomRight, origPoint, radian);
			//CoreUtil.drawFrame(0x0000FF, [topLeft, topRight, bottomRight, bottomLeft]);
			var left:Number = Math.min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
			var right:Number = Math.max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
			var top:Number = Math.min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
			var bottom:Number = Math.max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
			rectangle = new Rectangle(left, top, right - left, bottom - top);
			return rectangle;
		}
		
		/**
		 * 判断两矩形是否重叠。
		 */
		public static function rectOverlapping(rect1:Rectangle, rect2:Rectangle):Boolean
		{
			return  ! ( rect1.left   > rect2.right  ||
						rect1.right  < rect2.left   ||
						rect1.top    > rect2.bottom ||
						rect1.bottom < rect2.top);
		}
	}
}