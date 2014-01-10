package cn.vision.utils
{
	import cn.vision.core.NoInstance;
	
	/**
	 * Util of Mathematics.
	 * 
	 * @author vision
	 * @langversion 3.0
	 * @playerversion Flash 9, AIR 1.1
	 * @productversion vision 1.0
	 * 
	 */
	public final class MathUtil extends NoInstance
	{
		
		/**
		 * Conver degree to radian.
		 * 
		 * @param angle Angle to be converted.
		 * @return Radian converted.
		 * 
		 */
		public static function angleToRadian(angle:Number):Number
		{
			return angle * Math.PI / 180;
		}
		
		/**
		 * Convert radian to degree.
		 * 
		 * @param radian Radian to be converted.
		 * @return Angle converted.
		 * 
		 */
		public static function radianToAngle(radian:Number):Number
		{
			return radian * 180 / Math.PI;
		}
		
		/**
		 * ModuloAngle
		 * 
		 * @param angle
		 * @return Angle in the range of 0-360 degrees.
		 * 
		 */
		public static function moduloAngle(angle:Number):Number
		{
			angle = angle % 360;
			return (angle >= 0) ? angle : angle + 360;
		}
		
		/**
		 * Determine whether two numbers are equal.
		 * 
		 * @param value1
		 * @param value2
		 * @param accuracy Digits after the decimal, 0 to use the system default precision.
		 * @return 
		 * 
		 */
		public static function equals(value1:Number, value2:Number, accuracy:int = 0):Boolean
		{
			var result:Boolean;
			if (accuracy == 0)
			{
				result = (value1 == value2);
			}
			else
			{
				var factor:Number = Math.pow(10, accuracy);
				result = (Math.floor(value1 * factor) == Math.floor(value2 * factor));
			}
			return result;
		}
	}
}