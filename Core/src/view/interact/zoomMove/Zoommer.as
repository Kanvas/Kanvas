package view.interact.zoomMove
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	
	import consts.ConstsTip;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import view.ui.Bubble;
	import view.ui.Canvas;
	import view.ui.MainUIBase;

	/**
	 * 画布缩放控制
	 */
	public class Zoommer
	{
		/**
		 */
		public function Zoommer(control:ZoomMoveControl)
		{
			this.control = control;
		}
		
		/**
		 */		
		private var control:ZoomMoveControl;
		
		/**
		 */		
		private function get canvas():Canvas
		{
			return control.mainUI.canvas;
		}
		
		/**
		 */		
		private function get mainUI():MainUIBase
		{
			return control.mainUI;
		}
		
		/**
		 */		
		private function get flasher():Flasher
		{
			return control.flasher;
		}
		
		
		
		
		
		
		//--------------------------------------------------------------
		//
		//
		//
		//  缩放指令
		//
		//
		//---------------------------------------------------------------
		
		
		/**
		 * 放大画布
		 */
		public function zoomIn(notMouseCenter:Boolean = false):void
		{
			this.flasher.ready();
			
			var newScale:Number = flasher.canvasTargetScale * control.zoomScale;
			
			if (newScale > maxScale)
			{
				newScale = maxScale;
				Bubble.show(ConstsTip.TIP_ZOOM_MAX);
			}
			
			zoom(newScale, notMouseCenter);
			
			flasher.flash(0.5);
		}
		
		/**
		 * 缩小画布
		 */
		public function zoomOut(notMouseCenter:Boolean = false):void
		{
			this.flasher.ready();
			
			var newScale:Number = flasher.canvasTargetScale / control.zoomScale;
			if (newScale < minScale)
			{
				newScale = minScale;
				Bubble.show(ConstsTip.TIP_ZOOM_MIN);
			}
			
			zoom(newScale, notMouseCenter);
			
			flasher.flash(0.5);
		}
		
		public function zoomMoveOff(scale:Number, x:Number, y:Number, time:Number = 1, ease:Object = null):void
		{
			flasher.close(false);
			flasher.ready();
			flasher.canvasTargetScale = canvas.scaleX * scale;
			flasher.canvasTargetX = canvas.x + x;
			flasher.canvasTargetY = canvas.y + y;
			flasher.flash(time, ease);
		}
		
		
		public function zoomTo(newScale:Number, center:Point = null, time:Number = 1, ease:Object = null):void
		{
			flasher.close(false);
			flasher.ready();
			flasher.canvasTargetScale = newScale;
			
			if (center)
			{
				flasher.canvasTargetX = - center.x * newScale + canvas.stage.stageWidth * .5;
				flasher.canvasTargetY = - center.y * newScale + canvas.stage.stageHeight * .5;
			}
			else
			{
				var curScale:Number = canvas.scaleX;
				var scaleDis:Number = newScale - curScale;
				center = new Point(canvas.stage.mouseX, canvas.stage.mouseY);
				
				flasher.canvasTargetX = (canvas.stage.stageWidth / 2 - point.x) * scaleDis / curScale 
					+ canvas.stage.stageWidth / 2 + (canvas.x - canvas.stage.stageWidth / 2) / curScale * newScale;
				
				flasher.canvasTargetY = (canvas.stage.height / 2 - point.y) * scaleDis / curScale 
					+ canvas.stage.height / 2 + (canvas.y - canvas.stage.height / 2) / curScale * newScale;
			}
			
			flasher.flash(time, ease);
		}
		
		public function zoomRotateMoveTo(scale:Number, rotation:Number, x:Number, y:Number, ease:Object = null):void
		{
			flasher.canvasTargetScale = scale;
			flasher.canvasTargetRotation = rotation;
			flasher.canvasTargetX = x;
			flasher.canvasTargetY = y;
			
			flasher.advancedFlash(ease);
		}
		
		/**
		 * 画布中心点到鼠标的距离 × 缩放偏移量  + 画布中心点   + 图形中心点到画布中心点距  × 新比例
		 * 
		 * 整个过程中画布中心点为图形的注册点， 缩放是以此为基准进行的
		 */		
		private function zoom(newScale:Number, notMouseCenter:Boolean = false):void
		{
			var curScale:Number = canvas.scaleX;
			var scaleDis:Number = newScale - curScale;
			flasher.canvasTargetScale = newScale;
			
			if (notMouseCenter) 
			{
				point.x = canvas.stage.stageWidth  * .5;
				point.y = canvas.stage.stageHeight * .5;
			}
			else 
			{
				point.x = canvas.stage.mouseX;
				point.y = canvas.stage.mouseY;
			}
			
			flasher.canvasTargetX = (canvas.stage.stageWidth / 2 - point.x) * scaleDis / curScale 
							   + canvas.stage.stageWidth / 2 + (canvas.x - canvas.stage.stageWidth / 2) / curScale * newScale;
			
			flasher.canvasTargetY = (canvas.stage.height / 2 - point.y) * scaleDis / curScale 
				+ canvas.stage.height / 2 + (canvas.y - canvas.stage.height / 2) / curScale * newScale;
		}
		
		/**
		 * 内容填满画布并居中, 没有内容时， 画布比例为1:1
		 * 
		 * 并居中
		 */
		public function zoomAuto(originalScale:Boolean = false):void
		{
			flasher.close();
			flasher.ready();
			
			if (canvas.ifHasElements)
			{
				canvas.clearBG();// 防止画布背景的干扰
				
				canvasInerBound = canvas.getRect(canvas);
				canvasBound = canvas.getRect(mainUI);
				var scale:Number;
				
				if (canvasInerBound.width / canvasInerBound.height > mainUI.bound.width / mainUI.bound.height)
					scale = mainUI.bound.width / canvasBound.width;
				else
					scale = mainUI.bound.height / canvasBound.height;
				
				//画布保持原比例，不缩放
				if (originalScale)
				{
					flasher.canvasTargetScale = 1;
				}
				else
				{
					if (control.ifAutoZoom == false)
					{
						//检查canvas实际尺寸是否小于窗口尺寸，如果小于，则显示原始比例
						if ( ! (canvasInerBound.width < mainUI.bound.width && canvasInerBound.height < mainUI.bound.height) && ! originalScale)
						{
							flasher.canvasTargetScale *= scale;
						}
						else
						{
							flasher.canvasTargetScale = 1;
						}
					}
					else
					{
						flasher.canvasTargetScale *= scale;
					}
				}
				

				flasher.canvasTargetY = (mainUI.bound.top  - canvasInerBound.top  * flasher.canvasTargetScale) + (mainUI.bound.height - canvasInerBound.height * flasher.canvasTargetScale) * .5;
				flasher.canvasTargetX = (mainUI.bound.left - canvasInerBound.left * flasher.canvasTargetScale) + (mainUI.bound.width  - canvasInerBound.width  * flasher.canvasTargetScale) * .5;
			}
			else
			{
				flasher.canvasTargetScale = 1;
				flasher.canvasTargetX = mainUI.stage.stageWidth / 2;
				flasher.canvasTargetY = mainUI.stage.stageHeight / 2;
			}
			
			flasher.flash(0.8, Cubic.easeInOut);
		}
		
		/**
		 */		
		public static var maxScale:Number = 55;
		
		/**
		 */		
		public static var minScale:Number = 0.005;
		
		
		/**
		 * 画布canvas相对于主UI的布局
		 */
		private var canvasBound:Rectangle;
		
		/**
		 * 画布canvas中的内容相对于自身的布局 
		 */		
		private var canvasInerBound:Rectangle;
		
		private var point:Point = new Point;
		
	}
}