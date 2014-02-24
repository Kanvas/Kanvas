package commands
{
	import model.CoreFacade;
	
	import view.element.PageElement;
	import model.vo.PageVO;
	
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
			groupElementIndexs = new Vector.<int>;
			//CoreFacade.coreMediator.autoGroupController.
			
			groupLength = groupElements.length;
			
			for (var i:int = 0; i < groupLength; i++)
			{
				var item:ElementBase = groupElements[i];
				groupElementIndexs[i] = item.index;
				CoreFacade.removeElement(item);
				if (item is PageElement)
					CoreFacade.coreMediator.pageManager.removePage(item.vo as PageVO);
			}
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			for (var i:int = groupLength - 1; i >= 0; i--)
			{
				var item:ElementBase = groupElements[i];
				CoreFacade.addElementAt(item, groupElementIndexs[i]);
				if (item is PageElement)
				{
					var pageVO:PageVO = item.vo as PageVO;
					CoreFacade.coreMediator.pageManager.addPageAt(pageVO, pageVO.index);
				}
			}
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			for each (var item:ElementBase in groupElements)
			{
				CoreFacade.removeElement(item);
				if (item is PageElement)
					CoreFacade.coreMediator.pageManager.removePage(item.vo as PageVO);
			}
		}
		
		/**
		 */		
		private var shape:ElementBase;
		
		/**
		 */		
		private var groupElements:Vector.<ElementBase>;
		private var groupElementIndexs:Vector.<int>;
		private var groupLength:int;
	}
}