package view.elementSelector.toolBar
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import fl.transitions.Tween;
	
	import model.ConfigInitor;

	/**
	 * 线条的工具条
	 */	
	public class LineShape extends BorderShape
	{
		public function LineShape(toolBar:ToolBarController)
		{
			super(toolBar);
		}
		
		/**
		 */		
		override public function render():void
		{
			toolBar.addBtn(toolBar.styleBtn);
			toolBar.addBtn(addBtn);
			toolBar.addBtn(cutBtn);
			toolBar.addBtn(toolBar.topLayerBtn);
			toolBar.addBtn(toolBar.bottomLayerBtn);
			toolBar.addBtn(toolBar.delBtn);
			
			resetColorIconStyle();
		}
		
		/**
		 */		
		override public function layout(style:Style):void
		{
			var scale:Number = toolBar.selector.layoutTransformer.canvasScale * toolBar.selector.element.scale;
			var newX:Number = toolBar.selector.element.vo.width / 2 * scale;
			var rad:Number = Math.PI / 2 + selectorRotation * Math.PI / 180;
			
			var px:Number;
			var py:Number;
			
			//手动获取hover高度，防止r与实际不同步
			r = toolBar.selector.coreMdt.mainUI.hoverEffect.getHoverHeight(toolBar.selector.layoutInfo.height, toolBar.selector.element) / 2 * scale + 5;
			
			if (selectorRotation >= 0 && selectorRotation < 180)
			{
				px = Math.cos(rad) * r;
				py = - Math.sin(rad) * r;
			}
			else
			{
				//防止尺寸缩放按钮碰撞工具条
				var R:Number = r;
				if (selectorRotation < - 70 || selectorRotation == 180)
					R = r + ConfigInitor.ICON_SIZE_FOR_SCALE_AND_ROLL + 5;
					
				px = newX + Math.cos(rad) * R;
				py = - Math.sin(rad) * R;
			}
		
			//画布所方时，防止两个动画冲突导致的工具条动画停顿
			if (TweenMax.isTweening(toolBar.selector.coreMdt.mainUI.canvas))
			{
				toolBar.x = px;
				toolBar.y = py;
			}
			else
			{
				TweenLite.killTweensOf(toolBar, false);
				TweenLite.to(toolBar, 0.2, {x: px, y: py, ease: Cubic.easeOut});
			}
			
		}
		
		/**
		 */		
		private var r:uint = 11;
	}
}