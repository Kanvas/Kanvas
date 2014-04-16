/* 
Adobe AIR Application Install Badge -- AS3

Required variables (to be passed in FlashVars parameter of Object & Embed tags in HTML):
o appname (name of application displayed in message under install button)
o appurl (url of .air file on server)
o airversion (version of the AIR Runtime)

Optional variables:
o buttoncolor (six digit hex value of button background; setting value to "transparent" is also possible)
o messagecolor (six digit hex value of text message displayed under install button)
o imageurl (url of .jpg file to load)

Note that all of these values must be escaped per the requirements of the FlashVars parameter.

Also note that you can set the badge background color with the standard Object/Embed "bgcolor" parameter

*/


package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	import flash.system.*;
	import flash.text.TextField;

	// AIRBadge is our main document class
	public class AIRBadge extends MovieClip {

		public function AIRBadge() {
			// Read FlashVars
			try {
				var parameters:Object = LoaderInfo(this.root.loaderInfo).parameters;

				_messageColor = validateColor(parameters["messagecolor"]);

				_buttonColor = parameters["buttoncolor"];
				if (_buttonColor != "transparent") {
					_buttonColor = validateColor(_buttonColor);
				}

				_imageURL = validateURL(parameters["imageurl"]);

				_airVersion = String(parameters["airversion"]);

				_appURL = validateURL(encodeURI(parameters["appurl"]));
				
				_pubID = String(parameters["pubid"]);

				// Make sure the appname does not contain any tags, by checking for "less than" characters
				_appName = parameters["appname"];
				if ( _appName == null || _appName.length == 0 || _appName.indexOf("<") >= 0) {
					_appName = null;

				}
			} catch (error:Error) {
				_messageColor = "FF0000";
				_buttonColor = "000000";
				_appURL = "";
				_appName = null;
				_airVersion = "";
			}
			// Set-up event handler for button
			button.addEventListener(MouseEvent.MOUSE_UP, onButtonClicked);

			// Reset status message text
			root.statusMessage.text = "";

			// Load background image
			if (_imageURL && _imageURL.length > 0) {
				try {
					var loader:Loader = new Loader();
					loader.load(new URLRequest(_imageURL));
					root.image_mc.addChild(loader);
				} catch (error:Error) {
				}
			}

			// Colorize button background movieclip (buttonBg_mc)
			if ( _buttonColor != "transparent" ) {
				root.buttonBg_mc.visible = true;
				var tint:uint = new Number("0x" + _buttonColor).valueOf();

				var transform:ColorTransform = new ColorTransform();
				transform.redMultiplier = ((tint & 0xFF0000) >> 16) / 256.0;
				transform.greenMultiplier = ((tint & 0x00FF00) >> 8) / 256.0;
				transform.blueMultiplier = ((tint & 0x0000FF)) / 256.0;

				root.buttonBg_mc.transform.colorTransform = transform;

			} else {
				root.buttonBg_mc.visible = false;
			}
			//Will be enabled when we're fully loaded
			button.enabled = false;

			_loader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.applicationDomain = ApplicationDomain.currentDomain;

			_loader.contentLoaderInfo.addEventListener(Event.INIT, onInit);
			try {
				_loader.load(new URLRequest(BROWSERAPI_URL_BASE), loaderContext);
			} catch (e:Error) {
				root.statusMessage.text = e.message;
			}
		}

		private function onInit(e:Event):void {
			_air = e.target.content;
			switch (_air.getStatus(_airVersion)) {
				case "installed" :
					root.statusMessage.text = "";
					button.enabled = true;
					_air.getApplicationVersion( _appName, _pubID, versionDetectCallback ); 
					break;
				case "available" :
					root.statusMessage.htmlText = "<p align='center'><font color='#" + _messageColor + "'>在安装 Kanvas 之前，也会在您的系统上安装 Adobe® AIR®。</font></p>";
					button.enabled = true;
					break;
				case "unavailable" :
					root.statusMessage.htmlText = "<p align='center'><font color='#" + _messageColor + "'>Adobe® AIR® 在您的系统上不可用，无法安装 Kanvas。</font></p>";
					break;
			}
			_initialized = true;
		}
		
		private var _version:String;
		
		private function onButtonClicked(e:Event):void {
			if( !_initialized ) return;
			try {
				switch (_air.getStatus(_airVersion)) {
					case "installed" :
						if (_version)
						{
							if (_version == "non") 
							{
								root.statusMessage.htmlText = "<p align='center'><font color='#" + _messageColor + "'>开始安装...</font></p>";
								_air.installApplication( _appURL, _airVersion );
							}
							else
							{
								root.statusMessage.htmlText = "<p align='center'><font color='#" + _messageColor + "'>正在启动...</font></p>";
								_air.launchApplication( _appName, _pubID, ["launchFromBrowser"]);
							}
						}
						break;
					case "available" :
						root.statusMessage.htmlText = "<p align='center'><font color='#" + _messageColor + "'>开始安装...</font></p>";
						_air.installApplication( _appURL, _airVersion );
						break;
					case "unavailable" :
						// do nothing
						break;
				}
			} catch (e:Error) {
				root.statusMessage.text = e.message;
			}
		}
		
		private function versionDetectCallback(version:String):void 
		{ 
			_version = (version == null) ? "non" : version;
			if (version == null) 
			{
				root.statusMessage.htmlText = "<p align='center'><font color='#" + _messageColor + "'>您还没有安装 Kanvas。</font></p>";
				button.text = "INSTALL NOW";
			} 
			else 
			{ 
				root.statusMessage.htmlText = "<p align='center'><font color='#" + _messageColor + "'>您已安装 Kanvas "+version+"。</font></p>";
				button.text = "RUN NOW";
			} 
}

		// Validate URL: only allow HTTP, HTTPS scheme or relative path
		// Return null if not a valid URL
		private static function validateURL(url:String):String {
			if (url && url.length > 0) {
				var schemeMarker:int = url.indexOf(":");
				if (schemeMarker < 0) {
					schemeMarker = url.indexOf("%3a");
				}
				if (schemeMarker < 0) {
					schemeMarker = url.indexOf("%3A");
				}
				if (schemeMarker > 0) {
					var scheme:String = url.substr(0, schemeMarker).toLowerCase();
					if (scheme != "http" && scheme != "https" && scheme != "ftp") {
						url = null;
					}
				}
			}
			return url;
		}

		// Validate color: only allow 6 hex digits
		// Always return a valid color, black by default
		private static function validateColor(color:String):String {
			if ( color == null || color.length != 6 ) {
				color = "000000";
			} else {
				var validHex:String = "0123456789ABCDEFabcdef";
				var numValid:int = 0;
				for (var i:int=0; i < color.length; ++i) {
					if (validHex.indexOf(color.charAt(i)) >= 0) {
						++numValid;
					}
				}
				if (numValid != 6) {
					color = "000000";
				}
			}
			return color;
		}

		private const BROWSERAPI_URL_BASE: String = "http://airdownload.adobe.com/air/browserapi/air.swf";
		

		private var _messageColor: String;
		private var _buttonColor: String;
		private var _imageURL: String;
		private var _appURL: String;
		private var _appName: String;
		private var _airVersion: String;
		private var _pubID: String;

		private var _loader:Loader;
		private var _air:Object;
		private var _initialized:Boolean = false;
	}
}
