package commands
{
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;

	/**
	 * 改变元件的属性
	 */	
	public final class ChangeElementPropertyCMD extends Command
	{
		public function ChangeElementPropertyCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			element  = CoreFacade.coreMediator.currentElement;
			if (element)
			{
				selector = CoreFacade.coreMediator.selector;
				
				oldPropertyObj = notification.getBody();
				
				newPropertyObj = {};
				
				for (var propertyName:String in oldPropertyObj) 
				{
					if (propertyName == "indexChangeElement")
					{
						newPropertyObj["indexChangeElement"] = oldPropertyObj["indexChangeElement"];
					}
					else if (propertyName == "index")
					{
						//获取改变层级元素的新层级关系
						var layer:Vector.<int> = new Vector.<int>;
						var length:int =  oldPropertyObj["indexChangeElement"].length;
						for (var i:int = 0; i <　length; i++)
							layer[i] = oldPropertyObj["indexChangeElement"][i].index;
						newPropertyObj[propertyName] = layer;
					}
					else if (voPropertyNames.indexOf(propertyName) != -1)
					{
						newPropertyObj[propertyName] = element.vo[propertyName];
					}
					else
					{
						newPropertyObj[propertyName] = element[propertyName];
					}
				}
				
				groupElements = CoreFacade.coreMediator.autoGroupController.elements;
				
				autoGroupEnabled = CoreFacade.coreMediator.autoGroupController.enabled;
				
				setProperty(newPropertyObj, false);
				
				UndoRedoMannager.register(this);
			}
		}
		
		override public function undoHandler():void
		{
			element.clearHoverEffect();
			setProperty(oldPropertyObj, true);
		}
		
		override public function redoHandler():void
		{
			element.clearHoverEffect();
			setProperty(newPropertyObj, true);
		}
		
		private function setProperty(obj:Object, render:Boolean = false):void
		{
			var ifNeedRender:Boolean = true;
			
			for (var propertyName:String in obj) 
			{
				try
				{
					if (propertyName == "index")
					{
						CoreFacade.coreMediator.autoLayerController.swapElements(obj["indexChangeElement"], obj[propertyName]);
						//obj["indexChangeElement"][propertyName] = obj[propertyName];
					}
					else
					{
						if (element.vo.hasOwnProperty(propertyName))
							element.vo[propertyName] = obj[propertyName];
					}
				}
				catch (e:Error)
				{
					trace(e.getStackTrace());
				}
			}
		

			if (autoGroupEnabled)
			{
				CoreFacade.coreMediator.autoGroupController.resetElements(groupElements);
				
				var newObj:Object = obj;
				var oldObj:Object = (obj == newPropertyObj) ? oldPropertyObj : newPropertyObj;
				
				if (obj["x"] != undefined && obj["y"] != undefined)
				{
					CoreFacade.coreMediator.autoGroupController.moveTo(newObj.x - oldObj.x, newObj.y - oldObj.y);
					ifNeedRender = false;
				}
				if (obj["rotation"] != undefined)
				{
					CoreFacade.coreMediator.autoGroupController.rollTo(newObj.rotation - oldObj.rotation, element);
					ifNeedRender = false;
				}
				if (obj["scale"] != undefined)
				{
					CoreFacade.coreMediator.autoGroupController.scaleTo(newObj.scale / oldObj.scale, element);
					ifNeedRender = false;
				}
				
			}
			
			//element.clearHoverEffect();
			if (render || ifNeedRender)
				element.render();
			
			selector.update();
		}
		
		/**
		 */		
		private var oldPropertyObj:Object;
		
		/**
		 */		
		private var newPropertyObj:Object;
		
		/**
		 */	
		private var groupElements:Vector.<ElementBase>;
		
		/**
		 */		
		private var element:ElementBase;
		
		private var autoGroupEnabled:Boolean;
		
		/**
		 */		
		private var selector:ElementSelector;
		
		private static const voPropertyNames:Array = ["radius", "arrowWidth", "trailHeight", 'r', 'rAngle', "innerRadius", "width", "height", "thickness"];
	}
}