package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	/**
	 * 改变背景颜色
	 */
	public class ChangeBGColorCMD extends Command
	{
		/**
		 */		
		public function ChangeBGColorCMD()
		{
			super();
		}
		
		/**
		 */
		override public function execute(notification:INotification):void
		{
			newColorIndex = uint(notification.getBody());
			
			oldColorIndex = CoreFacade.coreProxy.bgColorIndex;
			
			setColor(newColorIndex);
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		private function setColor(index:uint):void
		{
			CoreFacade.coreProxy.bgColorIndex = index;
			CoreFacade.coreProxy.updateBgColor();
			
			sendNotification(Command.RENDER_BG_COLOR);
			
			CoreFacade.coreMediator.mainUI.bgColorUpdated(CoreFacade.coreProxy.bgColorIndex);
		}
		
		/**
		 */		
		private var oldColorIndex:uint = 0;
		
		private var newColorIndex:uint = 0;
		
		/**
		 */		
		override public function undoHandler():void
		{
			setColor(oldColorIndex);
		}
		
		override public function redoHandler():void
		{
			setColor(newColorIndex);
		}
		
	}
}