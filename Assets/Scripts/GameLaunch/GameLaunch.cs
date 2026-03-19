using UnityEngine;
using System.Collections;
using AssetBundles;
using GameChannel;
using System;
using XLua;
using UnityEngine.AddressableAssets;

[Hotfix]
[LuaCallCSharp]
public class GameLaunch : MonoBehaviour
{
    const string launchPrefabPath = "UI/Prefabs/View/UILaunch.prefab";
    GameObject launchPrefab;
    GameObject launchInst;

    IEnumerator Start ()
    {
        Logger.Log(string.Format("START"));
        LoggerHelper.Instance.Startup();
        // 初始化App版本
        // 初始化渠道
        
        // 启动资源管理模块
       var start = DateTime.Now;
        yield return AssetBundleManager.Instance.Initialize();
        yield return AssetBundleManager.Instance.PreLoadAllLuaScripts();
        Logger.Log(string.Format("AssetBundleManager Initialize use {0}ms", (DateTime.Now - start).Milliseconds));

        // 启动xlua热修复模块
        start = DateTime.Now;
        XLuaManager.Instance.Startup();
        string luaAssetbundleName = XLuaManager.Instance.AssetbundleName;
        AssetBundleManager.Instance.SetAssetBundleResident(luaAssetbundleName, true);

        XLuaManager.Instance.OnInit();
        //XLuaManager.Instance.StartHotfix();
        Logger.Log(string.Format("XLuaManager StartHotfix use {0}ms", (DateTime.Now - start).Milliseconds));

        // 初始化UI界面
        yield return InitLaunchPrefab();

        XLuaManager.Instance.StartGame();
        CustomDataStruct.Helper.Startup();
        UINoticeTip.Instance.DestroySelf();
        launchInst.SetActive(false);
        GameObject.Destroy(launchInst);
        yield break;
	}

    IEnumerator InitAppVersion()
    {
        var streamingAppVersion = "1.0.0";
        ChannelManager.instance.appVersion = streamingAppVersion;
        yield break;
    }

    IEnumerator InitChannel()
    {

        yield break;
    }

    GameObject InstantiateGameObject(GameObject prefab)
    {
        var start = DateTime.Now;
        GameObject go = GameObject.Instantiate(prefab);
        Logger.Log(string.Format("Instantiate use {0}ms", (DateTime.Now - start).Milliseconds));

        var luanchLayer = GameObject.Find("UIRoot/LuanchLayer");
        go.transform.SetParent(luanchLayer.transform);
        var rectTransform = go.GetComponent<RectTransform>();
        rectTransform.offsetMax = Vector2.zero;
        rectTransform.offsetMin = Vector2.zero;
        rectTransform.localScale = Vector3.one;
        rectTransform.localPosition = Vector3.zero;

        return go;
    }

    IEnumerator InitNoticeTipPrefab()
    {
        yield break;
    }

    IEnumerator InitLaunchPrefab()
    {
        var start = DateTime.Now;
        var handle = Addressables.LoadAssetAsync<GameObject>(launchPrefabPath);
        yield return handle;

        launchPrefab= handle.Result;
        handle.Release();
        if (launchPrefab == null)
        {
            Logger.LogError("LoadAssetAsync launchPrefab err : " + launchPrefabPath);
            yield break;
        }
        launchInst = InstantiateGameObject(launchPrefab);
        yield break;
    }
}
