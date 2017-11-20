package cn.yingzaiqidian.scorm 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * ...
	 * @author by cC Email:oC_Co@qq.com
	 */
	public class XmlLoader extends EventDispatcher
	{
		private var callback:Function = null;
		private var profun:Function = null;
		
		public function XmlLoader(_url:String,_callback:Function=null,_profun:Function=null) 
		{
			callback = _callback;
			profun = _profun;
			
			var loader:URLLoader = new URLLoader();
            configureListeners(loader);
			
            var request:URLRequest = new URLRequest(_url);
            loader.load(request);
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
		private function removeListeners(dispatcher:IEventDispatcher):void {
            dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
            dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
			removeListeners(loader);
			var obj = { };
			obj.code = 100;
			obj.msg = "";
			obj.xml = XML(loader.data);
			callback && callback(obj);
        }

        private function progressHandler(event:ProgressEvent):void {
			var bfb:Number = event.bytesLoaded * 100 / event.bytesTotal;
			profun && profun(bfb);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
			var loader:URLLoader = URLLoader(event.target);
			removeListeners(loader);
			var obj = { };
			obj.code = -1;
			obj.msg = event.text;
			obj.xml = null;
			callback && callback(obj);
        }
		
	}

}