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
			config.originalScale = args[1];
			
			commandManager.push(new Command1ProvideData(args[2], args[3]));
			commandManager.push(new Command2Init);
			commandManager.push(new Command3CreateGraph);
			commandManager.push(new Command4ChangeTheme);
			commandManager.push(new Command5ZoomAuto);
			commandManager.execute();
		}
		
		public function horizontalMove(value:Number):void
		{
			config.kp_internal::viewer.kp_internal::horizontalMove(value);
		}
		
		public function unselected():void
		{
			config.kp_internal::viewer.kp_internal::unselected();
		}
		
		/**
		 */		
		public var config  :KPConfig;
		public var provider:KPProvider;
	}
}