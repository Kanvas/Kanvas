package view.interact.zoomMove
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Linear;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import util.CoreUtil;
	
	/**
	 * 画布缩放和拖动动画的控制器；
	 */	
	public class Flasher
	{
		public function Flasher(control:ZoomMoveControl)
		{
			this.control = control;
		}
		
		/**
		 */		
		private var control:ZoomMoveControl;
		
		/**
		 * 检测动画目标的初始值，刚开始动画时
		 */		
		public function ready():void
		{
			if (isFlashing == false)
			{
				canvasTargetScale = canvas.scaleX;
				canvasTargetX = canvas.x;
				canvasTargetY = canvas.y;
			}
		}
		
		/**
		 */		
		public function close(toEnd:Boolean = true):void
		{
			TweenMax.killTweensOf(canvas, toEnd);
		}
		
		/**
		 */		

		public function flash(time:Number = 0.3, easeFlash:Object = null):void
		{
			if (Math.abs(canvasTargetScale - canvas.scaleX) > .001)
				control.mainUI.curScreenState.disableCanvas();
			
			TweenMax.killTweensOf(canvas, false);
			TweenMax.to(canvas, time, {scaleX: canvasTargetScale, scaleY: canvasTargetScale, x: canvasTargetX, y: canvasTargetY, 
				ease : easeFlash, 
				onUpdate : updated,
				onComplete : finishZoom});
			
			isFlashing = true;	
		}
		
		/**
		 */		
		private function updated():void
		{
			control.mainUI.synBgImgWidthCanvas();
			
			control.uiMediator.updateAfterZoomMove();
		}
		
		/**
		 */		
		private function finishZoom():void
		{
			control.mainUI.curScreenState.enableCanvas();
			isFlashing = false;
		}
		
		/**
		 */		
		private var _canvasTargetScale:Number = 1;

		/**
		 */
		public function get canvasTargetScale():Number
		{
			return _canvasTargetScale;
		}

		/**
		 * @private
		 */
		public function set canvasTargetScale(value:Number):void
		{
			_canvasTargetScale = value;
		}

		
		/**
		 */		
		private var _canvasTargetX:Number = 0;

		/**
		 */
		public function get canvasTargetX():Number
		{
			return _canvasTargetX;
		}

		/**
		 * @private
		 */
		public function set canvasTargetX(value:Number):void
		{
			_canvasTargetX = value;
		}

		
		/**
		 */		
		private var _canvasTargetY:Number = 0;

		/**
		 */
		public function get canvasTargetY():Number
		{
			return _canvasTargetY;
		}

		/**
		 * @private
		 */
		public function set canvasTargetY(value:Number):void
		{
			_canvasTargetY = value;
		}

		
		/**
		 */		
		public var isFlashing:Boolean = false;
		
		/**
		 */		
		private function get canvas():Sprite
		{
			return control.mainUI.canvas;
		}
		
		/**
		 */		
		private function get bgImgCanvas():Shape
		{
			return control.mainUI.bgImgCanvas;
		}
	}
}