package view.ui
{
	public interface IMainUIMediator
	{
		/**
		 * 画布控制动画开启时
		 */		
		function flashStart():void
			
		/**
		 * 画布缩放或移动后触发
		 */		
		function updateAfterZoomMove():void;
		
		/**
		 * 画布动画关闭时 
		 */		
		function flashStop():void;
		
		/**
		 * 主应用的背景被单击后触发
		 */		
		function bgClicked():void;
		
		
	}
}