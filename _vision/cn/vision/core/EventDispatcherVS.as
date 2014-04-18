package cn.vision.core
{
	import cn.vision.core.vs;
	import cn.vision.interfaces.IExtra;
	import cn.vision.interfaces.IID;
	import cn.vision.interfaces.IName;
	import cn.vision.utils.ClassUtil;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class EventDispatcherVS extends EventDispatcher implements IName, IExtra, IID
	{
		public function EventDispatcherVS(target:IEventDispatcher=null)
		{
			super(target);
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
		
		public function get id():String
		{
			return vs::id;
		}
		public function set id($value:String):void
		{
			vs::id = $value;
		}
		
		public function get name():String {return vs::name; }
		public function set name($value:String):void
		{
			vs::name = $value;
		}
		
		vs var className:String;
		vs var extra:Object;
		vs var name:String;
		vs var id:String;
	}
}