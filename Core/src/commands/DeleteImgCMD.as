package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.img.ImgLib;
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
			
			imgElement = notification.getBody() as ImgElement;
			
			
			elementIndex = CoreFacade.getElementIndex(imgElement);
			CoreFacade.removeElement(imgElement);
			
			// 判断如果系统中不再含有此图片ID的图片元素，则从图片库中删除此元素
			if (ifImgShared == false)
				ImgLib.unRegister(imgElement.imgVO.imgID);
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			CoreFacade.addElementAt(imgElement, elementIndex);
			ImgLib.register(imgElement.imgVO.imgID.toString(), imgElement.imgVO.sourceData);
		}
		
		override public function redoHandler():void
		{
			CoreFacade.removeElement(imgElement);
			ImgLib.unRegister(imgElement.imgVO.imgID);
		}
		
		/**
		 */		
		private var imgElement:ImgElement;
		
		private var elementIndex:int;
		
		/**
		 */		
		private function get ifImgShared():Boolean
		{
			var isImgShared:Boolean = false;
			for each (var element:ElementBase in CoreFacade.coreProxy.elements)
			{
				if (element is ImgElement && (element as ImgElement).imgVO.imgID == this.imgElement.imgVO.imgID)
				{
					isImgShared = true;
					break;
				}
			}
			
			return isImgShared;
		}
	}
}