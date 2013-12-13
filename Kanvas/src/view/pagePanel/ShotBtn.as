package view.pagePanel
{
	import com.kvs.ui.button.IconBtn;
	
	import flash.events.MouseEvent;
	
	/**
	 */	
	public class ShotBtn extends IconBtn
	{
		public function ShotBtn()
		{
			super();
		}
		
		/**
		 */		
		override protected function init():void
		{
			frameBtn.w = frameBtn.iconW = w;
			frameBtn.h = frameBtn.iconH = h;
			
			shot_frame_up;
			shot_frame_over;
			shot_frame_down;
			frameBtn.setIcons('shot_frame_up', 'shot_frame_over', 'shot_frame_down');
			frameBtn.addEventListener(MouseEvent.CLICK, frameClick);
			addChild(frameBtn);
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
		private var frameBtn:IconBtn = new IconBtn;
	}
}