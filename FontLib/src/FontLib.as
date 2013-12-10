package
{
	import flash.display.Sprite;
	
	import flashx.textLayout.compose.ISWFContext;
	
	/**
	 */	
	public class FontLib extends Sprite implements ISWFContext
	{
		//[Embed(source="MSYH.TTF", fontName="微软雅黑", mimeType="application/x-font")]
		//public var YaHei:Class;
		
		//[Embed(source="SIMFANG.ttf", fontName="仿宋", mimeType="application/x-font")]
		//public var FangSong:Class;
		
		//[Embed(source="FZKS.ttf", fontName="方正楷书", mimeType="application/x-font")]
		//public var KaiShu:Class;
		
		
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