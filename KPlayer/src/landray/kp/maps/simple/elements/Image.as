package landray.kp.maps.simple.elements
{
	import flash.display.Shape;
	
	import landray.kp.ui.Loading;
	import landray.kp.utils.CoreUtil;
	
	import model.vo.ElementVO;
	import model.vo.ImgVO;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	
	public final class Image extends BaseElement
	{
		public function Image($vo:ElementVO)
		{
			super($vo);
			imgCanvas.visible = false;
			addChild(imgCanvas);
		}
		
		override public function render(scale:Number = 1):void
		{
			super.render();
			
			if (CoreUtil.ifHasText(imgVO.url))// 再次编辑时从服务器载入图片
			{
				imgLoader = new ImgInsertor;
				imgLoader.addEventListener(ImgInsertEvent.IMG_LOADED_FROM_SERVER, imgLoaded, false, 0, true);
				imgLoader.loadImg(imgVO.url, imgVO.imgID);
				
				toLoadingState();
			}
			else if (CoreUtil.imageLibHasData(imgVO.imgID))// 资源包导入方式会用到，从资源库中获取数据
			{
				imgVO.sourceData = CoreUtil.imageLibGetData(imgVO.imgID);
				toNomalState();
			}
		}
		
		private function imgLoaded(e:ImgInsertEvent):void
		{
			imgVO.sourceData = e.bitmapData;
			
			imgLoader.removeEventListener(ImgInsertEvent.IMG_LOADED_TO_LOCAL, imgLoaded);
			imgLoader = null;
			
			drawBmd();
			
			toNomalState();
		}
		
		private function toNomalState():void
		{
			graphics.clear();
			imgCanvas.visible = true;
			drawBmd();
		}
		
		/**
		 */		
		private function toLoadingState():void
		{
			imgCanvas.visible = false;
			drawIMGProxy();
		}
		
		private function drawIMGProxy():void
		{
			graphics.clear();
			graphics.beginFill(0x555555);
			graphics.drawRect( - vo.width * .5, - vo.height * .5, vo.width, vo.height);
			graphics.endFill();
			
			if (! loading) 
				addChild(loading = new Loading);
			loading.play();
			
		}
		
		private function drawBmd():void
		{
			imgCanvas.graphics.clear();
			CoreUtil.drawBitmapDataToShape(imgVO.sourceData, imgCanvas, 
				vo.width, vo.height, - vo.width * .5, - vo.height * .5, true);
			
			if (loading) 
			{
				if (contains(loading)) 
					removeChild(loading);
				loading.stop();
				loading = null;
			}
		}
		
		private function get imgVO():ImgVO
		{
			return vo as ImgVO;
		}
		
		
		
		private var imgCanvas:Shape = new Shape;
		private var imgLoader:ImgInsertor;
		
		private var loading:Loading;
	}
}