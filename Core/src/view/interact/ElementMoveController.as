package view.interact
{
	import commands.Command;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import util.layout.LayoutTransformer;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;

	/**
	 * 元素移动控制器
	 */	
	public class ElementMoveController
	{
		public function ElementMoveController(mdt:CoreMediator)
		{
			this.coreMdt = mdt;
		}
		
		/**
		 */		
		public function startMove(element:ElementBase):void
		{
			stageStartX = mainUI.stage.mouseX;
			stageStartY = mainUI.stage.mouseY;
			
			mainUI.stage.addEventListener(MouseEvent.MOUSE_MOVE, movingElementHandler, false, 0, true);
			//var element:ElementBase = element;
			curMovingElement = element;
			
			// 选择器的位置是基准, 移动图形时先移动选择器，然后从选择器同步到图形
			var point:Point = layoutTransformer.elementPointToStagePoint(curMovingElement.x, curMovingElement.y);
			
			selectorStartX = selector.x = point.x;
			selectorStartY = selector.y = point.y;
			
			oldPropertyObj = {};
			oldPropertyObj.x = element.x;
			oldPropertyObj.y = element.y;
		}
		
		private var selectorStartX:Number;
		private var selectorStartY:Number;
		
		/**
		 * 
		 * 移动图形的时候需要同步移动鼠标感应效果框
		 */		
		private function movingElementHandler(evt:MouseEvent):void
		{
			evt.updateAfterEvent();
			
			var disX:Number = mainUI.stage.mouseX - stageStartX;
			var disY:Number = mainUI.stage.mouseY - stageStartY;
			
			selector.x = selectorStartX + disX;
			selector.y = selectorStartY + disY;
			
			//stageStartX = mainUI.stage.mouseX;
			//stageStartY = mainUI.stage.mouseY;
			
			//coreMdt.moveSelector(disX, disY);
			
			// 元素的移动是基于选择其的位置的
			var elementPoint:Point = layoutTransformer.stagePointToElementPoint(selector.x, selector.y);
			curMovingElement.x = point.x = elementPoint.x;
			curMovingElement.y = point.y = elementPoint.y;
			
			
			var temp:Point = coreMdt.autoAlignController.checkPosition(curMovingElement);
			if (temp)
			{
				if (! isNaN(temp.x))
					point.x = curMovingElement.x + temp.x;
				if (! isNaN(temp.y))
					point.y = curMovingElement.y + temp.y;
			}
			curMovingElement.x = point.x;
			curMovingElement.y = point.y;
			
			var selectorPoint:Point = layoutTransformer.elementPointToStagePoint(curMovingElement.x, curMovingElement.y);
			selector.x = selectorPoint.x;
			selector.y = selectorPoint.y;
			
			coreMdt.autoGroupController.moveElement(curMovingElement.x - curMovingElement.vo.x, 
													curMovingElement.y - curMovingElement.vo.y);
		}
		
		/**
		 */		
		public function stopMove():void
		{
			mainUI.stage.removeEventListener(MouseEvent.MOUSE_MOVE, movingElementHandler);
			coreMdt.currentMode.moveElementEnd();
			
			coreMdt.autoAlignController.clear();
			
			if (coreMdt.createNewShape == false)
			{
				var index:Vector.<int> = coreMdt.autoLayerController.autoLayer(curMovingElement);
				if (index)
				{
					oldPropertyObj.indexChangeElement = coreMdt.autoLayerController.indexChangeElement;
					oldPropertyObj.index = index;
				}
				
				coreMdt.currentElement = curMovingElement;
				coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldPropertyObj);
				
				var xDir:Number = mainUI.stage.mouseX - stageStartX;
				xDir = (xDir == 0) ? xDir : ((xDir > 0) ? 1 : -1);
				var yDir:Number = mainUI.stage.mouseY - stageStartY;
				yDir = (yDir == 0) ? yDir : ((yDir > 0) ? 1 : -1);
				
				coreMdt.autofitController.autofitElementPosition(curMovingElement, xDir, yDir);
			}
			else
			{
				coreMdt.createNewShape = false;
				coreMdt.createNewShapeMouseUped = true;
				if (coreMdt.createNewShapeMouseUped && coreMdt.createNewShapeTweenOver)
					coreMdt.sendNotification(Command.SElECT_ELEMENT, curMovingElement);
			}
			
			
		}
		
		
		/**
		 * 坐标转换器
		 */		
		private function get layoutTransformer():LayoutTransformer
		{
			return mainUI.layoutTransformer;
		}
		
		/**
		 */		
		private function get selector():ElementSelector
		{
			return coreMdt.selector;
		}
		
		/**
		 */		
		private var stageStartX:Number;
		private var stageStartY:Number;
		
		/**
		 */		
		private var sourceX:Number;
		
		/**
		 */		
		private var sourceY:Number;
		
		/**
		 */		
		private function get curMovingElement():ElementBase
		{
			return coreMdt.curInteractElement;
		}
		
		/**
		 */		
		private function set curMovingElement(value:ElementBase):void
		{
			coreMdt.curInteractElement = value;
		}
		
		/**
		 */		
		private function get mainUI():CoreApp
		{
			return coreMdt.mainUI;
		}
		
		/**
		 */		
		private var coreMdt:CoreMediator;
		
		private var point:Point = new Point;
		private var oldPropertyObj:Object;
	}
}