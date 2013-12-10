package commands
{
	
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	import model.vo.ImgVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	import util.img.ImgLib;
	import util.layout.LayoutTransformer;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;
	import view.element.imgElement.ImgElement;
	import view.ui.Canvas;
	
	
	/**
	 * 插入图片
	 */
	public class InserImageCMD extends Command
	{
		/**
		 */		
		public function InserImageCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			imgInsertor.addEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLoadedHandler);
			
			//分配图片ID，选择并上传图片
			imgInsertor.insert(ImgLib.imgID);
		}
		
		/**
		 */		
		private function imgLoadedHandler(evt:ImgInsertEvent):void
		{
			imgInsertor.addEventListener(ImgInsertEvent.IMG_UPLOADED_TO_SERVER, imgUploadComplete);
			
			imgInsertor.removeEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLoadedHandler);
			var layoutTransformer:LayoutTransformer = CoreFacade.coreMediator.layoutTransformer;
			
				
			// 元素ID与图片资源ID单独管理
			var imgVO:ImgVO = new ImgVO();
			imgVO.id = ElementCreator.id;
			imgVO.url = evt.imgURL;
			imgVO.imgID = evt.imgID;
			imgVO.sourceData = evt.bitmapData;
			
			imgVO.width = imgVO.sourceData.width;
			imgVO.height = imgVO.sourceData.height;
			
			//防止图片太大，，这里提前缩小图片比例
			var maxSize:Number;
			var imgScale:Number = 1;
			if (imgVO.width > imgVO.height)
				maxSize = imgVO.width;
			else
				maxSize = imgVO.height;
			
			if (maxSize > MAX_SIZE)
				imgScale = MAX_SIZE / maxSize;
				
			imgVO.scale = layoutTransformer.compensateScale * imgScale;
			
			//防止图片插入时遮盖到已有内容，需将其放置到已有内容边缘
			var canvas:Canvas = CoreFacade.coreMediator.canvas;
			canvas.clearBG();
			var bd:Rectangle = canvas.getBounds(canvas);
			
			imgVO.x = bd.left + bd.width + imgVO.width * imgVO.scale / 2 + 20 / layoutTransformer.canvasScale;
			imgVO.y = bd.top + (bd.height - imgVO.height * imgVO.scale) / 2 + imgVO.height * imgVO.scale / 2;
			
			imgElement = new ImgElement(imgVO);
			CoreFacade.addElement(imgElement);
			
			elementIndex = CoreFacade.getElementIndex(imgElement);
			
			this.sendNotification(Command.SElECT_ELEMENT, imgElement);
			
			// 图形创建时 添加动画效果
			TweenLite.from(imgElement, 0.3, {alpha: 0, scaleX : 0, scaleY : 0});
			
			UndoRedoMannager.register(this);
		}
		
		/**
		 */		
		private const MAX_SIZE:uint = 500;
		
		/**
		 */		
		private function imgUploadComplete(evt:ImgInsertEvent):void
		{
			imgInsertor.removeEventListener(ImgInsertEvent.IMG_UPLOADED_TO_SERVER, imgUploadComplete);
			
			imgElement.imgVO.url = evt.imgURL;
			imgElement.toNomalState();
			
			//imgElement.stage.loaderInfo.url;
		}
		
		/**
		 */		 
		override public function undoHandler():void
		{
			CoreFacade.removeElement(imgElement);
			
			if (ifImgShared == false)
				ImgLib.unRegister(imgElement.imgVO.imgID);
		}
		override public function redoHandler():void
		{
			CoreFacade.addElementAt(imgElement, elementIndex);
			if (ifImgShared == false)
				ImgLib.register(imgElement.imgVO.imgID.toString(), imgElement.imgVO.sourceData);
		}
		
		/**
		 */		
		private function get ifImgShared():Boolean
		{
			var isImgShared:Boolean = false;
			for each (var temp:ElementBase in CoreFacade.coreProxy.elements)
			{
				if (temp is ImgElement) 
				{
					var element:ImgElement = temp as ImgElement;
					if (element.imgVO.imgID == this.imgElement.imgVO.imgID)
					{
						isImgShared = true;
						break;
					}
				}
				
			}
			
			return isImgShared;
		}
		
		/**
		 */		
		private var imgElement:ImgElement;
		
		private var elementIndex:int;
		
		/**
		 */		
		private var imgInsertor:ImgInsertor = new ImgInsertor;
	}
}