package view.element.imgElement
{
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Shape;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;

	public class LoadingState extends ImgLoadStateBase
	{
		public function LoadingState(host:ImgElement)
		{
			super(host);
		}
		
		/**
		 */		
		override public function render():void
		{
			element.drawLoading();
		}
		
		/**
		 */		
		override public function loadingImg():void
		{
			imgLoader.addEventListener(ImgInsertEvent.IMG_LOADED_FROM_SERVER, imgLoaded, false, 0, true);
			imgLoader.addEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgLoadError, false, 0, true);
			
			imgLoader.loadImg(element.imgVO.url, element.imgVO.imgID, element.imgVO.width, element.imgVO.height);
			
			render();
		}
		
		private function imgLoadError(evt:ImgInsertEvent):void
		{
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLoaded);
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgLoadError);
			imgLoader = null;
			
			element.currLoadState = element.normalState;
			
			element.graphics.clear();
			element.shape.visible = true;
			element.graphics.clear();
			element.graphics.beginFill(0xff0000, 0.3);
			element.graphics.drawRect( - element.vo.width / 2, - element.vo.height / 2, element.vo.width, element.vo.height);
			element.graphics.endFill();
			
			var iconSize:Number = (element.vo.width > element.vo.height) ? element.vo.height * 0.5 : element.vo.width * 0.5;
			BitmapUtil.drawBitmapDataToShape(new load_error, element.shape as Shape, iconSize, iconSize, - iconSize * 0.5, - iconSize * 0.5, true);
			
			element.removeLoading();
		}
		
		/**
		 */		
		private function imgLoaded(evt:ImgInsertEvent):void
		{
			element.imgVO.sourceData = evt.bitmapData;
			
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLoaded);
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgLoadError);
			imgLoader = null;
			
			element.toNomalState();
		}
		
		
		/**
		 */		
		private var imgLoader:ImgInsertor = new ImgInsertor;
	}
}