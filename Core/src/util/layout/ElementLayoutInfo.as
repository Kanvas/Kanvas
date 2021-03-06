package util.layout
{
	import flash.geom.Point;
	
	import model.vo.ElementVO;
	
	import view.element.ElementBase;

	/**
	 * 当前图形元件的布局信息获取器， 获取的尺寸
	 * 
	 * 位置信息是相对于整个stage的；
	 * 
	 * 用于定位型变框和状态感应框（鼠标滑入滑出效果）
	 */	
	public class ElementLayoutInfo
	{
		public function ElementLayoutInfo(transformer:LayoutTransformer)
		{
			this.transformer = transformer;
		}
		
		/**
		 */		
		public var transformer:LayoutTransformer;
		
		/**
		 * 重新获取位置尺寸信息
		 */		
		public function update():void
		{
			if (currentElementUI)
			{
				_width = currentElementUI.scaledWidth * transformer.canvas.scaleX;
				_height = currentElementUI.scaledHeight * transformer.canvas.scaleY;
				
				//左上角坐标
				_tx =  - _width / 2;
				_ty = - _height / 2;      
				
				updateXY();
			}
			
		}
		
		/**
		 */		
		public function updateXY():void
		{
			_x = transformer.elementXToStageX(currentElementUI.x);
			_y = transformer.elementYToStageY(currentElementUI.y);
		}
		
		/**
		 * 左上角的x坐标
		 */		
		public function get tx():Number
		{
			return _tx;
		}
		
		/**
		 * 左上角的y坐标
		 */		
		public function get ty():Number
		{
			return _ty;
		}
		
		/**
		 */		
		private var _tx:Number;
		private var _ty:Number;
		
		/**
		 * 中心点x坐标
		 */		
		public function get x():Number
		{
			return _x;
		}
		
		/**
		 */		
		public function get y():Number
		{
			return _y;
		}
		
		private var _x:Number;
		private var _y:Number;
		
		
		/**
		 */		
		public function get width():Number
		{
			return _width;
		}
		
		/**
		 */		
		public function get height():Number
		{
			return _height;
		}
		
		/**
		 */		
		private var _width:Number;
		private var _height:Number;
		
		/**
		 */		
		public function angle():Number
		{
			return currentElementVo.rotation;
		}
		
		/**
		 */		
		private var center:Point;
		
		/**
		 */		
		private function get currentElementVo():ElementVO
		{
			return currentElementUI.vo;
		}
		
		/**
		 */		
		public function get currentElementUI():ElementBase
		{
			return _curElement;
		}
		
		/**
		 */		
		public function set currentElementUI(value:ElementBase):void
		{
			if(value && value != _curElement)
			{
				_curElement = value;
			}
		}
		
		/**
		 */		
		private var _curElement:ElementBase;
		
	}
}