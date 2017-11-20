package cn.yingzaiqidian.scorm
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author by cC Email:oC_Co@qq.com
	 */
	public class Main extends Sprite 
	{
		private var muluMc:MuluMc;
		private var toolMc:ToolMc;
		private var bsound:Sound;
		private var bsounndchl:SoundChannel;
		private var bsoundpos:int = 0;
		private var contMc:MovieClip;
		private var temp:McLoader;
		private var playStateDelay:uint = 0;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.stageFocusRect = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			new CopyRigth(this);
			loadConfig();
		}
		
		private function progressHandler(bfb:Number):void {
            trace(bfb);
        }
		private function loadConfig():void {
			var config = new XmlLoader("../xml/config.xml", function(obj:Object) {
				config = null;
				if (obj.code == 100) {
					GlobalAs.configXml = XML(obj.xml);
					loadCatalog();
				}
				else 
				{
					
				}
				
			},progressHandler);
		}

		private function loadCatalog():void {
			var config = new XmlLoader("../xml/catalog.xml", function(obj:Object) {
				config = null;
				if (obj.code == 100) {
					GlobalAs.XmltoObj(obj.xml, GlobalAs.courseAr);
					loadSkin();
				}
				else 
				{
					
				}
				
			},progressHandler);
		}

		private function loadSkin():void {
			GlobalAs.skin = new SkinLoader("../main/skin.swf", function(obj:Object) {
				if (obj.code == 100) {
					initScene();
				}
				else 
				{
					
				}
				
			},progressHandler);
		}
		private function initScene():void {
			var sw:Number = GlobalAs.configXml.@sw || stage.stageWidth;
			var sh:Number = GlobalAs.configXml.@sh || stage.stageHeight;
			
			GlobalAs.dispatcher.addEventListener(MyEvent.LOAD_PAGE, loadPage);
			GlobalAs.dispatcher.addEventListener(MyEvent.ALERT, showAlert);
			GlobalAs.dispatcher.addEventListener(MyEvent.MULU, showMulu);
			GlobalAs.dispatcher.addEventListener(MyEvent.BSOUND, bsoundFun);
			GlobalAs.dispatcher.addEventListener(MyEvent.JINDUBTN, jinduFun);

			var window:Rectangle = new Rectangle(0, 0, sw, sh);
			//创建可视区域
			scrollRect = window;
			//创建舞台背景
			var stageMc:MovieClip = GlobalAs.skin.getMc(Skin.STAGEBG);
			stageMc.x = 0;
			stageMc.y = 0;
			addChild(stageMc);
			//创建内容mc
			contMc = new MovieClip();
			addChild(contMc);
			//创建目录
			muluMc = new MuluMc();
			addChild(muluMc);
			
			//创建工具栏
			toolMc = new ToolMc();
			addChild(toolMc);

			//设置背景音乐
			if (GlobalAs.bl(GlobalAs.configXml.ToolMc.BsoundMc.@visible)) {
				bsound = new Sound(new URLRequest("../sound/bg.mp3"));
				bsounndchl = new SoundChannel();
				GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.BSOUND,{play: GlobalAs.bl(GlobalAs.configXml.ToolMc.BsoundMc.@initsound)}));
			}
			//设置swf音量
			GlobalAs.swfVolume = GlobalAs.configXml.ToolMc.SoundMc.@volume || 0;
				
			///学习位置，每节进度，学习状态，分数，总进度
			//thisframe+"#"+suspendstr+"#"+currentstatus+"#"+myscore+"#"+currentProgress;
			var str:String = "";

			if (stage.loaderInfo.parameters.courseType)
			{
				GlobalAs.courseType = stage.loaderInfo.parameters.courseType;
				str = ScoFunction.getInfo("goInit");
				try
				{
					ExternalInterface.addCallback("rightClick", webRightClick);
					ExternalInterface.addCallback("windowClose", webClose);
				}
				catch (e:Error)
				{
				}
			}
			else {
				str = GlobalAs.configXml.@test;
			}
			var scormAr:Array = str.split('#');
			if (scormAr.length == 5) {
				GlobalAs.pIndex = GlobalAs.studyIndex = parseInt(scormAr[0]);
				var courseProAr:Array = scormAr[1].split(',');
				if (courseProAr.length == GlobalAs.courseAr.length) {
					for (var m:int = 0; m < GlobalAs.courseAr.length; m++ ) {
						GlobalAs.courseAr[m].studyTime = parseFloat(courseProAr[m]);
					}
				}
				else {
					GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.ALERT, { msg: GlobalAs.configXml.Alert.Update } ));
				}
				GlobalAs.studyState = scormAr[2];
				GlobalAs.score = parseFloat(scormAr[3]) || 0;
				GlobalAs.studyProgress = parseFloat(scormAr[4]) || 0;
				
				if (GlobalAs.bl(GlobalAs.configXml.@record)) {
					GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.LOAD_PAGE, { pIndex:GlobalAs.pIndex } ));
				}
				else {
					GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.LOAD_PAGE, { pIndex: 0 } ));
				}
				
				addEventListener(Event.ENTER_FRAME,onTime);
			}
			else {
				GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.ALERT, { msg: GlobalAs.configXml.Alert.Scorm } ));
			}
		}
		private function showAlert(e:MyEvent):void {
			addChild(new Alert(e.param.msg));
		}
		private function showMulu(e:MyEvent):void {
			TweenLite.to(muluMc, .5, { x: e.param.isIn ? 0 : -muluMc.width});
		}

		private function bsoundFun(e:MyEvent):void {
			if (e.param.play) {
				bsounndchl = bsound.play(bsoundpos, int.MAX_VALUE);
				var vlCont:SoundTransform = new SoundTransform();
				vlCont.volume = GlobalAs.configXml.ToolMc.BsoundMc.@volume || 0;
				bsounndchl.soundTransform = vlCont;
			}
			else 
			{
				bsoundpos = bsounndchl.position;
				bsounndchl.stop(); 
			}
		}
		private function jinduFun(e:MyEvent):void {
			if (GlobalAs.swf) {
				GlobalAs.swf.playState(GlobalAs.playing);
			}
		}
		
		//时间设置 
		private function onTime(e:Event):void {
			if (GlobalAs.swf) {
				var obj:Object = GlobalAs.swf.getTime();
				toolMc.setJindu(obj);
				if (toolMc.draging) {
					GlobalAs.swf.goFrame(toolMc.getBfb());
				}
				else if (GlobalAs.playing) {
					//播放中，播到最后一帧
					if (obj.cframe == obj.tframe) {
						GlobalAs.playing = false;
						GlobalAs.swf.playState(GlobalAs.playing);

						if (playStateDelay) {
							clearTimeout(playStateDelay);
							playStateDelay = 0;
						}
						playStateDelay = setTimeout(function() {
							toolMc.setPlayBtn(GlobalAs.playing);
							if (GlobalAs.pIndex < GlobalAs.courseAr.length - 1 && GlobalAs.bl(GlobalAs.courseAr[GlobalAs.pIndex].autonext)) {
								GlobalAs.pIndex ++;
								GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.LOAD_PAGE, { pIndex:GlobalAs.pIndex } ));
							}
						},200);
					}
				}
				//更新进度
				var studyTime:Number = Math.floor(obj.cframe * 10000 / obj.tframe) / 100;
				if (studyTime > GlobalAs.courseAr[GlobalAs.pIndex].studyTime) {
					GlobalAs.courseAr[GlobalAs.pIndex].studyTime = studyTime;
				}
			}
		}
		private function loadPage(e:MyEvent):void {
			var pIndex:int = e.param.pIndex;
			GlobalAs.pIndex = pIndex;
			if (GlobalAs.pIndex > GlobalAs.studyIndex) {
				GlobalAs.studyIndex = GlobalAs.pIndex;
			}
			//设置目录焦点
			muluMc.changeActive(pIndex);
			
			tempGc();
			if (GlobalAs.courseAr[GlobalAs.pIndex].filetype == "swf") {
				temp = new SwfLoader();
			}
			else {
				temp = new FlvLoader();
			}
			temp.addEventListener(Event.COMPLETE,swfLoadCom);
			temp.addEventListener(IOErrorEvent.IO_ERROR,swfLoadErr);
		}
		private function swfLoadCom(e:Event):void {
			swfGc();
			GlobalAs.swf = temp;
			temp = null;
			contMc.addChild(GlobalAs.swf);
			contMc.x = GlobalAs.bl(GlobalAs.courseAr[GlobalAs.pIndex].catalog) ? GlobalAs.configXml.@cx : 0;
			contMc.y = GlobalAs.bl(GlobalAs.courseAr[GlobalAs.pIndex].catalog) ? GlobalAs.configXml.@cy : 0;
			toolMc.stateFun();
		}
		private function swfLoadErr(e:IOErrorEvent):void {
			tempGc();
			swfGc();
			toolMc.stateFun();
			GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.ALERT,{msg:GlobalAs.configXml.Alert.Error}));
		}
		/**
		 * 未加载完成时，回收
		 */
		private function tempGc():void {
			if (temp) {
				temp.removeEventListener(Event.COMPLETE, swfLoadCom);
				temp.removeEventListener(IOErrorEvent.IO_ERROR,swfLoadErr);
				temp.myGc();
				temp = null;
			}
		}
		/**
		 * 加载完成，回收
		 */
		private function swfGc():void {
			if (GlobalAs.swf) {
				GlobalAs.swf.removeEventListener(Event.COMPLETE, swfLoadCom);
				GlobalAs.swf.removeEventListener(IOErrorEvent.IO_ERROR,swfLoadErr);
				GlobalAs.swf.myGc();
				contMc.removeChild(GlobalAs.swf);
				GlobalAs.swf = null;
			}
		}
		
		function webRightClick():void
		{
			GlobalAs.dispatcher.dispatchEvent(new MyEvent(MyEvent.ALERT,{msg:GlobalAs.configXml.Alert.Copyright}));
		}

		function webClose():void
		{
			GlobalAs.checkStudyState();
		}
	}
	
}