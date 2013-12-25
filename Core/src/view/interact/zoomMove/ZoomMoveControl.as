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
		 * 同步canvas与背景图片的比例位置关系， 此方法在初始化， 插入背景图和画布缩放
		 * 
		 * 及移动时需要被调用
		 */		
		public function synBgImgWidthCanvas():void
		{
			var cDisX:Number = canvas.x - canvas.stage.stageWidth / 2;
			var cDisY:Number = canvas.y - canvas.stage.stageHeight / 2;
			
			//移动的比例因子，画布比例越大，背景图片的移动因子越小
			var pS:Number = (Zoommer.maxScale - canvas.scaleX) / Zoommer.maxScale * 0.9;
			bgImgCanvas.x = canvas.stage.stageWidth / 2 + cDisX * pS;
			bgImgCanvas.y = canvas.stage.stageHeight / 2 + cDisY * pS;
			
			//尺寸比例因子，背景图片的比例浮动要比canvas小很多
			var sS:Number = 1 + (canvas.scaleX / Zoommer.minScale) / (Zoommer.maxScale / Zoommer.minScale) * 10;
			bgImgCanvas.scaleX = bgImgCanvas.scaleY = sS;
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
		public function autoZoom():void
		{
			zoomer.zoomAuto();
		}
		
		public function setScreenState(state:String):void
		{
			var center:Point = new Point;
			center.x = (mainUI.stage.stageWidth  * .5 - canvas.x) / canvas.scaleX;
			center.y = (mainUI.stage.stageHeight * .5 - canvas.y) / canvas.scaleX;
			mainUI.stage.displayState = state;
			canvas.x = mainUI.stage.stageWidth  * .5 - center.x;
			canvas.y = mainUI.stage.stageHeight * .5 - center.y;
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