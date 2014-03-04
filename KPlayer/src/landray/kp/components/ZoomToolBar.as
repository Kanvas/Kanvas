package landray.kp.components
{	
	import com.greensock.TweenMax;
	import com.kvs.ui.button.IconBtn;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import landray.kp.core.kp_internal;
	import landray.kp.ui.ScreenFull;ScreenFull;
	import landray.kp.ui.ScreenHalf;ScreenHalf;
	import landray.kp.ui.ZoomAuto  ;ZoomAuto;
	import landray.kp.ui.ZoomIn    ;ZoomIn;
	import landray.kp.ui.ZoomOut   ;ZoomOut;
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Viewer;
	import landray.kp.core.KPConfig;
	import view.interact.zoomMove.ZoomMoveControl;
	import landray.kp.core.KPEmbeds;
	
	/**
	 * 缩放工具栏
	 */
	public final class ZoomToolBar extends Sprite
	{
		public function ZoomToolBar()
		{
			super();
			CoreUtil.initApplication(this, initialize);
		}
		
		kp_internal function resetScreenButtons():void
		{
			if (screenHalf && screenFull)
				screenHalf.visible = ! (screenFull.visible = true);
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			config = KPConfig.instance;
			embeds = KPEmbeds.instance;
			with (graphics) 
			{
				beginFill(0x474946);
				drawRect(0, 0, 36, 132);
				endFill();
			}
			
			alpha = 0;
			
			screenFull = new IconBtn;
			screenHalf = new IconBtn;
			zoomAuto   = new IconBtn;
			zoomIn     = new IconBtn;
			zoomOut    = new IconBtn;
			
			screenFull.styleXML = embeds.styleBtn;
			screenHalf.styleXML = embeds.styleBtn;
			zoomAuto  .styleXML = embeds.styleBtn;
			zoomIn    .styleXML = embeds.styleBtn;
			zoomOut   .styleXML = embeds.styleBtn;
			
			screenFull.tips = "全屏";
			screenHalf.tips = "退出全屏";
			zoomAuto  .tips = "自适应";
			zoomIn    .tips = "放大";
			zoomOut   .tips = "缩小";
			
			screenFull.w = screenFull.h = 28;
			screenHalf.w = screenHalf.h = 28;
			zoomAuto  .w = zoomAuto  .h = 28;
			zoomIn    .w = zoomIn    .h = 28;
			zoomOut   .w = zoomOut   .h = 28;
			
			screenFull.iconW = screenHalf.iconW = 18;
			screenFull.iconH = screenHalf.iconH = 16;
			
			zoomAuto.iconW = zoomIn.iconW = zoomOut.iconW = 12;
			zoomAuto.iconH = zoomIn.iconH = zoomOut.iconH = 12;
			
			var pathScreenFull:String = "landray.kp.ui.ScreenFull";
			var pathScreenHalf:String = "landray.kp.ui.ScreenHalf";
			var pathZoomAuto  :String = "landray.kp.ui.ZoomAuto";
			var pathZoomIn    :String = "landray.kp.ui.ZoomIn";
			var pathZoomOut   :String = "landray.kp.ui.ZoomOut";
			
			screenFull.setIcons(pathScreenFull, pathScreenFull, pathScreenFull);
			screenHalf.setIcons(pathScreenHalf, pathScreenHalf, pathScreenHalf);
			zoomAuto  .setIcons(pathZoomAuto  , pathZoomAuto  , pathZoomAuto);
			zoomIn    .setIcons(pathZoomIn    , pathZoomIn    , pathZoomIn);
			zoomOut   .setIcons(pathZoomOut   , pathZoomOut   , pathZoomOut);
			
			addChild(screenFull).y = 100;
			addChild(screenHalf).y = 100;
			addChild(zoomAuto  ).y = 4;
			addChild(zoomIn    ).y = 36;
			addChild(zoomOut   ).y = 68;
			
			zoomIn.x = zoomOut.x = zoomAuto.x = screenFull.x = screenHalf.x = 4;
			
			screenHalf.visible = visible = false;
			
			screenFull.addEventListener(MouseEvent.CLICK, clickScreenFull);
			screenHalf.addEventListener(MouseEvent.CLICK, clickScreenHalf);
			zoomIn    .addEventListener(MouseEvent.CLICK, clickZoomIn);
			zoomOut   .addEventListener(MouseEvent.CLICK, clickZoomOut);
			zoomAuto  .addEventListener(MouseEvent.CLICK, clickZoomAuto);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, timerShowMouseMove);
		}
		
		private function timerShowMouseMove(e:MouseEvent):void
		{
			if (mouseX　>=　-　100 && mouseX <= width) 
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, timerShowMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, timerProcessMouseMove);
				timerShowStart();
			} 
		}
		
		private function timerProcessMouseMove(e:MouseEvent):void
		{
			if (mouseX >= - 100 && mouseX <= width)
			{
				timerReset();
			}
			else
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, timerProcessMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, timerShowMouseMove);
				timerShowStop();
			}
		}
		
		private function timerHideMouseMove(e:MouseEvent):void
		{
			if (mouseX >= - 100 && mouseX <= width)
				timerHideStop();
			else
				timerHideStart();
		}
		
		private function timerShowComplete(e:TimerEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, timerProcessMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, timerHideMouseMove);
			timerShowStop();
			showToolBar();
		}
		
		private function timerHideComplete(e:TimerEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, timerHideMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, timerShowMouseMove);
			timerHideStop();
			hideToolBar();
		}
		
		private function timerReset():void
		{
			if (timer)
			{
				timer.reset();
				timer.start();
			}
		}
		
		private function timerShowStart():void
		{
			if (timer == null)
			{
				timer = new Timer(50, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerShowComplete);
				timer.start();
			}
		}
		
		private function timerShowStop():void
		{
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerShowComplete);
				timer.stop();
				timer = null;
			}
		}
		
		private function timerHideStart():void
		{
			if (timer == null)
			{
				timer = new Timer(1000, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHideComplete);
				timer.start();
			}
		}
		private function timerHideStop():void
		{
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerHideComplete);
				timer.stop();
				timer = null;
			}
		}
		
		private function showToolBar():void
		{
			if(!display) 
			{
				display = visible = true;
				TweenMax.killTweensOf(this, false);
				TweenMax.to(this, .5, {alpha:1});
			}
		}
		
		private function hideToolBar():void
		{
			if( display) 
			{
				display = false;
				TweenMax.killTweensOf(this, false);
				TweenMax.to(this, .5, {alpha:0, onComplete:function():void{visible = false}});
			}
		}
		
		/**
		 * @private
		 */
		private function clickZoomIn(e:MouseEvent):void
		{
			controller.zoomIn(true);
		}
		
		/**
		 * @private
		 */
		private function clickZoomOut(e:MouseEvent):void
		{
			controller.zoomOut(true);
		}
		
		/**
		 * @private
		 */
		private function clickZoomAuto(e:MouseEvent):void
		{
			controller.autoZoom();
		}
		
		/**
		 * @private
		 */
		private function clickScreenHalf(e:MouseEvent):void
		{
			screenHalf.visible = !(screenFull.visible = true);
			viewer.screenState = StageDisplayState.NORMAL;
		}
		
		/**
		 * @private
		 */
		private function clickScreenFull(e:MouseEvent):void
		{
			screenHalf.visible = !(screenFull.visible = false);
			viewer.screenState = StageDisplayState.FULL_SCREEN;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			visible = (alpha) ? true : false;
		}
		
		private function get viewer():Viewer
		{
			return config.kp_internal::viewer;
		}
		
		private function get controller():ZoomMoveControl
		{
			return config.kp_internal::controller;
		}
		
		/**
		 * @private
		 */
		private var zoomIn:IconBtn;
		
		/**
		 * @private
		 */
		private var zoomOut:IconBtn;
		
		/**
		 * @private
		 */
		private var zoomAuto:IconBtn;
		
		/**
		 * @private
		 */
		private var screenFull:IconBtn;
		
		/**
		 * @private
		 */
		private var screenHalf:IconBtn;
		
		/**
		 * @private
		 */
		private var timer:Timer;
		
		/**
		 * @private
		 */
		private var display:Boolean;
		
		/**
		 * @private
		 */
		private var config:KPConfig;
		
		/**
		 * @private
		 */
		private var embeds:KPEmbeds;
	}
}