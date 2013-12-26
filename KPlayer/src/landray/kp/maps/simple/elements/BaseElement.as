package landray.kp.maps.simple.elements
{
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import model.vo.ElementVO;
	
	public class BaseElement extends Sprite
	{
		public function BaseElement($vo:ElementVO)
		{
			super();
			vo = $vo;
			addChild(shape = new Shape);
			
			mouseChildren = false;
			
			shape.cacheAsBitmap = true;
			
			if (vo.style) 
				render();
			//addEventListener(MouseEvent.MOUSE_DOWN, click, true)
		}
		
		
		public function render(scale:Number = 1):void
		{
			updateLayout();
			
			mouseEnabled = buttonMode = vo.property.toLocaleLowerCase() == "true";
			
			if (vo.style) 
			{
				// 中心点为注册点
				vo.style.tx =　-　vo.width  * .5;
				vo.style.ty =　-　vo.height * .5;
				vo.style.width  = vo.width;
				vo.style.height = vo.height;
			}
			
			graphics.clear();
		}
		
		override public function get graphics():Graphics
		{
			return shape.graphics;
		}
		
		/**
		 * 获取在画布所占的矩形范围（不考虑旋转）。
		 */
		public function getRectangleForViewer():Rectangle
		{
			if(!vo.style) 
			{
				vo.style        = new Style;
				vo.style.tx     = - vo.width  * .5;
				vo.style.ty     = - vo.height * .5;
				vo.style.width  =   vo.width;
				vo.style.height =   vo.height;
			}
			
			var rect:Rectangle = new Rectangle;
			
			rect.x      = vo.scale * vo.style.tx;
			rect.y      = vo.scale * vo.style.ty;
			rect.width  = vo.scale * vo.style.width;
			rect.height = vo.scale * vo.style.height;
			
			return rect;
		}
		
		/**
		 * 更新布局范围。
		 */
		public function updateLayout():void
		{
			x = vo.x;
			y = vo.y;
			
			rotation = vo.rotation;
			scaleX = scaleY = vo.scale;
		}
		
		private var shape:Shape;
		
		/**
		 * 对应的ＶＯ结构体。
		 */
		public var vo:ElementVO;
	}
}