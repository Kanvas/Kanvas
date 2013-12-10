package view.elementSelector.toolBar
{
	/**
	 * 默认工具条，仅有一个删除按钮
	 */	
	public class DefaultShape extends ToolBarBase
	{
		public function DefaultShape(toolBar:ToolBarController)
		{
			super(toolBar);
		}
		
		/**
		 */		
		override public function render():void
		{
			toolBar.addBtn(toolBar.linkBtn);
			toolBar.addBtn(toolBar.topLayerBtn);
			toolBar.addBtn(toolBar.bottomLayerBtn);
			toolBar.addBtn(toolBar.delBtn);
		}
	}
}