package landray.kp.maps.simple.elements
{
	import com.kvs.ui.label.TextFlowLabel;
	import com.kvs.utils.XMLConfigKit.style.elements.TextFormatStyle;
	
	import flash.text.TextFormat;
	
	import model.vo.ElementVO;
	import model.vo.TextVO;
	
	public final class Label extends BaseElement
	{
		public function Label($vo:ElementVO)
		{
			super($vo);
			addChild(text = new TextFlowLabel);
			text.ifTextBitmap = true;
		}
		
		override public function render(scale:Number = 1):void
		{
			if (rendered == false)
			{
				rendered = true;
				super.render();
				text.text = textVO.text;
				var format:TextFormat = textVO.label.format.getFormat(textVO);
				text.renderLabel(format);
				text.x = - text.width  * .5;
				text.y = - text.height * .5;
				text.checkTextBm(textVO.scale * scale);
				//trace("before:", text.x, text.y, text.width, text.height);
			}
			else
			{
				text.checkTextBm(textVO.scale * scale);
			}
			//text.x = - text.width  * .5;
			//text.y = - text.height * .5;
			//trace("after:", text.x, text.y, text.width, text.height);
		}
		
		
		private var rendered:Boolean = false;
		
		private function get textVO():TextVO
		{
			return vo as TextVO;
		}
		
		private var text:TextFlowLabel;
	}
}