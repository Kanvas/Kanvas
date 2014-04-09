package
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.ExternalUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 网页版的kanvas
	 */	
	public class KanvasWeb extends Kanvas
	{
		public function KanvasWeb()
		{
			super();
		}
		
		/**
		 */		 
		override protected function kvsReadyHandler(evt:KVSEvent):void
		{
			super.kvsReadyHandler(evt);
			
			this.api = new APIForJS(kvsCore);
			initBtns();
		}
		
		/**
		 * 初始化控制按钮， 给工具条添加自定义按钮，负责保存等事物
		 */		
		private function initBtns():void
		{
			save_up;
			save_over;
			save_down;
			saveBtn.iconW = saveBtn.iconH = 30;
			saveBtn.w = saveBtn.h = 30;
			saveBtn.setIcons("save_up", "save_over", "save_down");
			saveBtn.tips = '保存';
			saveBtn.addEventListener(MouseEvent.MOUSE_DOWN, saveHandler);
			
			ok_up;
			ok_over;
			ok_down;
			exitBtn.iconW = exitBtn.iconH = 30;
			exitBtn.w = exitBtn.h = 30;
			exitBtn.setIcons("ok_up", "ok_over", "ok_down");
			exitBtn.tips = '保存并退出';
			exitBtn.addEventListener(MouseEvent.MOUSE_DOWN, exitHandler);
			
			//
			var btns:Vector.<IconBtn> = new Vector.<IconBtn>;
			btns.push(saveBtn);
			btns.push(exitBtn);
			toolBar.addCustomButtons(btns);
		}
		
		/**
		 */		
		private function saveHandler(evt:MouseEvent):void
		{
			saveBtn.selected = true;
			
			//ExternalUtil.call("saveData");
		}
		
		/**
		 * 数据保存成功
		 */		
		private function saveComplete():void
		{
			saveBtn.selected = false;
		}
		
		/**
		 */		
		private function exitHandler(evt:MouseEvent):void
		{
			exitBtn.selected = true;
			this.mouseChildren = this.mouseEnabled = false;
			this.kvsCore.alpha = 0.6;
			
			ExternalUtil.call("");
		}
		
		/**
		 * 暂存按钮 
		 */		
		private var saveBtn:IconBtn = new IconBtn;
		
		/**
		 * 提交并退出按钮
		 */		
		private var exitBtn:IconBtn = new IconBtn;
	}
}