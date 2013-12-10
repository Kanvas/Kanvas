package com.kvs.utils
{
	import flash.geom.Point;

	public class PointUtil
	{
		/**
		 * point围绕orgPoint旋转一定弧度之后所活得的点
		 * 
		 */
		public static function rotatePointAround(point:Point, origPoint:Point, radian:Number):Point
		{
			var result:Point = new Point;
			var vector:Point = point.subtract(origPoint);
			var cos:Number = Math.cos(radian);
			var sin:Number = Math.sin(radian);
			result.x = vector.x * cos - vector.y * sin + origPoint.x;
			result.y = vector.x * sin + vector.y * cos + origPoint.y;
			return result;
		}
		/**
		 * point乘以一个数值，会改变该点的坐标
		 * 
		 */
		public static function multiply(point:Point, scale:Number):void
		{
			point.x *= scale;
			point.y *= scale;
		}
		/**
		 * point返回一个负方向的点
		 * 
		 */
		public static function negtive(point:Point):Point
		{
			return new Point(-point.x, -point.y);
		}
	}
}