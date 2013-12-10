package view.interact
{
	import com.kvs.utils.MathUtil;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import util.CoreUtil;
	import util.layout.LayoutTransformer;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.element.text.TextEditField;
	import view.interact.autoGroup.IAutoGroupElement;
	import view.interact.multiSelect.TemGroupElement;
	import view.ui.Canvas;

	public final class ElementAutoAlignController
	{
		public function ElementAutoAlignController($elements:Vector.<ElementBase>, $canvas:Canvas, $shape:Shape, $coreMdt:CoreMediator)
		{
			elements = $elements;
			canvas = $canvas;
			shape = $shape;
			coreMdt = $coreMdt;
		}
		
		/**
		 * 清除shape绘制的虚线
		 */
		public function clear():void
		{
			shape.graphics.clear();
			clearHoverEffect();
		}
		
		/**
		 * 检查移动位置,移动对象时调用
		 */
		public function checkPosition(element:ElementBase, point:Point = null, axis:String = "x"):Point
		{
			if (enabled)
			{
				shape.graphics.clear();
				tempPoint = (point) ? checkPoint(element, point, axis) : checkElement(element);
			}
			return (enabled) ? tempPoint : null;
		}
		
		
		/**
		 * @private
		 * 基于元素的检测，主要用于检测元素移动
		 */
		private function checkElement(current:ElementBase):Point
		{
			tempPoint.x = NaN;
			tempPoint.y = NaN;
			var area:Number = areaPosition / canvas.scaleX;
			//元素１检测的属性集
			var e1pArr:Array = [xArr, yArr];
			var alignArr:Array = [false, false];
			//存储直线a,b,c变量
			for (var i:int = 0; i < 2; i++)
			{
				var elementsLoopBreak:Boolean = false;
				for each (var element:ElementBase in elements)
				{
					if (current == element || ! element.visible || CoreUtil.inAutoGroup(element) || CoreUtil.pointOutOfStageBounds(new Point(element.x, element.y))) continue;
					var plus:Number = current.rotation - element.rotation;
					//判断元素１的横向是对元素２的横向还是纵向进行对齐检测
					if (plus % 90 == 0)
					{
						var bool:Boolean = (plus % 180 == 0);
						//元素２检测的属性集
						var e2pArr:Array = (bool) ? [xArr, yArr] : [yArr, xArr];
						var j:int = 0;
						var k:int = 0;
						while (j < 3)
						{
							var e1p:String = e1pArr[i][j];
							var e2p:String = e2pArr[i][k];
							//获取移动点
							var curPoint:Point = getPoint(current, e1p);
							//获得判断点
							var chkPoint:Point = getPoint(element, e2p);
							//第一直线经过的点
							var points1:Array = getOriginPointsByProperty(current, e1p);
							//第二直线经过的点
							var points2:Array = getTargetPointsByProperty(element, e2p);
							//两直线相交的点
							var aimPoint:Point = getPointByIntersect(points1, points2);
							//距离判断
							if (Point.distance(aimPoint, curPoint) < area)
							{
								alignArr[i] = new Point;
								drawLineInPoints(Point.interpolate(points2[0], points2[1], .5), aimPoint);
								//此方向的增量向量
								alignArr[i].x = tempPoint.x = aimPoint.x - curPoint.x;
								alignArr[i].y = tempPoint.y = aimPoint.y - curPoint.y;
								elementsLoopBreak = true;
								break;
							}
							if (++k>=3)
							{
								j++;
								k = 0;
							}
						}//end of while
					}
					else
					{
						var property:String = e1pArr[i][0];
						if (Math.abs(current[property] - element[property]) < area)
						{
							tempPoint[property] = element[property] - current[property];
							drawLineAxis(element[property], property);
							elementsLoopBreak = true;
						}
					}//end of if plus
					if (elementsLoopBreak) break;
				}//end of for element
			}//end of for i
			if (alignArr[0] && alignArr[1])
			{
				tempPoint.x = alignArr[0].x + alignArr[1].x;
				tempPoint.y = alignArr[0].y + alignArr[1].y;
			}
			return tempPoint;
		}
		
		/**
		 * @private
		 * 基于点的检测，主要用于检测形变
		 */
		private function checkPoint(current:ElementBase, point:Point, axis:String = "x"):Point
		{
			var area:Number = areaPosition / canvas.scaleX;
			tempPoint.x = NaN;
			tempPoint.y = NaN;
			var elementsLoopBreak:Boolean = false;
			for each (var element:ElementBase in elements)
			{
				if (current == element || ! element.visible || CoreUtil.inAutoGroup(element) || CoreUtil.pointOutOfStageBounds(new Point(element.x, element.y))) continue;
				var plus:Number = current.rotation - element.rotation;
				if (plus % 90 == 0)
				{
					var bool:Boolean = (plus % 180 == 0);
					//元素２检测的属性集
					var pArr:Array = (bool) ? ((axis == "x") ? xArr : yArr) : ((axis == "x") ? yArr : xArr);
					var j:int = 0;
					while (j < 3)
					{
						var e1p:String = axis;
						var e2p:String = pArr[j];
						//获取移动点
						var curPoint:Point = point;
						//获得判断点
						var chkPoint:Point = getPoint(element, e2p);
						//第一直线经过的点
						var points1:Array = getOriginPointsByProperty(current, e1p);
						//第二直线经过的点
						var points2:Array = getTargetPointsByProperty(element, e2p);
						//两直线相交的点
						var aimPoint:Point = getPointByIntersect(points1, points2);
						//距离判断
						if (Point.distance(aimPoint, curPoint) < area)
						{
							drawLineInPoints(Point.interpolate(points2[0], points2[1], .5), aimPoint);
							//此方向的增量向量
							tempPoint.x = aimPoint.x;
							tempPoint.y = aimPoint.y;
							elementsLoopBreak = true;
							break;
						}
						j++;
					}//end of while
				}
				if (elementsLoopBreak) break;
			}//end of for element
			return tempPoint;
		}
		
		private function getPointByIntersect(points1:Array, points2:Array):Point
		{
			var a:Array = [];
			var b:Array = [];
			var c:Array = [];
			
			//第一直线a1x+b1y+c1=0
			a[1] = points1[0].y - points1[1].y;
			b[1] = points1[1].x - points1[0].x;
			c[1] = points1[0].x * points1[1].y - points1[0].y * points1[1].x;
			//第二直线a2x+b2y+c2=0
			a[2] = points2[0].y - points2[1].y;
			b[2] = points2[1].x - points2[0].x;
			c[2] = points2[0].x * points2[1].y - points2[0].y * points2[1].x;
			//两直线相交的点
			var x:Number = (b[1] * c[2] - b[2] * c[1]) / (a[1] * b[2] - a[2] * b[1]);
			var y:Number = (a[2] * c[1] - a[1] * c[2]) / (a[1] * b[2] - a[2] * b[1]);
			
			return new Point(x, y);
		}
		
		/**
		 * 检查旋转角度,旋转时调用
		 */
		public function checkRotation(element:ElementBase, rotation:Number):Number
		{
			if (enabled)
			{
				clearHoverEffect();
				
				rotation = MathUtil.modRotation(rotation);
				var mod:Number = rotation % 45;
				if (mod < areaRotation)
					rotation -= mod;
				else if (mod > 45 - areaRotation)
					rotation += (45 - mod);
				else
					rotation = checkValue(element, rotation, "rotation");
				
				if (currentAlignElement)
				{
					coreMdt.mainUI.hoverEffect.element = currentAlignElement;
					coreMdt.mainUI.hoverEffect.show();
				}
			}
			return (enabled) ? rotation : NaN;
		}
		
		/**
		 * 检查缩放,缩放时调用
		 */
		public function checkScale(element:ElementBase, scale:Number):Number
		{
			if (enabled)
			{
				clearHoverEffect();
				
				scale = (element is TextEditField) ? NaN : checkValue(element, scale, "scaleX");
				
				if (currentAlignElement)
				{
					coreMdt.mainUI.hoverEffect.element = currentAlignElement;
					coreMdt.mainUI.hoverEffect.show();
				}
			}
			return (enabled) ? scale : NaN;
		}
		
		private function checkValue(current:ElementBase, value:Number, property:String):Number
		{
			for each (var element:ElementBase in elements)
			{
				var result:Number = checkValueNear(current, element, value, element[property], property);
				if (!isNaN(result))
				{
					currentAlignElement = element;
					return result;
				}
			}
			return NaN;
		}
		
		
		
		private function checkValueNear(element1:ElementBase, element2:ElementBase, value1:Number, value2:Number, property:String):Number
		{
			var result:Number;
			if (element1 != element2 && element2.visible && ! CoreUtil.inAutoGroup(element2))
			{
				if (property == "rotation")
				{
					value1 = MathUtil.modRotation(value1);
					value2 = MathUtil.modRotation(value2);
					var mod:Number = (value1 - value2) % 90;
					var mda:Number = Math.abs(mod);
					if (mda < areaRotation)
					{
						result = value1 - mod;
						//trace("first:"+result);
					}
					else if (mda > 90 - areaRotation)
					{
						result = value1 - ((mod < 0) ? 90 + mod : mod - 90);
						//trace("second:"+result, "mod:", mod);
					}
					
				}
				else if (property == "scaleX")
				{
					if (getClass(element1) == getClass(element2) && (element1.rotation - element2.rotation) % 90 == 0)
					{
						var w1:Number = value1 * element1.vo.width;
						var w2:Number = value2 * element2.vo.width;
						var h1:Number = value1 * element1.vo.height;
						var h2:Number = value2 * element2.vo.height;
						var ds:Number = areaScale / canvas.scaleX;
						var dp:Number = areaPosition / canvas.scaleX;
						
						if (Math.abs(w1 - w2) < dp)
							result = w2 / element1.vo.width;
						else if (Math.abs(w1 - h2) < dp)
							result = h2 / element1.vo.width;
						else if (Math.abs(h1 - w2) < dp)
							result = w2 / element1.vo.height;
						else if (Math.abs(h1 - h2) < dp)
							result = h2 / element1.vo.height;
					}
				}
			}
			return result;
		}
		
		private function getClass(obj:Object):Object
		{
			return getDefinitionByName((getQualifiedClassName(obj)));
		}
		
		//获取当前移动元素的检测点集合，形成直线
		private function getOriginPointsByProperty(element:ElementBase, property:String):Array
		{
			return [element[originPointObj[property][0]], element[originPointObj[property][1]]];
		}
		private const originPointObj:Object = {
			x     :["middleLeft", "middleRight" ],
			left  :["middleLeft", "middleRight" ],
			right :["middleLeft", "middleRight" ],
			y     :["topCenter" , "bottomCenter"],
			top   :["topCenter" , "bottomCenter"],
			bottom:["topCenter" , "bottomCenter"]
		};
		
		//获取检测元素的检测点集合，形成直线
		private function getTargetPointsByProperty(element:ElementBase, property:String):Array
		{
			return [element[targetPointObj[property][0]], element[targetPointObj[property][1]]];
		}
		private const targetPointObj:Object = {
			x     :["topCenter" , "bottomCenter"],
			left  :["topLeft"   , "bottomLeft"  ],
			right :["topRight"  , "bottomRight" ],
			y     :["middleLeft", "middleRight" ],
			top   :["topLeft"   , "topRight"    ],
			bottom:["bottomLeft", "bottomRight" ]
		};
			
		private function getPoint(element:ElementBase, property:String):Point
		{
			return element[pointObj[property]];
		}
		private const pointObj:Object = {
			left  :"middleLeft",
			right :"middleRight",
			top   :"topCenter",
			bottom:"bottomCenter",
			x     :"middleCenter",
			y     :"middleCenter"
		};
		
		/**
		 * 清除当前目标对齐元素的hoverEffect
		 */
		private function clearHoverEffect():void
		{
			if (currentAlignElement)
			{
				currentAlignElement.clearHoverEffect();
				currentAlignElement = null;
			}
		}
		
		/**
		 * 以轴画线
		 */
		private function drawLineAxis(value:Number, axis:String = "x"):void
		{
			shape.graphics.lineStyle(.1, 0x555555);
			if (axis == "x")
			{
				value = coreMdt.mainUI.layoutTransformer.elementXToStageX(value);
				axisPoint1.x = value;
				axisPoint1.y = 0;
				axisPoint2.x = value;
				axisPoint2.y = canvas.stage.stageHeight;
			}
			else
			{
				value = coreMdt.mainUI.layoutTransformer.elementYToStageY(value);
				axisPoint1.x = 0;
				axisPoint1.y = value;
				axisPoint2.x = canvas.stage.stageWidth;
				axisPoint2.y = value;
			}
			drawDashed(shape.graphics, axisPoint1, axisPoint2, 10, 10);
		}
		
		/**
		 * 在两点间画线
		 */
		private function drawLineInPoints(point1:Point, point2:Point):void
		{
			shape.graphics.lineStyle(.1, 0x555555);
			var transformer:LayoutTransformer = coreMdt.layoutTransformer;
			axisPoint1.x = transformer.elementXToStageX(point1.x);
			axisPoint1.y = transformer.elementYToStageY(point1.y);
			axisPoint2.x = transformer.elementXToStageX(point2.x);
			axisPoint2.y = transformer.elementYToStageY(point2.y);
			drawDashed(shape.graphics, axisPoint1, axisPoint2, 10, 10);
		}
		
		/**
		 * 绘制虚线
		 */
		private function drawDashed(graphics:Graphics, beginPoint:Point, endPoint:Point, width:Number, grap:Number):void
		{
			if (!graphics || !beginPoint || !endPoint || width <= 0 || grap <= 0) return;
			
			var Ox:Number = beginPoint.x;
			var Oy:Number = beginPoint.y;
			
			var radian:Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
			var totalLen:Number = Point.distance(beginPoint, endPoint);
			var currLen:Number = 0;
			var x:Number, y:Number;
			
			while (currLen <= totalLen)
			{
				x = Ox + Math.cos(radian) * currLen;
				y = Oy +Math.sin(radian) * currLen;
				graphics.moveTo(x, y);
				
				currLen += width;
				if (currLen > totalLen) currLen = totalLen;
				
				x = Ox + Math.cos(radian) * currLen;
				y = Oy +Math.sin(radian) * currLen;
				graphics.lineTo(x, y);
				
				currLen += grap;
			}
			
		}
		
		/**
		 * 启用或禁用自动缩放
		 */
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			if (value == enabled) return;
			_enabled = value;
			clear();
		}
		private var _enabled:Boolean = true;
		
		/**
		 * 移动时自动对齐的检测范围，像素为单位
		 * 
		 * @default 10
		 */
		public var areaPosition:Number = 10;
		
		/**
		 * 旋转时自动对齐的检测范围，角度为单位
		 * 
		 * @default 5
		 */
		public var areaRotation:Number = 5;
		
		/**
		 * 缩放时自动对齐的检测范围
		 */
		public var areaScale:Number = .05;
		
		/**
		 * 元素集合
		 */
		private var elements:Vector.<ElementBase>;
		
		/**
		 * 画布，用于获取缩放值
		 */
		private var canvas:Canvas;
		
		/**
		 * 虚线绘制UI
		 */
		private var shape:Shape;
		
		private var coreMdt:CoreMediator;
		
		/**
		 * 当前对齐的元素
		 */
		private var currentAlignElement:ElementBase;
		
		private var tempPoint:Point = new Point;
		
		private var axisPoint1:Point = new Point;
		
		private var axisPoint2:Point = new Point;
		
		
		private const xArr:Array = ["x", "left", "right"];
		private const yArr:Array = ["y", "top", "bottom"];
	}
}