package landray.kp.core
{
	public class KPEmbeds
	{
		public  static const instance:KPEmbeds = new KPEmbeds;
		private static var   created :Boolean;
		public function KPEmbeds()
		{
			if(!created) 
			{
				created = true;
				super();
			} 
			else 
			{
				throw new Error("Single Ton!");
			}
		}
		[Embed(source="../../../Core/src/Config.xml", mimeType="application/octet-stream")]
		public var styleClass:Class;
	}
}