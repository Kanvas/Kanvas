package
{
	import com.kvs.ui.button.IconBtn;
	
	import commands.ChangeBgImgAIR;
	import commands.InsertIMGFromAIR;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	import model.CoreFacade;
	
	
	/**
	 * 
	 */	
	public class KanvasAIR extends Kanvas
	{
		public function KanvasAIR()
		{
			super();
			
			CoreApp.isAIR = true;
			initCommands();
		}
		
		private function initCommands():void
		{
			CoreFacade.inserImgCommad = InsertIMGFromAIR;
			CoreFacade.insertBgCommand = ChangeBgImgAIR;
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			registFileRef();
		}
		
		/**
		 */		
		override protected function kvsReadyHandler(evt:KVSEvent):void 
		{
			super.kvsReadyHandler(evt);
			
			this.api = new APIForAIR(kvsCore);
			
			save_up;
			save_over;
			save_down;
			saveBtn.iconW = saveBtn.iconH = 30;
			saveBtn.w = saveBtn.h = 30;
			saveBtn.setIcons("save_up", "save_over", "save_down");
			saveBtn.tips = '保存';
			saveBtn.addEventListener(MouseEvent.MOUSE_DOWN, saveHandler);
			
			//
			var btns:Vector.<IconBtn> = new Vector.<IconBtn>;
			btns.push(saveBtn);
			toolBar.addCustomButtons(btns);
			
			kvsCore.addEventListener(KVSEvent.DATA_CHANGED, dataChanged);
		}
		
		/**
		 */		
		private function dataChanged(evt:KVSEvent):void
		{
			this.saveBtn.selected = false;
		}
		
		/**
		 */		
		private function saveHandler(evt:MouseEvent):void
		{
			saveBtn.selected = true;
			
			airAPI.saveFile();
		}
		
		/**
		 * 暂存按钮 
		 */		
		private var saveBtn:IconBtn = new IconBtn;
		
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
		
		/**
		 */		
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
				var file:File = new File(event.arguments[0]); 
				
				if (airAPI.file)
				{
					airAPI.openFile(file);
				}
				else
				{
					airAPI.file = file;
					kvsCore.addEventListener(Event.RESIZE, kvsResizeHandler);
				}
			} 
		} 
		
		/**
		 */		
		private function kvsResizeHandler(evt:Event):void
		{
			if (airAPI.file)
			{
				airAPI.openFile(airAPI.file);
				kvsCore.removeEventListener(Event.RESIZE, kvsResizeHandler);
			}
		}
		
	}
}