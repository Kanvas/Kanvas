package view.elementSelector.toolBar
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.ui.button.LabelBtnWithTopIcon;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.States;
	
	import commands.Command;
	
	import flash.events.MouseEvent;

	/**
	 * 边框型图形，不含填充，可控制边框粗细
	 */	
	public class BorderShape extends ToolbarWithStyle
	{
		public function BorderShape(toolBar:ToolBarController)
		{
			super(toolBar);
			
			this.colorIconStyleXML = <states>
											<normal>
												<border color='${iconColor}' thickness='3'/>
											</normal>
											<hover radius={colorIconSize}>
												<border color='${iconColor}' thickness='3'/>
											</hover>
											<down radius={colorIconSize}>
												<border color='${iconColor}' thickness='3'/>
											</down>
										</states>
			
			
			this.colorPreviewIconStyleXML = <states>
												<normal radius={colorIconSize}>
													<border color='${iconColor}' thickness='3'/>
												</normal>
												<hover radius={colorIconSize}>
													<border color='${iconColor}' thickness='3'/>
												</hover>
												<down radius={colorIconSize}>
													<border color='${iconColor}' thickness='3'/>
												</down>
											</states>
			
			xi;
			cu;
			
			addBtn.tips = '加粗';
			toolBar.initBtnStyle(addBtn, 'cu');
			addBtn.addEventListener(MouseEvent.CLICK, addHandler, false, 0, true);
			
			cutBtn.tips = '变细';
			toolBar.initBtnStyle(cutBtn, 'xi');
			cutBtn.addEventListener(MouseEvent.CLICK, cutHandler, false, 0, true);
		}
		
		/**
		 */		
		private function addHandler(evt:MouseEvent):void
		{
			if (element.vo.thickness < 10) 
			{
				var oldObj:Object = {};
				oldObj.thickness = element.vo.thickness;
				
				element.vo.thickness ++;
				//element.vo.thickness += 1/toolBar.selector.coreMdt.canvas.scaleX;
				
				element.render();
				
				toolBar.selector.layoutInfo.update();
				toolBar.selector.render();
				
				toolBar.selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldObj);
			}
		}
		
		/**
		 */		
		private function cutHandler(evt:MouseEvent):void
		{
			if (element.vo.thickness > 1) 
			{
				var oldObj:Object = {};
				oldObj.thickness = element.vo.thickness;
				
				element.vo.thickness --;
				//element.vo.thickness -= 1/toolBar.selector.coreMdt.canvas.scaleX;
				
				element.render();
				
				toolBar.selector.layoutInfo.update();
				toolBar.selector.render();
				
				toolBar.selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldObj);
			}
		}
		
		/**
		 */		
		protected var addBtn:IconBtn = new IconBtn;
		
		/**
		 */		
		protected var cutBtn:IconBtn = new IconBtn;
		
		/**
		 */		
		override public function render():void
		{
			toolBar.addBtn(toolBar.styleBtn);
			toolBar.addBtn(addBtn);
			toolBar.addBtn(cutBtn);
			toolBar.addBtn(toolBar.topLayerBtn);
			toolBar.addBtn(toolBar.bottomLayerBtn);
			toolBar.addBtn(toolBar.delBtn);
			
			
			resetColorIconStyle();
			
		}
		
	}
}