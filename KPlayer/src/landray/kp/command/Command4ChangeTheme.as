package landray.kp.command
{
	import landray.kp.core.kp_internal;
	import landray.kp.view.Graph;

	public final class Command4ChangeTheme extends _InernalCommand
	{
		public function Command4ChangeTheme()
		{
			super();
			
		}
		
		override public function execute():void
		{
			executeStart();
			changeTheme();
			executeEnd();
		}
		
		private function changeTheme():void
		{
			config.kp_internal::viewer.theme = config.kp_internal::theme;
			
			for each (var graph:Graph in config.kp_internal::graphs) 
				graph.theme = config.kp_internal::theme;
		}
		private var theme:String;
	}
}