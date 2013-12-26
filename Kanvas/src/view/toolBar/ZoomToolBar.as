package view.toolBar
{	
	import com.greensock.TweenLite;
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.StageUtil;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import landray.kp.ui.*;
	
	import view.interact.zoomMove.ZoomMoveControl;
	
	/**
	 * 工具栏
	 */
	public final class ZoomToolBar extends Sprite
	{
		public function ZoomToolBar($controller:ZoomMoveControl = null)
		{
			super();
			controller = $controller;
			
			StageUtil.initApplication(this, initialize);
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			
			addChild(subContainer = new Sprite).alpha = 0;
			
			visible = false;
			
			with (subContainer.graphics) 
			{
				beginFill(0x474946);
				drawRect(0, 0, 36, 100);
				endFill();
			}
			
			zoomAuto   = new IconBtn;
			zoomIn     = new IconBtn;
			zoomOut    = new IconBtn;
			
			zoomAuto  .styleXML = btnStyleXML;
			zoomIn    .styleXML = btnStyleXML;
			zoomOut   .styleXML = btnStyleXML;
			
			zoomAuto  .tips = "自适应";
			zoomIn    .tips = "放大";
			zoomOut   .tips = "缩小";
			
			zoomAuto.w = zoomAuto.h = 28;
			zoomIn.w = zoomIn.h = 28;
			zoomOut.w = zoomOut.h = 28;
			
			zoomAuto.iconW = 12;
			zoomAuto.iconH = 11;
			zoomIn.iconW = 12;
			zoomIn.iconH = 12;
			zoomOut.iconW = 12;
			zoomOut.iconH = 12;
			
			zoomIn.x = zoomOut.x = zoomAuto.x = 4;
			
			ZoomAuto;
			var pathZoomAuto:String = "landray.kp.ui.ZoomAuto";
			zoomAuto.setIcons(pathZoomAuto, pathZoomAuto, pathZoomAuto);
			ZoomIn;
			var pathZoomIn:String = "landray.kp.ui.ZoomIn";
			zoomIn.setIcons(pathZoomIn, pathZoomIn, pathZoomIn);
			ZoomOut;
			var pathZoomOut:String = "landray.kp.ui.ZoomOut";
			zoomOut.setIcons(pathZoomOut, pathZoomOut, pathZoomOut);
			
			subContainer.addChild(zoomIn  ).y = 36;
			subContainer.addChild(zoomOut ).y = 68;
			subContainer.addChild(zoomAuto).y = 4 ;
			
			zoomIn  .addEventListener(MouseEvent.CLICK, clickZoomIn  );
			zoomOut .addEventListener(MouseEvent.CLICK, clickZoomOut );
			zoomAuto.addEventListener(MouseEvent.CLICK, clickZoomAuto);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, timerStartMouseMove);
		}
		
		/**
		 * @private
		 */
		private function timerStartMouseMove(e:MouseEvent):void
		{
			if (mouseX　>=　-　100 && mouseX <= width) 
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, timerStartMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, timerProcessMouseMove);
				//start timer record
				timerStart();
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
				visible = true;
				TweenLite.killTweensOf(subContainer, false);
				TweenLite.to(subContainer, .5, {alpha:1});
			}
		}
		
		private function hideToolBar():void
		{
			if( display) 
			{
				display = false;
				TweenLite.killTweensOf(subContainer, false);
				TweenLite.to(subContainer, .5, {alpha:0, onComplete:function():void{visible = false}});
			}
		}
		
		/**
		 * @private
		 */
		private function clickZoomIn(e:MouseEvent):void
		{
			if (controller)
				controller.zoomIn(true);
		}
		
		/**
		 * @private
		 */
		private function clickZoomOut(e:MouseEvent):void
		{
			if (controller)
				controller.zoomOut(true);
		}
		
		/**
		 * @private
		 */
		private function clickZoomAuto(e:MouseEvent):void
		{
			if (controller)
				controller.autoZoom();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			visible = (alpha<.01) ? true : false;
		}
		
		/**
		 * @private
		 */
		private var zoomIn  :IconBtn;
		
		/**
		 * @private
		 */
		private var zoomOut :IconBtn;
		
		/**
		 * @private
		 */
		private var zoomAuto:IconBtn;
		
		/**
		 * @private
		 */
		public var controller:ZoomMoveControl;
		
		/**
		 * @private
		 */
		private var display:Boolean;
		
		private var subContainer:Sprite;
		
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