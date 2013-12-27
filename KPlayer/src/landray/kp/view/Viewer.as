package landray.kp.view
{
	import com.kvs.ui.toolTips.ToolTipsManager;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import landray.kp.controls.Selector;
	import landray.kp.core.KPConfig;
	import landray.kp.core.KPEmbeds;
	import landray.kp.core.KPProvider;
	import landray.kp.core.kp_internal;
	import landray.kp.mediator.MediatorViewer;
	import landray.kp.utils.CoreUtil;
	
	import model.vo.BgVO;
	
	import util.layout.LayoutTransformer;
	
	import view.interact.zoomMove.ZoomMoveControl;
	import view.toolBar.ZoomToolBar;
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
			
			//创建viewer的辅助
			//transformer为坐标舞台与画布转换类
			transformer = new LayoutTransformer(canvas);
			//mediator为viewer事件处理交互类
			mediator    = new MediatorViewer(this);
			kp_internal::controller  = new ZoomMoveControl(this, mediator);
			
			templete = provider.styleXML;
			
			//添加背景颜色
			addChild(bgColorCanvas);
			//背景图片
			addChild(bgImgCanvas);
			//添加画布
			addChild(canvas);
			
			//添加selector选择框
			addChild(kp_internal::selector = new Selector(this)).visible = false;
			//添加按钮工具条
			addChild(kp_internal::toolBar  = new ZoomToolBar(this));
			//更新布局
			updateLayout();
			
			Bubble.init(stage);
			
			config.kp_internal::tipsManager = new ToolTipsManager(this);
			config.kp_internal::tipsManager.setStyleXML(KPEmbeds.instance.styleTips);
			
			if (width && height)
				dispatchEvent(new Event("initialize"));
		}
		
		/**
		 * @private
		 */
		private function updateLayout():void
		{
			//绘制背景与交互背景
			kp_internal::drawBackground();
			kp_internal::drawInteractor();
			//指定自适应矩形范围
			bound = new Rectangle(0, 0, width, height);
			//移动toolBar至右侧
			if (kp_internal::toolBar) 
			{
				kp_internal::toolBar.x =  width  - kp_internal::toolBar.width   -  5;
				kp_internal::toolBar.y = (height - kp_internal::toolBar.height) * .5;
			}
		}
		
		/**
		 * @private
		 */
		kp_internal function zoomAuto():void
		{
			kp_internal::controller.autoZoom(config.originalScale);
		}
		
		/**
		 * @private
		 */
		kp_internal function refresh():void
		{
			kp_internal::drawInteractor();
			kp_internal::drawBackground((background) ? background.color : 0xFFFFFF);
			if (kp_internal::selector) 
			{
				if (kp_internal::selector.visible) 
					kp_internal::selector.render();
			}
			
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
		
		/**
		 * @private
		 */
		kp_internal function drawInteractor():void
		{
			var x:Number = transformer.stageXToElementX(0);
			var y:Number = transformer.stageYToElementY(0);
			var w:Number = width  / transformer.canvasScale;
			var h:Number = height / transformer.canvasScale;
			canvas.drawBG(new Rectangle(x, y, w, h));
		}
		
		/**
		 * @private
		 */
		kp_internal function convertElementCoordsToViewer(x:Number, y:Number):Point
		{
			temp.x = transformer.elementXToStageX(x);
			temp.y = transformer.elementYToStageY(y);
			return temp;
		}
		
		kp_internal function horizontalMove(distance:Number):void
		{
			if (stage)
			{
				var center:Point = new Point;
				center.x = transformer.stageXToElementX(stage.stageWidth * .5) - distance;
				center.y = transformer.stageYToElementY(stage.stageHeight * .5);
				kp_internal::controller.zoomTo(transformer.canvasScale, center);
			}
		}
		
		kp_internal function unselected():void
		{
			if (kp_internal::selector)
			{
				kp_internal::selector.visible = false;
			}
		}
		
		kp_internal function setScreenState(state:String):void
		{
			if(isNaN(lastWidth) || isNaN(lastHeight))
			{
				lastWidth  = stage.stageWidth;
				lastHeight = stage.stageHeight;
			}
			if (stage.displayState!= state)
				stage.displayState = state;
			var x:Number = (lastWidth  * .5 - canvas.x) / canvas.scaleX;
			var y:Number = (lastHeight * .5 - canvas.y) / canvas.scaleX;
			lastWidth  = stage.stageWidth;
			lastHeight = stage.stageHeight;
			canvas.x = lastWidth  * .5 - x;
			canvas.y = lastHeight * .5 - y;
			
			synBgImgWidthCanvas();
		}
		
		private var lastWidth:Number;
		private var lastHeight:Number;
		
		
		/**
		 * 设定背景，格式为BgVO
		 */
		public function get background():BgVO
		{
			return __background;
		}
		
		/**
		 * @private
		 */
		public function set background(value:BgVO):void
		{
			__background = value;
			mediator.kp_internal::setBackground(background);
		}
		
		/**
		 * @private
		 */
		private var __background:BgVO;
		
		/**
		 * 设定模板，
		 * 
		 */
		public function set templete(value:XML):void
		{
			mediator.kp_internal::setTemplete(value);
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
		
		/**
		 * @private
		 */
		private var transformer:LayoutTransformer;
				
		/**
		 * @private
		 */
		private var mediator:MediatorViewer;
		
		/**
		 * @private
		 */
		kp_internal var controller:ZoomMoveControl;
		
		/**
		 * @private
		 */
		kp_internal var selector:Selector;
		
		/**
		 * @private
		 */
		kp_internal var toolBar :ZoomToolBar;
		
		/**
		 * @private
		 */
		private var config:KPConfig;
		
		/**
		 * @private
		 */
		private var provider:KPProvider;
		
		/**
		 * @private
		 */
		private var temp:Point = new Point;
	}
}