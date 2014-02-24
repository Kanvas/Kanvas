package view.element
{
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.Shape;
	
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import model.vo.PageVO;
	import modules.pages.PageEvent;
	
	
	/**
	 * 页面
	 */	
	public final class PageElement extends ElementBase
	{
		public function PageElement(vo:PageVO)
		{
			xmlData = <page/>;
			_screenshot = false;
			
			super(vo);
			vo.addEventListener(PageEvent.DELETE_PAGE_FROM_UI, deletePageHandler);
		}
		
		/**
		 */		
		override public function exportData():XML
		{
			super.exportData();
			
			xmlData.@index = pageVO.index;
			
			return xmlData;
		}
		
		/**
		 */		
		override protected function preRender():void
		{
			super.preRender();
			
			addChild(maskShape = new Shape);
			maskShape.graphics.beginFill(0, 0);
			maskShape.graphics.drawRect(0, 0, 1, 1);
			maskShape.graphics.endFill();
			
			graphicShape.mask = maskShape;
		}
		
		/**
		 * 热点在预览状态时不显示
		 */		
		override public function toPrevState():void
		{
			super.toPrevState();
			
			graphicShape.visible = false;
		}
		
		/**
		 */		
		override public function returnFromPrevState():void
		{
			super.returnFromPrevState();
			
			graphicShape.visible = true;
			
			this.render();
		}
		
		override public function toSelectedState():void
		{
			super.toSelectedState();
			pageVO.dispatchEvent(new PageEvent(PageEvent.PAGE_SELECTED, pageVO, false));
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			graphics.clear();
			
			// 中心点为注册点
			if (vo.style)
			{
				vo.style.tx = - vo.width  / 2;
				vo.style.ty = - vo.height / 2;
				
				vo.style.width  = vo.width;
				vo.style.height = vo.height;
				
				var left  :Number = vo.style.tx;
				var top   :Number = vo.style.ty;
				var right :Number = vo.style.tx + vo.style.width;
				var bottom:Number = vo.style.ty + vo.style.height;
				
				drawInteract(left, top, right - left, bottom - top);
				
				StyleManager.setLineStyle(graphics, vo.style.getBorder, vo.style, vo);
				
				var w:Number = 20;
				
				//left
				graphics.moveTo(left, top);
				graphics.lineTo(left + w, top);
				
				graphics.moveTo(left, bottom);
				graphics.lineTo(left + w, bottom);
				
				graphics.moveTo(left, top);
				graphics.lineTo(left, bottom);
				
				//right
				graphics.moveTo(right, top);
				graphics.lineTo(right - w, top);
				
				graphics.moveTo(right, bottom);
				graphics.lineTo(right - w, bottom);
				
				graphics.moveTo(right, top);
				graphics.lineTo(right, bottom);
				
				maskShape.x = vo.style.tx;
				maskShape.y = vo.style.ty;
				maskShape.width  = vo.style.width;
				maskShape.height = vo.style.height;
			}
		}
		
		/**
		 */		
		override public function del():void
		{
			dispatchEvent(new ElementEvent(ElementEvent.DEL_PAGE, this));
		}
		
		private function drawInteract(x:Number, y:Number, w:Number, h:Number):void
		{
			graphics.beginFill(0, 0);
			//left
			graphics.drawRect(x, y, 40, 20);
			graphics.drawRect(x, y + h - 20, 40, 20);
			graphics.drawRect(x, y, 20, h);
			
			//right
			graphics.drawRect(x + w - 40, y, 40, 20);
			graphics.drawRect(x + w - 40, y + h - 20, 40, 20);
			graphics.drawRect(x + w - 20, y, 20, h);
			graphics.endFill();
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var pageVO:PageVO = new PageVO;
			
			return new PageElement(cloneVO(pageVO) as PageVO);
		}
		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.cameraShape);
		}
		
		/**
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			selector.frame.visible = true;
			ViewUtil.show(selector.sizeControl);
			ViewUtil.show(selector.scaleRollControl);
		}
		
		/**
		 * 隐藏型变控制点， 图形被取消选择后会调用此方法
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			selector.frame.visible = false;
			ViewUtil.hide(selector.sizeControl);
			ViewUtil.hide(selector.scaleRollControl);
		}
		
		/**
		 */		
		override public function hideFrameOnMdown(selector:ElementSelector):void
		{
			selector.frame.alpha = 0.5;
			ViewUtil.hide(selector.sizeControl);
			ViewUtil.hide(selector.scaleRollControl);
		}
		
		/**
		 */		
		override public function showSelectorFrame(selector:ElementSelector):void
		{
			selector.frame.alpha = 1;
			ViewUtil.show(selector.sizeControl);
			ViewUtil.show(selector.scaleRollControl);
		}
		
		/**
		 * 来自主UI中的删除页面命令
		 */		
		private function deletePageHandler(e:PageEvent):void
		{
			del();
		}
		
		private function get pageVO():PageVO
		{
			return vo as PageVO;
		}
		
		private var maskShape:Shape;
	}
}