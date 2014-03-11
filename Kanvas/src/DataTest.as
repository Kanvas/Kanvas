package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	

	/**
	 */	
	public class DataTest
	{
		/**
		 */		
		public function DataTest(importUI:Sprite, exportUI:Sprite, core:CoreApp)
		{
			this.core = core;
			
			importUI.doubleClickEnabled = true;
			importUI.addEventListener(MouseEvent.DOUBLE_CLICK, importData);
			
			exportUI.doubleClickEnabled = true;
			exportUI.addEventListener(MouseEvent.DOUBLE_CLICK, exportData);
		}
		
		/**
		 */		
		public function importData(evt:MouseEvent = null):void
		{
			file.addEventListener(Event.SELECT, onFileSelected);
			file.browse([new FileFilter("kvs", "*.kvs;*.zip;")]);
		}
		
		/**
		 */		
		private function onFileSelected(e:Event):void 
		{
			file.removeEventListener(Event.SELECT, onFileSelected);
			
			file.addEventListener(Event.COMPLETE, onFileLoaded);
			
			try
			{
				file.load();
			} 
			catch(error:Error) 
			{
				
			}
			
		}
		
		/**
		 */		
		private function onFileLoaded(e:Event):void 
		{
			file.removeEventListener(Event.COMPLETE, onFileLoaded);
			core.importZipData(file.data);
		}
		
		/**
		 */		
		public function exportData(evt:MouseEvent = null):void
		{
			var data:ByteArray = core.exportZipData();
			
			try
			{
				file.save(data, '新建文档.kvs');
			} 
			catch(error:Error) 
			{
				
			}
			
		}
		
		/**
		 */		
		private var file:FileReference = new FileReference;
		
		/**
		 */		
		private var core:CoreApp;
		
	}
}