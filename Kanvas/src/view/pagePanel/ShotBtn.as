package view.pagePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.XMLConfigKit.style.elements.Img;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class ShotBtn extends IconBtn
	{
		public function ShotBtn(pagesPanel:PagePanel)
		{
			super();
			
			this.pagePanel = pagesPanel;
		}
		
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