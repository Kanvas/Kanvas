package landray.kp.maps.main.elements
{
	import model.vo.PageVO;
	
	public final class Page extends BaseElement
	{
		public function Page($vo:PageVO)
		{
			super($vo);
			mouseEnabled = false;
		}
		
		override public function render(scale:Number = 1):void
		{
			super.render();
			graphics.beginFill(0, 0);
			graphics.drawRect(vo.style.tx, vo.style.ty, vo.style.width, vo.style.height);
			graphics.endFill();
		}
	}
}