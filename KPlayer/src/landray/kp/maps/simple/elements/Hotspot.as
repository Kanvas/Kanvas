package landray.kp.maps.simple.elements
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.vo.HotspotVO;
	
	
	/**
	 * 热点图
	 */	
	public final class Hotspot extends BaseElement 
	{
		public function Hotspot($vo:HotspotVO)
		{
			super($vo);
			alpha = 0;
			//buttonMode = true;
		}
		
		/**
		 * 渲染
		 */
		override public function render(scale:Number = 1):void
		{
			super.render();
			
			StyleManager.drawRect(this, vo.style, vo);
		}

	}
}