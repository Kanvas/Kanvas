package view.editor.text
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.colorPanel.ColorPanel;
	import com.kvs.ui.colorPanel.IColorPanelHost;
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	import com.kvs.utils.layout.BoxLayout;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import view.elementSelector.toolBar.StyleBtn;
	
	/**
	 * 字体颜色选择面板
	 */	
	public class FontColorsPanel extends FiUI implements IColorPanelHost
	{
		public function FontColorsPanel(stylePanel:TextStylePanel)
		{
			super();
			
			this.stylePanel = stylePanel;
		}
		
		/**
		 */		
		public function previewColor(colorBtn:StyleBtn):void
		{
			stylePanel.changeFontColor(colorBtn.iconColor);
		}
		
		/**s
		 */			
		public function panelRollOut(curColorBtn:StyleBtn):void
		{
			stylePanel.changeFontColor(curColorBtn.iconColor);
		}
		
		/**
		 */		
		public function colorSelected(curColorBtn:StyleBtn):void 
		{
			stylePanel.changeFontColor(curColorBtn.iconColor);
			
			stylePanel.colorSelectBtn.data = curColorBtn.data;
			stylePanel.colorSelectBtn.selected = false;
			
			this.hide();
		}
		
		
		/**
		 */		
		private var colorPanel:ColorPanel;
		
		/**
		 */		
		private var stylePanel:TextStylePanel;
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			this.colorPanel = new ColorPanel(this);
			colorPanel.panelWidth = 208;
			colorPanel.iconWidth = iconSize;
			colorPanel.iconHeight = iconSize;
			
			colorPanel.bgStyleXML = bgStyleXML;
			colorPanel.iconBGStatesXML = colorBgStatesXML;
			colorPanel.iconStatesXML = colorIconStatesXML;
			
			addChild(colorPanel);
			
			XMLVOMapper.fuck(bgStyleXML, bgStyle);
		}
		
		/**
		 */		
		private var iconSize:uint = 26;
		
		/**
		 * 根据配置文件，构建颜色内容
		 */		
		public function update(xml:XML):void
		{
			colorPanel.dataXML = xml;
			
			colorPanel.x = - colorPanel.width / 2;
			colorPanel.y = - colorPanel.height;
			
			drawBg();
		}
		
		/**
		 */		
		private function drawBg():void
		{
			bgStyle.tx = - colorPanel.width / 2;
			bgStyle.ty = - colorPanel.height;
			bgStyle.width = colorPanel.width - 2;
			bgStyle.height = colorPanel.height + 8;
			
			this.graphics.clear();
			StyleManager.setShapeStyle(bgStyle, graphics);
			this.graphics.moveTo(0, 8);
			this.graphics.lineTo(- 8, 0);
			this.graphics.lineTo(bgStyle.tx, 0);
			this.graphics.lineTo(bgStyle.tx, bgStyle.ty);
			this.graphics.lineTo(bgStyle.width / 2, bgStyle.ty);
			this.graphics.lineTo(bgStyle.width / 2, 0);
			this.graphics.lineTo(8, 0);
			this.graphics.lineTo(0, 8);
			this.graphics.endFill();
		}
			
		/**
		 */		
		private var btns:Vector.<StyleBtn> = new Vector.<StyleBtn>;
		
		/**
		 */		
		private var boxLayout:BoxLayout = new BoxLayout;
		
		/**
		 */		
		public function show():void
		{
			ViewUtil.show(this);
			
			colorPanel.setCurColor(uint(stylePanel.colorSelectBtn.data));
		}
		
		/**
		 */		
		public function hide():void
		{
			ViewUtil.hide(this);
		}
		
		/**
		 */		
		private var colorBgStatesXML:XML = <states>
											<normal>
												<fill color='#555555' alpha='1'/>
											</normal>
											<hover>
												<fill color='#DDDDDD' alpha='1'/>
											</hover>
											<down>
												<fill color='#DDDDDD' alpha='1'/>
											</down>
										</states>
			
		/**
		 */		
		private var colorIconStatesXML:XML = <states>
												<normal radius='0'>
													<border color='ffffff' thickness='1' alpha='1'/>
													<fill color='${iconColor}'/>
												</normal>
												<hover radius='30'>
													<border color='ffffff' thickness='1' alpha='1'/>
													<fill color='${iconColor}'/>
												</hover>
												<down radius='30'> 
													<border color='ffffff' thickness='1' alpha='1'/>
													<fill color='${iconColor}'/>
												</down>
											</states>
			
		
		
		/**
		 */		
		private var bgStyle:Style = new Style;
		
		/**
		 */		
		private var bgStyleXML:XML = <style>
										<fill color='DDDDDD'/>
										<border color='DDDDDD'/>
									</style>
	}
}