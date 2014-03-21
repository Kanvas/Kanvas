package model.vo
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import modules.pages.PageEvent;
	import modules.pages.PageQuene;
	import modules.pages.pg_internal;
	
	[Event(name="updateThumb", type="modules.pages.PageEvent")]
	
	[Event(name="deletePageFromUI", type="modules.pages.PageEvent")]
	
	[Event(name="pageSelected", type="modules.pages.PageEvent")]
	
	[Event(name="updatePageIndex", type="modules.pages.PageEvent")]
	
	/**
	 */	
	public final class PageVO extends ElementVO
	{
		public function PageVO()
		{
			super();
		}
		
		override public function set x(value:Number):void
		{
			if (x != value)
			{
				super.x = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set y(value:Number):void
		{
			if (y != value)
			{
				super.y = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set width(value:Number):void
		{
			if (width != value)
			{
				super.width = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set height(value:Number):void
		{
			if (height != value)
			{
				super.height = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set scale(value:Number):void
		{
			if (scale != value)
			{
				super.scale = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function set rotation(value:Number):void
		{
			if (rotation != value)
			{
				super.rotation = value;
				dispatchEvent(new PageEvent(PageEvent.UPDATE_THUMB, this));
			}
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			return (thumbUpdatable) ? super.dispatchEvent(event) : false;
		}
		
		public function get parent():PageQuene
		{
			return pg_internal::parent;
		}
		
		pg_internal var parent:PageQuene
		
		/**
		 */		
		public function set index(value:int):void
		{
			__index = value;	
			
			dispatchEvent(new PageEvent(PageEvent.UPDATE_PAGE_INDEX, this));
		}
		
		public function get index():int
		{
			return __index;
		}
		private var __index:int = -1;
		
		public function get thumbUpdatable():Boolean
		{
			return __thumbUpdatable;
		}
		public function set thumbUpdatable(value:Boolean):void
		{
			if (__thumbUpdatable!= value)
			{
				__thumbUpdatable = value;
			}
		}
		private var __thumbUpdatable:Boolean = true;
		
		public var bitmapData:BitmapData;
	}
}