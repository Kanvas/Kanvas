package view.interact.interactMode
{
	import view.interact.CoreMediator;
	
	/**
	 * 预览模式
	 */	
	public class PrevMode extends ModeBase
	{
		public function PrevMode(mainMediator:CoreMediator)
		{
			super(mainMediator);
		}
		
		/**
		 */		
		override public function toUnSelectedMode():void
		{
			mainMediator.currentMode = mainMediator.unSelectedMode;
			
			mainMediator.zoomMoveControl.autoZoom();
			returnFromPrevState();
		}
	}
}