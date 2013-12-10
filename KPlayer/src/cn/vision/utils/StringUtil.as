package cn.vision.utils
{
	import cn.vision.core.NoInstance;
	
	public final class StringUtil extends NoInstance
	{
		public static function toString($value:*):String
		{
			if(!($value is String)) $value = String($value);
			return $value;
		}
	}
}