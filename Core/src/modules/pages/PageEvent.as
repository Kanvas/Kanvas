package modules.pages
{
	import flash.events.Event;
	
	public final class PageEvent extends Event
	{
		
		public static const UPDATE_LAYOUT:String = "updateLayout";
		
		public static const UPDATE_THUMB:String = "updateThumb";
		
		public function PageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}