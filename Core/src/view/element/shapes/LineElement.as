package view.element.shapes
{
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.geom.Point;
	
	import model.vo.ElementVO;
	import model.vo.LineVO;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 * 线条
	 */	
	public class LineElement extends ElementBase implements IAutoGroupElement
	{
		public function LineElement(vo:ElementVO)
		{
			super(vo);
			
			xmlData = <line/>
		}
		
		
		/**
		 */		
		override public function exportData():XML
		{
			xmlData = super.exportData();
			
			xmlData.@thickness = vo.thickness;
			xmlData.@borderAlpha = vo.style.getBorder.alpha;
			
			return xmlData;
		}
		
		/**
		 */		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.lineShape);
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			return new LineElement(cloneVO(new LineVO));
		}
		
		/**
		 */		
		override public function cloneVO(newVO:ElementVO):ElementVO
		{
			super.cloneVO(newVO);
			
			newVO.type = vo.type;
			newVO.styleID = vo.styleID;
			
			return newVO;
		}
		
		/**
		 */		
		override public function showHoverEffect():void
		{
			var dis:Number = (hoverStyle.width - vo.width) / 2;
			
			hoverEffectShape.graphics.clear();
			StyleManager.setLineStyle(hoverEffectShape.graphics, hoverStyle.getBorder);
			hoverEffectShape.graphics.drawRect(hoverStyle.tx + hoverStyle.width / 2 - dis, hoverStyle.ty, hoverStyle.width / 2 + dis, hoverStyle.height);
			hoverEffectShape.graphics.endFill();
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			this.graphics.clear();
			StyleManager.setLineStyle(graphics, vo.style.getBorder, vo.style, vo);
			graphics.moveTo(0, 0);
			graphics.lineTo(lineVO.width / 2, 0);
		}
		
		/**
		 * 隐藏图形控制点，开启线条控制点
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			ViewUtil.show(selector.lineControl);
			ViewUtil.show(selector.scaleRollControl);
			ViewUtil.hide(selector.scaleRollControl.rollPoint);
		}
		
		/**
		 * 隐藏型变控制点
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			ViewUtil.hide(selector.lineControl);
			ViewUtil.hide(selector.scaleRollControl);
			ViewUtil.show(selector.scaleRollControl.rollPoint);
		}
		
		override public function enableBG():void
		{
			//bg.visible = true;
			//bg.mouseEnabled = true;
		}
		
		/**
		 */		
		override public function disableBG():void
		{
			//bg.mouseEnabled = false;
			//bg.visible = false;
		}
		
		override public function drawBG():void
		{
			var w:Number = Math.max(vo.width * .5, 10);
			var h:Number = Math.max(vo.height * .5, 10);
			bg.graphics.clear();
			bg.graphics.beginFill(0xe0e0e0, 0);
			bg.graphics.drawRect(0, 0, w, h);
			bg.graphics.endFill();
		}
		
		override public function get scaledWidth():Number
		{
			return super.scaledWidth * .5;
		}
		
		override public function get topLeft():Point
		{
			tlPoint.x = 0;
			tlPoint.y = - .5 * vo.scale * vo.height;
			return caculateTransform(tlPoint);
		}
		
		override public function get topCenter():Point
		{
			tcPoint.x =   .25 * vo.scale * vo.width;
			tcPoint.y = - .5  * vo.scale * vo.height;
			return caculateTransform(tcPoint);
		}
		
		override public function get middleLeft():Point
		{
			mlPoint.x = x;
			mlPoint.y = y;
			return mlPoint;
		}
		
		override public function get middleCenter():Point
		{
			mcPoint.x = .25 * vo.scale * vo.width;
			mcPoint.y = 0;
			return caculateTransform(mcPoint);
		}
		
		override public function get bottomLeft():Point
		{
			blPoint.x = 0;
			blPoint.y = .5 * vo.scale * vo.height;
			return caculateTransform(blPoint);
		}
		
		override public function get bottomCenter():Point
		{
			bcPoint.x = .25 * vo.scale * vo.width;;
			bcPoint.y = .5  * vo.scale * vo.height;
			return caculateTransform(bcPoint);
		}
		
		override public function get left():Number
		{
			return x;
		}
		
		/**
		 */		
		protected function get lineVO():LineVO
		{
			return vo as LineVO;
		}
		
	}
}