package cn.vision.core
{
	import cn.vision.core.vs;
	import cn.vision.interfaces.*;
	import cn.vision.utils.ClassUtil;
	
	import flash.display.Sprite;
	
	use namespace vs;
	
	public class UI extends Sprite implements IEnable, IExtra, IID, IName
	{
		public function UI()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			vs::enabled = true;
		}
		
		public function get className():String
		{
			if(!vs::className)
				vs::className = ClassUtil.getClassName(this);
			return vs::className;
		}
		
		public function get extra():Object
		{
			if(!vs::extra)
				vs::extra = {};
			return vs::extra;
		}
		
		public function get enabled():Boolean
		{
			return vs::enabled;
		}
		public function set enabled($value:Boolean):void
		{
			vs::enabled = $value;
		}
		
		public function get id():String
		{
			return vs::id;
		}
		public function set id($value:String):void
		{
			vs::id = $value;
		}
		
		vs var className:String;
		vs var enabled:Boolean;
		vs var extra:Object;
		vs var id:String;
	}
}
