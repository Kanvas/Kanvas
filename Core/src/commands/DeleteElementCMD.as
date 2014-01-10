package commands
{
	import model.CoreFacade;
	
	import modules.pages.PageElement;
	import modules.pages.PageVO;
	
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
					if (item is PageElement)
						CoreFacade.coreMediator.pageManager.removePage(item.vo as PageVO);
				}
			}
			
			UndoRedoMannager.register(this);
		}
		
		
		
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
					CoreFacade.addElementAt(groupElements[i], elementIndexArray[i]);
					if (item is PageElement)
					{
						var pageVO:PageVO = item.vo as PageVO;
						CoreFacade.coreMediator.pageManager.addPageAt(pageVO, pageVO.index);
					}
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
				{
					CoreFacade.removeElement(item);
					if (item is PageElement)
						CoreFacade.coreMediator.pageManager.removePage(item.vo as PageVO);
				}
			}
		}
		
		/**
		 */		
		private var shape:ElementBase;
		
		private var elementIndex:int;
		
		private var elementIndexArray:Array;
		
		private var groupElements:Vector.<ElementBase>;
		
		private var autoGroupEnabled:Boolean;
	}
}