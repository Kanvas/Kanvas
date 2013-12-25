package
{
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	import flashx.textLayout.compose.ISWFContext;
	
	/**
	 */	
	public class FontLib extends Sprite implements ISWFContext
	{
		
		[Embed(source="YuppySC-Regular.otf", fontName="雅痞", mimeType="application/x-font")]
		public var YaHei:Class;
		
		[Embed(source="华文细黑.ttf", fontName="华文细黑", mimeType="application/x-font")]
		public var FangSong:Class;
		
		[Embed(source="WawaSC-Regular.otf", fontName="娃娃体", mimeType="application/x-font")]
		public var KaiShu:Class;
		
		/**
		 */		
		public function FontLib()
		{
		}
		
		/**
		 */		
		public function callInContext(fn:Function, thisArg:Object, argsArray:Array, returns:Boolean=true):*
		{
			if (returns)
				return fn.apply(thisArg, argsArray);
			fn.apply(thisArg, argsArray);
		}
	}
}