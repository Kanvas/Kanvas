package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;

	/**
	 * 图形删除指令, 负责删除图形，线条和图片
	 */	
	public class DeleteElementCMD extends Command
	{
		public function DeleteElementCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			shape = notification.getBody() as ElementBase;
			elementIndex = CoreFacade.getElementIndex(shape);
			CoreFacade.removeElement(shape);
			
			elementIndexArray = [];
			
			groupElements = CoreFacade.coreMediator.autoGroupController.elements;
			
			autoGroupEnabled = CoreFacade.coreMediator.autoGroupController.enabled;
			
			if (autoGroupEnabled)
			{
				var l:int = groupElements.length;
				for (var i:int = 0; i < l; i ++)
				{
					var item:ElementBase = groupElements[i];
					elementIndexArray[i] = CoreFacade.getElementIndex(item);
					CoreFacade.removeElement(item);
				}
			}
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		private var groupElements:Vector.<ElementBase>;
		
		/**
		 */		
		override public function undoHandler():void
		{
			//反序加入显示列表
			if (autoGroupEnabled)
			{
				var l:int = groupElements.length;
				for (var i:int = l - 1; i >= 0; i --)
				{
					var item:ElementBase = groupElements[i];
					CoreFacade.addElementAt(item, elementIndexArray[i]);
				}
			}
			CoreFacade.addElementAt(shape, elementIndex);
		}
		
		override public function redoHandler():void
		{
			CoreFacade.removeElement(shape);
			if (autoGroupEnabled)
			{
				for each (var item:ElementBase in groupElements)
					CoreFacade.removeElement(item);
			}
			
		}
		
		/**
		 */		
		private var shape:ElementBase;
		
		private var elementIndex:int;
		
		private var elementIndexArray:Array;
		
		private var autoGroupEnabled:Boolean;
	}
}