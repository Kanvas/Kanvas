package view.toolBar
{	
	import com.greensock.TweenMax;
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.StageUtil;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import landray.kp.core.kp_internal;
	import landray.kp.ui.*;
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Viewer;
	
	import view.interact.zoomMove.ZoomMoveControl;
	
	/**
	 * 工具栏
	 */
	public final class ZoomToolBar extends Sprite
	{
		public function ZoomToolBar($viewer:Viewer)
		{
			super();
			
			controller = $viewer;
			
			CoreUtil.initApplication(this, initialize);
			
			
		}
		
		kp_internal function resetScreenButtons():void
		{
			if (screenHalf && screenFull)
			{
				screenHalf.visible = ! (screenFull.visible = true);
			}
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			with (graphics) 
			{
				beginFill(0x474946);
				drawRect(0, 0, 36, 132);
				endFill();
			}
			
			alpha = 0;
			
			visible = false;
			
			zoomAuto   = new IconBtn;
			zoomIn     = new IconBtn;
			zoomOut    = new IconBtn;
			screenHalf = new IconBtn;
			screenFull = new IconBtn;
			
			zoomAuto  .styleXML = btnStyleXML;
			zoomIn    .styleXML = btnStyleXML;
			zoomOut   .styleXML = btnStyleXML;
			screenHalf.styleXML = btnStyleXML;
			screenFull.styleXML = btnStyleXML;
			
			zoomAuto  .tips = "自适应";
			zoomIn    .tips = "放大";
			zoomOut   .tips = "缩小";
			screenHalf.tips = "退出全屏";
			screenFull.tips = "全屏";
			
			zoomAuto.w = zoomAuto.h = 28;
			zoomIn.w = zoomIn.h = 28;
			zoomOut.w = zoomOut.h = 28;
			screenHalf.w = screenHalf.h = 28;
			screenFull.w = screenFull.h = 28;
			
			zoomAuto.iconW = 12;
			zoomAuto.iconH = 11;
			zoomIn.iconW = 12;
			zoomIn.iconH = 12;
			zoomOut.iconW = 12;
			zoomOut.iconH = 12;
			screenFull.iconW = 18;
			screenFull.iconH = 16;
			screenHalf.iconW = 18;
			screenHalf.iconH = 16;
			
			zoomIn.x = zoomOut.x = zoomAuto.x = screenFull.x = screenHalf.x = 4;
			
			ZoomAuto;
			var pathZoomAuto:String = "landray.kp.ui.ZoomAuto";
			zoomAuto.setIcons(pathZoomAuto, pathZoomAuto, pathZoomAuto);
			ZoomIn;
			var pathZoomIn:String = "landray.kp.ui.ZoomIn";
			zoomIn.setIcons(pathZoomIn, pathZoomIn, pathZoomIn);
			ZoomOut;
			var pathZoomOut:String = "landray.kp.ui.ZoomOut";
			zoomOut.setIcons(pathZoomOut, pathZoomOut, pathZoomOut);
			ScreenHalf;
			var pathScreenHalf:String = "landray.kp.ui.ScreenHalf";
			screenHalf.setIcons(pathScreenHalf, pathScreenHalf, pathScreenHalf);
			ScreenFull;
			var pathScreenFull:String = "landray.kp.ui.ScreenFull";
			screenFull.setIcons(pathScreenFull, pathScreenFull, pathScreenFull);
			
			addChild(zoomAuto  ).y = 4 ;
			addChild(zoomIn    ).y = 36;
			addChild(zoomOut   ).y = 68;
			addChild(screenHalf).y = 100;
			addChild(screenFull).y = 100;
			
			screenHalf.visible = false;
			
			zoomIn    .addEventListener(MouseEvent.CLICK, clickZoomIn    );
			zoomOut   .addEventListener(MouseEvent.CLICK, clickZoomOut   );
			zoomAuto  .addEventListener(MouseEvent.CLICK, clickZoomAuto  );
			screenHalf.addEventListener(MouseEvent.CLICK, clickScreenHalf);
			screenFull.addEventListener(MouseEvent.CLICK, clickScreenFull);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, timerStartMouseMove);
		}
		
		private function timerStartMouseMove(e:MouseEvent):void
		{
			if (mouseX　>=　-　100) 
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, timerStartMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, timerProcessMouseMove);
				//start timer record
				timerStart();
			} 
		}
		
		private function timerProcessMouseMove(e:MouseEvent):void
		{
			if (mouseX >= - 100)
			{
				timerReset();
			}
			else
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, timerProcessMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, timerStartMouseMove);
				
				timerStop();
				hideToolBar();
			}
		}
		
		private function timerComplete(e:TimerEvent):void
		{
			showToolBar();
		}
		
		private function timerStart():void
		{
			if (timer == null)
			{
				timer = new Timer(500, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
				timer.start();
			}
		}
		
		private function timerReset():void
		{
			if (timer)
			{
				timer.reset();
				timer.start();
			}
		}
		
		private function timerStop():void
		{
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
				timer.stop();
				timer = null;
			}
		}
		
		private function showToolBar():void
		{
			if(!display) 
			{
				display = true;
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
			controller.kp_internal::controller.zoomIn(true);
		}
		
		/**
		 * @private
		 */
		private function clickZoomOut(e:MouseEvent):void
		{
			controller.kp_internal::controller.zoomOut(true);
		}
		
		/**
		 * @private
		 */
		private function clickZoomAuto(e:MouseEvent):void
		{
			controller.kp_internal::controller.autoZoom();
		}
		
		/**
		 * @private
		 */
		private function clickScreenHalf(e:MouseEvent):void
		{
			screenHalf.visible = ! (screenFull.visible = true);
			controller.kp_internal::setScreenState(StageDisplayState.NORMAL);
		}
		
		/**
		 * @private
		 */
		private function clickScreenFull(e:MouseEvent):void
		{
			screenHalf.visible = ! (screenFull.visible = false);
			controller.kp_internal::setScreenState(StageDisplayState.FULL_SCREEN);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			visible = (alpha) ? true : false;
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
		private var controller:Viewer;
		
		/**
		 * @private
		 */
		private var display:Boolean;
		
		private var timer:Timer;
		
		private var btnStyleXML:XML = 
			<states>
				<normal radius='0'>
					<fill color='#686A66,#575654' angle="90"/>
					<img/>
				</normal>
				<hover radius='0'>
					<border color='#2D2C2A' alpha='1' thikness='1'/>
					<fill color='#57524F,#4B4643' angle="90"/>
					<img/>
				</hover>
				<down radius='0'>
					<border color='#2D2C2A' alpha='1' thikness='1'/>
					<fill color='#2D2C2A,#262626' angle="90"/>
					<img/>
				</down>
			</states>;
	}
}