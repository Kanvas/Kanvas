package view.themePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.XMLConfigKit.style.StatesControl;
	import com.kvs.utils.layout.IBoxItem;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class ThemeItem extends IconBtn implements IBoxItem
	{
		public function ThemeItem()
		{
			super();
		}
		
		/**
		 */		
		public var themeID:String = '';
		
		/**
		 */		
		public var icon:String = '';

	}
}