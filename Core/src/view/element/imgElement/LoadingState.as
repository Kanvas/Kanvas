package view.element.imgElement
{
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
			imgLoader.loadImg(host.imgVO.url, host.imgVO.imgID, host.imgVO.width, host.imgVO.height);
			
			host.currLoadState.render();
		}
		
		/**
		 */		
		private function imgLoaded(evt:ImgInsertEvent):void
		{
			host.imgVO.sourceData = evt.bitmapData;
			
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLoaded);
			imgLoader = null;
			
			host.toNomalState();
		}
		
		
		/**
		 */		
		private var imgLoader:ImgInsertor = new ImgInsertor;
	}
}