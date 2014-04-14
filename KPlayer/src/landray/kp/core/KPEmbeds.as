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
		
		public var styleTips:XML = <label hPadding='12' vPadding='8' radius='30' vMargin='10' hMargin='20'>
										<border thikness='1' alpha='0' color='555555' pixelHinting='true'/>
										<fill color='e96565' alpha='0.9'/>
										<format font='微软雅黑' size='15' color='ffffff'/>
										<text value='${tips}' substr='2000'>
											<effects>
												<shadow color='0' alpha='0.3' distance='1' blur='1' angle='90'/>
											</effects>
										</text>
									</label>;
	}
}