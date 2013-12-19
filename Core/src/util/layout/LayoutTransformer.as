package util.layout
{
	import com.kvs.charts.chart2D.marker.MarkerPointRender;
	
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import model.vo.ElementVO;
	
	import view.element.ElementBase;
	import view.element.shapes.LineElement;

	/**
	 * 画布坐标与stage坐标的转换器
	 */	
	public class LayoutTransformer
	{
		/**
		 */		
		public function LayoutTransformer(canvas:Sprite)
		{
			this.canvas = canvas;
		}
		
		/**
		 * 根据元素VO获取页面镜头信息，包括镜头宽高，旋转角度，
		 */		
		public function getLayoutInfo(ele:ElementBase):ElementVO
		{
			var matr:ElementVO = new ElementVO;
			
			matr.x = elementXToStageX(ele.x);
			matr.y = elementYToStageY(ele.y);
			matr.width = ele.scaledWidth * canvasScale;
			matr.height = ele.scaledHeight * canvasScale;
			matr.rotation = ele.rotation;
			
			if (ele is LineElement)
				matr.width = matr.width / 2;
			
			if (matr.width / matr.height > 4 / 3)
			{
				var newH:Number = matr.width * 3 / 4;
				matr.height = newH;
			}
			else
			{
				var newW:Number = matr.height * 4 / 3;
				matr.width = newW;
			}
			
			return matr;
		}
		
		/**
		 * 画布比例的补充比例，让元素抵消画布缩放影响，随时随地原生态
		 */		
		public function get compensateScale():Number
		{
			return 1 / canvas.scaleX;
		}
		
		/**
		 * 图形比例抵消画布比例补位后，得到的实际比例
		 */		
		public function getStageScaleFromElement(scale:Number):Number
		{
			return scale / this.compensateScale;
		}
		
		/**
		 * 将舞台比例转化为元素的最终比例
		 */		
		public function getElementScaleByStageScale(scale:Number):Number
		{
			return scale * compensateScale;
		}
		
		/**
		 * 将元件的坐标转化为舞台坐标
		 */		
		public function elementXToStageX(value:Number):Number
		{
			return canvas.x + value * canvas.scaleX;
		}
		
		/**
		 * 将元件的坐标转化为舞台坐标
		 */		
		public function elementYToStageY(value:Number):Number
		{
			return canvas.y + value * canvas.scaleY;
		}
		
		/**
		 * 将舞台中某点的x坐标转换为画布上的坐标
		 */		
		public function stageXToElementX(stageX:Number):Number
		{
			return (stageX - canvas.x) / canvas.scaleX;
		}
		
		/**
		 * 将舞台中某点的y坐标转换为画布上的坐标
		 */		
		public function stageYToElementY(stageY:Number):Number
		{
			return (stageY - canvas.y) / canvas.scaleY;
		}
		
		/**
		 * 将舞台上间距转化为画布上的间距
		 */		
		public function stageDisToCanvasDis(dis:Number):Number
		{
			return dis / canvasScale;
		}
		
		/**
		 * 画布比例
		 */		
		public function get canvasScale():Number
		{
			return canvas.scaleX;
		}
		
		/**
		 */		
		public var canvas:Sprite;
	}
}