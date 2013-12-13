package view.pagePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.ui.label.TextFlowLabel;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.vo.TextVO;
	
	/**
	 */	
	public class PageUI extends IconBtn
	{
		public function PageUI(vo:Object)
		{
			super();
			
			this.pageVO = vo;
			addChild(label);
			
			deleteBtn = new IconBtn;
			deleteBtn.tips = '删除页面';
			deleteBtn.iconW = deleteBtn.iconH = 16;
			deleteBtn.setIcons('del_up', 'del_over', 'del_down');
			deleteBtn.visible = false;
			addChild(deleteBtn);
			
			deleteBtn.addEventListener(MouseEvent.CLICK, delHander);
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		
		/**
		 */		
		private function delHander(evt:MouseEvent):void
		{
			this.dispatchEvent(new Event('delPageToCore', true));
		}
		
		/**
		 */		
		private function rollOver(et:MouseEvent):void
		{
			deleteBtn.visible = true;
		}
		
		/**
		 */		
		private function rollOut(evt:MouseEvent):void
		{
			deleteBtn.visible = false;
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			var ty:Number = (currState.height - iconH) / 2;
			
			this.graphics.lineStyle(1, 0xEEEEEE);
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(leftGutter, ty, iconW, iconH);
			this.graphics.endFill();
			
			deleteBtn.x = leftGutter + iconW;
			deleteBtn.y = ty;
		}
		
		/**
		 * 左侧防止文字的间距 
		 */		
		private var leftGutter:uint = 35;
		
		/**
		 */		
		private var label:LabelUI = new LabelUI;
		
		/**
		 * 用于绘制页面缩略图 
		 */		
		private var imgShape:Shape = new Shape;
		
		/**
		 * 更新序号显示
		 */		
		public function updataLabel():void
		{
			label.text = pageVO.index + 1;
			
			updateLabelWidthStyle();
			
			label.x = (leftGutter - label.width) / 2;
            label.y = (h - label.height) / 2;
		}
		
		/**
		 */		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			
			this.mouseEnabled = true;
			updateLabelWidthStyle();
		}
		
		/**
		 */		
		private function updateLabelWidthStyle():void
		{
			if(selected)
				label.styleXML = selectedTextStyle;
			else
				label.styleXML = normalTextStyle;
			
			label.render();
		}
		
		/**
		 */		
		private var normalTextStyle:XML = <label radius='0' vPadding='0' hPadding='0'>
											<format color='#555555' font='雅痞' size='12'/>
										  </label>
			
		/**
		 */		
		private var selectedTextStyle:XML = <label radius='0' vPadding='0' hPadding='0'>
											<format color='#ffffff' font='雅痞' size='12'/>
										  </label>
		
		/**
		 */		
		public var pageVO:Object;
		
		/**
		 */		
		private var deleteBtn:IconBtn
	}
}