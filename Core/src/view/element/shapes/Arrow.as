package view.element.shapes
{
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.ArrowVO;
	import model.vo.ShapeVO;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.customPoint.CustomPointControl;
	import view.elementSelector.customPoint.ICustomShape;
	
	/**
	 * 单箭头
	 */	
	public class Arrow extends ShapeBase implements ICustomShape
	{
		public function Arrow(vo:ShapeVO)
		{
			super(vo);
			
			xmlData = <arrow/>
		}
		
		/**
		 */		
		public function customRender(selector:ElementSelector, control:CustomPointControl):void
		{
			var scale:Number = selector.layoutInfo.transformer.canvasScale * vo.scale;
			
			var x:Number = selector.mouseX;
			var y:Number = selector.mouseY;
			
			if (y < - vo.height / 2 * scale)
				y = - vo.height / 2 * scale;
			
			if (y > 0)
				y = 0;
			
			if (x < - vo.width / 2 * scale)
				x = - vo.width / 2 * scale;
			
			if (x > vo.width / 2 * scale)
				x = vo.width / 2 * scale;
			
			arrowVO.arrowWidth = (vo.width / 2 * scale - x) / scale;
			arrowVO.trailHeight = - y * 2 / scale;
			
			this.render();
			selector.render();
		}
		
		/**
		 */		
		public function layoutCustomPoint(selector:ElementSelector):void
		{
			var scale:Number = selector.layoutInfo.transformer.canvasScale * vo.scale;
			
			selector.customPointControl.x = (vo.width / 2 - arrowVO.arrowWidth) * scale;
			selector.customPointControl.y = - arrowVO.trailHeight / 2 * scale;
		}
		
		
		public function get propertyNameArray():Array
		{
			return _propertyNameArray;
		}
		
		private const _propertyNameArray:Array = ["arrowWidth", "trailHeight"]
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var arrowVO:ArrowVO = new ArrowVO;
			arrowVO.arrowWidth = this.arrowVO.arrowWidth;
			arrowVO.trailHeight = this.arrowVO.trailHeight;
			
			return new Arrow(cloneVO(arrowVO) as ArrowVO);
		}
		
		/**
		 */		
		protected function get arrowVO():ArrowVO
		{
			return vo as ArrowVO;
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			StyleManager.setShapeStyle(vo.style, graphics, vo);
			
			// 从箭头的顶点开始绘制，顺时针绕一圈
			graphics.moveTo(vo.width / 2, 0);
			graphics.lineTo(vo.width / 2 - arrowVO.arrowWidth, vo.height / 2);
			graphics.lineTo(vo.width / 2 - arrowVO.arrowWidth, arrowVO.trailHeight / 2);
			graphics.lineTo( - vo.width / 2, arrowVO.trailHeight / 2);
			
			//--------------------中轴线--------------------------------------------------------------
			
			graphics.lineTo( - vo.width / 2, - arrowVO.trailHeight / 2);
			graphics.lineTo(vo.width / 2 - arrowVO.arrowWidth, - arrowVO.trailHeight / 2);
			graphics.lineTo(vo.width / 2 - arrowVO.arrowWidth, - vo.height / 2);
			graphics.lineTo(vo.width / 2, 0);
			
			graphics.endFill();
		}
		
		/**
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			super.showControlPoints(selector);
			
			ViewUtil.show(selector.customPointControl);
		}
		
		/**
		 * 隐藏型变控制点
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			super.hideControlPoints(selector);
			
			ViewUtil.hide(selector.customPointControl)
		}
		
		/**
		 * 
		 */		
		override public function hideFrameOnMdown(selector:ElementSelector):void
		{
			super.hideFrameOnMdown(selector);
			
			ViewUtil.hide(selector.customPointControl);
		}
		
		/**
		 */		
		override public function showSelectorFrame(selector:ElementSelector):void
		{
			super.showSelectorFrame(selector);
			
			ViewUtil.show(selector.customPointControl);
		}
		
	}
	
}