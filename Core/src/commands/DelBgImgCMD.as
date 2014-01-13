package commands
{
	import flash.display.BitmapData;
	
	import model.CoreFacade;
	import model.CoreProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.img.ImgInsertor;
	import util.img.ImgLib;

	/**
	 */	
	public class DelBgImgCMD extends Command
	{
		public function DelBgImgCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			//ImgLib.unRegister(CoreFacade.coreProxy.bgVO.imgID);
			imgInsertor = CoreFacade.coreProxy.backgroundImageLoader;
			imgInsertor.close();
			
			oldImgObj = {};
			oldImgObj.imgID   = CoreFacade.coreProxy.bgVO.imgID;
			oldImgObj.imgData = CoreFacade.coreProxy.bgVO.imgData;
			oldImgObj.imgURL  = CoreFacade.coreProxy.bgVO.imgURL;
			
			newImgObj = {};
			newImgObj.imgID   = 0;
			newImgObj.imgData = null;
			newImgObj.imgURL  = null;
			
			updateBgImg(newImgObj);
			
			//CoreFacade.coreMediator.mainUI.canvas.hideLoading();
			
			
		}
		
		
		override public function undoHandler():void
		{
			updateBgImg(oldImgObj);
		}
		
		
		override public function redoHandler():void
		{
			updateBgImg(newImgObj);
		}
		
		private function updateBgImg(obj:Object):void
		{
			//分配背景图片的ID
			CoreFacade.coreProxy.bgVO.imgID   = obj.imgID;
			CoreFacade.coreProxy.bgVO.imgData = obj.imgData;
			CoreFacade.coreProxy.bgVO.imgURL  = obj.imgURL;
			
			CoreFacade.coreMediator.mainUI.drawBGImg(obj.imgData);
			CoreFacade.coreMediator.mainUI.bgImgUpdated(obj.imgData);
		}
		
		/**
		 */		
		private var oldImgObj:Object;
		
		/**
		 */		
		private var newImgObj:Object;
		
		private var imgInsertor:ImgInsertor;
	}
}