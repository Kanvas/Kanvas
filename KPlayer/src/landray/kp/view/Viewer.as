package landray.kp.view
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import landray.kp.components.ZoomToolBar;
	import landray.kp.core.KPConfig;
	import landray.kp.core.KPProvider;
	import landray.kp.core.kp_internal;
	import landray.kp.mediator.MediatorViewer;
	import landray.kp.utils.CoreUtil;
	
	import model.vo.BgVO;
	
	import view.interact.zoomMove.ZoomMoveControl;
	import view.ui.Bubble;
	import view.ui.MainUIBase;

	[Event(name="initialize", type="flash.events.Event")]
	
	/**
	 * Viewer用于画布显示，所有的图形都添加于画布中。
	 * <p>
	 * Viewer继承自MainUIBase，容器缩放，背景绘制，都是基于MainUIBase.
	 * 
	 */
	public final class Viewer extends MainUIBase
	{
		/**
		 * 构造函数.
		 */
		public function Viewer()
		{
			super();
			//注册添加舞台初始化事件
			CoreUtil.initApplication(this, initialize);
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			config   = KPConfig  .instance;
			provider = KPProvider.instance;
			
			Bubble.init(stage);
			
			//添加背景颜色
			addChild(bgColorCanvas);
			//背景图片
			addChild(bgImgCanvas);
			//添加画布
			addChild(canvas);
			
			//添加selector选择框
			addChild(config.kp_internal::selector);
			//添加按钮工具条
			addChild(toolBarZoom);
			
			//更新布局
			updateLayout();
			
			if (width && height)
				dispatchEvent(new Event("initialize"));
		}
		
		/**
		 * @private
		 */
		private function updateLayout():void
		{
			//绘制背景与交互背景
			kp_internal::drawBackground((background) ? uint(background.color) : 0xFFFFFF);
			//交互背景
			canvas.drawBG(new Rectangle(0, 0, width, height));
			//指定自适应矩形范围
			bound = new Rectangle(5, 5, width - 10, height - 10 - 36);
			
			//移动toolBar至右侧
			toolBarZoom.x =  width  - toolBarZoom.width   -  5;
			toolBarZoom.y = (height - toolBarZoom.height) * .5;
		}
		
		/**
		 * @private
		 */
		kp_internal function drawBackground(color:uint=0xFFFFFF):void
		{
			with (bgColorCanvas.graphics) 
			{
				clear();
				beginFill(color, 1);
				drawRect(0, 0, width, height);
				endFill();
			}
		}
		
		public function set screenState(value:String):void
		{
			if (__screenState!= value)
			{
				__screenState = value;
				mediator.kp_internal::setScreenState(value);
			}
		}
		private var __screenState:String = "normal";
		
		/**
		 * 设定背景，格式为BgVO
		 */
		public function get background():BgVO
		{
			return config.kp_internal::bgVO;
		}
		
		public function set background(bgVO:BgVO):void
		{
			kp_internal::drawBackground(CoreUtil.getColor(bgVO));
			mediator.kp_internal::setBackground(bgVO);
		}
		
		/**
		 * 设定主题
		 */
		public function set theme(value:String):void
		{
			mediator.kp_internal::setTheme(value);
		}
		
		/**
		 * 设定宽度。
		 */
		override public function get width():Number
		{
			return __width;
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			__width = value;
			updateLayout();
		}
		
		/**
		 * @private
		 */
		private var __width:Number = 0;
		
		/**
		 * 设定高度
		 */
		override public function get height():Number
		{
			return __height;
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			__height = value;
			updateLayout();
		}
				
		/**
		 * @private
		 */
		private var __height:Number = 0;
		
		private function get controller():ZoomMoveControl
		{
			return config.kp_internal::controller;
		}
		
		private function get mediator():MediatorViewer
		{
			return config.kp_internal::mediator;
		}
		
		private function get toolBarZoom():ZoomToolBar
		{
			return config.kp_internal::zoomToolBar;
		}
		
		/**
		 * @private
		 */
		private var config:KPConfig;
		
		/**
		 * @private
		 */
		private var provider:KPProvider;
	}
}