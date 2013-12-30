package view.pagePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.utils.XMLConfigKit.style.elements.Img;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import model.CoreFacade;
	
	/**
	 */	
	public class ShotBtn extends IconBtn implements IClickMove
	{
		public function ShotBtn(pagesPanel:PagePanel)
		{
			super();
			
			this.pagePanel = pagesPanel;
			this.dragMoveControl = new ClickMoveControl(this, shotSprite);
		}
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
		}
		
		/**
		 * 当鼠标按下对象，没有拖动就释放时触发此方法
		 */		
		public function clicked():void
		{
			pagePanel.addPage();
		}
		
		/**
		 */		
		public function startMove():void
		{
		}
		
		/**
		 */			
		public function stopMove():void
		{
		}
		
		/**
		 */		
		private var dragMoveControl:ClickMoveControl;
		
		/**
		 */		
		private var pagePanel:PagePanel;
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			this.mouseChildren = true;
			
			frameBtn.w = frameBtn.iconW = w;
			frameBtn.h = frameBtn.iconH = h;
			
			shot_frame_up;
			shot_frame_over;
			shot_frame_down;
			frameBtn.setIcons('shot_frame_up', 'shot_frame_over', 'shot_frame_down');
			frameBtn.addEventListener(MouseEvent.CLICK, frameClick);
			addChild(frameBtn);
			
			addChild(shotSprite);
			
			this.addEventListener(MouseEvent.ROLL_OVER, showFrame);
			this.addEventListener(MouseEvent.ROLL_OUT, hideFrame);
		}
		
		/**
		 */		
		private function showFrame(evt:MouseEvent):void
		{
			if (frameBtn.selected == false)
			{
				CoreFacade.coreMediator.showCameraShot();
			}
		}
		
		/**
		 */		
		private function hideFrame(evt:MouseEvent):void
		{
			if (frameBtn.selected == false)
			{
				CoreFacade.coreMediator.hideCanmeraShot();
			}
		}
		
		/**
		 */		
		override public function render():void
		{
			if (w != 0)
				currState.width = w;
			
			if (h != 0)
				currState.height = h;
			
			var img:Img = currState.getImg;
			img.ready();
			
			if (isNaN(iconW))
				iconW = img.width;
			
			if (isNaN(iconH))
				iconH = img.height;
			
			shotSprite.x = (currState.width - iconW) / 2;
			shotSprite.y = (currState.height - iconH) / 2;
			BitmapUtil.drawBitmapDataToSprite(img.data, shotSprite, iconW, iconH, 0, 0, true);
			shotSprite.graphics.endFill();
		}
		
		/**
		 */		
		private function frameClick(evt:MouseEvent):void
		{
			frameBtn.selected = !frameBtn.selected;
			frameBtn.mouseEnabled = true;
		}
		
		/**
		 */		
		private var shotSprite:Sprite = new Sprite;
		
		/**
		 */		
		private var frameBtn:IconBtn = new IconBtn;
	}
}