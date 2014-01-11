package view.element.imgElement
{
	import com.kvs.utils.graphic.BitmapUtil;
	
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
			host.shape.visible = false;
			host.drawIMGProxy();
		}
		
		/**
		 */		
		override public function loadingImg():void
		{
			imgLoader.addEventListener(ImgInsertEvent.IMG_LOADED_FROM_SERVER, imgLoaded, false, 0, true);
			imgLoader.addEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgLoadError, false, 0, true);
			
			imgLoader.loadImg(host.imgVO.url, host.imgVO.imgID, host.imgVO.width, host.imgVO.height);
			
			render();
		}
		
		private function imgLoadError(evt:ImgInsertEvent):void
		{
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLoaded);
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgLoadError);
			imgLoader = null;
			
			host.currLoadState = host.normalState;
			
			host.graphics.clear();
			host.shape.visible = true;
			host.shape.graphics.clear();
			host.shape.graphics.beginFill(0xff0000, 0.3);
			host.shape.graphics.drawRect( - host.vo.width / 2, - host.vo.height / 2, host.vo.width, host.vo.height);
			host.shape.graphics.endFill();
			
			var iconSize:Number = (host.vo.width > host.vo.height) ? host.vo.height * 0.5 : host.vo.width * 0.5;
			BitmapUtil.drawBitmapDataToShape(new load_error, host.shape, iconSize, iconSize, - iconSize * 0.5, - iconSize * 0.5, true);
			
			host.removeLoading();
		}
		
		/**
		 */		
		private function imgLoaded(evt:ImgInsertEvent):void
		{
			host.imgVO.sourceData = evt.bitmapData;
			
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLoaded);
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgLoadError);
			imgLoader = null;
			
			host.toNomalState();
		}
		
		
		/**
		 */		
		private var imgLoader:ImgInsertor = new ImgInsertor;
	}
}