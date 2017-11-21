package cn.yingzaiqidian.scorm 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author by cC Email:oC_Co@qq.com
	 */
	public class SkinLoader extends EventDispatcher
	{
		private var callback:Function = null;
		private var profun:Function = null;
		private var loader:Loader = null;
		public function SkinLoader(_url:String,_callback:Function=null,_profun:Function=null) 
		{
			callback = _callback;
			profun = _profun;
			
			var context:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain);
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			loader = new Loader();
            configureListeners(loader.contentLoaderInfo);
            var request:URLRequest = new URLRequest(_url);
            loader.load(request,context);
		}
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        }
		private function removeListeners(dispatcher:IEventDispatcher):void {
            dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
            dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
        }
		private function completeHandler(event:Event):void {
			removeListeners(loader.contentLoaderInfo);
            var obj = { };
			obj.code = 101;
			obj.msg = "";
			callback && callback(obj);
        }
       
        private function ioErrorHandler(event:IOErrorEvent):void {
			removeListeners(loader.contentLoaderInfo);
            var obj = { };
			obj.code = -1;
			obj.msg = event.text;
			callback && callback(obj);
        }

        private function progressHandler(event:ProgressEvent):void {
            var bfb:Number = event.bytesLoaded * 100 / event.bytesTotal;
			profun && profun(bfb);
        }
		
		private function getClass(className:String):Class
		{
			var objClass:Class = null;
			if(loader.contentLoaderInfo.applicationDomain.hasDefinition(className))  
			{  
				objClass = loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
			}  
			else  
			{
				objClass = null;  
			}  
			return objClass;  
		}
		public function getMc(classname:String):MovieClip {
			var objClass:Class = getClass(classname);
			var mc:MovieClip;
			if (objClass) {
				mc = new objClass();
			}
			else {
				
				mc = new MovieClip();
				var txt:TextField = new TextField();
				txt.text = classname;
				txt.textColor=0xff0000;
				mc.addChild(txt);
			}
			return mc;
		}
	}

}