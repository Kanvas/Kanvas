package view.elementSelector.lineControl
{
	import com.kvs.utils.MathUtil;
	
	import flash.geom.Point;
	
	import mx.utils.ColorUtil;
	
	import util.CoreUtil;
	import util.LayoutUtil;
	
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	
	/**
	 * 弧度控制点
	 */	
	public class ArcPointControl extends StartEndControlBase
	{
		public function ArcPointControl(selector:ElementSelector, ui:ControlPointBase)
		{
			super(selector, ui);
		}
		
		/**
		 */		
		override public function moveOff(xOff:Number, yOff:Number):void
		{
			arcX += xOff;
			arcY += yOff;
			
			var cP:Point = LayoutUtil.elementPointToStagePoint(vo.x, vo.y, selector.coreMdt.canvas);
			var r:Number = selector.curRDis / vo.scale / selector.layoutTransformer.canvasScale;
			
			var rad:Number = selector.getRote(arcY, arcX, cP.y, cP.x) / 180 * Math.PI - lineRad;
				//trace(rad, arcX, arcY);
			
			CoreUtil.drawLine(0, cP, new Point(cP.x + Math.cos(rad) * r, cP.y - Math.sin(rad) * r));
				
			vo.arc = - Math.sin(rad) * r;
		}
	}
}