package view.ui
{
	import com.greensock.TweenMax;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.RectangleUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import util.LayoutUtil;
	
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
			addChild(bgColorCanvas);
			addChild(bgImgCanvas);
			bgImgCanvas.mouseEnabled = bgImgCanvas.mouseChildren = false;
			
			addChild(canvas = new Canvas(this));
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
			
			fitBgBitmapToBound();
			
			dispatchEvent(new KVSEvent(KVSEvent.UPATE_BOUND));
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
		public function synBgImgWidthCanvas(tween:Boolean = false):void
		{
			/*var cDisX:Number = canvas.x - canvas.stage.stageWidth  / 2;
			var cDisY:Number = canvas.y - canvas.stage.stageHeight / 2;
			var s:Number = Math.pow(canvas.scaleX, 0.5);
			
			
			bgImgCanvas.scaleX = bgImgCanvas.scaleY = s;
			
			var p:Number = Math.min(1, s / canvas.scaleX / 4);
			
			bgImgCanvas.x = canvas.stage.stageWidth  / 2 + cDisX * p;
			bgImgCanvas.y = canvas.stage.stageHeight / 2 + cDisY * p;*/
			bgImgCanvas.scaleX = bgImgCanvas.scaleY = Math.pow(canvas.scaleX, .1);
			bgImgCanvas.rotation = canvas.rotation;
			var p:Number =  Math.pow(1 / (1 + canvas.scaleX), 2);
			var hw:Number = stage.stageWidth  * .5;
			var hh:Number = stage.stageHeight * .5;
			bgImgCanvas.x = hw + (canvas.x - hw) * p;
			bgImgCanvas.y = hh + (canvas.y - hh) * p;
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
				
				if (bgImgBitmap) bgImgCanvas.removeChild(bgImgBitmap);
				bgImgBitmap = new Bitmap(bmd);
				bgImgBitmap.x = -.5 * bgImgBitmap.width;
				bgImgBitmap.y = -.5 * bgImgBitmap.height;
				bgImgCanvas.addChild(bgImgBitmap);
				fitBgBitmapToBound();
				synBgImgWidthCanvas();
			}
		}
		
		private function fitBgBitmapToBound():void
		{
			if (bgImgBitmap && bound)
			{
				var vw:Number = bound.width;
				var vh:Number = bound.height;
				var bw:Number = bgImgBitmap.width  / bgImgBitmap.scaleX;
				var bh:Number = bgImgBitmap.height / bgImgBitmap.scaleY;
				var ss:Number = 1.5 * ((vw / vh > bw / bh) ? vw / bw : vh / bh);
				TweenMax.to(bgImgBitmap, 1, {scaleX:ss, scaleY:ss, x:-.5 * bw * ss, y:-.5 * bh * ss});
			}
		}
		
		/**
		 */		
		public var bgImgCanvas:Sprite = new Sprite;
		private var bgImgBitmap:Bitmap;
	}
}