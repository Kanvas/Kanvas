package util.layout
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	import com.kvs.utils.RectangleUtil;
	
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
		public function modCanvasPositionStart(targetX:Number, targetY:Number, targetScale:Number, targetRotation:Number):Number
		{
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
			
			var center:Point = new Point(.5 * (mainUI.bound.left + mainUI.bound.right), .5 * (mainUI.bound.top + mainUI.bound.bottom));
			
			//point A
			eleAO = center.clone();
			eleAO.offset(-startX, -startY);
			PointUtil.rotate(eleAO, MathUtil.angleToRadian(-startRotation));
			PointUtil.multiply(eleAO, 1 / startScale);
			
			//point a move from with out rotation
			sceAF = center.clone();
			
			//point b move to with out rotation
			sceAT = eleAO.clone();
			PointUtil.multiply(sceAT, endScale);
			PointUtil.rotate(sceAT, MathUtil.angleToRadian( endRotation));
			sceAT.offset(endX, endY);
			
			//point B
			eleBO = center.clone();
			eleBO.offset(-endX, -endY);
			PointUtil.rotate(eleBO, MathUtil.angleToRadian(-endRotation));
			PointUtil.multiply(eleBO, 1 / endScale);
			
			//point b move from with out rotation
			sceBF = eleBO.clone();
			PointUtil.multiply(sceBF, startScale);
			PointUtil.rotate(sceBF, MathUtil.angleToRadian( startRotation));
			sceBF.offset(startX, startY);
			
			//point b move to with out rotation
			sceBT = center.clone();
			
			//scene center
			sceCO = center.clone();
			
			var distanceUI:Number = mainUI.boundDiagonalDistance;
			var distanceAB:Number = Point.distance(eleAO, eleBO);
			centerScale = distanceUI / distanceAB;
			
			modInOut = (centerScale < startScale && centerScale < endScale);
			
			log2Start = MathUtil.log2(startScale);
			log2End   = MathUtil.log2(endScale);
			
			if (modInOut)
			{
				scaleDis = Math.abs(startScale - centerScale) + Math.abs(centerScale - endScale);
				log2Middle = MathUtil.log2(centerScale);
				lenSM = Math.abs(log2Start - log2Middle);
				lenME = Math.abs(log2Middle - log2End)
				lenSE = lenSM + lenME;
				proSM = lenSM / lenSE;
				proME = 1 - proSM;
			}
			else
			{
				scaleDis = Math.abs(startScale - endScale);
				centerScale = NaN;
				lenSE = Math.abs(log2Start - log2End);
			}
			
			return centerScale;
		}
		
		/**
		 * 根据当前rotation,scale计算canvas的坐标
		 */
		public function modCanvasPosition():void
		{
			if (modPositionNeed)
			{
				//由于progress有误差，根据重新计算当前distance progress
				var percent:Number = progress;
				//get current scale according to progress
				if (modInOut)
				{
					scale = (progress < proSM)
						? log2Start  - lenSM *  (progress / proSM)
						: log2Middle + lenME * ((progress - proSM) / proME);
					percent =  (lastScale > canvas.scaleX)
						? Math.abs(canvas.scaleX - startScale ) / scaleDis
						:(Math.abs(canvas.scaleX - centerScale) + Math.abs(centerScale - startScale)) / scaleDis;
				}
				else
				{
					scale = log2Start + (log2End - log2Start) * progress;
					if (! MathUtil.equals(scaleDis, 0))
						percent = Math.abs(canvas.scaleX - startScale) / scaleDis;
				}
				percent = Math.min(Math.max(0, percent), 1);
				
				//需要将移动到的点
				//progress
				var sceAC:Point = Point.interpolate(sceAT, sceAF, percent);
				var sceBC:Point = Point.interpolate(sceBT, sceBF, percent);
				//rotate
				PointUtil.rotate(sceAC, MathUtil.angleToRadian(rotation - endRotation  ), sceCO);
				PointUtil.rotate(sceBC, MathUtil.angleToRadian(rotation - startRotation), sceCO);
				//使用AB中点作为CANVAS移动参照
				var sceOC:Point = Point.interpolate(sceAC, sceBC, .5);
				var eleOC:Point = Point.interpolate(eleAO, eleBO, .5);
				//get canvas plus
				PointUtil.multiply(eleOC, canvas.scaleX);
				PointUtil.rotate(eleOC, MathUtil.angleToRadian(rotation));
				//move
				canvas.x = sceOC.x - eleOC.x;
				canvas.y = sceOC.y - eleOC.y;
				
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
		
		private var log2Start:Number;
		
		private var log2End:Number;
		
		private var log2Middle:Number;
		
		private var lenSM:Number;
		
		private var lenME:Number;
		
		private var lenSE:Number;
		
		private var proSM:Number;
		
		private var proME:Number;
		
		private var canvas:Sprite;
		
		private var mainUI:MainUIBase;
		
	}
}