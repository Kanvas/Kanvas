package util.layout
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import util.LayoutUtil;
	
	import view.ui.MainUIBase;

	/**
	 * 画布容器包装类
	 * 用于存储一个缓动进程progress，根据当前progress计算相对应的画布需要移动的位置。
	 */	
	public final class CanvasLayoutPacker
	{
		public function CanvasLayoutPacker($mainUI:MainUIBase = null)
		{
			if ($mainUI != null)
			{
				mainUI = $mainUI;
				canvas = $mainUI.canvas;
			}
			else
			{
				throw new ArgumentError("参数不能为null!", 1009);
			}
		}
		
		/**
		 * 根据画布的 起始位置和目标位置求得对应的元素中心点，并根据2中心点的直线为运动轨迹。
		 * 
		 * @param targetX
		 * @param targetY
		 * @param targetScale
		 * @param targetRotation
		 * 
		 */
		public function modCanvasPositionStart(targetX:Number, targetY:Number, targetScale:Number, targetRotation:Number):void
		{
			startX = x = canvas.x;
			startY = y = canvas.y;
			startScale = canvas.scaleX;
			startRotation = canvas.rotation;
			endX = targetX;
			endY = targetY;
			endScale = targetScale;
			endRotation = targetRotation;
			progress = 0;
			modPositionNeed = true;
			
			var stageBound:Rectangle = mainUI.bound;
			var startSceCenter:Point = new Point(.5 * (stageBound.left + stageBound.right), .5 * (stageBound.top + stageBound.bottom));
			
			startEleCenter = startSceCenter.clone();
			startEleCenter.offset(-startX, -startY);
			startEleCenter = PointUtil.rotatePointAround(startEleCenter, new Point, MathUtil.angleToRadian(-startRotation));
			PointUtil.multiply(startEleCenter, 1 / startScale);
			
			endEleCenter = startSceCenter.clone();
			endEleCenter.offset(-endX, -endY);
			endEleCenter = PointUtil.rotatePointAround(endEleCenter, new Point, MathUtil.angleToRadian(-targetRotation));
			PointUtil.multiply(endEleCenter, 1 / endScale);
			
			endSceCenter = LayoutUtil.elementPointToStagePoint(endEleCenter.x, endEleCenter.y, canvas);
			
			vector = startSceCenter.subtract(endSceCenter);
			
		}
		
		public function modCanvasPosition():void
		{
			if (modPositionNeed)
			{
				var stageBound:Rectangle = mainUI.bound;
				var temp:Point = vector.clone();
				PointUtil.multiply(temp, progress);
				var curSceCenter:Point = endSceCenter.add(temp);
				var curEleCenter:Point = endEleCenter.clone();
				PointUtil.multiply(curEleCenter, scale);
				curEleCenter = PointUtil.rotatePointAround(curEleCenter, new Point, MathUtil.angleToRadian(rotation));
				canvas.x = curSceCenter.x - curEleCenter.x;
				canvas.y = curSceCenter.y - curEleCenter.y;
				trace(canvas.x, canvas.y, canvas.scaleX, canvas.rotation)
			}
		}
		
		public function modCanvasPositionEnd():void
		{
			modPositionNeed = false;
		}
		
		public function get rotation():Number
		{
			return canvas.rotation;
		}
		public function set rotation(value:Number):void
		{
			canvas.rotation = value;
		}
		
		public function get scale():Number
		{
			return canvas.scaleX;
		}
		public function set scale(value:Number):void
		{
			canvas.scaleX = canvas.scaleY = value;
		}
		
		public var progress:Number;
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		private var startX:Number;
		
		private var startY:Number;
		
		private var startScale:Number;
		
		private var startRotation:Number;
		
		private var startEleCenter:Point;
		
		private var endX:Number;
		
		private var endY:Number;
		
		private var endScale:Number;
		
		private var endRotation:Number;
		
		private var modPositionNeed:Boolean;
		
		private var endEleCenter:Point;
		
		private var endSceCenter:Point;
		
		private var vector:Point;
		
		private var canvas:Sprite;
		
		private var mainUI:MainUIBase;
	}
}