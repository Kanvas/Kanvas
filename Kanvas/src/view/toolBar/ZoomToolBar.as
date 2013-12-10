package view.toolBar
{	
	import com.greensock.TweenLite;
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
			
			addChild(subContainer = new Sprite).alpha = 0;
			
			visible = false;
			
			controller = $controller;
			
			with (subContainer.graphics) 
			{
				beginFill(0x474946);
				drawRect(0, 0, 36, 100);
				endFill();
			}
			
			
			subContainer.addChild(zoomIn   = new ZoomIn  ).y = 36;
			subContainer.addChild(zoomOut  = new ZoomOut ).y = 68;
			subContainer.addChild(zoomAuto = new ZoomAuto).y = 4 ;
			zoomIn.x = zoomOut.x = zoomAuto.x = 4;
			
			zoomIn  .addEventListener(MouseEvent.CLICK, clickZoomIn  );
			zoomOut .addEventListener(MouseEvent.CLICK, clickZoomOut );
			zoomAuto.addEventListener(MouseEvent.CLICK, clickZoomAuto);
			
			StageUtil.initApplication(this, addedToStage);
		}
		
		/**
		 * @private
		 */
		private function addedToStage():void
		{
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
				TweenLite.killTweensOf(subContainer, false, {alpha:true});
				TweenLite.to(subContainer, .5, {alpha:1});
			}
		}
		
		private function hideToolBar():void
		{
			if( display) 
			{
				display = false;
				TweenLite.killTweensOf(subContainer, false, {alpha:true});
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
		private var zoomIn  :SimpleButton;
		
		/**
		 * @private
		 */
		private var zoomOut :SimpleButton;
		
		/**
		 * @private
		 */
		private var zoomAuto:SimpleButton;
		
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
	}
}