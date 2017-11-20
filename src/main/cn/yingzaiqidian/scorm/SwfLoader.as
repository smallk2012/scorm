package cn.yingzaiqidian.scorm 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author by cC Email:oC_Co@qq.com
	 */
	public class SwfLoader extends McLoader
	{
		private var loader:Loader = null; 
		private var swf:MovieClip = null;
		
		public function SwfLoader() 
		{
			var url:String = "../swf/" + GlobalAs.courseAr[GlobalAs.pIndex].href + ".swf";
			loader = new Loader();
            configureListeners(loader.contentLoaderInfo);
            var request:URLRequest = new URLRequest(url);
            loader.load(request);
		}

		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.INIT, initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        }
		private function removeListeners(dispatcher:IEventDispatcher):void {
            dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
            dispatcher.removeEventListener(Event.INIT, initHandler);
            dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
        }
        private function completeHandler(e:Event):void {
			swf.play();
			addChild(swf);
			setVolume();
			dispatchEvent(new Event(Event.COMPLETE));
        }

        private function initHandler(e:Event):void {
			//读取的swf初始化必须stop();否则会播放
			swf = e.target.content as MovieClip;
            swf.stop();
        }

        private function ioErrorHandler(e:IOErrorEvent):void {
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
        }

        private function progressHandler(e:ProgressEvent):void {
            var bfb:Number = e.bytesLoaded * 100 / e.bytesTotal;
        }
		public override function setVolume():void
		{
			var st:SoundTransform = this.soundTransform;
			st.volume = GlobalAs.swfVolume;
			this.soundTransform = st;
		}
		public override function getTime():Object {
			var obj:Object = { };
			obj.bfb = Math.floor(swf.currentFrame * 10000 / swf.totalFrames) / 10000;
			obj.cframe = swf.currentFrame / stage.frameRate;
			obj.tframe = swf.totalFrames / stage.frameRate;
			return obj;
		}
		public override function goFrame(bfb:Number):void {
			swf.gotoAndStop(Math.floor(swf.totalFrames * bfb));
		}
		public override function playState(bl:Boolean):void {
			trace(swf.currentFrame , swf.totalFrames);
			if (bl) {
				if (swf.currentFrame == swf.totalFrames) {
					swf.stop();
				}
				else {
					swf.play();
				}
			}
			else {
				swf.stop();
			}
		}
		public override function myGc():void {
			removeListeners(loader);
			loader.unload();
			loader = null;
			if (swf) {
				swf.stop();
				removeChild(swf);
				swf = null;
			}
			
		}
	}

}