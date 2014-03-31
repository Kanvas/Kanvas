package
{
	import commands.InserImageCMD;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import model.CoreFacade;
	
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
			
			CoreApp.isAIR = true;
			CoreFacade.inserImgCommad = InsertIMGFromAIR;
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			registFileRef();
		}
		
		/**
		 * 
		 */		
		override protected function kvsReadyHandler(evt:KVSEvent):void 
		{
			super.kvsReadyHandler(evt);
			
			ToolBarCustomFunc.openFile = airAPI.openFile;
			ToolBarCustomFunc.saveFile = airAPI.saveFile;
			
			kvsCore.customButtonJS = false;
			kvsCore.customButtonData = customButtonData;
		}
		
		/**
		 */		
		private function get airAPI():APIForAIR
		{
			return api as APIForAIR;
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
		
		/**
		 */		
		private function onDragDrop(e:NativeDragEvent):void
		{
			var filesArray:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if (filesArray.length)
			{
				var f:File = filesArray[0];
				
				if (f.extension == "kvs")
				{
					airAPI.openFile(f);
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
			//先窗口最大化
			NativeApplication.nativeApplication.activeWindow.maximize();
			
			if (event.arguments.length > 0) 
			{ 
				var f:File = new File(event.arguments[0]); 
				airAPI.openFile(f);
			} 
		} 
		
		/**
		 */		
		private var customButtonData:XML = 
			<buttons>
				<button label='打开' tip='打开文件' callBack='openFile'/>
				<button label='保存' tip='保存文件' callBack='saveFile'/>
			</buttons>;
	}
}