package com.kvs.ui.scroll
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.kvs.ui.FiUI;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;

	/**
	 * 
	 */	
	public class VScrollControl
	{
		/**
		 * 垂直滚动控制器
		 * 
		 * @sourceView 含有滚动内容信息的对象，滚动区域大小，滚动了多少都可以从这里获取到信息；
		 * 
		 * @baseView 滚动内容位于此容器中，滚动遮罩也会被在此处被创建并设置给被滚动的元素， 滚动条也会被
		 * 
		 * 添加到  baseView上
		 * 
		 * 
		 * 这里把 sourceView 与 viewForMask分离开来， view实现了所有接口， viewForMask仅仅是一个装载需要滚动内容的
		 * 
		 * 容器。通常也可以把它们合为同一个对象看。
		 */		
		public function VScrollControl(sourceView:IVScrollView)
		{
			this.sourceView = sourceView;
			
			sourceView.viewCanvas.mask = viewMask;
			sourceView.scrollApp.addChild(viewMask);
			
			scrollBar.alpha = 0;
			scrollBar.w = this.barWidth;
			scrollBar.x = sourceView.viewWidth + (sourceView.scrollApp.w - sourceView.viewWidth - barWidth) / 2;
			
			sourceView.scrollApp.addChild(scrollBar);
			scrollBar.addEventListener(MouseEvent.MOUSE_DOWN, scrolBarDown, false, 0, true);
			
			sourceView.scrollApp.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
			sourceView.scrollApp.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
		}
		
		/**
		 */		
		private function rollOverHandler(evt:MouseEvent):void
		{
			sourceView.scrollApp.stage.addEventListener(MouseEvent.MOUSE_WHEEL, rollHandler, false, 0, true);
		}
		
		/**
		 */		
		private function rollOutHandler(evt:MouseEvent):void
		{
			sourceView.scrollApp.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, rollHandler);
		}
		
		/**
		 * 
		 */		
		private function rollHandler(evt:MouseEvent):void
		{
			if (evt.delta < 0)
				barPos -= scrollPer;
			else
				barPos += scrollPer;
			
			scroll();
		}
		
		/**
		 * 每次鼠标滚轮滚动的距离 
		 */		
		private var scrollPer:uint = 20;
		
		/**
		 */		
		private function scroll():void
		{
			if(barPos < minScrollBarY)
				barPos = minScrollBarY;
			else if (barPos > maxScrollBarY)
				barPos = maxScrollBarY;
			
			var off:Number;
			
			if (this.sourceView.viewHeight < this.sourceView.fullSize)
			{
				scrollBar.y = barPos;
				off = (minScrollBarY - barPos) / barScrollDis * (this.sourceView.fullSize - this.sourceView.viewHeight)
			}
			else
			{
				scrollBar.y = minScrollBarY;
				off = 0;
			}
			
			TweenMax.to(sourceView, 0.3, {off: off});
		}
		
		/**
		 * 显示区域的遮罩
		 */		
		private var viewMask:Shape = new Shape;
		
		/**
		 * 刷新滚动状态，应用初始化或者尺寸，内容变化时
		 * 
		 * 触发；
		 */		
		public function update():void
		{
			if (this.sourceView.viewHeight >= this.sourceView.fullSize)
			{
				this.sourceView.off = 0;
				
				scrollBar.y = minScrollBarY
				TweenLite.to(scrollBar, 0.5, {alpha: 0});
			}
			else
			{
				this.sourceView.off = 0;
				barHeight = this.sourceView.viewHeight / this.sourceView.fullSize * this.sourceView.viewHeight;
				barPos = minScrollBarY - this.sourceView.off / (this.sourceView.fullSize - this.sourceView.viewHeight) * barScrollDis
				
				scrollBar.h = barHeight;
				scrollBar.render();
				scrollBar.y = barPos;
				
				TweenLite.to(scrollBar, 0.3, {alpha: 1});
			}
			
		}
		
		/**
		 * 滚动条最小y坐标
		 */		
		private function get minScrollBarY():Number
		{
			return sourceView.maskRect.y + 5//滚动条上下各留一点间隙;
		}
		
		/**
		 * 滚动条最大y坐标
		 */		
		private function get maxScrollBarY():Number
		{
			return minScrollBarY + barScrollDis;
		}
		
		/**
		 * 滚动条能滚动的最大范围
		 */		
		private function get barScrollDis():Number
		{
			return this.sourceView.viewHeight - barHeight - 10
		}
		
		/**
		 */		
		public function updateMaskArea():void
		{
			// 绘制遮罩
			viewMask.graphics.clear();
			viewMask.graphics.beginFill(0, 0.3);
			viewMask.graphics.drawRect(sourceView.maskRect.x, sourceView.maskRect.y, 
				sourceView.maskRect.width, sourceView.maskRect.height);
			viewMask.graphics.endFill();
		}
		
		
		
		
		//----------------------------------------------
		//
		//
		//  滚动条拖动控制
		//
		//
		//----------------------------------------------
		
		/**
		 */		
		private function scrolBarDown(evt:MouseEvent):void
		{
			sourceView.scrollApp.stage.addEventListener(MouseEvent.MOUSE_MOVE, scrollBarMove, false, 0, true);
			sourceView.scrollApp.stage.addEventListener(MouseEvent.MOUSE_UP, scrollBarUp, false, 0, true);
			
			startY = scrollBar.y;
			startMY = evt.stageY
		}
		
		/**
		 * 开始拖动时， 滚动条的y值
		 */		
		private var startY:Number = 0;
		
		/**
		 * 开始拖动时 stage 的mouseY值
		 */		
		private var startMY:Number = 0;
		
		/**
		 */		
		private function scrollBarUp(evt:MouseEvent):void
		{
			sourceView.scrollApp.stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollBarMove);
			sourceView.scrollApp.stage.removeEventListener(MouseEvent.MOUSE_UP, scrollBarUp);
		}
		
		/**
		 */		
		private function scrollBarMove(evt:MouseEvent):void
		{
			barPos = startY + evt.stageY - startMY;
			scroll();
		}
		
		/**
		 * 滚动条高度， 动态计算得来 
		 */		
		private var barHeight:Number = 0;
		
		/**
		 * 滚动条位置， 动态计算而来 
		 */		
		private var barPos:Number = 0;
		
		/**
		 * 被滚动对象，这里含有滚动信息和被滚动的内容
		 */		
		private var sourceView:IVScrollView;
		
		/**
		 */		
		private var _barWidth:Number = 5;

		/**
		 * 滚动条的宽度
		 */
		public function get barWidth():Number
		{
			return _barWidth;
		}

		/**
		 * @private
		 */
		public function set barWidth(value:Number):void
		{
			_barWidth = value;
			
			scrollBar.w = _barWidth;
			scrollBar.x = sourceView.viewWidth + (sourceView.scrollApp.w - sourceView.viewWidth - barWidth) / 2;
		}

		/**
		 */		
		private var scrollBar:ScrollBarUI = new ScrollBarUI;
		
	}
}