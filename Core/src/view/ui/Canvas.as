package view.ui
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import landray.kp.ui.Loading;
	
	/**
	 */	
	public class Canvas extends Sprite
	{
		public function Canvas(mianUI:MainUIBase)
		{
			super();
			
			this.mainUI = mianUI;
			
			addChild(interactorBG);
			interactorBG.addChild(bgImgContainer = new Sprite);
		}
		
		
		/**
		 */		
		private var mainUI:MainUIBase;
		
		/**
		 * 是否含有元件
		 */		
		public function get ifHasElements():Boolean
		{
			return (numChildren > 1);
		}
		
		/**
		 */		
		public function drawBG(rect:Rectangle):void
		{
			interactorBG.graphics.clear();
			interactorBG.graphics.beginFill(0x666666, 0);
			interactorBG.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			interactorBG.graphics.endFill();
		}
		
		private function drawImageBG(rect:Rectangle):void
		{
			bgImgContainer.graphics.clear();
			bgImgContainer.graphics.beginFill(0x666666, 1);
			bgImgContainer.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			bgImgContainer.graphics.endFill();
		}
		
		/**
		 * 画布自动缩放时需要清空背景，保证尺寸位置计算的准确性
		 */		
		public function clearBG():void
		{
			interactorBG.graphics.clear();
		}
		
		public function showLoading(rect:Rectangle):void
		{
			drawImageBG(rect);
			
			if (loading == null)
			{
				loading = new Loading;
				interactorBG.addChild(loading);
			}
		}
		
		public function hideLoading():void
		{
			bgImgContainer.graphics.clear();
			
			if (loading)
			{
				if (interactorBG.contains(loading))
					interactorBG.removeChild(loading);
				loading.stop();
				loading = null;
			}
		}
		
		/**
		 */		
		public var interactorBG:Sprite = new Sprite;
		
		private var interactRect:Rectangle;
		
		private var loading:Loading;
		
		private var bgImgContainer:Sprite;
	}
}