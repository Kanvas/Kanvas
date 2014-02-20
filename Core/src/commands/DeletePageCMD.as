package commands
{
	import model.CoreFacade;
	
	import modules.pages.PageElement;
	import modules.pages.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;

	public final class DeletePageCMD extends Command
	{
		public function DeletePageCMD()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			trace("DeletePageCMD.excute()")
			page = notification.getBody() as PageElement;
			pageVO = page.vo as PageVO;
			index1 = CoreFacade.getElementIndex(page);
			index2 = (page.vo as PageVO).index;
			
			CoreFacade.removeElement(page);
			CoreFacade.coreMediator.pageManager.removePage(pageVO);
			
			UndoRedoMannager.register(this);
		}
		
		override public function undoHandler():void
		{
			CoreFacade.addElementAt(page, index1);
			CoreFacade.coreMediator.pageManager.addPageAt(pageVO, index2);
		}
		
		override public function redoHandler():void
		{
			CoreFacade.removeElement(page);
			CoreFacade.coreMediator.pageManager.removePage(pageVO);
		}
		
		private var page:PageElement;
		private var pageVO:PageVO;
		
		private var index1:int;
		private var index2:int;
	}
}