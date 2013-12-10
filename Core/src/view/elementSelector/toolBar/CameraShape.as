package view.elementSelector.toolBar
{
	public final class CameraShape extends ToolBarBase
	{
		public function CameraShape(toolBar:ToolBarController)
		{
			super(toolBar);
		}
		
		override public function render():void
		{
			toolBar.addBtn(toolBar.topLayerBtn);
			toolBar.addBtn(toolBar.bottomLayerBtn);
			toolBar.addBtn(toolBar.delBtn);
		}
	}
}