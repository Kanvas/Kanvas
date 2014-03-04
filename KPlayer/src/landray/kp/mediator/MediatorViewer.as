package landray.kp.mediator
{
	import com.kvs.utils.Map;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import landray.kp.components.Selector;
	import landray.kp.core.KPConfig;
	import landray.kp.core.KPProvider;
	import landray.kp.core.kp_internal;
	import landray.kp.manager.ManagerPage;
	import landray.kp.maps.main.elements.BaseElement;
	import landray.kp.utils.*;
	import landray.kp.view.*;
	
	import model.vo.BgVO;
	
	import util.LayoutUtil;
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	
	import view.interact.zoomMove.ZoomMoveControl;
	import view.ui.Canvas;
	import view.ui.IMainUIMediator;
	
	/**
	 * Viewer的辅助类，事件处理，缩放控制，样式切换等。
	 * 
	 */
	public final class MediatorViewer implements IMainUIMediator
	{
		public function MediatorViewer()
		{
			initialize();
		}
		
		/**
		 * @private
		 */
		private function initialize():void
		{
			config   = KPConfig  .instance;
			provider = KPProvider.instance;
			
			kp_internal::setTemplete(provider.styleXML);
			
			if (viewer.stage) 
				addedToStage();
			else 
				viewer.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
		}
		
		private function initializeStage():void
		{
			lastWidth  = viewer.stage.stageWidth;
			lastHeight = viewer.stage.stageHeight;
			viewer.width  = lastWidth;
			viewer.height = lastHeight;
			viewer.addEventListener(MouseEvent.CLICK, click);
			viewer.stage.addEventListener(Event.RESIZE, resize);
			viewer.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			viewer.stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreen);
			viewer.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel, false, 0, true);
			viewer.stage.focus = viewer;
			
			viewer.dispatchEvent(new Event("initialize"));
		}
		
		private function resizeStage():void
		{
			if (screenFull)
			{
				screenFull = false;
			}
			else
			{
				var thisWidth :Number = viewer.stage.stageWidth;
				var thisHeight:Number = viewer.stage.stageHeight;
				canvas.x += (thisWidth  - lastWidth ) * .5;
				canvas.y += (thisHeight - lastHeight) * .5;
				lastWidth  = thisWidth;
				lastHeight = thisHeight;
			}
		}
		
		public function updateAfterZoomMove():void
		{
			if (selector.visible) 
				selector.render();
			for each (var graph:Graph in config.kp_internal::graphs)
				graph.render(viewer.canvas.scaleX);
			viewer.synBgImgWidthCanvas();
		}
		
		public function bgClicked():void
		{
			if (selector.visible)
			{
				selector.visible = false;
				ExternalUtil.kanvasUnselected();
			}
		}
		
		/**
		 * @private
		 */
		private function addedToStage(e:Event=null):void
		{
			if (viewer.stage.stageWidth && viewer.stage.stageHeight)
			{
				viewer.removeEventListener(Event.ADDED_TO_STAGE, addedToStage, false);
				initializeStage();
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
				viewer.stage.removeEventListener(Event.RESIZE, addedToStageResize);
				initializeStage();
			}
		}
		
		/**
		 * @private
		 */
		private function resize(e:Event):void
		{
			if (viewer.stage.stageWidth && viewer.stage.stageHeight)
			{
				viewer.width  = viewer.stage.stageWidth;
				viewer.height = viewer.stage.stageHeight;
				resizeStage();
			}
		}
		
		/**
		 * @private
		 */
		private function keyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 32:
					controller.autoZoom();
					pageManager.reset();
					break;
				case 37:
				case 38:
					pageManager.prev();
					break;
				case 39:
				case 40:
					pageManager.next();
					break;
			}
		}
		
		private function fullScreen(e:FullScreenEvent):void
		{
			if (e.fullScreen == false)
			{
				config.kp_internal::toolBarSlid.kp_internal::resetScreenButtons();
				viewer.screenState = StageDisplayState.NORMAL;
			}
		}
		
		/**
		 * @private
		 */
		private function mouseWheel(e:MouseEvent):void
		{
			if (e.delta > 0)
				controller.zoomIn();
			else if (e.delta < 0)
				controller.zoomOut();
		}
		
		/**
		 * @private
		 */
		private function click(e:MouseEvent):void
		{
			try 
			{
				var element:BaseElement = BaseElement(e.target);
				if (element) 
				{
					if (element.related) 
					{
						var visible:Boolean = (element.vo.type!= "hotspot");
						if (visible) 
						{
							selector.render(element);
						}
						ExternalUtil.kanvasLinkClicked(element.vo.id);
					}
				}
				selector.visible = visible;
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
		kp_internal function centerAdaptive():void
		{
			canvas.rotation = 0;
			canvas.scaleX = canvas.scaleY = 1;
			var bound:Rectangle = LayoutUtil.getContentRect(canvas);
			var stage:Rectangle = viewer.bound;
			var cenC:Point = new Point((bound.left + bound.right) * .5, (bound.top + bound.bottom) * .5);
			var cenS:Point = new Point((stage.left + stage.right) * .5, (stage.top + stage.bottom) * .5);
			canvas.x = cenS.x - cenC.x;
			canvas.y = cenS.y - cenC.y;
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
			CoreUtil.registLib(lib);
			
			var templetes:XML = XML(value.child("template").toXMLString());
			for each(var item:XML in templetes.children())
				CoreUtil.registLibXMLWhole(item.@id, item, item.name().toString());
			
			themes.clear();
			
			var themesXML:XML = XML(value.child('themes').toXMLString());
			for each(item in themesXML.children()) 
				themes.put(item.name().toString(), item);
		}
		
		/**
		 * @private
		 */
		kp_internal function setTheme(value:String):void
		{
			if (themes.containsKey(value)) 
			{
				CoreUtil.registLib(lib);
				CoreUtil.clearLibPart();
				
				var theme:XML = themes.getValue(value) as XML;
				for each (var item:XML in theme.children()) 
					CoreUtil.registLibXMLPart(item.@styleID, item, item.name().toString());
				
				viewer.kp_internal::drawBackground(CoreUtil.getColor(background));
			}
		}
		
		kp_internal function setScreenState(value:String):void
		{
			screenFull = (value == "fullScreen");
			if(isNaN(lastWidth) || isNaN(lastHeight))
			{
				lastWidth  = viewer.stage.stageWidth;
				lastHeight = viewer.stage.stageHeight;
			}
			viewer.stage.displayState = value;
			var thisWidth :Number = viewer.stage.stageWidth;
			var thisHeight:Number = viewer.stage.stageHeight;
			var recOld:Rectangle = new Rectangle(5, 5, lastWidth - 10, lastHeight - 50);
			var recNew:Rectangle = new Rectangle(5, 5, thisWidth - 10, thisHeight - 50);
			if (value == "fullScreen")
			{
				screenScale = (recOld.width / recOld.height > recNew.width / recNew.height)
					? recNew.width  / recOld.width
					: recNew.height / recOld.height;
			}
			else
			{
				screenScale = 1 / screenScale;
			}
			var canvasToScale:Number = canvas.scaleX * screenScale;
			var vector:Point = new Point((thisWidth - lastWidth) * .5, (thisHeight - lastHeight) * .5);
			canvas.x += vector.x;
			canvas.y += vector.y;
			recOld.offset(vector.x, vector.y);
			recOld.width  *= screenScale;
			recOld.height *= screenScale;
			var tl:Point = new Point(recOld.x, recOld.y);
			LayoutUtil.convertPointStage2Canvas(tl, canvas.x, canvas.y, canvas.scaleX, canvas.rotation);
			LayoutUtil.convertPointCanvas2Stage(tl, canvas.x, canvas.y, canvasToScale, canvas.rotation);
			recOld.x = tl.x;
			recOld.y = tl.y;
			var canvasCenter:Point = new Point((recOld.left + recOld.right) * .5, (recOld.top + recOld.bottom) * .5);
			var stageCenter :Point = new Point((recNew.left + recNew.right) * .5, (recNew.top + recNew.bottom) * .5);
			var aimX:Number = canvas.x + stageCenter.x - canvasCenter.x;
			var aimY:Number = canvas.y + stageCenter.y - canvasCenter.y;
			controller.zoomRotateMoveTo(canvasToScale, canvas.rotation, aimX, aimY, null, 1);
			
			viewer.synBgImgWidthCanvas();
			
			lastWidth  = thisWidth;
			lastHeight = thisHeight;
		}
		
		
		private function get background():BgVO
		{
			return config.kp_internal::bgVO;
		}
		
		private function get viewer():Viewer
		{
			return config.kp_internal::viewer;
		}
		
		private function get canvas():Canvas
		{
			return config.kp_internal::viewer.canvas;
		}
		
		private function get controller():ZoomMoveControl
		{
			return config.kp_internal::controller;
		}
		
		private function get selector():Selector
		{
			return config.kp_internal::selector;
		}
		
		private function get pageManager():ManagerPage
		{
			return config.kp_internal::pageManager;
		}
		
		private function get lib():XMLVOLib
		{
			return config.kp_internal::lib;
		}
		
		private function get themes():Map
		{
			return config.kp_internal::themes;
		}
		
		/**
		 * @private
		 */
		private var config:KPConfig;
		
		private var provider:KPProvider;
		
		/**
		 * @private
		 */
		private var loader:ImgInsertor;
		
		private var lastWidth:Number;
		
		private var lastHeight:Number;
		
		private var screenScale:Number;
		
		private var screenFull:Boolean;
	}
}