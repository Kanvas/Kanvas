package landray.kp.core
{
	import cn.vision.pattern.Presenter;
	
	import landray.kp.command.*;
	
	/**
	 */	
	public final class KPPresenter extends Presenter
	{
		public  static const instance:KPPresenter = new KPPresenter;
		private static var   created :Boolean;
		
		/**
		 */
		public function KPPresenter()
		{
			if(!created) 
			{
				created  = true;
				super();
				initialize();
			} 
			else 
			{
				throw new Error("Single Ton!");
			}
		}
		
		/**
		 */		
		private function initialize():void
		{
			config = KPConfig.instance;
			provider = KPProvider.instance;
		}
		
		/**
		 */		
		override protected function setup(...args):void
		{
			//set config container
			config.kp_internal::container = container;
			config.id = args[0];
			
			if (args[1]) 
			{
				provider.dataURL = args[2];
				//init commands
				commandManager.push(new Command1LoadData);
				commandManager.push(new Command2Init);
				commandManager.push(new Command3CreateGraph);
				commandManager.push(new Command4ChangeTheme);
				commandManager.push(new Command5ZoomAuto);
				//commandManager.push(new Command6InitComplete);
				commandManager.execute();
			} 
			else 
			{
				provider.dataXML = new XML(args[2]);
				commandManager.push(new Command2Init);
				commandManager.push(new Command3CreateGraph);
				commandManager.push(new Command4ChangeTheme);
				commandManager.push(new Command5ZoomAuto);
				//commandManager.push(new Command6InitComplete);
				commandManager.execute();
			}
			
		}
		
		/**
		 */		
		public var config  :KPConfig;
		public var provider:KPProvider;
	}
}