package cn.yingzaiqidian.scorm
{
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.net.navigateToURL;
	
	/**
	 * ...
	 * @author cC Email:oC_Co@qq.com
	 */
	public class CopyRigth extends Object 
	{
		private var Ar = [ 
		{ 内容:"作者: 陈承(K)" , 链接:"" ,线条:false,编辑:false},
		{ 内容:"资深Web前端" , 链接:"http://www.yingzaiqidian.cn",线条:false,编辑:true },
		{ 内容:"熟悉vue,angular,响应式网站,移动端适配" , 链接:"http://www.yingzaiqidian.cn" ,线条:false,编辑:true},
		{ 内容:"QQ: 89257501 手机：15900760815" , 链接:"" ,线条:false,编辑:false},
		{ 内容:"Email: oC_Co@qq.com" , 链接:"" ,线条:false,编辑:false}
		];
		public function CopyRigth(_root:Object)
		{
			var _myMenu:ContextMenu = new ContextMenu;
			_myMenu.hideBuiltInItems();  
			for (var i:int = 0; i < Ar.length;i++ )
			{
				var customMenu:ContextMenuItem = new ContextMenuItem(Ar[i]["内容"],Ar[i]["线条"],Ar[i]["编辑"])  
				customMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuHandler);  
				_myMenu.customItems.push(customMenu);  
            }  
			_root.contextMenu = _myMenu;  
		}
		private function menuHandler(e:ContextMenuEvent)
		{
			for (var i:int = 0; i < Ar.length;i++ )
			{
				if (Ar[i]["内容"] == e.currentTarget.caption)
				{
					if (Ar[i]["链接"] != "")
					{
						navigateToURL(new URLRequest(Ar[i]["链接"]), "_blank");
					}
					break;
				}
			}
		}
	}
	
}