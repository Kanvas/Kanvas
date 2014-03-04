package landray.kp.command
{
	import landray.kp.core.kp_internal;
	import landray.kp.maps.main.Main;
	import landray.kp.maps.mind.Mind;
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Graph;

	public final class Command3CreateGraph extends _InernalCommand
	{
		public function Command3CreateGraph()
		{
			super();
		}
		override public function execute():void
		{
			executeStart();
			//regist graph class
			registGraphs();
			//initialize data
			resolveData();
			executeEnd();
		}
		
		private function registGraphs():void
		{
			graphManager.registGraph("basic", landray.kp.view.Graph);
			graphManager.registGraph("main" , landray.kp.maps.main.Main);
			graphManager.registGraph("mind" , landray.kp.maps.mind.Mind);
		}
		
		private function resolveData():void
		{
			//clear
			config.kp_internal::graphs.length = 0;
			while(config.kp_internal::viewer.canvas.numChildren>1) config.kp_internal::viewer.canvas.removeChildAt(1);
			
			if (provider.dataXML)
			{
				try 
				{
					config.kp_internal::theme = provider.dataXML.header[0].@styleID;
					config.kp_internal::viewer.theme = config.kp_internal::theme;
				} 
				catch (e:Error) {}
				try 
				{
					CoreUtil.mapping(provider.dataXML.bg[0], config.kp_internal::bgVO);
					config.kp_internal::viewer.background = config.kp_internal::bgVO;
				} 
				catch (e:Error) {}
				
				//resolve main
				try 
				{
					var xml:XML = provider.dataXML.main[0];
					if (xml && xml.children()&&xml.children().length()) 
					{
						var reference:Class = graphManager.getGraph(String(xml.name()));
						var graph:Graph = new reference;
						graph.templete = provider.styleXML;
						graph.theme = config.kp_internal::theme;
						graph.dataProvider = xml;
						config.kp_internal::graphs.push(graph);
					}
				} 
				catch (e:Error) {}
				
				//resolve page
				try
				{
					pageManager.dataProvider = provider.dataXML.pages[0].children();
					config.kp_internal::toolBarSlid.visible = (pageManager.length > 0);
				}
				catch (e:Error) {}
				
				//resolve module
				/*var list:XMLList = provider.dataXML.module.children();
				for each (xml in list) 
				{
					reference = graphManager.getGraph(String(xml.name()));
					if (reference) 
					{
						graph = new reference;
						graph.dataProvider = xml;
						config.kp_internal::graphs.push(graph);
						//config.kp_internal::viewer.canvas.addChild(graph);
					}
				}*/
			}
		}
	}
}