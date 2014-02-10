package view.ui
{
	import com.kvs.utils.RectangleUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import view.screenState.FullScreenState;
	import view.screenState.NormalScreenState;
	import view.screenState.ScreenStateBase;
	
	/**
	 */	
	public class MainUIBase extends Sprite
	{
		public function MainUIBase()
		{
			super();
			
			normalState = new NormalScreenState(this);
			fullscreenState = new FullScreenState(this);
			curScreenState = normalState;
			
			// 背景颜色
			this.addChild(bgColorCanvas);
			this.addChild(bgImgCanvas);
			
			canvas = new Canvas(this);
			addChild(canvas);
		}
		
		
		/**
		 */		
		public var curScreenState:ScreenStateBase; 
		
		/**
		 */		
		public var normalState:ScreenStateBase;
		
		/**
		 */		
		public var fullscreenState:ScreenStateBase;
		
		/**
		 */		
		private var _canvas:Canvas;
		
		/**
		 * 画布, 绘制背景图片，图形，文字，线条的地方
		 */
		public function get canvas():Canvas
		{
			return _canvas;
		}
		
		/**
		 * @private
		 */
		public function set canvas(value:Canvas):void
		{
			_canvas = value;
		}
		
		/**
		 */		
		private var _boundForAutoZoom:Rectangle;
		
		/**
		 * 画布自动缩放的范围(剔除工具条，面板等)
		 */
		public function get bound():Rectangle
		{
			return _boundForAutoZoom;
		}
		
		/**
		 * @private
		 */
		public function set bound(value:Rectangle):void
		{
			_boundForAutoZoom = value;
			
			__boundDiagonalDistance = RectangleUtil.getDiagonalDistance(bound);
			
			this.dispatchEvent(new KVSEvent(KVSEvent.UPATE_BOUND));
		}
		
		public function get boundDiagonalDistance():Number
		{
			return  __boundDiagonalDistance;
		}
		
		private var __boundDiagonalDistance:Number;
		
		/**
		 */		
		private var _bgColorCanvas:Sprite = new Sprite;
		
		/**
		 * 用来绘制背景色, 接收鼠标交互，控制画布行为
		 */
		public function get bgColorCanvas():Sprite
		{
			return _bgColorCanvas;
		}
		
		/**
		 * @private
		 */
		public function set bgColorCanvas(value:Sprite):void
		{
			_bgColorCanvas = value;
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
			var s:Number = Math.pow(canvas.scaleX, 0.5);
			
			bgImgCanvas.scaleX = bgImgCanvas.scaleY = s;
			
			var p:Number = s / canvas.scaleX / 4;
			
			if(p > 1)
				p = 1;
			
			bgImgCanvas.x = canvas.stage.stageWidth / 2 + cDisX * p;
			bgImgCanvas.y = canvas.stage.stageHeight / 2 + cDisY * p;
		}
		
		/**
		 */		
		public var scale3D:Number = 8;
		
		/**
		 */		
		public function clearBGImg():void
		{
			bgImgCanvas.graphics.clear();
			canvas.graphics.clear();
		}
		
		/**
		 * 在画布的正中心绘制背景图片
		 */		
		public function drawBGImg(bmd:BitmapData):void
		{
			clearBGImg();
			
			// 图片数据为空时，仅删除背景图
			if (bmd)
			{
				var scale:Number;
				//舞台区域为相对长方形， 以背景图高度为基准等比缩放
				if (stage.width / stage.height > bmd.width / bmd.height)
					scale =  stage.height / bmd.height;
					
				else
					scale = stage.width / bmd.width;
				
				BitmapUtil.drawBitmapDataToShape(bmd, bgImgCanvas, bmd.width , bmd.height, 
					- bmd.width / 2, - bmd.height / 2, false);
				
				canvas.scaleX = canvas.scaleY = 1;
				canvas.x = bound.x + bound.width / 2;
				canvas.y = bound.y + bound.height / 2;
					
				synBgImgWidthCanvas();
			}
		}
		
		/**
		 */		
		public var bgImgCanvas:Shape = new Shape;
	}
}