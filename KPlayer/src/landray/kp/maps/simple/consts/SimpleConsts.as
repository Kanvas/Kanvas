package landray.kp.maps.simple.consts
{
	import landray.kp.maps.simple.elements.*;
	
	import model.vo.*;
	
	public class SimpleConsts
	{
		public static const SHAPE_UI_MAP :XML = 
			<elements>
				<element type="circle"          voClassPath="model.vo.ShapeVO"/>
				<element type="rect"            voClassPath="model.vo.ShapeVO"/>
				<element type="arrow"           voClassPath="model.vo.ArrowVO"/>
				<element type="doubleArrow"     voClassPath="model.vo.ArrowVO"/>
				<element type="triangle"        voClassPath="model.vo.ShapeVO"/>
				<element type="stepTriangle"    voClassPath="model.vo.ShapeVO"/>
				<element type="diamond"         voClassPath="model.vo.ShapeVO"/>
				<element type="star"            voClassPath="model.vo.StarVO"/>
				<element type="line"            voClassPath="model.vo.LineVO"/>
				<element type="arrowLine"       voClassPath="model.vo.LineVO"/>
				<element type="doubleArrowLine" voClassPath="model.vo.LineVO"/>
				<element type="text"            voClassPath="model.vo.TextVO"/>
				<element type="img"             voClassPath="model.vo.ImgVO"/>
				<element type="hotspot"         voClassPath="model.vo.HotspotVO"/>
				<element type="dashRect"        voClassPath="model.vo.ShapeVO"/>
				<element type="dialog"          voClassPath="model.vo.DialogVO"/>
				<element type="camera"          voClassPath="model.vo.ElementVO"/>
			</elements>;
		
		public static const SHAPE_UI:Object = 
		{
			circle         :landray.kp.maps.simple.elements.Circle, 
			rect           :landray.kp.maps.simple.elements.Rect,
			arrow          :landray.kp.maps.simple.elements.Arrow,
			doubleArrow    :landray.kp.maps.simple.elements.DoubleArrow,
			triangle       :landray.kp.maps.simple.elements.Triangle,
			stepTriangle   :landray.kp.maps.simple.elements.StepTriangle,
			diamond        :landray.kp.maps.simple.elements.Diamond,
			star           :landray.kp.maps.simple.elements.Star,
			line           :landray.kp.maps.simple.elements.LineElement,
			arrowLine      :landray.kp.maps.simple.elements.ArrowLine,
			doubleArrowLine:landray.kp.maps.simple.elements.DoubleArrowLine,
			text           :landray.kp.maps.simple.elements.Label,
			img            :landray.kp.maps.simple.elements.Image,
			hotspot        :landray.kp.maps.simple.elements.Hotspot,
			dialog         :landray.kp.maps.simple.elements.Dialog,
			dashRect       :landray.kp.maps.simple.elements.DashRect,
			camera         :landray.kp.maps.simple.elements.Camera
		};
	}
}