package view.element
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	import com.kvs.utils.RectangleUtil;
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.vo.ElementVO;
	
	import util.ElementCreator;
	import util.LayoutUtil;
	import util.StyleUtil;
	
	import view.element.state.*;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.toolBar.ToolBarController;
	import view.ui.Canvas;
	import view.ui.ICanvasLayout;
	
	/**
	 * 所有元素UI的基类
	 * 
	 * 元素包括、图片、形状、视频、线条、文字
	 */
	public class ElementBase extends Sprite implements IClickMove, ICanvasLayout
	{
		public function ElementBase(vo:ElementVO)
		{
			this.vo = vo;
			_screenshot = true;
			addChild(graphicShape = new Shape);
			
			initState();
			StageUtil.initApplication(this, init);
		}
		
		/**
		 * 将元件的属性导出为XML数据
		 */		
		public function exportData():XML
		{
			xmlData.@id = vo.id;
			xmlData.@property = vo.property;
			xmlData.@type = vo.type;
			xmlData.@styleType = vo.styleType;
			xmlData.@styleID = vo.styleID;
			xmlData.@x = vo.x;
			xmlData.@y = vo.y;
			xmlData.@width = vo.width;
			xmlData.@height = vo.height;
			xmlData.@rotation = vo.rotation;
			xmlData.@color = vo.color.toString(16);
			xmlData.@colorIndex = vo.colorIndex;
			xmlData.@scale = vo.scale;
			
			return xmlData;
		}
		
		/**
		 * 数据导出时用到，将VO的各项属性转换为XML数据
		 */		
		public var xmlData:XML;
		
		
		
		
		
		
		
		
		//------------------------------------------------------
		//
		//
		//  图形控制点机制， 控制图形的原始尺寸， 特征点如圆角， 等
		//
		//  每种图形控制点各异，与型变控制器搭档, 实现整个控制 
		//
		//
		//-------------------------------------------------------
		
		
		/**
		 * 
		 * 每种图形需要的控制器不同, 各自负责控制器的开启与关闭, 图形被选择后会调用
		 * 
		 * 此方法
		 * 
		 */		
		public function showControlPoints(selector:ElementSelector):void
		{
			selector.frame.visible = true;
			ViewUtil.show(selector.scaleRollControl);
		}
		
		/**
		 * 隐藏型变控制点， 图形被取消选择后会调用此方法
		 */		
		public function hideControlPoints(selector:ElementSelector):void
		{
			selector.frame.visible = false;
			ViewUtil.hide(selector.scaleRollControl);
		}
		
		/**
		 * 图形处于选择状态并按下图形时调用
		 */		
		public function hideFrameOnMdown(selector:ElementSelector):void
		{
			selector.frame.alpha = 0.5;
			ViewUtil.hide(selector.scaleRollControl);
		}
		
		/**
		 * 图形移动结束后或者临时组合被按下并释放后调用此方法，显示型变框
		 */		
		public function showSelectorFrame(selector:ElementSelector):void
		{
			selector.frame.alpha = 1;
			ViewUtil.show(selector.scaleRollControl);
		}
		
		/**
		 * 元件自己决定开启那个工具条，不同类型元件的工具条各异
		 */		
		public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.defaultShape);
		}
		
		
		
		
		
		
		
		
		
		
		//-------------------------------------------------
		//
		//
		//  鼠标滑过效果
		//
		//
		//--------------------------------------------------
		
		
		
		/**
		 * 效果绘制的范围需要从全局获取
		 */		
		public function renderHoverEffect(style:Style):void
		{
			//记录下此样式是为了在多选/组合式显示子元素的边框
			hoverStyle.border = style.border;
			hoverStyle.fill = style.fill;
			hoverStyle.tx = style.tx;
			hoverStyle.ty = style.ty;
			hoverStyle.width = style.width;
			hoverStyle.height = style.height;
			
			showHoverEffect();
		}
		
		/**
		 * 显示鼠标状态
		 */		
		public function showHoverEffect():void
		{
			hoverEffectShape.graphics.clear();
			StyleManager.setLineStyle(hoverEffectShape.graphics, hoverStyle.getBorder);
			hoverEffectShape.graphics.drawRect(hoverStyle.tx, hoverStyle.ty, hoverStyle.width, hoverStyle.height);
			hoverEffectShape.graphics.endFill();
			
			//hoverEffectShape.graphics.lineStyle(1, 0xFFFFFF, 1, true, 'none');
			//hoverEffectShape.graphics.drawRect(style.tx - 1, style.ty - 1, style.width + 2, style.height + 2);
		}
		
		/**
		 * 隐藏鼠标状态
		 */		
		public function clearHoverEffect():void
		{
			hoverEffectShape.graphics.clear();
		}
		
		/**
		 * 鼠标经过元素
		 */
		protected function mouseOverHandler(evt:MouseEvent):void
		{
			currentState.mouseOver();
		}
		
		/**
		 * 鼠标离开元素
		 */
		protected function mouseOutHandler(evt:MouseEvent):void
		{
			currentState.mouseOut();
		}
		
		/**
		 * 此样式来源于全局鼠标hover样式，而布局信息采集自元件自身
		 */		
		public var hoverStyle:Style = new Style;
		
		
		/**
		 * 鼠标感应效果绘制的画布 
		 */		
		protected var hoverEffectShape:Shape = new Shape;
		
		
		/**
		 * 一个属性，指定拖动该元素时是否影响智能组合拖动
		 */
		public var autoGroupChangable:Boolean = true;
		
		
		
		
		
		//------------------------------------------------
		//
		//
		//
		//  供外部调用的接口
		//
		//
		//
		//-------------------------------------------------
		
		protected function caculateTransform(point:Point):Point
		{
			var rx:Number = point.x * cos - point.y * sin;
			var ry:Number = point.x * sin + point.y * cos;
			point.x = rx;
			point.y = ry;
			point.x += x;
			point.y += y;
			return point;
		}
		
		public function get topLeft():Point
		{
			tlPoint.x = - .5 * vo.scale * vo.width;
			tlPoint.y = - .5 * vo.scale * vo.height;
			return caculateTransform(tlPoint);
		}
		
		protected var tlPoint:Point = new Point;
		
		public function get topCenter():Point
		{
			tcPoint.x = 0;
			tcPoint.y = - .5 * vo.scale * vo.height;
			return caculateTransform(tcPoint);
		}
		protected var tcPoint:Point = new Point;
		
		public function get topRight():Point
		{
			trPoint.x =   .5 * vo.scale * vo.width;
			trPoint.y = - .5 * vo.scale * vo.height;
			return caculateTransform(trPoint);
		}
		protected var trPoint:Point = new Point;
		
		public function get middleLeft():Point
		{
			mlPoint.x = - .5 * vo.scale * vo.width;
			mlPoint.y = 0;
			return caculateTransform(mlPoint);
		}
		protected var mlPoint:Point = new Point;
		
		public function get middleCenter():Point
		{
			mcPoint.x = x;
			mcPoint.y = y;
			return mcPoint;
		}
		protected var mcPoint:Point = new Point;
		
		public function get middleRight():Point
		{
			mrPoint.x = .5 * vo.scale * vo.width;
			mrPoint.y = 0;
			return caculateTransform(mrPoint);
		}
		protected var mrPoint:Point = new Point;
		
		public function get bottomLeft():Point
		{
			blPoint.x = - .5 * vo.scale * vo.width;
			blPoint.y =   .5 * vo.scale * vo.height;
			return caculateTransform(blPoint);
		}
		protected var blPoint:Point = new Point;
		
		public function get bottomCenter():Point
		{
			bcPoint.x = 0;
			bcPoint.y = .5 * vo.scale * vo.height;
			return caculateTransform(bcPoint);
		}
		protected var bcPoint:Point = new Point;
		
		public function get bottomRight():Point
		{
			brPoint.x = .5 * vo.scale * vo.width;
			brPoint.y = .5 * vo.scale * vo.height;
			return caculateTransform(brPoint);
		}
		
		/**
		 */		
		protected var brPoint:Point = new Point;
		
		public function get left():Number
		{
			return x - .5 * vo.scale * vo.width;
		}
		
		public function get right():Number
		{
			return x + .5 * vo.scale * vo.width;
		}
		
		public function get top():Number
		{
			return y - .5 * vo.scale * vo.height;
		}
		
		public function get bottom():Number
		{
			return y + .5 * vo.scale * vo.height;
		}
		
		
		
		
		override public function get rotation():Number
		{
			return __rotation;
		}
		
		override public function set rotation(value:Number):void
		{
			if (__rotation!= value)
			{
				__rotation = value;
				cos = Math.cos(MathUtil.angleToRadian(rotation));
				sin = Math.sin(MathUtil.angleToRadian(rotation));
				if (parent)
					value += parent.rotation;
				super.rotation = value;
			}
		}
		private var __rotation:Number;
		
		private var cos:Number = Math.cos(0);
		private var sin:Number = Math.sin(0);
		
		override public function get scaleX():Number
		{
			return __scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			if (__scaleX!= value)
			{
				__scaleX = value;
				if (parent)
					value *= parent.scaleX;
				super.scaleX = value;
			}
		}
		
		private var __scaleX:Number = 1;
		
		override public function get scaleY():Number
		{
			return __scaleY;
		}
		
		override public function set scaleY(value:Number):void
		{
			if (__scaleY!= value)
			{
				__scaleY = value;
				if (parent)
					value *= parent.scaleY;
				super.scaleY = value;
			}
		}
		
		private var __scaleY:Number = 1;
		
		
		
		override public function get x():Number
		{
			return __x;
		}
		
		override public function set x(value:Number):void
		{
			if (__x!= value)
			{
				__x = value;
				updateView();
			}
		}
		
		private var __x:Number = 0;
		
		override public function get y():Number
		{
			return __y;
		}
		
		override public function set y(value:Number):void
		{
			if (__y!= value)
			{
				__y = value;
				updateView();
			}
		}
		
		private var __y:Number = 0;
		
		public function updateView(check:Boolean = true):void
		{
			if (check && stage)
			{
				var rect:Rectangle = LayoutUtil.getItemRect(parent as Canvas, this);
				if (rect.width < 1 || rect.height < 1)
				{
					super.visible = false;
				}
				else 
				{
					var boud:Rectangle = LayoutUtil.getStageRect(stage);
					super.visible = RectangleUtil.rectOverlapping(rect, boud);
				}
			}
			if (parent && visible)
			{
				var prtScale :Number = parent.scaleX;
				var prtRadian:Number = MathUtil.angleToRadian(parent.rotation);
				var prtCos:Number = Math.cos(prtRadian);
				var prtSin:Number = Math.sin(prtRadian);
				//scale
				var tmpX:Number = x * prtScale;
				var tmpY:Number = y * prtScale;
				//rotate, move
				super.rotation = parent.rotation + rotation;
				super.scaleX = prtScale * scaleX;
				super.scaleY = prtScale * scaleY;
				super.x = tmpX * prtCos - tmpY * prtSin + parent.x;
				super.y = tmpX * prtSin + tmpY * prtCos + parent.y;
			}
		}
		
		public function toPreview(renderable:Boolean = false):void
		{
			super.visible = previewVisible;
			if (renderable)
			{
				alpha = previewAlpha;
				updateView(false);
			}
		}
		
		public function toShotcut(renderable:Boolean = false):void
		{
			previewAlpha   = alpha;
			previewVisible = visible;
			if (renderable)
			{
				alpha   = 1;
				super.visible = screenshot;
				updateView(false);
			}
			else
			{
				previewVisible = visible;
				super.visible = false;
			}
		}
		
		protected var previewAlpha  :Number;
		protected var previewVisible:Boolean;
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if (visible) updateView();
		}
		
		public function get screenshot():Boolean
		{
			return _screenshot;
		}
		protected var _screenshot:Boolean;
		
		/**
		 * 
		 * 元素的原始尺寸 乘以 缩放比例  = 实际尺寸；
		 * 
		 */		
		public function get scaledWidth():Number
		{
			var w:Number = vo.width * vo.scale;
			
			//有些图形，例如临时组合是没有样式的
			if(vo.style && vo.style.getBorder)
				w = w + vo.thickness * vo.scale;
			
			return 	w;
		}
		
		/**
		 */		
		public function get scaledHeight():Number
		{
			var h:Number = vo.height * vo.scale;
			
			if(vo.style && vo.style.getBorder)
				h = h + vo.thickness * vo.scale;
			
			return h;		
		}
		
		public function get tempScaledWidth():Number
		{
			var w:Number = vo.width * scale;
			if (vo.style && vo.style.getBorder)
				w = w + vo.thickness * scale;
			return w;
		}
		
		public function get tempScaledHeight():Number
		{
			var h:Number = vo.height * scale;
			if(vo.style && vo.style.getBorder)
				h = h + vo.thickness * scale;
			return h;
		}
		
		/**
		 * 复制出一个新的自己
		 */		
		public function clone():ElementBase
		{
			return null;
		}
		
		/**
		 * 
		 */		
		public function cloneVO(newVO:ElementVO):ElementVO
		{
			// 除了ID， 其他都与原shape属性相同
			newVO.id = ElementCreator.id;
			newVO.styleType = vo.styleType;
			newVO.styleID = vo.styleID;
			
			//提前应用样式是为了防止color和thickness被刷新
			StyleUtil.applyStyleToElement(newVO);  
			
			newVO.color = vo.color;
			newVO.colorIndex = vo.colorIndex;
			newVO.thickness = vo.thickness;
			
			newVO.x = this.vo.x;
			newVO.y = this.vo.y;
			newVO.width = vo.width;
			newVO.height = vo.height;
			newVO.scale = vo.scale;
			newVO.rotation = vo.rotation;
			
			return newVO;
		}
		
		/**
		 */		
		public function set scale(value:Number):void
		{
			this.scaleX = this.scaleY = value;
		}
		
		/**
		 */		
		public function get scale():Number
		{
			return this.scaleX;
		}
		
		/**
		 * 移动去
		 */
		public function moveTo(value:Point):void
		{
			vo.x = value.x;
			vo.y = value.y;
			
			updateLayout();
		}
		
		
		public function get index():int
		{
			return (parent) ? parent.getChildIndex(this) : -1;
		}
		
		public function get isPage():Boolean
		{
			return _isPage;
		}
		protected var _isPage:Boolean;
		
		override public function get graphics():Graphics
		{
			return graphicShape.graphics;
		}
		
		
		public function get shape():Shape
		{
			return graphicShape;
		}
		
		
		/*override public function set mouseEnabled(enabled:Boolean):void
		{
		if (enabled == false)
		{
		trace(".............")
		}
		super.mouseEnabled = enabled;
		}*/
		
		
		//---------------------------------------------
		//
		//
		// 初始化
		//
		//
		//---------------------------------------------
		
		
		/**
		 * 初始化
		 */
		protected function init():void
		{
			preRender();
			
			//在未给元素应用样式之前是无法自动渲染的
			if (vo.style)
				render();
		}
		
		/**
		 * 构建子对象，初始化状态，控制器， 为渲染做好准备
		 */		
		protected function preRender():void
		{
			addChild(bg); 
			
			addChild(hoverEffectShape);
			disableBG();
			
			doubleClickEnabled = true;
			initListen();
			
			clickMoveControl = new ClickMoveControl(this, this);
		}
		
		/**
		 * 初始化监听
		 */
		private function initListen():void
		{
			mouseChildren = false;
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler, false, 0, true);
		}
		
		/**
		 */		
		protected function mouseDownHandler(evt:MouseEvent):void
		{
			currentState.mouseDown();
		}
		
		/**
		 */		
		protected function mouseUpHandler(evt:MouseEvent):void
		{
			currentState.mouseUp();
		}
		
		/**
		 * 具体的删除指令由元件自身决定
		 * 
		 * 因为不同的删除命令有对应的撤销命令
		 */
		public function del():void
		{
			currentState.del();
		}
		
		/**
		 * 复制，粘贴不同元素对应的command也不同
		 */		
		public function copy():void
		{
			this.dispatchEvent(new ElementEvent(ElementEvent.COPY_ELEMENT));
		}
		
		/**
		 */		
		public function paste():void
		{
			this.dispatchEvent(new ElementEvent(ElementEvent.PAST_ELEMENT));
		}
		
		/**
		 */		
		public function enable():void
		{
			currentState.enable();
		}
		
		/**
		 */		
		public function disable():void
		{
			currentState.disable();
		}
		
		/**
		 * 预览模式下元素不可disable
		 */
		public function get enableChangable():Boolean
		{
			return ! (currentState is ElementPrevState);
		}
		
		
		
		
		//------------------------------------------------
		//
		//
		// 状态切换
		//
		//
		//-------------------------------------------------
		
		/**
		 * 多选时， 仅组合自身和独立元件被纳入；
		 * 
		 * 组合的子元件不被纳入;
		 */		
		public function addToTemGroup(group:Vector.<ElementBase>):Vector.<ElementBase>
		{
			return currentState.addToTemGroup(group);
		}
		
		/**
		 * 组合类的智能组合与一般元素不同，仅包含自己的子元素；
		 * 
		 * 智能组合获取时，自身和组合的子元素一并被获取
		 */		
		public function getChilds(group:Vector.<ElementBase>):Vector.<ElementBase>
		{
			group.push(this);
			
			return group;
		}
		
		public function get grouped():Boolean
		{
			return (currentState is ElementGroupState || currentState is ElementMultiSelected);
		}
		
		/**
		 * 智能组合检测时，组合元件和其子元件不可以被组合
		 */		
		public function get canAutoGrouped():Boolean
		{
			return currentState.canAutoGrouped;
		}
		
		/**
		 * 初始化状态
		 */
		protected function initState():void
		{
			selectedState = new ElementSelected(this);
			unSelectedState = new ElementUnSelected(this);
			multiSelectedState = new ElementMultiSelected(this);
			groupState = new ElementGroupState(this);
			prevState = new ElementPrevState(this);
			
			currentState = unSelectedState;
		}
		
		/**
		 * 进入选中状态, 并通知主场景开启对应的工具条
		 */
		public function toSelectedState():void
		{
			currentState.toSelected();
		}
		
		/**
		 * 进入没选中状态
		 */
		public function toUnSelectedState():void
		{
			currentState.toUnSelected();
		}
		
		/**
		 */		
		public function toPrevState():void
		{
			currentState.toPrevState();
		}
		
		/**
		 */		
		public function returnFromPrevState():void
		{
			currentState.returnFromPrevState();
		}
		
		/**
		 * 进入多选状态
		 */
		public function toMultiSelectedState():void
		{
			currentState.toMultiSelection();
		}
		
		/**
		 * 进入到组合状态，此元件被纳入组合的子元件
		 */		
		public function toGroupState():void
		{
			currentState.toGroupState();
		}
		
		/**
		 * 当前状态
		 */
		public var currentState:ElementStateBase;
		
		/**
		 * 选中状态
		 */
		public var selectedState:ElementStateBase;
		
		/**
		 * 没选中状态
		 */
		public var unSelectedState:ElementStateBase;
		
		/**
		 * 多选状态
		 */
		public var multiSelectedState:ElementStateBase;
		
		/**
		 * 组合状态
		 */		
		public var groupState:ElementGroupState;
		
		/**
		 * 预览状态
		 */		
		public var prevState:ElementPrevState;
		
		
		
		
		
		
		
		//----------------------------------------
		//
		//
		//  渲染
		//
		//
		//------------------------------------------
		
		/**
		 * 渲染
		 */
		public function render():void
		{
			updateLayout();
			drawBG();
		}
		
		/**
		 * 根据模型更新布局和比例
		 */
		public function updateLayout():void
		{
			this.x = vo.x;
			this.y = vo.y;
			
			this.rotation = vo.rotation;
			this.scaleX = this.scaleY = vo.scale;
		}
		
		/**
		 * 显示背景，仅进入选择状态后才使得背景
		 * 
		 * 可接受交互感应
		 */		
		public function enableBG():void
		{
			bg.visible = true;
			bg.mouseEnabled = true;
		}
		
		/**
		 */		
		public function disableBG():void
		{
			bg.mouseEnabled = false;
			bg.visible = false;
		}
		
		/**
		 * 画背景, 背景随看不到，但是当元素处于
		 * 
		 * 选择状态下，点击背景是可以拖动元素的;
		 * 
		 * 非选择状态下只能通过点击图像区域才可以拖动元件
		 */
		public function drawBG():void
		{
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000, 0);
			bg.graphics.drawRect(- vo.width / 2, - vo.height / 2, vo.width, vo.height);
			bg.graphics.endFill();
		}
		
		/**
		 * 背景 
		 */
		protected var bg:Sprite = new Sprite;
		
		
		
		
		
		
		
		
		
		//-----------------------------------------------------
		//
		//
		//  点击 与移动图形控制
		//
		//
		//------------------------------------------------------
		
		/**
		 */		
		public function startMove():void
		{
			currentState.startMove();
		}
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void { }
		
		/**
		 */		
		public function stopMove():void
		{
			currentState.stopMove();
		}
		
		/**
		 */		
		public function clicked():void
		{
			// 非选择状态下才会触发clicked
			currentState.clicked();
		}
		
		/**
		 *  点击拖动控制 
		 */		
		private var clickMoveControl:ClickMoveControl;
		
		/**
		 * 从预览状态返回时 ，需要切换到之前的状态
		 * 
		 * 由每个状态负责向回切换，把向回切换的方法保存下来即可
		 */		
		public var returnFromPrevFun:Function; 
		
		/**
		 * 数据
		 */
		public var vo:ElementVO;
		
		protected var graphicShape:Shape;
	}
}