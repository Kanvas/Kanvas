package landray.kp.mediator
{
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	
	import landray.kp.controls.Selector;
	import landray.kp.core.KPConfig;
	import landray.kp.core.kp_internal;
	import landray.kp.maps.simple.elements.BaseElement;
	import landray.kp.utils.CoreUtil;
	import landray.kp.view.Graph;
	import landray.kp.view.Viewer;
	
	import model.vo.BgVO;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	
	import view.ui.IMainUIMediator;
	
	/**
	 * Viewer的辅助类，事件处理，缩放控制，样式切换等。
	 * 
	 */
	public final class MediatorViewer implements IMainUIMediator
	{
		public function MediatorViewer($viewer:Viewer)
		{
			initialize($viewer);
		}
		
		/**
		 * @private
		 */
		private function initialize($viewer:Viewer):void
		{
			viewer = $viewer;
			config = KPConfig.instance;
			
			if (viewer.stage) 
				addedToStage();
			else 
				viewer.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			
			viewer.stage.addEventListener(Event.RESIZE, resize);
			
			viewer.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
			viewer.stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreen);
			
			viewer.addEventListener(MouseEvent.ROLL_OUT  , rollOut);
			viewer.addEventListener(MouseEvent.ROLL_OVER , rollOver);
			viewer.addEventListener(MouseEvent.CLICK     , click);
			
			viewer.stage.focus = viewer;
		}
		
		private function refresh():void
		{
			for each (var graph:Graph in config.kp_internal::graphs)
				graph.render(viewer.canvas.scaleX);
		}
		
		/**
		 * @private
		 */
		private function addedToStage(e:Event=null):void
		{
			if (viewer.stage.stageWidth && viewer.stage.stageHeight)
			{
				//Debugger.debug("added:"+viewer.stage.stageWidth, viewer.stage.stageHeight);
				viewer.width  = viewer.stage.stageWidth;
				viewer.height = viewer.stage.stageHeight;
			}
			else 
			{
				viewer.stage.addEventListener(Event.RESIZE, addedToStageResize);
			}
		}
		
		private function addedToStageResize(e:Event):void
		{
			if (viewer.stage.stageWidth && viewer.stage.stageHeight)
			{
				//Debugger.debug("addedResize:", viewer.stage.stageWidth, viewer.stage.stageHeight);
				viewer.stage.removeEventListener(Event.RESIZE, addedToStageResize);
				viewer.width  = viewer.stage.stageWidth;
				viewer.height = viewer.stage.stageHeight;
				viewer.dispatchEvent(new Event("initialize"));
			}
		}
		
		/**
		 * @private
		 */
		private function resize(e:Event):void
		{
			if (viewer.stage.stageWidth && viewer.stage.stageHeight)
			{
				//Debugger.debug("resize:", viewer.stage.stageWidth, viewer.stage.stageHeight);
				viewer.width  = viewer.stage.stageWidth;
				viewer.height = viewer.stage.stageHeight;
			}
		}
		
		/**
		 * @private
		 */
		private function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == 32) 
				viewer.kp_internal::controller.autoZoom();
		}
		
		private function fullScreen(e:FullScreenEvent):void
		{
			if (e.fullScreen == false)
			{
				viewer.kp_internal::toolBar.kp_internal::resetScreenButtons();
				viewer.kp_internal::setScreenState(StageDisplayState.NORMAL);
			}
			
		}
		
		/**
		 * @private
		 */
		private function rollOut(e:MouseEvent):void
		{
			viewer.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		
		/**
		 * @private
		 */
		private function rollOver(e:MouseEvent):void
		{
			viewer.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel, false, 0, true);
		}
		
		/**
		 * @private
		 */
		private function mouseWheel(e:MouseEvent):void
		{
			if (e.delta > 0)
				viewer.kp_internal::controller.zoomIn();
			else if (e.delta < 0)
				viewer.kp_internal::controller.zoomOut();
		}
		
		/**
		 * @private
		 */
		private function click(e:MouseEvent):void
		{
			var selector:Selector = viewer.kp_internal::selector;
			try 
			{
				var element:BaseElement = BaseElement(e.target);
				if (element) 
				{
					if (element.vo.property.toLocaleLowerCase() == "true") 
					{
						if (element.vo.type!="hotspot") 
						{
							selector.element = element;
							var visible:Boolean = true;
							selector.render(element.getRectangleForViewer());
						}
						ExternalInterface.call("KANVAS.linkClicked", config.id, element.vo.id);
					}
				}
				viewer.kp_internal::selector.visible = visible;
			} 
			catch(o:Error) { }
		}
		
		/**
		 * @private
		 */
		private function loaded(e:ImgInsertEvent):void
		{
			viewer.drawBGImg(e.bitmapData);
		}
		
		/**
		 * @private
		 */
		kp_internal function setBackground(value:BgVO):void
		{
			if (CoreUtil.ifHasText(value.imgURL)) 
			{
				loader = new ImgInsertor;
				loader.addEventListener(ImgInsertEvent.IMG_LOADED_FROM_SERVER, loaded, false, 0, true);
				loader.loadImg(value.imgURL, value.imgID);
			} 
			else if (CoreUtil.imageLibHasData(value.imgID)) 
			{
				viewer.drawBGImg(CoreUtil.imageLibGetData(value.imgID));
			}
		}
		
		/**
		 * @private
		 */
		kp_internal function setTemplete(value:XML):void
		{
			CoreUtil.registLib(config.kp_internal::lib);
			
			var templetes:XML = XML(value.child("template").toXMLString());
			for each(var item:XML in templetes.children())
				CoreUtil.registLibXMLWhole(item.@id, item, item.name().toString());
				
			config.kp_internal::themes.clear();
			
			var themes:XML = XML(value.child('themes').toXMLString());
			for each(item in themes.children()) 
				config.kp_internal::themes.put(item.name().toString(), item);
			
		}
		
		/**
		 * @private
		 */
		kp_internal function setTheme(value:String):void
		{
			if (config.kp_internal::themes.containsKey(value)) 
			{
				CoreUtil.registLib(config.kp_internal::lib);
				CoreUtil.clearLibPart();
				
				var style:XML = config.kp_internal::themes.getValue(value) as XML;
				for each (var item:XML in style.children()) 
					CoreUtil.registLibXMLPart(item.@styleID, item, item.name().toString());
				
				var xml:XML   = CoreUtil.getStyle('bg', 'colors') as XML;
				if (xml)
				{
					var index:int  = viewer.background.colorIndex;
					var color:uint = uint(CoreUtil.setColor(xml.children()[index].toString()));
					viewer.background.color = color;
					viewer.kp_internal::drawBackground(color);
				}
			}
		}
		
		public function updateAfterZoomMove():void
		{
			viewer.kp_internal::refresh();
			refresh();
		}
		
		public function bgClicked():void
		{
			if (viewer.kp_internal::selector.visible)
			{
				viewer.kp_internal::selector.visible = false;
				ExternalInterface.call("KANVAS.unselected", config.id);
			}
		}
		
		/**
		 * @private
		 */
		private var viewer:Viewer;
		
		/**
		 * @private
		 */
		private var config:KPConfig;
		
		
		/**
		 * @private
		 */
		private var loader:ImgInsertor;
		
		/**
		 * @private
		 */
		private var point:Point;
	}
}