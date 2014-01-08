package view.toolBar
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import control.InteractEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	/**
	 * 工具条
	 */	
	public class ToolBar extends FiUI
	{
		public function ToolBar()
		{
			super();
		}
		
		/**
		 */		
		private function prevHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new InteractEvent(InteractEvent.PREVIEW));
		}
		
		/**
		 */		
		private function addHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new InteractEvent(InteractEvent.OPEN_SHAPE_PANEL));
		}
		
		/**
		 */		
		private function openThemeHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new InteractEvent(InteractEvent.OPEN_THEME_PANEL));
		}
		
		/**
		 * 初始化
		 */		
		override protected function init():void
		{
			super.init();
			
			XMLVOMapper.fuck(bgStyleXML, bgStyle);
			
			addChild(bgShape);
			addChild(centerBtnsC);
			
			
			play_up;
			play_over;
			play_down;
			prevBtn.iconW = prevBtn.iconH = 30;
			prevBtn.w = prevBtn.h = 30;
			prevBtn.setIcons("play_up", "play_over", "play_down");
			prevBtn.tips = '预 览';
			addChild(prevBtn);
			prevBtn.addEventListener(MouseEvent.CLICK, prevHandler, false, 0, true);
			
			
			undo_up;
			undo_over;
			undo_down;
			undoBtn.iconW = undoBtn.iconH = 30;
			undoBtn.w = undoBtn.h = 30;
			undoBtn.setIcons("undo_up", "undo_over", "undo_down");
			undoBtn.selected = true;
			undoBtn.tips = '撤销';
			addChild(undoBtn);
			
			
			redo_up;
			redo_over;
			redo_down;
			redoBtn.iconW = redoBtn.iconH = 30;
			redoBtn.w = redoBtn.h = 30;
			redoBtn.setIcons("redo_up", "redo_over", "redo_down");
			redoBtn.selected = true;
			redoBtn.tips = '重做';
			addChild(redoBtn);
			
			
			add_up;
			add_over;
			add_down;
			addBtn.iconW = addBtn.iconH = 30;
			addBtn.w = addBtn.h = 30;
			addBtn.setIcons("add_up", "add_over", "add_down");
			addBtn.tips = '开启图形创建面板';
			centerBtnsC.addChild(addBtn);
			addBtn.addEventListener(MouseEvent.CLICK, addHandler, false, 0, true);
			
			
			style_up;
			style_over;
			style_down;
			themeBtn.iconW = themeBtn.iconH = 30;
			themeBtn.w = themeBtn.h = 30;
			themeBtn.setIcons("style_up", "style_over", "style_down");
			themeBtn.tips = '开启风格样式面板';
			centerBtnsC.addChild(themeBtn);
			themeBtn.x = addBtn.width + 10;
			themeBtn.addEventListener(MouseEvent.CLICK, openThemeHandler, false, 0, true);
			
			addChild(customButtonContainer = new Sprite);
			
			updateLayout();
		}
		
		/**
		 */		
		public function updateLayout():void
		{
			bgShape.graphics.clear();
			
			bgStyle.width = w;
			bgStyle.height = h + 50;
			bgStyle.ty = - 50;
			StyleManager.drawRectOnShape(bgShape, bgStyle);
			
			prevBtn.x = 20;
			prevBtn.y = (h - prevBtn.height) / 2;
			
			undoBtn.x = prevBtn.width + prevBtn.x + 50;
			undoBtn.y = (h - undoBtn.height) / 2;
			
			redoBtn.x = undoBtn.x + undoBtn.width + 10;
			redoBtn.y = (h - redoBtn.height) / 2;
			
			centerBtnsC.x = (w - centerBtnsC.width) / 2;
			centerBtnsC.y = (h - centerBtnsC.height) / 2;
			
			customButtonContainer.x = w - customButtonContainer.width - 10;
			
		}
		
		/**
		 */		
		public function setCustomButton(value:XML):void
		{
			if (value)
			{
				while (customButtonContainer.numChildren) 
					customButtonContainer.removeChildAt(0);
				
				var list:XMLList = value.children();
				var length:int = list.length();
				
				for (var i:int = 0; i < length; i++)
				{
					var button:CustomLabelBtn = new CustomLabelBtn;
					button.text = list[i].@label;
					button.tips = list[i].@tip;
					
					if (list[i].@callBack && list[i].@callBack != "" && list[i].@callBack != " ")
						button.callBack.push(list[i].@callBack);
					
					if (list[i].param)
					{
						for each (var param:XML in list[i].param)
						{
							button.callBack.push(param.toString());
						}
					}
					
					button.bgStyleXML = customBtn_bgStyle;
					button.labelStyleXML = customBtn_labelStyle;
					
					button.w = customBtnW;
					button.h = customBtnH;
					
					button.x = (customBtnW + customBtnGap) * i;
					button.y = (h - customBtnH) * .5;
					
					button.addEventListener(MouseEvent.CLICK, customButtonClick);
					customButtonContainer.addChild(button);
				}
				
				updateLayout();
			}
		}
		
		private function customButtonClick(evt:MouseEvent):void
		{
			ExternalInterface.call.apply(null, evt.currentTarget.callBack);
		}
		
		/**
		 * 中间按钮区域容器 
		 */		
		private var centerBtnsC:Sprite = new Sprite;
		
		/**
		 * 自定义按钮之间的间距
		 */		
		private var customBtnGap:uint = 5;
		
		/**
		 */		
		private var prevBtn:IconBtn = new IconBtn;
		
		/**
		 * 撤销按钮
		 */		
		public var undoBtn:IconBtn = new IconBtn();
		
		/**
		 * 反撤销按钮
		 */	
		public var redoBtn:IconBtn = new IconBtn;
		
		
		/**
		 * 元素创建按钮，点击后会弹出元素创建面板 
		 */		
		public var addBtn:IconBtn = new IconBtn;
		
		/**
		 * 风格设置按钮，点击后会弹出风格设置面板，用于设置风格和背景； 
		 */		
		public var themeBtn:IconBtn = new IconBtn;
		
		/**
		 * 绘制背景的画布
		 */		
		private var bgShape:Shape = new Shape;
		
		private var customButtonContainer:Sprite;
		
		
		
		
		
		//---------------------------------------------------
		//
		//
		//  背景， 按钮等所需的样式文件
		//
		//
		//---------------------------------------------------
			
		/**
		 * 自定义按钮文字样式配置文件 
		 */		
		private const customBtn_labelStyle:XML = <label vAlign="center">
									                <format color='#FFFFFF' font='华文细黑' size='12' letterSpacing="3"/>
									            </label>;
		
		/**
		 * 自定义按钮的背样式配置文件 
		 */		
		private const customBtn_bgStyle:XML = <states>
												<normal>
													<border color="#eeeeee" alpha='1'/>
													<fill color='#0082B4' alpha='1'/>
												</normal>
												<hover>
													<border color="#eeeeee" alpha='1'/>
													<fill color='#309AD6' alpha='1' angle="90"/>
												</hover>
												<down>
													<border color="#eeeeee" alpha='1'/>
													<fill color='#555555' alpha='1' angle="90"/>
												</down>
											</states>;
		
		private const customBtnW:Number = 70;
		
		private const customBtnH:Number = 27;
		
		/**
		 * 背景样式
		 */		
		private var bgStyle:Style = new Style;
		
		/*
		 * 背景样式 的配置文件
		 */		
		private var bgStyleXML:XML = <style>
											<border thickness='1' alpha='0.8' color='#000000'/>
											<fill color='111111, #1c1d1e' alpha='0.8, 0.8' angle='90'/>
									 </style>
	}
}