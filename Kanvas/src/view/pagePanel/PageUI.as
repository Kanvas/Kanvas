package view.pagePanel
{
	import com.kvs.ui.button.LabelBtn;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class PageUI extends LabelBtn
	{
		public function PageUI(vo:Object)
		{
			super();
			
			this.pageVO = vo;
			this.text = "页面";
			
			this.bgStyleXML = <states>
								   <normal>
									   <border color='#333333' alpha='1'/>
 										<fill alpha='0'/>
								   </normal>
								   <hover>
									   <border color='#999999' alpha='1' thickness='1'/>
									   <fill alpha='0'/>
								   </hover>
								   <down>
									   <border color='#666666' alpha='1' thickness='2'/>
									   <fill alpha='0'/>
								   </down>
							   </states>
		}
		
		/**
		 * 更新序号显示
		 */		
		public function updataLabel():void
		{
			this.text = pageVO.index + 1;
			this.labelUI.render();
		}
		
		/**
		 */		
		public var pageVO:Object;
	}
}