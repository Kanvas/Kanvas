package view.interact.zoomMove
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
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
			if (packer) packer.modCanvasPositionEnd();
			if (Math.max(canvasTargetScale / canvas.scaleX, canvas.scaleX / canvasTargetScale) > 1.0005)
				control.mainUI.curScreenState.disableCanvas();
			
			TweenMax.killTweensOf(canvas, false);
			TweenMax.to(canvas, time, {scaleX: canvasTargetScale, scaleY: canvasTargetScale, x: canvasTargetX, y: canvasTargetY, 
				ease : easeFlash, 
				onUpdate : updated,
				onComplete : finishZoom});
			
			isFlashing = true;	
		}
		
		public function advancedFlash(easeFlash:Object = null):void
		{
			if (Math.max(canvasTargetScale / canvas.scaleX, canvas.scaleX / canvasTargetScale) > 1.0005)
				control.mainUI.curScreenState.disableCanvas();
			
			if (canvas == null) return;
			if (packer == null) 
				packer = new Packer(canvas);
			else
				TweenMax.killTweensOf(packer, false);
			
			packer.modCanvasPositionStart(canvasTargetX, canvasTargetY, canvasTargetScale, canvasTargetRotation);
			
			var scalePlus:Number = Math.max(canvasTargetScale / packer.scale, packer.scale / canvasTargetScale);
			var timeScale:Number = (scalePlus / speedScale) * ((scalePlus < 1.25) ? 2 : 1);
			var timeRotation:Number = Math.abs(canvasTargetRotation - packer.rotation) / speedRotation;
			var timeMove:Number = Point.distance(new Point(packer.x, packer.y), new Point(canvasTargetX, canvasTargetY)) / speedMove;
			trace("scale:", timeScale, "\nrotation:", timeRotation, "\nmove:", timeMove);
			var time:Number = Math.min(Math.max(timeScale, timeRotation, timeMove, 1), 2);
			
			//缩放差距不大时启用先缩小后放大式镜头缩放
			if (scalePlus < 1.25)
			{
				var canvasMiddleScale:Number = Math.min(canvasTargetScale, packer.scale) / 1.5;
				TweenMax.to(packer, time * .5, {scale:canvasMiddleScale});
				TweenMax.to(packer, time * .5, {scale:canvasTargetScale, delay:time * .5});
				easeFlash = Strong.easeInOut;
			}
			else
			{
				TweenMax.to(packer, time, {scale:canvasTargetScale});
				easeFlash = Strong.easeOut;
			}
			TweenMax.to(packer, time, {rotation:canvasTargetRotation, x:canvasTargetX, y:canvasTargetY, 
				progress: 1, 
				ease : easeFlash,
				onUpdate : updated,
				onComplete : finishZoom});
		}
		
		private var packer:Packer;
		
		/**
		 */		
		private function updated():void
		{
			if (packer) packer.modCanvasPosition();
			
			control.mainUI.synBgImgWidthCanvas();
			
			control.uiMediator.updateAfterZoomMove();
		}
		
		/**
		 */		
		private function finishZoom():void
		{
			if (packer) {
				packer.modCanvasPosition();
				packer.modCanvasPositionEnd();
			}
			control.mainUI.curScreenState.enableCanvas();
			isFlashing = false;
		}
		
		public var canvasTargetRotation:Number = 0;
		
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
		
		
		private var speedMove:Number = 1000;
		private var speedScale:Number = 2.5;
		private var speedRotation:Number = 150;
	}
}