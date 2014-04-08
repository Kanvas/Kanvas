package landray.kp.maps.main.elements
{
	import model.vo.ElementVO;
	
	public final class Page extends Element
	{
		public function Page($vo:ElementVO)
		{
			super($vo);
		}
		
		override public function render(scale:Number = 1):void
		{
			if(!rendered)
			{
				rendered = true;
				super.render();
				
				graphics.beginFill(0, 0);
				graphics.drawRect(vo.style.tx, vo.style.ty, vo.style.width, vo.style.height);
				graphics.endFill();
			}
		}
	}
}