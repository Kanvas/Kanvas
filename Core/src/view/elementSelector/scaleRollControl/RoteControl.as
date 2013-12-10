package view.elementSelector.scaleRollControl
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import commands.Command;
	
	import flash.display.Sprite;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	
	/**
	 * 图形旋转控制
	 */	
	public class RoteControl implements IClickMove
	{
		public function RoteControl(holder:ElementSelector, ui:Sprite)
		{
			this.selector = holder;
			moveControl = new ClickMoveControl(this, ui);
		}
		
		/**
		 */		
		private var moveControl:ClickMoveControl;
		
		/**
		 */		
		private var selector:ElementSelector;
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			var dis:Number = selector.currentRote - oldAngle;
			
			var rote:Number = oldRotation + dis;
			
			if (rote < 0)
				rote += 360;
			rote = Math.ceil(rote);
			
			//旋转自动对齐检测，如检测不到需要对齐的角度，返回NaN
			var rotation:Number = selector.coreMdt.autoAlignController.checkRotation(selector.element, rote);
			if (!isNaN(rotation))
				rote = rotation;
			
			dis = rote - oldRotation;
			
			selector.element.vo.rotation = rote;
			selector.element.rotation = rote;
			selector.rote();
			
			selector.coreMdt.autoGroupController.roll(dis, selector.element);
		}
		
		/**
		 */		
		public function stopMove():void
		{
			var index:Vector.<int> = selector.coreMdt.autoLayerController.autoLayer(selector.element);
			if (index)
			{
				oldPropertyObj.indexChangeElement = selector.coreMdt.autoLayerController.indexChangeElement;
				oldPropertyObj.index = index;
			}
			
			selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldPropertyObj);
			
			selector.coreMdt.mainUI.hoverEffect.hide();
			
			var xDir:int = selector.coreMdt.mainUI.stage.mouseX - lastMouseX;
			xDir = (xDir == 0) ? xDir : ((xDir > 0) ? 1 : -1);
			var yDir:int = selector.coreMdt.mainUI.stage.mouseY - lastMouseY;
			yDir = (yDir == 0) ? yDir : ((yDir > 0) ? 1 : -1);
			
			selector.coreMdt.autofitController.autofitElementPosition(selector.coreMdt.currentElement, xDir, yDir);
			
			selector.coreMdt.autoAlignController.clear();
		}
		
		/**
		 */		
		private var oldPropertyObj:Object;
		
		/**
		 */		
		public function clicked():void
		{
			
		}
		
		/**
		 */		
		public function startMove():void
		{
			oldAngle = selector.currentRote;
			oldRotation = selector.rotation;
			oldPropertyObj = {};
			oldPropertyObj.rotation = selector.rotation;
			
			lastMouseX = selector.coreMdt.mainUI.stage.mouseX;
			lastMouseY = selector.coreMdt.mainUI.stage.mouseY;
		}
		
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		/**
		 */		
		private var oldAngle:Number = 0;
		
		/**
		 */		
		private var oldRotation:Number = 0;
		
	}
}