package view.element.imgElement
{
	import model.vo.ImgVO;
	
	import view.element.ElementBase;

	public class NormalState extends ImgLoadStateBase
	{
		public function NormalState(host:ImgElement)
		{
			super(host);
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var imgVO:ImgVO = new ImgVO;
			imgVO.sourceData = element.imgVO.sourceData;
			imgVO.url = element.imgVO.url;
			imgVO.imgID = element.imgVO.imgID;
			
			var element:ImgElement = new ImgElement(element.cloneVO(imgVO) as ImgVO);
			element.currLoadState = element.normalState;
			
			element.toNomalState();
			
			return element;
		}
		
		/**
		 */		
		override public function render():void
		{
			if (element.imgVO.sourceData)
			{
				element.graphics.clear();
				element.shape.visible = true;
				element.drawBmd();
			}
		}
	}
}