package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;
	
	/**
	 * 删除临时组合里的子元素
	 */	
	public class DeleteChildInTemGroupCMD extends Command
	{
		public function DeleteChildInTemGroupCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			groupElements = CoreFacade.coreMediator.autoGroupController.elements;
			//CoreFacade.coreMediator.autoGroupController.
			
			for each (var item:ElementBase in groupElements)
			{
				CoreFacade.removeElement(item);
			}
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			for each (var item:ElementBase in groupElements)
				CoreFacade.addElement(item);
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			for each (var item:ElementBase in groupElements)
				CoreFacade.removeElement(item);
		}
		
		/**
		 */		
		private var shape:ElementBase;
		
		/**
		 */		
		private var groupElements:Vector.<ElementBase>;
		
	}
}