package view.interact.zoomMove
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kvs.utils.MathUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import util.layout.CanvasLayoutPacker;
	
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
				canvasTargetRotation = canvas.rotation;
				canvasTargetScale = canvas.scaleX;
				canvasTargetX = canvas.x;
				canvasTargetY = canvas.y;
			}
		}
		
		/**
		 */		
		public function close(toEnd:Boolean = false):void
		{
			isFlashing = false;
			TweenMax.killTweensOf(canvas, toEnd);
			if (packer)
			{
				TweenMax.killTweensOf(packer, toEnd);
				packer.modCanvasPositionEnd();
			}
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
			if (MathUtil.equals(MathUtil.log2(canvas.scaleX), MathUtil.log2(canvasTargetScale)) && 
				MathUtil.equals(MathUtil.modRotation(canvas.rotation), MathUtil.modRotation(canvasTargetRotation)) && 
				MathUtil.equals(canvas.x, canvasTargetX) && 
				MathUtil.equals(canvas.y, canvasTargetY))
				return;
			if (Math.max(canvasTargetScale / canvas.scaleX, canvas.scaleX / canvasTargetScale) > 1.0005)
				control.mainUI.curScreenState.disableCanvas();
			
			
			if (packer == null) 
				packer = new CanvasLayoutPacker(control.mainUI);
			else
				TweenMax.killTweensOf(packer, false);
			
			canvasTargetRotation = MathUtil.modTargetRotation(packer.rotation, canvasTargetRotation);
			
			
			var scalePlus:Number = Math.abs(MathUtil.log2(canvasTargetScale) - MathUtil.log2(canvas.scaleX));
			var timeScale:Number = (scalePlus < control.plusScale) ? control.plusScale / speedScale + scalePlus / speedScale : scalePlus / speedScale;
			var timeRotation:Number = Math.abs(canvasTargetRotation - packer.rotation) / speedRotation;
			var time:Number = Math.min(Math.max(timeScale, timeRotation, control.minTweenTime), control.maxTweenTime);
			trace("time==============================");
			trace("scale:", timeScale);
			trace("rotation:", timeRotation);
			
			//缩放差距不大时启用先缩小后放大式镜头缩放
			if (scalePlus < 1)
			{
				var canvasMiddleScale:Number = MathUtil.exp2(MathUtil.log2(Math.min(canvasTargetScale, canvas.scaleX)) - control.plusScale);
				packer.modCanvasPositionStart(canvasTargetX, canvasTargetY, canvasTargetScale, canvasTargetRotation, true, canvasMiddleScale);
				TweenMax.to(packer, time * .5, {
					scale:MathUtil.log2(canvasMiddleScale), 
					ease:Quad.easeOut
				});
				TweenMax.to(packer, time * .5, {
					scale:MathUtil.log2(canvasTargetScale), 
					delay:time * .5, 
					ease:Quad.easeIn
				});
				TweenMax.to(packer, time, {
					rotation:canvasTargetRotation, 
					ease:easeFlash, 
					onUpdate:updated, 
					onComplete:finishZoom
				});
			}
			else
			{
				packer.modCanvasPositionStart(canvasTargetX, canvasTargetY, canvasTargetScale, canvasTargetRotation);
				TweenMax.to(packer, time, {
					scale:MathUtil.log2(canvasTargetScale), 
					rotation:canvasTargetRotation, 
					ease:easeFlash, 
					onUpdate:updated, 
					onComplete:finishZoom
				});
			}
			isFlashing = true;
		}
		
		private var packer:CanvasLayoutPacker;
		
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
			if (packer) packer.modCanvasPositionEnd();
			
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
		
		private var speedScale:Number = 4;
		private var speedRotation:Number = 90;
	}
}