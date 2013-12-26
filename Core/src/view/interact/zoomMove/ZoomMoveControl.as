package view.interact.zoomMove
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	
	import flash.display.Shape;
	import flash.display.StageDisplayState;
	import flash.geom.Point;
	
	import view.ui.Canvas;
	import view.ui.IMainUIMediator;
	import view.ui.MainUIBase;

	/**
	 * 
	 */	
	public class ZoomMoveControl
	{
		public function ZoomMoveControl(mainUI:MainUIBase, uiMediator:IMainUIMediator)
		{
			this.mainUI = mainUI;
			this.uiMediator = uiMediator;
			
			flasher = new Flasher(this);
			zoomer = new Zoommer(this);
			mover = new Mover(this);
		}
		
		/**
		 * 
		 */		
		public function zoomTo(scale:Number, mouseCenter:Point = null, time:Number = 1, ease:Object = null):void
		{
			if (ease == null)
				ease = Cubic.easeInOut;
			
			zoomer.zoomTo(scale, mouseCenter, time, ease);
		}
		
		/**
		 */		
		public function zoomIn(isMouseCenter:Boolean = false):void
		{
			zoomer.zoomIn(isMouseCenter);
		}
		
		/**
		 */		
		public function zoomOut(isMouseCenter:Boolean = false):void
		{
			zoomer.zoomOut(isMouseCenter);
		}
		
		/**
		 */		
		public function autoZoom(originalScale:Boolean = false):void
		{
			zoomer.zoomAuto(originalScale);
		}
		
		/**
		 * 生效背景交互
		 */		
		public function enableBGInteract():void
		{
			mover.ifEnable = true;
		}
		
		/**
		 * 禁止背景交互
		 */		
		public function disableBgInteract():void
		{
			mover.ifEnable = false;
		}
		
		/**
		 */		
		private function get canvas():Canvas
		{
			return mainUI.canvas;
		}
		
		/**
		 */		
		private function get bgImgCanvas():Shape
		{
			return mainUI.bgImgCanvas;
		}
		
		public var zoomScale:Number = 1.2;
		
		/**
		 * 默认不管画布中的元素有多大都自动对焦， 关闭后则
		 * 
		 * 大于1:1下画布尺寸时才自动对焦，缩小画布比例适应内容；
		 * 
		 * 小于画布默认尺寸时仅居中对齐
		 */		
		public var ifAutoZoom:Boolean = true;
		
		/**
		 * 移动画布时，吃属性会开启；用来判断防止按下Control时进入多选状态 
		 */		
		public var isMoving:Boolean = false;
		
		/**
		 */		
		internal var flasher:Flasher;
		
		/**
		 */		
		private var zoomer:Zoommer;
		
		/**
		 */		
		private var mover:Mover;
		
		/**
		 */		
		internal var mainUI:MainUIBase;
		
		/**
		 */		
		internal var uiMediator:IMainUIMediator;
	}
}