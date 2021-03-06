package landray.kp.maps.simple.elements
{
	import com.kvs.ui.label.TextFlowLabel;
	
	import model.vo.ElementVO;
	import model.vo.TextVO;
	
	/**
	 * 
	 */	
	public final class Label extends BaseElement
	{
		public function Label($vo:ElementVO)
		{
			super($vo);
			addChild(text = new TextFlowLabel);
			text.ifTextBitmap = true;
			mouseChildren = false;
		}
		
		/**
		 */		
		override public function render(scale:Number = 1):void
		{
			if (rendered == false)
			{
				rendered = true;
				super.render();
				
				text.text = textVO.text;
				
				//兼容文本换行
				text.ifMutiLine = textVO.ifMutiLine;
				text.fixWidth = textVO.width;
				
				text.renderLabel(textVO.label.format.getFormat(textVO));
				
				text.x = - text.width  * .5;
				text.y = - text.height * .5;
				
				text.checkTextBm(textVO.scale * scale);
			}
			else
			{
				text.checkTextBm(textVO.scale * scale);
			}
		}
		
		/**
		 */		
		private var rendered:Boolean = false;
		
		private function get textVO():TextVO
		{
			return vo as TextVO;
		}
		
		/**
		 */		
		private var text:TextFlowLabel;
	}
}