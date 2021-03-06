package
{
	import com.kvs.ui.Panel;
	import com.kvs.ui.toolTips.ToolTipsManager;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.XMLConfigKit.App;
	
	import control.InteractEvent;
	import control.NavControl;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.Font;
	
	import model.CoreFacade;
	
	import view.screenState.FullScreenState;
	import view.shapePanel.ShapePanel;
	import view.themePanel.ThemePanel;
	import view.toolBar.ToolBar;
	import view.toolBar.ZoomToolBar;
	import view.ui.Debugger;
	
	/**
	 */	
	public class Kanvas extends App
	{
		public function Kanvas()
		{
			StageUtil.initApplication(this, init, true);
		}
		
		/**
		 */		
		private function init():void
		{
			this.resetLib();
			
			//addChild(new Debugger);
			
			kvsCore.externalUI = uiContainer;
			addChild(kvsCore);
			addChild(uiContainer);
			
			initPanels();
			preLayout();
			uiContainer.addChild(themePanel);
			uiContainer.addChild(shapePanel);
			uiContainer.addChild(toolBar);
			uiContainer.addChild(zoomToolBar);
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
			
			// 工具提示初始化
			toolTipsManager = new ToolTipsManager(this);
			toolTipsManager.setStyleXML(tipsStyle);
			
			//UI交互控制
			mainNavControl = new NavControl(this);
			
			// 核心core开始初始化
			kvsCore.addEventListener(KVSEvent.READY, coreInitCompleteHandler, false, 0, true);
			kvsCore.startInit();
			
			if (kvsCore.controller)
			{
				zoomToolBar.controller = kvsCore.controller;
			}
			
			//自定义按钮
			if (kvsCore.customButtonData)
				toolBar.setCustomButton(kvsCore.customButtonData);
			else
				kvsCore.addEventListener(KVSEvent.SET_CUSTOM_DATA, setCustomData, false, 0, true);
			
			// 数据测试用
			dataTest = new DataTest(this.toolBar, shapePanel, kvsCore);
			
			//addChild(debugger);
		}
		
		
		private function setCustomData(evt:KVSEvent):void
		{
			toolBar.setCustomButton(kvsCore.customButtonData);
		}
		
		/**
		 * 核心Core初始化完毕
		 */		
		private function coreInitCompleteHandler(evt:KVSEvent):void
		{
			// 初始化默认样式
			kvsCore.changeTheme('White');
		}
		
		/**
		 */		
		private var dataTest:DataTest;
		
		/**
		 */		
		private function initPanels():void
		{
			exitIcon;
			
			// 图形面板初始化
			shapePanel = new ShapePanel(this);
			shapePanel.title = '图形创建';
			shapePanel.ifShowExitBtn = true;
			shapePanel.isOpen = false;
			shapePanel.bgStyleXML = panelBGStyleXML;
			shapePanel.exitBtnStyleXML = exitBtnStyle;
			
			// 样式面板初始化
			themePanel = new ThemePanel(this);
			themePanel.w = 160;
			themePanel.barHeight = 40;
			themePanel.title = '风格样式';
			themePanel.ifShowExitBtn = true;
			themePanel.isOpen = false;
			themePanel.bgStyleXML = panelBGStyleXML;
			themePanel.exitBtnStyleXML = exitBtnStyle;
		}
		
		/**
		 */		
		private function stageResizeHandler(evt:Event):void
		{
			//Debugger.debug("resize:"+stage.stageWidth, stage.stageHeight)
			if (stage.stageWidth && stage.stageHeight)
			{
				preLayout();
				toolBar.updateLayout();
				shapePanel.updateLayout();
				themePanel.updateLayout();
				
				kvsCore.resize();
			}
		}
		
		/**
		 * 设置工具条，创建面板的尺寸/布局关系
		 */		
		private function preLayout():void
		{
			toolBar.w = stage.stageWidth;
			toolBar.h = 50;
			
			shapePanel.h = themePanel.h = stage.stageHeight - toolBar.h;
			shapePanel.y = themePanel.y = toolBar.h;
			
			zoomToolBar.y = (stage.stageHeight - zoomToolBar.height) * .5;
			
			//面板关闭时，将其移至屏幕外右侧，面板开启时，将其移至屏幕内右侧；
			if (themePanel.isOpen)
			{
				themePanel.x = stage.stageWidth - themePanel.w;
				shapePanel.x = stage.stageWidth;
				
				zoomToolBar.x = stage.stageWidth - themePanel.w - zoomToolBar.width - 5;
			}
			else if (shapePanel.isOpen)
			{
				shapePanel.x = stage.stageWidth - shapePanel.w;
				themePanel.x = stage.stageWidth;
				
				zoomToolBar.x = stage.stageWidth - themePanel.w - zoomToolBar.width - 5;
			}
			else
			{
				shapePanel.x = stage.stageWidth;
				themePanel.x = stage.stageWidth;
				zoomToolBar.x = stage.stageWidth - zoomToolBar.width - 5;
			}
			
			
			updateKvsContenBound();
		}
		
		/**
		 * 尺寸缩放，面板开始／关闭时，更新画布内容区域，此区域作为画布内容自适应，内容范围检测等事务
		 */		
		public function updateKvsContenBound():void
		{
			// 给画布流内容留一定的边距
			var gutter:uint;
			
			if (stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				gutter = 5;
				kvsCore.bound = new Rectangle(gutter, gutter, stage.stageWidth - gutter * 2, stage.stageHeight - gutter * 2);
			}
			else
			{
				gutter = 30;
				var w:Number =  stage.stageWidth - gutter * 2;
				if (shapePanel.isOpen || themePanel.isOpen)
					w -= shapePanel.w;
				
				kvsCore.bound = new Rectangle(gutter, toolBar.h + gutter, w, 
					stage.stageHeight - toolBar.h - gutter * 2);
			}
		}
		
		/**
		 * 装载工具条，面板的容器
		 */		
		private var uiContainer:Sprite = new Sprite;
		
		/**
		 * 图形面板，从这里创建图形元素 
		 */		
		public var shapePanel:Panel;
		
		/**
		 * 全局样式控制面板 
		 */		
		public var themePanel:Panel;
		
		/**
		 * 工具条
		 */		
		public var toolBar:ToolBar = new ToolBar;
		
		/**
		 * zoom工具条
		 */
		public var zoomToolBar:ZoomToolBar = new ZoomToolBar;
		
		/**
		 * Kanvas的核心内核， 负责基本图文绘制和整体图形机制
		 */		
		public var kvsCore:CoreApp = new CoreApp;
		
		/**
		 * 主场景交互控制 
		 */		
		private var mainNavControl:NavControl;
		
		/**
		 * 工具提示控制器
		 */		
		private var toolTipsManager:ToolTipsManager;
		
		
		
		
		
		//-------------------------------------------------
		//
		// 公共样式及配置
		//
		//-------------------------------------------------
		
		
		/**
		 * 图形创建面板和样式面板中退出按钮的样式 
		 */		
		private var exitBtnStyle:XML = <states>
											   <normal width='30' height='30' radius='30'>
												   <fill color='#333333' alpha='0'/>
												   <img classPath='exitIcon' width='20' height='20'/>
											   </normal>
											   <hover width='30' height='30' radius='30'>
												   <border color='#999999' alpha='1' thickness='1'/>
												   <fill alpha='0'/>
												   <img classPath='exitIcon' width='20' height='20'/>
											   </hover>
											   <down width='30' height='30' radius='30'>
												   <border color='#666666' alpha='1' thickness='2'/>
												   <fill alpha='0'/>
												   <img classPath='exitIcon' width='20' height='20'/>
											   </down>
										   </states>
		/**
		 * 工具提示的样式 
		 */			 
		private var tipsStyle:XML = <label hPadding='12' vPadding='8' radius='30' vMargin='10' hMargin='20'>
										<border thikness='1' alpha='0' color='555555' pixelHinting='true'/>
										<fill color='e96565' alpha='0.9'/>
										<format font='华文细黑' size='13' color='ffffff'/>
										<text value='${tips}'>
											<effects>
												<shadow color='0' alpha='0.3' distance='1' blur='1' angle='90'/>
											</effects>
										</text>
									</label>;
		
		
		/**
		 * 面板样式
		 */		
		private var panelBGStyleXML:XML = <style>
											<border color='#eeeeee' alpha='1'/>
											<fill color='#fafafa, #fafafa' alpha='1, 1' type='radial'/>
										 </style>
	}
}