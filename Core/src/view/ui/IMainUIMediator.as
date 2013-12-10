package view.ui
{
	public interface IMainUIMediator
	{
		/**
		 * 画布缩放或移动后触发
		 */		
		function updateAfterZoomMove():void;
		
		/**
		 * 主应用的背景被单击后触发
		 */		
		function bgClicked():void;
	}
}