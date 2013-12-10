package view.interact.interactMode
{
	import commands.Command;
	
	import model.CoreFacade;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.interact.CoreMediator;
	import view.interact.multiSelect.TemGroupElement;
	
	/**
	 */	
	public class SelectedMode extends ModeBase
	{
		public function SelectedMode(mainMediator:CoreMediator)
		{
			super(mainMediator);
		}
		
		/**
		 * 由键盘控制的图形移动
		 */		
		override public function moveOff(xOff:Number, yOff:Number):void
		{
			var oldPropertyObj:Object = {};
			oldPropertyObj.x = mainMediator.selector.element.x;
			oldPropertyObj.y = mainMediator.selector.element.y;
			
			mainMediator.selector.element.x += xOff * mainMediator.layoutTransformer.compensateScale;
			mainMediator.selector.element.y += yOff * mainMediator.layoutTransformer.compensateScale;
			
			moveSelector(xOff, yOff);
			
			var index:Vector.<int> = mainMediator.autoLayerController.autoLayer(mainMediator.selector.element);
			if (index)
			{
				oldPropertyObj.indexChangeElement = mainMediator.autoLayerController.indexChangeElement;
				oldPropertyObj.index = index;
			}
			
			mainMediator.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldPropertyObj);
		}
		
		/**
		 */		
		override public function group():void
		{
			if (mainMediator.currentElement is TemGroupElement)
				mainMediator.sendNotification(Command.TEM_TO_GROUP);
		}
		
		/**
		 */		
		override public function unGroup():void
		{
			if (mainMediator.currentElement is GroupElement)
				mainMediator.sendNotification(Command.GROUP_TO_TEM);
		}
		
		/**
		 */		
		override public function moveElementEnd():void
		{
			mainMediator.selector.showFrameOnMup();
		}
		
		/**
		 * 选择和编辑模式下有效
		 */		
		override public function esc():void
		{
			mainMediator.sendNotification(Command.UN_SELECT_ELEMENT);
		}
		
		/**
		 */		
		override public function undo():void
		{
			mainMediator.sendNotification(Command.UN_DO);
		}
		
		/**
		 */		
		override public function redo():void
		{
			mainMediator.sendNotification(Command.RE_DO);
		}
		
		/**
		 */		
		override public function copy():void
		{
			mainMediator.currentElement.copy();
		}
		
		/**
		 */		
		override public function paste():void
		{
			mainMediator.getElementForPaste().paste();
		}
		
		/**
		 */		
		override public function cut():void
		{
			mainMediator.sendNotification(Command.CUT_ELEMENT);
		}
		
		/**
		 */		
		override public function del():void
		{
			mainMediator.currentElement.del();
		}
		
		/**
		 * 显示/隐藏型变框只有在选择模式下才能被调用
		 * 
		 * 其他模式下不会用到型变框
		 */		
		override public function showSelector():void
		{
			mainMediator.selector.show(mainMediator.currentElement);
		}
		
		/**
		 */		
		override public function updateSelector():void
		{
			mainMediator.updateSelector();
		}
				
		/**
		 */		
		override public function hideSelector():void
		{
			mainMediator.selector.hide();
		}
		
		/**
		 */		
		override public function toUnSelectedMode():void
		{
			hideSelector();
			
			mainMediator.currentMode = mainMediator.unSelectedMode;
		}
		
		/**
		 */		
		override public function toEditMode():void
		{
			mainMediator.showSelector();		
			mainMediator.disableKeyboardControl();
			mainMediator.currentMode = mainMediator.editMode;
		}
		
		/**
		 * 单选模式时，取消选择当前元件
		 */		
		override public function unSelectElementDown(element:ElementBase):void
		{
			mainMediator.sendNotification(Command.UN_SELECT_ELEMENT);
			mainMediator.checkAutoGroup(element);
		}
		
		/**
		 * 多选模式下被调用，将当前点击元件添加到临时组合
		 */		
		override public function unSelectElementClicked(element:ElementBase):void
		{
			mainMediator.multiSelectControl.addToTemGroup(element);
		}
		
		/**
		 * 取消选择当前元件
		 */		
		override public function stageBGClicked():void
		{
			mainMediator.sendNotification(Command.UN_SELECT_ELEMENT);
		}
	}
}