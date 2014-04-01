package view.elementSelector.lineControl
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.utils.MathUtil;
	
	import commands.Command;
	
	import flash.display.Sprite;
	
	import model.vo.ElementVO;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;

	/**
	 */	
	public class StartEndControlBase implements IClickMove
	{
		public function StartEndControlBase(selector:ElementSelector, ui:ControlPointBase)
		{
			this.selector = selector;
			
			moveControl = new ClickMoveControl(this, ui);
		}
		
		/**
		 */		
		private var moveControl:ClickMoveControl;
		
		/**
		 */		
		protected var selector:ElementSelector;
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			var x:Number = startX;
			var y:Number = startY;
			
            // 全局坐标转换为画布坐标
			vo.x = selector.layoutTransformer.stageXToElementX(x);
			vo.y = selector.layoutTransformer.stageYToElementY(y);
			
			var xDis:Number = (endX - startX);
			var yDis:Number = (endY - startY);
			var r:Number = Math.sqrt(xDis * xDis + yDis * yDis);
			
			vo.width = r / selector.layoutTransformer.canvasScale / vo.scale * 2;
			vo.rotation =  selector.getRote(endY, endX, startY, startX);
			
			selector.element.render();
			selector.update();
		}
		
		/**
		 * 获取起始点的全局相对坐标
		 */		
		public function startMove():void
		{
			//获取结束点的坐标
			var rad:Number = vo.rotation / 180 * Math.PI;
			var r:Number = vo.width / 2 * vo.scale * selector.layoutTransformer.canvasScale;
				
			endX = selector.x + r * Math.cos(rad);
			endY = selector.y + r * Math.sin(rad);
			
			//rad = (vo.rotation + 180) * Math.PI / 180;
			
			startX = selector.x;// + r * Math.cos(rad)
			startY = selector.y;// + r * Math.sin(rad)
				
			oldObj = {};
			oldObj.x = vo.x;
			oldObj.y = vo.y;
			oldObj.width = vo.width;
			oldObj.rotation = vo.rotation;
			
			lastMouseX = selector.coreMdt.mainUI.stage.mouseX;
			lastMouseY = selector.coreMdt.mainUI.stage.mouseY;
		}
		
		/**
		 */		
		public function stopMove():void
		{
			selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_PROPERTY, oldObj);
			
			var xDir:int = selector.coreMdt.mainUI.stage.mouseX - lastMouseX;
			xDir = (xDir == 0) ? xDir : ((xDir > 0) ? 1 : -1);
			var yDir:int = selector.coreMdt.mainUI.stage.mouseY - lastMouseY;
			yDir = (yDir == 0) ? yDir : ((yDir > 0) ? 1 : -1);
			
			selector.coreMdt.autofitController.autofitElementPosition(selector.coreMdt.currentElement, xDir, yDir);
		}
		 
		/**
		 */		
		protected function get vo():ElementVO
		{
			return selector.element.vo;
		}
		
		/**
		 */		
		public function clicked():void
		{
		}
		
		protected var lastMouseX:Number;
		protected var lastMouseY:Number;
		
		/**
		 */		
		protected var startX:Number = 0;
		
		/**
		 */		
		protected var startY:Number = 0;
		
		/**
		 */		
		protected var endX:Number = 0;
		
		/**
		 */		
		protected var endY:Number = 0;
		
		/**
		 */
		protected var rotation:Number;
		
		/**
		 */		
		protected var oldObj:Object;
		
	}
}