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
			imgVO.sourceData = host.imgVO.sourceData;
			imgVO.url = host.imgVO.url;
			imgVO.imgID = host.imgVO.imgID;
			
			var element:ImgElement = new ImgElement(host.cloneVO(imgVO) as ImgVO);
			element.currLoadState = host.normalState;
			
			element.toNomalState();
			
			return element;
		}
		
		/**
		 */		
		override public function render():void
		{
			host.graphics.clear();
			host.shape.visible = true;
			host.drawBmd();
		}
	}
}