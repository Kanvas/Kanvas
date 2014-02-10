package util
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	
	import flash.display.Sprite;
	import flash.geom.Point;

	public final class LayoutUtil
	{
		public static function elementPointToStagePoint(x:Number, y:Number, canvas:Sprite, ignoreRotation:Boolean = false):Point
		{
			var result:Point = new Point(x, y);
			//缩放
			PointUtil.multiply(result, canvas.scaleX);
			//旋转
			if (ignoreRotation == false)
				result = PointUtil.rotate(result, new Point(0, 0), MathUtil.angleToRadian(canvas.rotation));
			//平移
			result.offset(canvas.x, canvas.y);
			
			return result;
		}
		
		public static function stagePointToElementPoint(x:Number, y:Number, canvas:Sprite, ignoreRotation:Boolean = false):Point
		{
			var result:Point = new Point(x, y);
			//平移
			result.offset(-canvas.x, -canvas.y);
			//旋转
			if (ignoreRotation == false)
				result = PointUtil.rotate(result, new Point(0, 0), MathUtil.angleToRadian(-canvas.rotation));
			//缩放
			PointUtil.multiply(result, 1 / canvas.scaleX);
			
			return result;
		}
	}
}