package landray.kp.view
{
	import com.kvs.ui.toolTips.ToolTipsManager;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import landray.kp.controls.Selector;
	import landray.kp.core.KPConfig;
	import landray.kp.core.KPEmbeds;
	import landray.kp.core.KPProvider;
	import landray.kp.core.kp_internal;
	import landray.kp.maps.main.comman.ElementToolTip;
	import landray.kp.mediator.MediatorViewer;
	import landray.kp.utils.CoreUtil;
	
	import model.vo.BgVO;
	
	import util.LayoutUtil;
	
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
			//mediator为viewer事件处理交互类
			mediator    = new MediatorViewer(this);
			kp_internal::controller  = new ZoomMoveControl(this, mediator);
			config.kp_internal::controller = kp_internal::controller;
			
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
			
			toolTip = new ElementToolTip(this);
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
			kp_internal::drawBackground((background) ? uint(background.color) : 0xFFFFFF);
			kp_internal::drawInteractor();
			//指定自适应矩形范围
			var gutter:uint = (stage && stage.displayState == StageDisplayState.FULL_SCREEN) ? 5 : 30;
			
			bound = new Rectangle(gutter, gutter, width - gutter * 2, height - gutter * 2);
			
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
			var x:Number = 0;
			var y:Number = 0;
			var w:Number = width ;
			var h:Number = height;
			canvas.drawBG(new Rectangle(x, y, w, h));
		}
		
		/**
		 * @private
		 */
		kp_internal function convertElementCoordsToViewer(x:Number, y:Number):Point
		{
			return LayoutUtil.elementPointToStagePoint(x, y, canvas);
		}
		
		kp_internal function horizontalMove(distance:Number):void
		{
			
			kp_internal::controller.zoomMoveOff(1, distance, 0);
			
		}
		
		kp_internal function unselected():void
		{
			if (kp_internal::selector)
				kp_internal::selector.visible = false;
		}
		
		kp_internal function setToolTipMultiline(w:Number):void
		{
			if (w > 0)
			{
				config.kp_internal::tipsManager.getStyle().layout = "wrap";
				config.kp_internal::tipsManager.maxWidth = w;
			}
		}
		
		kp_internal function showLinkOveredTip(msg:String, w:Number = 0):void
		{
			toolTip.showToolTip(msg, w);
		}
		
		kp_internal function setScreenState(state:String):void
		{
			if (screenState!= state)
			{
				trace("set state:", state)
				if(isNaN(lastWidth) || isNaN(lastHeight))
				{
					lastWidth  = stage.stageWidth;
					lastHeight = stage.stageHeight;
				}
				screenState = state;
				stage.displayState = state;
				var gutterOld:int = (state == "normal") ? 5 : 30;
				var gutterNew:int = (state == "normal") ? 30 : 5;
				var recOld:Rectangle = new Rectangle(gutterOld, gutterOld, lastWidth - gutterOld * 2, lastHeight - gutterOld * 2);
				var recNew:Rectangle = new Rectangle(gutterNew, gutterNew, stage.stageWidth - gutterNew * 2, stage.stageHeight - gutterNew * 2);
				if (state == "fullScreen")
				{
					fullScreenScale = (recOld.width / recOld.height > recNew.width / recNew.height)
						? recNew.width  / recOld.width
						: recNew.height / recOld.height;
				}
				else
				{
					fullScreenScale = 1 / fullScreenScale;
				}
				var canvasScale:Number = canvas.scaleX * fullScreenScale;
				var sceOld:Point = new Point(lastWidth * .5, lastHeight * .5);
				var sceNew:Point = new Point(stage.stageWidth * .5, stage.stageHeight * .5);
				var vector:Point = sceNew.subtract(sceOld);
				recOld.offset(vector.x, vector.y);
				canvas.x += vector.x;
				canvas.y += vector.y;
				recOld.width  *= fullScreenScale;
				recOld.height *= fullScreenScale;
				var tl:Point = new Point(recOld.x, recOld.y);
				LayoutUtil.convertPointStage2Canvas(tl, canvas.x, canvas.y, canvas.scaleX, canvas.rotation);
				LayoutUtil.convertPointCanvas2Stage(tl, canvas.x, canvas.y, canvasScale  , canvas.rotation);
				recOld.x = tl.x;
				recOld.y = tl.y;
				var canvasCenter:Point = new Point((recOld.left + recOld.right) * .5, (recOld.top + recOld.bottom) * .5);
				var stageCenter :Point = new Point((recNew.left + recNew.right) * .5, (recNew.top + recNew.bottom) * .5);
				var aimX:Number = canvas.x + stageCenter.x - canvasCenter.x;
				var aimY:Number = canvas.y + stageCenter.y - canvasCenter.y;
				kp_internal::controller.zoomRotateMoveTo(canvasScale, canvas.rotation, aimX, aimY, null, .5);
				
				synBgImgWidthCanvas();
				
				lastWidth  = stage.stageWidth;
				lastHeight = stage.stageHeight;
			}
		}
		
		private var lastWidth:Number;
		private var lastHeight:Number;
		private var fullScreenScale:Number;
		private var screenState:String = "normal";
		
		
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
		private var toolTip:ElementToolTip;
		
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
		private var mediator:MediatorViewer;
		
		/**
		 * @private
		 */
		private var temp:Point = new Point;
	}
}