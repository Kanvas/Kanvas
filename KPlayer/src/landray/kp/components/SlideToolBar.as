package landray.kp.components
{
	import com.kvs.ui.button.IconBtn;
	
	import flash.display.Sprite;
	
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Viewer;
	
	public final class SlideToolBar extends Sprite
	{
		public function SlideToolBar($viewer:Viewer)
		{
			super();
			
			viewer = $viewer;
			
			CoreUtil.initApplication(this, initialize);
		}
		
		public function updateLayout():void
		{
			drawBackground();
		}
		
		private function initialize():void
		{
			//background
			drawBackground();
			//buttons
		}
		
		private function drawBackground():void
		{
			clear();
			with (graphics) 
			{
				beginFill(0x474946);
				drawRect(0, 0, viewer.width, 36);
				endFill();
			}
		}
		
		private var viewer:Viewer;
		
		private var prev:IconBtn;
		
		private var next:IconBtn;
		
		private var full:IconBtn;
		
		private var half:IconBtn;
	}
}