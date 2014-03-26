package commands
{
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	import util.img.ImgLib;
	import util.undoRedo.UndoRedoMannager;
	
	import view.interact.CoreMediator;

	/**
	 */	
	public class ChangeBgImgCMD extends Command
	{
		public function ChangeBgImgCMD()
		{
			super();
		}
		
		/**
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			try {
				handler = notification.getBody() as Function;
			}
			catch(e:Error)
			{
				
			}
			
			//如果存在已有图片，则先删除已有
			/*if(CoreFacade.coreProxy.bgVO.imgURL)
				sendNotification(Command.DELETE_BG_IMG);*/
			
			imgID = ImgLib.imgID;
			
			imgInsertor = CoreFacade.coreProxy.backgroundImageLoader;
			imgInsertor.addEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLocalHandler);
			imgInsertor.insert(imgID);
		}
		
		private function imgLocalHandler(evt:ImgInsertEvent):void
		{
			
			imgInsertor.removeEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLocalHandler);
			if (imgInsertor.chooseSameImage)
			{
				ImgLib.unRegister(imgID);
			}
			else
			{
				imgInsertor.addEventListener(ImgInsertEvent.IMG_UPLOADED_TO_SERVER, imgLoadedHandler, false, 0, true);
				if (handler != null)
				{
					handler();
					handler = null;
				}
				/*var w:Number = imgInsertor.bitmapData.width;
				var h:Number = imgInsertor.bitmapData.height;
				var x:Number = - w * .5;
				var y:Number = - h * .5;
				//var rect:Rectangle = new Rectangle(x, y, w, h);
				//CoreFacade.coreMediator.mainUI.canvas.showLoading(rect);
				*/
			}
		}
		
		/**
		 * 图片上传成功才会调用此方法
		 */		
		private function imgLoadedHandler(evt:ImgInsertEvent):void
		{
			imgInsertor.removeEventListener(ImgInsertEvent.IMG_UPLOADED_TO_SERVER, imgLoadedHandler);
			
			oldImgObj = {};
			oldImgObj.imgID   = CoreFacade.coreProxy.bgVO.imgID;
			oldImgObj.imgData = CoreFacade.coreProxy.bgVO.imgData;
			oldImgObj.imgURL  = CoreFacade.coreProxy.bgVO.imgURL;
			
			newImgObj = {};
			newImgObj.imgID   = evt.imgID;
			newImgObj.imgData = evt.bitmapData;
			newImgObj.imgURL  = evt.imgURL;
			
			//CoreFacade.coreMediator.mainUI.canvas.hideLoading();
			
			updateBgImg(newImgObj);
			
			UndoRedoMannager.register(this);
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
			
			CoreFacade.coreMediator.coreApp.drawBGImg   (obj.imgData);
			(CoreFacade.coreMediator.coreApp as CoreApp).bgImgUpdated(obj.imgData);
		}
		
		private var handler:Function;
		
		/**
		 */		
		private var oldImgObj:Object;
		
		/**
		 */		
		private var newImgObj:Object;
		/**
		 */		
		private var imgInsertor:ImgInsertor;
		
		private var imgID:uint;
	}
}