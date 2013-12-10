package landray.kp.command
{
	import landray.kp.core.kp_internal;
	
	public final class Command5ZoomAuto extends _InernalCommand
	{
		public function Command5ZoomAuto(tween:Boolean=true)
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