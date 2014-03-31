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
			
			var newElement:ImgElement = new ImgElement(element.cloneVO(imgVO) as ImgVO);
			newElement.currLoadState = element.normalState;
			
			newElement.toNomalState();
			
			return newElement;
		}
		
		/**
		 */		
		override public function render():void
		{
			element.showBmp();
		}
	}
}