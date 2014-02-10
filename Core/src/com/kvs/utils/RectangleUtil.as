package com.kvs.utils
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class RectangleUtil
	{
		/**
		 * 矩形绕某点旋转一定角度后所形成的新的占位矩形。
		 */
		public static function rotateRectangle(rectangle:Rectangle, origin:Point, rotation:Number):Rectangle
		{
			var radian:Number = MathUtil.angleToRadian(rotation);
			var topLeft    :Point = rectangle.topLeft    .clone();
			var bottomRight:Point = rectangle.bottomRight.clone();
			var topRight   :Point = new Point(rectangle.right, rectangle.top);
			var bottomLeft :Point = new Point(rectangle.left , rectangle.bottom);
			topLeft     = PointUtil.rotate(topLeft    , origin, radian);
			bottomRight = PointUtil.rotate(bottomRight, origin, radian);
			topRight    = PointUtil.rotate(topRight   , origin, radian);
			bottomLeft  = PointUtil.rotate(bottomLeft , origin, radian);
			var left  :Number = Math.min(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
			var right :Number = Math.max(topLeft.x, topRight.x, bottomLeft.x, bottomRight.x);
			var top   :Number = Math.min(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
			var bottom:Number = Math.max(topLeft.y, topRight.y, bottomLeft.y, bottomRight.y);
			return new Rectangle(left, top, right - left, bottom - top);
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
		
		/**
		 * 矩形对角线长度。
		 */
		public static function getDiagonalDistance(rectangle:Rectangle):Number
		{
			return Point.distance(rectangle.topLeft, rectangle.bottomRight);
		}
	}
}