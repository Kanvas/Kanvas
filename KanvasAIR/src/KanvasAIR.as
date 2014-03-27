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
	
	import view.toolBar.ToolBarCustomFunc;
	
	/**
	 * 
	 */	
	public class KanvasAIR extends Kanvas
	{
		public function KanvasAIR()
		{
			super();
			
			this.apiClass = APIForAIR;
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			kvsCore.air = true;
			ToolBarCustomFunc.importData = dataTest.importData;
			ToolBarCustomFunc.exportData = dataTest.exportData;
			kvsCore.customButtonJS = false;
			kvsCore.customButtonData = customButtonData;
			
			registFileRef();
		}
		
		
		
		
		/*********************************************
		 * 
		 * 
		 * 
		 * 
		 * 拖拽，双击方式开启文件
		 * 
		 * 
		 * 
		 * 
		 * 
		 * ********************************************/
		
		/**
		 */		
		private function registFileRef():void
		{
			addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);
			addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			
			if(!NativeApplication.nativeApplication.isSetAsDefaultApplication("kvs")) 
				NativeApplication.nativeApplication.setAsDefaultApplication("kvs");
		}
		
		private function onDragIn(e:NativeDragEvent):void
		{
			var filesInClip:Clipboard = e.clipboard;
			if (filesInClip.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
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
				
				if (f.extension == "kvs")
				{
					var fs:FileStream = new FileStream(); 
					
					fs.addEventListener(Event.COMPLETE, onComplete); 
					fs.openAsync(f, FileMode.READ); 
				}
				else if (f.extension == "jpg" || f.extension == "png")
				{
					
				}
				else
				{
					
				}
			}
		}
		
		/**
		 * 双击方式开启文件
		 */		
		private function onInvoke( event:InvokeEvent ):void 
		{ 
			if (event.arguments.length > 0) 
			{ 
				var f:File = new File(event.arguments[0]); 
				var fs:FileStream = new FileStream(); 
				fs.addEventListener(Event.COMPLETE, onComplete); 
				fs.openAsync(f, FileMode.READ); 
			} 
		} 
		
		private function onComplete( event:Event ):void 
		{ 
			var fs:FileStream = event.target as FileStream; 
			var bs:ByteArray  = new ByteArray;
			fs.readBytes(bs);
			
			kvsCore.importZipData(bs);
			fs.close(); 
		}
		
		/**
		 */		
		private var customButtonData:XML = 
			<buttons>
				<button label='打开' tip='打开文件' callBack='importData'/>
				<button label='保存' tip='保存文件' callBack='exportData'/>
			</buttons>;
	}
}