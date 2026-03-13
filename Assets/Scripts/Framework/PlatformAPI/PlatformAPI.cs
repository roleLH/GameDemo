using System.Runtime.InteropServices;
using UnityEngine;
using XLua;

// bridge内的函数名需要和这里声明出来的保持一致
[LuaCallCSharp]
public class PlatformAPI
{
    [DllImport("__Internal")]
    private static extern void WX_SharePYQ();

    // Lua 调用入口
    public static void Share(string title, string desc, string img)
    {
#if UNITY_WEBGL && !UNITY_EDITOR
        WX_SharePYQ();   // 调用微信小游戏 JSBridge
#elif UNITY_ANDROID
        AndroidShare(title, desc, img);     // 调用安卓 SDK
#elif UNITY_IOS
        iOSShare(title, desc, img);         // 调用 iOS SDK
#else
        Logger.Log("调用微信分享接口");
#endif
    }

#if UNITY_WEBGL && !UNITY_EDITOR
    [DllImport("__Internal")]
    private static extern void WX_Share(string title, string desc, string img);

    static class WXBridge
    {
        public static void Share(string title, string desc, string img)
        {
            WX_Share(title, desc, img);
        }
    }
#endif

#if UNITY_ANDROID
    static void AndroidShare(string title, string desc, string img)
    {
        using (AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
        {
            AndroidJavaObject activity = jc.GetStatic<AndroidJavaObject>("currentActivity");
            using (AndroidJavaClass plugin = new AndroidJavaClass("com.example.MySharePlugin"))
            {
                plugin.CallStatic("share", activity, title, desc, img);
            }
        }
    }
#endif

#if UNITY_IOS
    [DllImport("__Internal")]
    static extern void iOSShare(string title, string desc, string img);
#endif
}