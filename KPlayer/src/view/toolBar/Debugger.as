package view.toolBar
{
	import flash.text.TextField;
	
	public final class Debugger extends TextField
	{
		public static var instance:Debugger;
		public function Debugger()
		{
			super();
			instance = this;
			width = 300;
			height = 200;
		}
		public static function debug(...args):void
		{
			trace(args);
			if (instance) 
			{
				instance.debug.apply(instance, args);
			}
		}
		public function debug(...args):void
		{
			appendText(args.toString()+"\n");
		}
	}
}