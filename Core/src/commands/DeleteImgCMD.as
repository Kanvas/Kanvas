package commands
{
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;
	import view.element.imgElement.ImgElement;

	/**
	 */	
	public class DeleteImgCMD extends Command
	{
		public function DeleteImgCMD()
		{
			super();
		}
		
		/**
		 * 如果图片原始数据不再被其他图片元素共用，则取消其在图片库中的引用；
		 * 
		 * 撤销时重新注册到图片库中
		 * 
		 * 图片的删除并不会直接从服务器端删除，最多从kanvas的图片库中删除数据
		 * 
		 * 服务器端负责无效图片数据的统一清理
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			element = notification.getBody() as ImgElement;
			
			elementIndex = element.index;
			
			CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(element);
			CoreFacade.removeElement(element);
			if (element.isPage)
				CoreFacade.coreMediator.pageManager.removePage(element.vo.pageVO);
			
			v = CoreFacade.coreMediator.pageManager.refreshVOThumbs();
			// 判断如果系统中不再含有此图片ID的图片元素，则从图片库中删除此元素
			/*if (ifImgShared == false)
				ImgLib.unRegister(element.imgVO.imgID);*/
			
			UndoRedoMannager.register(this);
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			CoreFacade.addElementAt(element, elementIndex);
			if (element.isPage)
				CoreFacade.coreMediator.pageManager.addPageAt(element.vo.pageVO, element.vo.pageVO.index);
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			//ImgLib.register(imgElement.imgVO.imgID.toString(), imgElement.imgVO.sourceData);
			
			this.dataChanged();
		}
		
		override public function redoHandler():void
		{
			CoreFacade.removeElement(element);
			if (element.isPage)
				CoreFacade.coreMediator.pageManager.removePage(element.vo.pageVO);
			CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			//ImgLib.unRegister(imgElement.imgVO.imgID);
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var element:ImgElement;
		
		private var elementIndex:int;
		
		/**
		 */		
		private function get ifImgShared():Boolean
		{
			var isImgShared:Boolean = false;
			for each (var element:ElementBase in CoreFacade.coreProxy.elements)
			{
				if (element is ImgElement && (element as ImgElement).imgVO.imgID == this.element.imgVO.imgID)
				{
					isImgShared = true;
					break;
				}
			}
			
			return isImgShared;
		}
		
		private var v:Vector.<PageVO>;
	}
}