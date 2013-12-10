package view.element.shapes
{
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ElementVO;
	import model.vo.LineVO;
	
	import view.element.ElementBase;
	
	/**
	 * 单箭头线条
	 */	
	public class ArrowLine extends LineElement
	{
		public function ArrowLine(vo:ElementVO)
		{
			super(vo);
			
			xmlData = <arrowLine/>
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			return new ArrowLine(cloneVO(new LineVO));
		}
		
		/**
		 * 效果绘制的范围需要从全局获取
		 */		
		override public function renderHoverEffect(style:Style):void
		{
			var wDis:Number = (style.width - vo.width) / 2;
			var hDis:Number = 15;
			
			hoverEffectShape.graphics.clear();
			StyleManager.setLineStyle(hoverEffectShape.graphics, style.getBorder);
			hoverEffectShape.graphics.drawRect(style.tx + style.width / 2 - wDis, 
				style.ty - hDis, style.width / 2 + wDis, style.height + hDis * 2);
			hoverEffectShape.graphics.endFill();
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			
			graphics.moveTo(lineVO.width / 2, 0);
			graphics.lineTo(lineVO.width / 2 - 20, - 15);
			
			graphics.moveTo(lineVO.width / 2, 0);
			graphics.lineTo(lineVO.width / 2 - 20, 15);
		}
	}
}