package view.ui
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	
	import modules.pages.PageUtil;
	import model.vo.PageVO;
	import modules.pages.Scene;
	
	import util.LayoutUtil;
	
	/**
	 * 
	 * 截图管理器，负责生成kanvas的截图
	 * 
	 */	
	public class ThumbManager
	{
		public function ThumbManager(app:CoreApp)
		{
			this.core = app;
		}
		
		/**
		 */		
		private var core:CoreApp;
		
		/**
		 * 输出指定宽高的截图，此截图为全场景范围
		 */		
		public function getShotCut(width:Number, height:Number):BitmapData
		{
			//canvas.clearBG();
			
			var w:Number = canvas.width;
			var h:Number = canvas.height;
			
			if (w && h)
			{
				var canvasScale:Number = canvas.scaleX;
				var bgimgScale:Number = bgImg.scaleX;
				
				if (w * h > 16000000)
				{
					var t:Number = (w > h) ? 1000 / w : 1000 / h;
					bgImg.scaleX = bgImg.scaleY = canvas.scaleX = canvas.scaleY *= t;
					w *= t;
					h *= t;
				}
				
				var c:Sprite = new Sprite;
				var m:Shape = new Shape;
				
				m.graphics.beginFill(0);
				m.graphics.drawRect(0, 0, width, height);
				m.graphics.endFill();
				
				//绘制背景色
				c.graphics.beginFill(uint(CoreFacade.coreProxy.bgVO.color));
				c.graphics.drawRect(0, 0, width, height);
				c.graphics.endFill();
				
				var canvasRect:Rectangle = canvas.getBounds(canvas);
				var canvasBmd:BitmapData = new BitmapData(canvasRect.width, canvasRect.height, true, 0);
				canvasBmd.draw(canvas, new Matrix(1, 0, 0, 1, - canvasRect.left, - canvasRect.top));
				var canvasBmp:Bitmap = new Bitmap(canvasBmd);
				var bwh:Number = canvasBmp.width / canvasBmp.height;
				var swh:Number = width / height;
				var aim:Number = (bwh > swh) ? width / canvasBmp.width : height / canvasBmp.height;
				canvasBmp.scaleX = canvasBmp.scaleY = aim;
				canvasBmp.x = (width - canvasBmp.width) * .5;
				canvasBmp.y = (height - canvasBmp.height) * .5;
				canvasBmp.smoothing = true;
				c.addChild(canvasBmp);
				
				canvas.scaleX = canvas.scaleY = canvasScale;
				
				if (bgImg.width && bgImg.height)// 防止无背景图片时的异常
				{
					var bgimgRect:Rectangle = bgImg.getBounds(bgImg);
					var bgimgBmd:BitmapData = new BitmapData(bgimgRect.width, bgimgRect.height, true, 0);
					bgimgBmd.draw(bgImg, new Matrix(1, 0, 0, 1, - bgimgRect.left, - bgimgRect.top));
					var bgimgBmp:Bitmap = new Bitmap(bgimgBmd);
					bgImg.scaleX = bgImg.scaleY = bgimgScale;
					bgimgBmp.scaleX = bgimgBmp.scaleY = aim;
					bgimgBmp.x = (width - bgimgBmp.width) * .5;
					bgimgBmp.y = (height - bgimgBmp.height) * .5;
					bgimgBmp.smoothing = true;
					c.addChildAt(bgimgBmp, 0);
				}
				
				c.mask = m;
				c.addChild(m);
				c.y = 100;
				
				//core.addChild(c);
				
				var bmd:BitmapData = new BitmapData(width, height);
				bmd.draw(c);
			}
			
			return bmd;
		}
		
		/**
		 */		
		private function get canvas():Canvas
		{
			return core.canvas;
		}
		
		private function get bgImg():Shape
		{
			return core.bgImgCanvas;
		}
	}
}