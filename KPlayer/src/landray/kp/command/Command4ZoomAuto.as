package landray.kp.command
{
	import landray.kp.core.kp_internal;
	
	public final class Command4ZoomAuto extends _InernalCommand
	{
		public function Command4ZoomAuto(tween:Boolean=true)
		{
			super();
			initialize(tween);
		}
		private function initialize(tween:Boolean=true):void
		{
			tweening = tween;
		}
		override public function execute():void
		{
			executeStart();
			config.kp_internal::viewer.kp_internal::zoomAuto();
			executeEnd();
		}
		private var tweening:Boolean;
	}
}