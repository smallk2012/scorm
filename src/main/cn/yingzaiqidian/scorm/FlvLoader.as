package cn.yingzaiqidian.scorm 
{
	import flash.display.Shape;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * ...
	 * @author by cC Email:oC_Co@qq.com
	 */
	public class FlvLoader extends McLoader
	{
		private var nc:NetConnection;
        public var ns:NetStream;
        private var client:Object;
		private var vid:Video;
		
		private var cframe:Number = 0;
		private var tframe:Number = 1;
		
		public function FlvLoader() 
		{
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRect(0, 0, GlobalAs.configXml.@sw , GlobalAs.configXml.@sh);
			bg.graphics.endFill();
			addChildAt(bg, 0);
			
			var url:String = "../flv/" + GlobalAs.courseAr[GlobalAs.pIndex].href + "." + GlobalAs.courseAr[GlobalAs.pIndex].filetype;
			nc = new NetConnection();
            nc.connect(null);
            ns = new NetStream(nc);
            client = new Object();
            client.onMetaData = onMetaData;
           
			ns.client = client;
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			ns.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
            vid = new Video();
            addChild(vid);
            vid.attachNetStream(ns);
            vid.smoothing = true;
			ns.play(url);
		}

		private function onMetaData(obj:Object):void
		{
			var sx:Number = 1;
			var sw:Number = GlobalAs.configXml.@sw;
			var sh:Number = GlobalAs.configXml.@sh;
			
            if ((obj.width / obj.height) > (sw / sh)){
                sx = sw / obj.width;
            } else {
                sx = sh / obj.height;
            };
            vid.width = (obj.width * sx);
            vid.height = (obj.height * sx);
			
            vid.x = (sw - vid.width) / 2;
            vid.y = (sh - vid.height) / 2;
			cframe = 0;
			tframe = obj.duration;
		}
		private function asyncErrorHandler(e:AsyncErrorEvent):void
		{
			trace("??");
		}

		private function statusHandler(e:NetStatusEvent):void
		{
			GlobalAs.log(e.info.code);
			switch (e.info.code) {
                case "NetStream.Play.Start":
					GlobalAs.log("视频开始播放");
                    dispatchEvent(new Event(Event.COMPLETE));
                    break;
				case "NetStream.Play.Stop":
                    GlobalAs.log("视频播放结束" + ns.time + ":" + tframe);
                    break;
                case "NetStream.Play.StreamNotFound":
                    dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
                    break;
            }
		}
		public override function setVolume():void
		{
			var st:SoundTransform = this.soundTransform;
			st.volume = GlobalAs.swfVolume;
			ns.soundTransform = st;
		}
		public override function getTime():Object {
			cframe = ns.time;
			var obj:Object = { };
			obj.bfb = ns.time / tframe;
			//视频播放时间与总时间差距不能超过0.5,否则转换有问题
			obj.cframe = cframe + 0.5 > Math.floor(tframe) ? Math.floor(tframe) : Math.floor(cframe);
			obj.tframe = Math.floor(tframe);
			return obj;
		}
		public override function goFrame(bfb:Number):void {
			ns.seek(tframe * bfb);
		}
		public override function playState(bl:Boolean):void {
			if (bl)
			{
				ns.resume();
			}
			else
			{
				ns.pause();
			}	
		}
		public override function myGc():void {
			vid.clear();
			ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			ns.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
			nc.close();
			ns.close();
			nc = null;
			ns = null;
		}
	}

}