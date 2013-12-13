package view.interact
{

	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	import com.kvs.utils.RectangleUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import util.CoreUtil;
	
	import view.element.ElementBase;
	import view.element.text.TextEditField;

	/**
	 * 
	 * 智能镜头
	 * 
	 */	
	public final class ElementAutofitController
	{
		public function ElementAutofitController($coreMdt:CoreMediator)
		{
			coreMdt = $coreMdt;
		}
		
		/**
		 * 检测元素的坐标是否超出画布边界，是则移至画布中心
		 * 
		 */
		public function autofitElementPosition(element:ElementBase, xDir:int = 0, yDir:int = 0):Boolean
		{
			if (enabled && element && ! CoreUtil.elementOutOfCanvasBounds(element))
			{
				//最后需要移动的相对位置
				var x:Number = 0;
				var y:Number = 0;
				//画布矩形范围
				var canvasBound:Rectangle = coreMdt.mainUI.bound;
				//画布窗口中心点相对于舞台的坐标
				var centerX:Number = coreMdt.layoutTransformer.stageXToElementX(.5 * coreMdt.mainUI.stage.stageWidth);
				var centerY:Number = coreMdt.layoutTransformer.stageYToElementY(.5 * coreMdt.mainUI.stage.stageHeight);
				
				var toolBarWidth:Number = coreMdt.selector.toolBar.barWidth;
				var toolBarHeight:Number = coreMdt.selector.toolBar.barHeight;
				
				//-------------------------------------------------------------------------------
				
				//元素坐标的范围判断
				var centerPaddingLeft:Number = canvasBound.left + toolBarWidth * .5;
				var centerPaddingRight:Number = canvasBound.right - toolBarWidth * .5;
				
				var point:Point = getToolBarPoint(element);
				
				//元素的坐标
				var elementX:Number = coreMdt.layoutTransformer.elementXToStageX(point.x);
				//元素中心点需要偏移的坐标，元素顶部在Y方向上不可能超过工具条的位置，所以中心点不需要在Y方向进行判断
				var centerOffsetX:Number = 0;
				if (xDir == 0 || xDir == -1)
					centerOffsetX = autofitLeft(elementX, centerPaddingLeft);
				if (xDir == 0 || xDir == 1)
					centerOffsetX = (centerOffsetX == 0) ? autofitRight(elementX, centerPaddingRight) : centerOffsetX;
				
				//-------------------------------------------------------------------------------
				
				//元素矩形的范围
				var rectPaddingLeft:Number = canvasBound.left;
				var rectPaddingRight:Number = canvasBound.right;
				var rectPaddingTop:Number = canvasBound.top + toolBarHeight;
				var rectPaddingBottom:Number = canvasBound.bottom;
				
				//element矩形范围判断
				var rect:Rectangle = CoreUtil.getRectForStage(element);
				var rectOffsetX:Number = 0;
				
				//检测
				if (xDir == 0 || xDir == -1)
					rectOffsetX = autofitLeft(rect.left, rectPaddingLeft);
				if (xDir == 0 || xDir == 1)
					rectOffsetX = (rectOffsetX == 0) ? autofitRight(rect.right, rectPaddingRight) : rectOffsetX;
				
				//元素矩形范围需要偏移的坐标
				if (yDir == 0 || yDir == -1)
					y = autofitTop(rect.top, rectPaddingTop);
				if (yDir == 0 || yDir == 1)
					y = (y == 0) ? autofitBottom(rect.bottom, rectPaddingBottom) : y;
				
				//X坐标根据情况取其中一种
				if (rect.left < rectPaddingLeft || elementX < centerPaddingLeft)
					x = Math.min(centerOffsetX, rectOffsetX);
				else if (rect.right > rectPaddingRight || elementX > centerPaddingRight)
					x = Math.max(centerOffsetX, rectOffsetX);
				
				x /= coreMdt.layoutTransformer.canvasScale;
				y /= coreMdt.layoutTransformer.canvasScale;
				
				coreMdt.zoomMoveControl.zoomTo(coreMdt.layoutTransformer.canvasScale, new Point(centerX + x, centerY + y), time);
				return true;
			}
			return false;
		}
		
		/**
		 * 自适应文本编辑器工具条的位置
		 * 
		 */
		public function autofitEditorInputText(xDir:int = 0, yDir:int = 0):Boolean
		{
			if (enabled)
			{
				var x:Number = 0;
				var y:Number = 0;
				//画布矩形范围
				var canvasBound:Rectangle = coreMdt.mainUI.bound;
				//画布窗口中心点相对于舞台的坐标
				var centerX:Number = coreMdt.layoutTransformer.stageXToElementX(.5 * coreMdt.mainUI.stage.stageWidth);
				var centerY:Number = coreMdt.layoutTransformer.stageYToElementY(.5 * coreMdt.mainUI.stage.stageHeight);
				
				var editorBound:Rectangle = coreMdt.mainUI.textEditor.editorBound;
				
				if (xDir == 0 || xDir == 1)
					x = autofitRight(editorBound.right, canvasBound.right);
				if (xDir == 0 || xDir == -1)
					x = (x == 0) ? autofitLeft(editorBound.left, canvasBound.left) : x;
				
				if (yDir == 0 || yDir == 1)
					y = autofitBottom(editorBound.bottom, canvasBound.bottom);
				if (yDir == 0 || yDir == -1)
					y = (y == 0) ? autofitTop(editorBound.top, canvasBound.top) : y;
				
				x /= coreMdt.layoutTransformer.canvasScale;
				y /= coreMdt.layoutTransformer.canvasScale;
				
				coreMdt.zoomMoveControl.zoomTo(coreMdt.layoutTransformer.canvasScale, new Point(centerX + x, centerY + y), time);
				return true;

			}
			return false;
		}
		
		/**
		 * 检测文本进入编辑状态的scale，太小则放大一些
		 * 
		 */
		public function autofitEditorModifyText(element:ElementBase, xDir:int = 0, yDir:int = 0):Boolean
		{
			if (enabled && element && element is TextEditField)
			{
				var x:Number = 0;
				var y:Number = 0;
				var elementBound:Rectangle = CoreUtil.getRectForStage(element, false);
				var plsScale:Number = (elementBound.height < 15) ? 15 / elementBound.height : 1;
				var aimScale:Number = coreMdt.layoutTransformer.canvasScale * plsScale;
				
				//画布中心点
				var cenPoint:Point = new Point(.5 * coreMdt.mainUI.stage.stageWidth, .5 * coreMdt.mainUI.stage.stageHeight);
				//缩放前editor的旋转点
				var oriPoint:Point = element.topLeft.clone();
				oriPoint.x = coreMdt.layoutTransformer.elementXToStageX(oriPoint.x);
				oriPoint.y = coreMdt.layoutTransformer.elementYToStageY(oriPoint.y);
				
				//缩放前editor的旋转点
				var vector:Point = oriPoint.subtract(cenPoint);
				PointUtil.multiply(vector, plsScale);
				oriPoint = cenPoint.add(vector);
				
				//editor缩放后所占矩形
				var editorBound:Rectangle = coreMdt.mainUI.textEditor.editorBound;
				editorBound.bottom = editorBound.bottom - coreMdt.mainUI.textEditor.fieldHeight * (1 - plsScale);
				editorBound.right = editorBound.left + Math.max(coreMdt.mainUI.textEditor.offSet * 2 + elementBound.width * plsScale, coreMdt.mainUI.textEditor.panelWidth);
				editorBound.x = oriPoint.x - coreMdt.mainUI.textEditor.offSet;
				editorBound.y = oriPoint.y - coreMdt.mainUI.textEditor.offSet - coreMdt.mainUI.textEditor.panelHeight;
				editorBound = RectangleUtil.rotateRectangle(editorBound, oriPoint, element.rotation);
				//将矩形平移，以适应文本的中心点缩放
				var elePoint:Point = element.middleCenter.clone();
				elePoint.x = coreMdt.layoutTransformer.elementXToStageX(elePoint.x);
				elePoint.y = coreMdt.layoutTransformer.elementYToStageY(elePoint.y);
				vector = elePoint.subtract(cenPoint);
				PointUtil.multiply(vector, plsScale);
				vector = cenPoint.add(vector).subtract(elePoint);
				editorBound.offset(-vector.x, -vector.y);
				
				//画布矩形范围
				var canvasBound:Rectangle = coreMdt.mainUI.bound;
				
				//-------------------------------------------------------------------------------
				
				//最后需要移动的相对位置
				if (xDir == 0 || xDir == 1)
					x = autofitRight(editorBound.right, canvasBound.right);
				if (xDir == 0 || xDir == -1)
					x = (x == 0) ? autofitLeft(editorBound.left, canvasBound.left) : x;
				
				if (yDir == 0 || yDir == 1)
					y = autofitBottom(editorBound.bottom, canvasBound.bottom);
				if (yDir == 0 || yDir == -1)
					y = (y == 0) ? autofitTop(editorBound.top, canvasBound.top) : y;
				
				//-------------------------------------------------------------------------------
				//画布窗口中心点相对于舞台的坐标
				cenPoint.x = coreMdt.layoutTransformer.stageXToElementX(cenPoint.x);
				cenPoint.y = coreMdt.layoutTransformer.stageYToElementY(cenPoint.y);
				
				vector.offset(x, y);
				PointUtil.multiply(vector, 1 / aimScale);
				vector = vector.add(cenPoint);
				
				coreMdt.zoomMoveControl.zoomTo(aimScale, vector, time);

				return true;
			}
			return false;
		}
		
		private function getToolBarPoint(element:ElementBase):Point
		{
			var rotation:Number = MathUtil.modRotation(element.rotation);
			var point:Point;
			if (rotation >= 10 && rotation < 80)
				point = element.topLeft;
			else if (rotation >= 80 && rotation < 100)
				point = element.middleLeft;
			else if (rotation >= 100 && rotation < 170)
				point = element.bottomLeft;
			else if (rotation >= 170 || rotation < 190)
				point = element.bottomCenter;
			else if (rotation >= 190 && rotation < 260)
				point = element.bottomRight;
			else if (rotation >= 260 && rotation < 280)
				point = element.middleRight;
			else if (rotation >= 280 && rotation < 350)
				point = element.topRight;
			else
				point = element.topCenter;
			return point;
		}
		
		private function autofitLeft(left:Number, paddingLeft:Number):Number
		{
			return (left < paddingLeft) ? left - paddingLeft : 0;
		}
		
		private function autofitRight(right:Number, paddingRight:Number):Number
		{
			return (right > paddingRight) ? right - paddingRight : 0;
		}
		
		private function autofitTop(top:Number, paddingTop:Number):Number
		{
			return (top < paddingTop) ? top - paddingTop : 0;
		}
		
		private function autofitBottom(bottom:Number, paddingBottom:Number):Number
		{
			return (bottom > paddingBottom) ? bottom - paddingBottom : 0;
		}
		
		public var enabled:Boolean = true;
		
		private var coreMdt:CoreMediator;
		
		private var time:Number = .7;
	}
}