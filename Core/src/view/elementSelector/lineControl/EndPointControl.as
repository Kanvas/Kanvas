package view.elementSelector.lineControl
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import model.vo.ElementVO;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	
	/**
	 */	
	public class EndPointControl extends StartEndControlBase
	{
		public function EndPointControl(selector:ElementSelector, ui:ControlPointBase)
		{
			super(selector, ui);
		}
		
		/**
		 */		
		override public function moveOff(xOff:Number, yOff:Number):void
		{
			endX += xOff;
			endY += yOff;
			
			super.moveOff(xOff, yOff);
			
			rotation = selector.coreMdt.autoAlignController.checkRotation(selector.element, selector.element.rotation);
			
			
		}
		
		override public function stopMove():void
		{
			if (! isNaN(rotation))
			{
				vo.rotation = rotation;
				
				selector.element.render();
				selector.update();
			}
			
			super.stopMove();
		}
	}
}