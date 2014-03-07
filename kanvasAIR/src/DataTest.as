package
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import view.toolBar.Debugger;
	import view.toolBar.ToolBarCustomFunc;
	

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
			
			ToolBarCustomFunc.importData = importData;
			ToolBarCustomFunc.exportData = exportData;
			core.customButtonJS = false;
			core.customButtonData = customButtonData;
			
			registFileRef();
		}
		
		private function registFileRef():void
		{
			core.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);
			core.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
			NativeApplication.nativeApplication.addEventListener( InvokeEvent.INVOKE, onInvoke ); 
			var t:Boolean = NativeApplication.nativeApplication.isSetAsDefaultApplication("kvs");
			if (!t) NativeApplication.nativeApplication.setAsDefaultApplication("kvs");
		}
		
		private function onDragIn(e:NativeDragEvent):void
		{
			var filesInClip:Clipboard = e.clipboard;
			if(filesInClip.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				NativeDragManager.acceptDragDrop(core as InteractiveObject);
				NativeDragManager.dropAction = NativeDragActions.NONE;
			}
		}
		
		private function onDragDrop(e:NativeDragEvent):void
		{
			var filesArray:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			
			if (filesArray.length)
			{
				var f:File = filesArray[0];
				var fs:FileStream = new FileStream(); 
				Debugger.debug("dragIn:" + f.name + " " + f.extension);
				fs.addEventListener( Event.COMPLETE, onComplete ); 
				fs.openAsync( f, FileMode.READ ); 
			}
		}
		
		private function onInvoke( event:InvokeEvent ):void 
		{ 
			if (event.arguments.length > 0) 
			{ 
				var f:File = new File(event.arguments[0]); 
				var fs:FileStream = new FileStream(); 
				fs.addEventListener( Event.COMPLETE, onComplete ); 
				fs.openAsync( f, FileMode.READ ); 
			} 
		} 
		private function onComplete( event:Event ):void 
		{ 
			var fs:FileStream = event.target as FileStream; 
			var bytes:ByteArray = new ByteArray;
			fs.readBytes(bytes);
			core.importZipData(bytes);
			fs.close(); 
		}
		
		/**
		 */		
		private function importData(evt:MouseEvent = null):void
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
		private function exportData(evt:MouseEvent = null):void
		{
			var data:ByteArray = core.exportZipData();
			
			try
			{
				file.save(data, 'kvs.kvs');
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
		
		private var customButtonData:XML = 
			<buttons>
				<button label='打开' tip='打开文件' callBack='importData'/>
				<button label='保存' tip='保存文件' callBack='exportData'/>
			</buttons>
	}
}