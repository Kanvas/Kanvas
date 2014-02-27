package modules.pages
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import util.LayoutUtil;
	
	import view.ui.MainUIBase;
	import model.vo.PageVO;

	public final class PageUtil
	{
		public static function getSceneFromVO(pageVO:PageVO, mainUI:MainUIBase):Scene
		{
			var scene:Scene = new Scene;
			//scale
			var vw:Number = mainUI.bound.width;
			var vh:Number = mainUI.bound.height;
			var pw:Number = pageVO.scale * pageVO.width;
			var ph:Number = pageVO.scale * pageVO.height;
			scene.scale = ((vw / vh) > (pw / ph)) ? vh / ph : vw / pw;
			//rotation
			scene.rotation = MathUtil.modRotation(- pageVO.rotation);
			scene.rotation = (scene.rotation > 180) ? scene.rotation - 360 : scene.rotation;
			//position
			var plus:Point = new Point(pageVO.x * scene.scale, pageVO.y * scene.scale);
			PointUtil.rotate(plus, MathUtil.angleToRadian(scene.rotation));
			
			scene.x = (mainUI.bound.left + mainUI.bound.right) * .5 - plus.x;
			scene.y = (mainUI.bound.top + mainUI.bound.bottom) * .5 - plus.y;
			return scene;
		}
		
		public static function getThumbByPageVO(pageVO:PageVO, w:Number, h:Number, mainUI:MainUIBase):BitmapData
		{
			//scale
			var vw:Number = w;
			var vh:Number = h;
			var pw:Number = pageVO.scale * pageVO.width;
			var ph:Number = pageVO.scale * pageVO.height;
			var scale:Number = ((vw / vh) > (pw / ph)) ? vh / ph : vw / pw;
			var rotation:Number = -pageVO.rotation;
			var radian  :Number = MathUtil.angleToRadian(pageVO.rotation);
			var cos:Number = Math.cos(radian);
			var sin:Number = Math.sin(radian);
			//算出pageVO的左上角point
			var tp:Point = new Point;
			tp.x = - .5 * pageVO.scale * pageVO.width;
			tp.y = - .5 * pageVO.scale * pageVO.height;
			var rx:Number = tp.x * cos - tp.y * sin;
			var ry:Number = tp.x * sin + tp.y * cos;
			tp.x = rx + pageVO.x;
			tp.y = ry + pageVO.y;
			LayoutUtil.convertPointCanvas2Stage(tp, -(vw - pw * scale) * .5, -(vh - ph * scale) * .5, scale, rotation);
			mainUI.canvas.toShotcutState(-tp.x, -tp.y, scale, rotation);
			var bmd:BitmapData = BitmapUtil.drawWithSize(mainUI.canvas, w, h, false);
			mainUI.canvas.toPreviewState();
			return bmd;
		}
	}
}