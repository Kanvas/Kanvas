package util.layout
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import util.CoreUtil;
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
		public function modCanvasPositionStart(targetX:Number, targetY:Number, targetScale:Number, targetRotation:Number, inOut:Boolean = false, middleScale:Number = 1):void
		{
			modInOut = inOut;
			centerScale = middleScale;
			endX = targetX;
			endY = targetY;
			endScale = targetScale;
			endRotation = targetRotation;
			startX = x = canvas.x;
			startY = y = canvas.y;
			startScale = lastScale = canvas.scaleX;
			startRotation = canvas.rotation;
			progress = 0;
			modPositionNeed = true;
			
			//caculate scale distance
			scaleDis = (modInOut) ? Math.abs(startScale - centerScale) + Math.abs(centerScale - endScale) : Math.abs(startScale - endScale);
			
			var center:Point = new Point(.5 * (mainUI.bound.left + mainUI.bound.right), .5 * (mainUI.bound.top + mainUI.bound.bottom));
			
			//point B
			eleBO = center.clone();
			eleBO.offset(-endX, -endY);
			eleBO = PointUtil.rotatePointAround(eleBO, orignal, MathUtil.angleToRadian(-endRotation));
			PointUtil.multiply(eleBO, 1 / endScale);
			
			//point b move from with out rotation
			sceBF = eleBO.clone();
			PointUtil.multiply(sceBF, startScale);
			sceBF = PointUtil.rotatePointAround(sceBF, orignal, MathUtil.angleToRadian(startRotation));
			sceBF.offset(startX, startY);
			
			//point b move to with out rotation
			sceBT = center.clone();
			
			//scene center
			sceCO = center.clone();
		}
		
		/**
		 * 根据当前rotation,scale计算canvas的坐标
		 */
		public function modCanvasPosition():void
		{
			if (modPositionNeed)
			{
				//由于progress有误差，根据重新计算当前distance progress
				progress = (modInOut)
					? ((lastScale > canvas.scaleX) 
						? Math.abs( canvas.scaleX - startScale  ) / scaleDis
						:(Math.abs( canvas.scaleX - centerScale ) + Math.abs(centerScale - startScale)) / scaleDis)
					: Math.abs(canvas.scaleX - startScale) / scaleDis;
				//需要将移动到的点
				//progress
				var curSce:Point = Point.interpolate(sceBT, sceBF, progress);
				//rotation
				curSce = PointUtil.rotatePointAround(curSce, sceCO, MathUtil.angleToRadian(canvas.rotation - startRotation));
				var curEle:Point = eleBO.clone();
				PointUtil.multiply(curEle, canvas.scaleX);
				curEle = PointUtil.rotatePointAround(curEle, orignal, MathUtil.angleToRadian(rotation));
				//move canvas
				canvas.x = curSce.x - curEle.x;
				canvas.y = curSce.y - curEle.y;
				lastScale = canvas.scaleX;
			}
		}
		
		public function modCanvasPositionEnd():void
		{
			modPositionNeed = false;
			modInOut = false;
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
			return MathUtil.log2(canvas.scaleX);
		}
		public function set scale(value:Number):void
		{
			canvas.scaleX = canvas.scaleY = MathUtil.exp2(value);
		}
		
		public var progress:Number;
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		private var startX:Number;
		
		private var startY:Number;
		
		private var startScale:Number;
		
		private var startRotation:Number;
		
		private var endX:Number;
		
		private var endY:Number;
		
		private var endScale:Number;
		
		private var endRotation:Number;
		
		private var modPositionNeed:Boolean;
		
		private var modInOut:Boolean;
		
		private var transform:Boolean;
		
		private var centerScale:Number;
		
		//----------------------------------------
		// point A
		//----------------------------------------
		
		/**
		 * point A 在画布中的坐标 
		 */
		private var eleAO:Point;
		
		/**
		 * point A 相对于舞台的缓动起始位置
		 */
		private var sceAF:Point;
		
		/**
		 * point A 相对于舞台的缓动终止位置
		 */
		private var sceAT:Point;
		
		/**
		 * point A 相对于舞台的移动向量
		 */
		private var sceAV:Point;
		
		
		
		//----------------------------------------
		// point B
		//----------------------------------------
		
		/**
		 * point B 在画布中的坐标 
		 */
		private var eleBO:Point;
		
		/**
		 * point B 相对于舞台的缓动起始位置
		 */
		private var sceBF:Point;
		
		/**
		 * point B 相对于舞台的缓动终止位置
		 */
		private var sceBT:Point;
		
		/**
		 * point B 相对于舞台的移动向量
		 */
		private var sceBV:Point;
		
		//----------------------------------------
		// point center
		//----------------------------------------
		private var sceCO:Point;
		
		private var lastScale:Number;
		
		private var scaleDis:Number;
		
		
		private var orignal:Point = new Point;
		
		private var canvas:Sprite;
		
		private var mainUI:MainUIBase;
		
	}
}