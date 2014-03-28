package view.element.imgElement
{
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import landray.kp.ui.Loading;
	
	import model.vo.ImgVO;
	
	import util.img.ImgLib;
	
	import view.element.ElementBase;
	import view.element.ElementEvent;
	import view.interact.autoGroup.IAutoGroupElement;
	
	
	/**
	 * 图片
	 */
	public class ImgElement extends ElementBase implements IAutoGroupElement
	{
		public function ImgElement(vo:ImgVO)
		{
			super(vo);
			xmlData = <img/>;
			
			shape.visible = false;
			autoGroupChangable = false;
			
			// 图片加载状态初始化
			loadingState = new LoadingState(this);
			normalState = new NormalState(this);
			currLoadState = loadingState;
		}
		
		public function showBmp(smooth:Boolean = true):void
		{
			if (bmpLarge && bmpSmall)
			{
				var tmpDispl:Bitmap = (width <= minSize || height <= minSize) ? bmpSmall : bmpLarge;
				if (tmpDispl != bmpDispl)
				{
					if (bmpDispl && contains(bmpDispl)) 
						removeChild(bmpDispl);
					bmpDispl = tmpDispl;
					addChild(bmpDispl);
				}
				bmpDispl.smoothing = smooth;
			}
		}
		
		override public function updateView(check:Boolean=true):void
		{
			super.updateView(check);
			checkBmdRender();
		}
		
		
		
		
		
		
		
		
		
		//------------------------------------------
		//
		//
		// 图片有两种特殊状态： 加载状态和正常状态
		//
		// 默认为加载状态，此时正在加载/上传图片
		//
		//
		//------------------------------------------
		
		
		/**
		 */		
		internal var currLoadState:ImgLoadStateBase;
		internal var loadingState:ImgLoadStateBase;
		internal var normalState:ImgLoadStateBase;
		
		
		/**
		 */		
		public function toNomalState():void
		{
			currLoadState = normalState;
			
			initBmp(imgVO.sourceData);
			currLoadState.render();
		}
		
		/**
		 */		
		override public function del():void
		{
			dispatchEvent(new ElementEvent(ElementEvent.DEL_IMG, this));
		}
		
		/**
		 */		
		override public function exportData():XML
		{
			xmlData = super.exportData();
			
			xmlData.@url = imgVO.url;
			xmlData.@imgID = imgVO.imgID;
			
			return xmlData;
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			return currLoadState.clone();
		}
		
		/**
		 */		
		override protected function init():void
		{
			preRender();
			render();
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			rendered = true;
			super.render();
			
			// 图片插入时
			if (imgVO.sourceData)
			{
				currLoadState.render();
			}
			else if (imgVO.url != "null" && RexUtil.ifHasText(imgVO.url))// 再次编辑时从服务器载入图片, 或者从内存中加载图片
			{
				currLoadState.loadingImg();
			}
			else if (CoreApp.isAIR)
			{
				currLoadState.loadingImg();
			}
		}
		
		private var rendered:Boolean;
		
		/**
		 */		
		internal function createLoading():void
		{
			if(!loading) 
				addChild(loading = new Loading);
			loading.play();
		}
		
		internal function removeLoading():void
		{
			if (loading) 
			{
				if (contains(loading)) 
					removeChild(loading)
				
				loading.stop();
				loading = null;
			}
		}
		
		/**
		 */		
		internal function drawLoading():void
		{
			graphics.clear();
			graphics.beginFill(0x555555, 0.3);
			graphics.drawRect( - vo.width / 2, - vo.height / 2, vo.width, vo.height);
			graphics.endFill();
			
			createLoading();
		}
		
		/**
		 */		
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
		
		private function checkBmdRender():void
		{
			var renderBmdNeeded:Boolean = (width > minSize && height > minSize)
				? (lastWidth<= minSize || lastHeight<= minSize)
				: (lastWidth > minSize && lastHeight > minSize);
			lastWidth  = width;
			lastHeight = height;
			if (renderBmdNeeded) 
			{
				showBmp();
			}
		}
		
		
		/**
		 * 
		 * 元素的原始尺寸 乘以 缩放比例  = 实际尺寸；
		 * 
		 */		
		override public function get scaledWidth():Number
		{
			return vo.width * vo.scale;		
		}
		
		/**
		 */		
		override public function get scaledHeight():Number
		{
			return vo.height * vo.scale;
		}
		
		/**
		 */		
		public function get imgVO():ImgVO
		{
			return vo as ImgVO;
		}
		
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