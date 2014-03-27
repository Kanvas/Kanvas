package landray.kp.maps.main.elements
{
	import com.kvs.utils.graphic.BitmapUtil;
	
	import fl.motion.Source;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import landray.kp.ui.Loading;
	import landray.kp.utils.CoreUtil;
	
	import model.vo.ElementVO;
	import model.vo.ImgVO;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	
	import view.ui.Debugger;
	
	/**
	 * 
	 */	
	public final class Image extends Element
	{
		public function Image($vo:ElementVO)
		{
			super($vo);
		}
		
		/**
		 */		
		public function showBmp(smooth:Boolean = true):void
		{
			if (bmpDispl && contains(bmpDispl)) removeChild(bmpDispl);
			if (bmpLarge && bmpSmall)
			{
				bmpDispl = (width <= minSize || height <= minSize) ? bmpSmall : bmpLarge;
				bmpDispl.smoothing = smooth;
				addChild(bmpDispl);
			}
		}
		
		override public function render(scale:Number = 1):void
		{
			super.render();
			
			if (CoreUtil.ifHasText(imgVO.url))// 再次编辑时从服务器载入图片
			{
				loader = new ImgInsertor;
				loader.addEventListener(ImgInsertEvent.IMG_LOADED_FROM_SERVER, imgLoaded, false, 0, true);
				loader.addEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgError, false, 0, true);
				loader.loadImg(imgVO.url, imgVO.imgID);
				toLoadingState();
			}
		}
		
		override public function updateView(check:Boolean = true):void
		{
			super.updateView(check);
			checkBmdRender();
		}
		
		private function checkBmdRender():void
		{
			var renderBmdNeeded:Boolean = (width > minSize && height > minSize)
				? (lastWidth<= minSize || lastHeight<= minSize)
				: (lastWidth > minSize && lastHeight > minSize);
			lastWidth  = width;
			lastHeight = height;
			if (renderBmdNeeded) showBmp();
		}
		
		
		
		/**
		 */		
		private function toNomalState():void
		{
			showBmp();
		}
		
		/**
		 */		
		private function toLoadingState():void
		{
			drawLoading();
		}
		
		/**
		 */		
		private function drawLoading():void
		{
			graphics.clear();
			graphics.beginFill(0x555555, .3);
			graphics.drawRect( - vo.width * .5, - vo.height * .5, vo.width, vo.height);
			graphics.endFill();
			
			createLoading();
		}
		
		private function initBmp(bmd:BitmapData):void
		{
			if (bmd)
			{
				bmdLarge = bmd;
				bmpLarge = new Bitmap(bmdLarge);
				bmpLarge.width  =  vo.width;
				bmpLarge.height =  vo.height;
				bmpLarge.x = -.5 * vo.width;
				bmpLarge.y = -.5 * vo.height;
				if(!bmdSmall)
				{
					var ow:Number = bmdLarge.width;
					var oh:Number = bmdLarge.height;
					if (ow > minSize && oh > minSize)
					{
						var ss:Number = (ow > oh) ? minSize / oh : minSize / ow;
						bmdSmall = new BitmapData(ow * ss, oh * ss, true, 0);
						var matrix:Matrix = new Matrix;
						matrix.scale(ss, ss);
						bmdSmall.draw(bmdLarge, matrix, null, null, null, true);
					}
					else
					{
						bmdSmall = bmdLarge;
					}
					bmpSmall = new Bitmap(bmdSmall);
					bmpSmall.width  =  vo.width;
					bmpSmall.height =  vo.height;
					bmpSmall.x = -.5 * vo.width;
					bmpSmall.y = -.5 * vo.height;
				}
			}
		}
		
		private function createLoading():void
		{
			if(!loading) 
				addChild(loading = new Loading);
			loading.play();
		}
		private function removeLoading():void
		{
			if (loading) 
			{
				if (contains(loading)) 
					removeChild(loading);
				loading.stop();
				loading = null;
			}
		}
		
		/**
		 */		
		private function imgLoaded(e:ImgInsertEvent):void
		{
			Debugger.debug("imgLoaded:", imgVO.url);
			initBmp(e.bitmapData);
			
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED_FROM_SERVER, imgLoaded);
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgError);
			loader = null;
			
			toNomalState();
			removeLoading();
		}
		
		/**
		 */		
		private function imgError(evt:ImgInsertEvent):void
		{
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED_FROM_SERVER, imgLoaded);
			loader.removeEventListener(ImgInsertEvent.IMG_LOADED_ERROR, imgError);
			loader = null;
			
			graphics.clear();
			
			graphics.beginFill(0xff0000, 0.3);
			graphics.drawRect( - vo.width * .5, - vo.height * .5, vo.width, vo.height);
			graphics.endFill();
			
			var iconSize:Number = (vo.width > vo.height) ? vo.height * 0.5 : vo.width * 0.5;
			BitmapUtil.drawBitmapDataToGraphics(new load_error, graphics, iconSize, iconSize, - iconSize * 0.5, - iconSize * 0.5, false);
			
			removeLoading();
		}
		
		private function get imgVO():ImgVO
		{
			return vo as ImgVO;
		}
		
		/**
		 */		
		private var loader :ImgInsertor;
		private var loading:Loading;
		
		private var lastWidth :Number;
		private var lastHeight:Number;
		private var minSize   :Number = 20;
		
		private var bmdLarge:BitmapData;
		private var bmdSmall:BitmapData;
		private var bmpLarge:Bitmap;
		private var bmpSmall:Bitmap;
		private var bmpDispl:Bitmap;
		
	}
}