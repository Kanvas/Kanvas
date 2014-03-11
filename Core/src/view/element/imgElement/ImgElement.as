package view.element.imgElement
{
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Shape;
	
	import landray.kp.ui.Loading;
	
	import model.vo.ImgVO;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
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
			
			
			// 图片加载状态初始化
			this.loadingState = new LoadingState(this);
			this.normalState = new NormalState(this);
			this.currLoadState = loadingState;
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
			super.render();
			
			// 图片插入时
			if (imgVO.sourceData)
			{
				currLoadState.render();
			}
			else if (ImgLib.ifHasData(imgVO.imgID))// 资源包导入方式会用到，从资源库中获取数据
			{
				imgVO.sourceData = ImgLib.getData(imgVO.imgID);
				toNomalState();
			}
			else if (imgVO.url != "null" && RexUtil.ifHasText(imgVO.url))// 再次编辑时从服务器载入图片
			{
				currLoadState.loadingImg();
			}
		}
		
		/**
		 */		
		internal function drawBmd():void
		{
			shape.graphics.clear();
			BitmapUtil.drawBitmapDataToShape(imgVO.sourceData, shape, 
				vo.width, vo.height, - vo.width / 2, - vo.height / 2, false);
			
			removeLoading();
		}
		
		/**
		 */		
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
		internal function drawIMGProxy():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x555555, 0.3);
			this.graphics.drawRect( - vo.width / 2, - vo.height / 2, vo.width, vo.height);
			this.graphics.endFill();
			
			if (!loading) 
				addChild(loading = new Loading);
			
			loading.play();
		}
		
		/**
		 * 
		 * 元素的原始尺寸 乘以 缩放比例  = 实际尺寸；
		 * 
		 */		
		override public function get scaledWidth():Number
		{
			var w:Number = vo.width * vo.scale;		
			
			return 	w;
		}
		
		/**
		 */		
		override public function get scaledHeight():Number
		{
			var h:Number = vo.height * vo.scale;
			
			return h;		
		}
		
		/**
		 */		
		public function get imgVO():ImgVO
		{
			return vo as ImgVO;
		}
		
		private var loading:Loading;
	}
}