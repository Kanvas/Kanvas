package modules.pages
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	
	import flash.geom.Point;
	
	import view.ui.MainUIBase;

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
			var plus:Point = PointUtil.rotate(new Point(pageVO.x * scene.scale, pageVO.y * scene.scale), new Point(0, 0), MathUtil.angleToRadian(scene.rotation));
			
			scene.x = (mainUI.bound.left + mainUI.bound.right) * .5 - plus.x;
			scene.y = (mainUI.bound.top + mainUI.bound.bottom) * .5 - plus.y;
			return scene;
		}
	}
}