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
	import model.vo.PageVO;
	
	import modules.pages.PageUtil;
	import modules.pages.Scene;
	
	import util.CoreUtil;
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
		public function getShotCut(w:Number, h:Number):BitmapData
		{
			var canvasRect:Rectangle = LayoutUtil.getContentRect(canvas, false);
			var cw:Number = canvasRect.width;
			var ch:Number = canvasRect.height;
			var vw:Number = w;
			var vh:Number = h;
			if (cw && ch && vw && vh)
			{
				var scale:Number = ((vw / vh) > (cw / ch)) ? vh / ch : vw / cw;
				var rotation:Number = 0;
				var tp:Point = new Point(canvasRect.x, canvasRect.y);
				LayoutUtil.convertPointCanvas2Stage(tp, -(vw - cw * scale) * .5, -(vh - ch * scale) * .5, scale, rotation);
				canvas.toShotcutState(-tp.x, -tp.y, scale, 0);
				var bmd:BitmapData = BitmapUtil.drawWithSize(canvas, vw, vh);
				canvas.toPreviewState();
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