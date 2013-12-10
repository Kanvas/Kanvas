package view.elementSelector.lineControl
{
	import fl.controls.SelectableList;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	
	/**
	 */	
	public class StartPointControl extends StartEndControlBase
	{
		public function StartPointControl(selector:ElementSelector, ui:ControlPointBase)
		{
			super(selector, ui);
		}
		
		/**
		 */		
		override public function moveOff(xOff:Number, yOff:Number):void
		{
			startX += xOff;
			startY += yOff;
			
			super.moveOff(xOff, yOff);
			
			var rotation:Number = selector.coreMdt.autoAlignController.checkRotation(selector.element, selector.element.rotation);
			if (! isNaN(rotation))
			{
				vo.rotation = rotation;
				var rad:Number = vo.rotation / 180 * Math.PI;
				var r:Number = vo.width / 2 * vo.scale;
				vo.x = selector.coreMdt.layoutTransformer.stageXToElementX(endX) - r * Math.cos(rad);
				vo.y = selector.coreMdt.layoutTransformer.stageYToElementY(endY) - r * Math.sin(rad);
				
				selector.element.render();
				selector.update();
			}
		
		}
	}
	
}