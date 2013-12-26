package view.interact.zoomMove
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	
	import view.interact.CoreMediator;

	/**
	 */	
	public final class Packer
	{
		public function Packer($canvas:Sprite)
		{
			if ($canvas != null)
			{
				canvas = $canvas;
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
			
			var stageBound:Rectangle = coreMdt.mainUI.bound;
			var cenScePoint:Point = new Point(.5 * (stageBound.left + stageBound.right), .5 * (stageBound.top + stageBound.bottom));
			
			startEleCenter = cenScePoint.clone();
			startEleCenter.offset(-startX, -startY);
			startEleCenter = PointUtil.rotatePointAround(startEleCenter, new Point, MathUtil.angleToRadian(-startRotation));
			PointUtil.multiply(startEleCenter, 1 / startScale);
			
			endEleCenter = cenScePoint.clone();
			endEleCenter.offset(-endX, -endY);
			endEleCenter = PointUtil.rotatePointAround(endEleCenter, new Point, MathUtil.angleToRadian(-targetRotation));
			PointUtil.multiply(endEleCenter, 1 / endScale);
			
			modCanvasPosition();
		}
		
		public function modCanvasPosition():void
		{
			if (modPositionNeed)
			{
				var stageBound:Rectangle = coreMdt.mainUI.bound;
				
				var curEleCenter:Point = Point.interpolate(endEleCenter, startEleCenter, progress);
				var curSceCenter:Point = curEleCenter.clone();
				PointUtil.multiply(curSceCenter, scale);
				curSceCenter = PointUtil.rotatePointAround(curSceCenter, new Point, MathUtil.angleToRadian(rotation));
				canvas.x = .5 * (stageBound.left + stageBound.right) - curSceCenter.x;
				canvas.y = .5 * (stageBound.top + stageBound.bottom) - curSceCenter.y;
			}
		}
		
		public function modCanvasPositionEnd():void
		{
			modCanvasPosition();
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
		
		private function get coreMdt():CoreMediator
		{
			return CoreFacade.coreMediator;
		}
		
		public var progress:Number;
		
		public var x:Number;
		
		public var y:Number;
		
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
		
		private var canvas:Sprite;
		
	}
}