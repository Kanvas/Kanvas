package
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 */	
	public class KanvasAIR4 extends Kanvas
	{
		public function KanvasAIR4()
		{
			super();
		}
		
		override protected function init():void
		{
			super.init();
			kvsCore.customButtonJS = false;
			kvsCore.customButtonData = customButtonData;
			registFileRef();
		}
		
		private function registFileRef():void
		{
			addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);
			addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
			NativeApplication.nativeApplication.addEventListener( InvokeEvent.INVOKE, onInvoke ); 
			var t:Boolean = NativeApplication.nativeApplication.isSetAsDefaultApplication("kvs");
			if (!t) NativeApplication.nativeApplication.setAsDefaultApplication("kvs");
		}
		
		private function onDragIn(e:NativeDragEvent):void
		{
			var filesInClip:Clipboard = e.clipboard;
			if(filesInClip.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				NativeDragManager.acceptDragDrop(this);
				NativeDragManager.dropAction = NativeDragActions.MOVE;
			}
		}
		
		private function onDragDrop(e:NativeDragEvent):void
		{
			var filesArray:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if (filesArray.length)
			{
				var f:File = filesArray[0];
				var fs:FileStream = new FileStream(); 
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
			kvsCore.importZipData(bytes);
			fs.close(); 
		}
		
		private var customButtonData:XML = 
			<buttons>
				<button label='打开' tip='打开文件' callBack='importData'/>
				<button label='保存' tip='保存文件' callBack='exportData'/>
			</buttons>;
	}
}