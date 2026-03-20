using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using XLua;
using System;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine.ResourceManagement.ResourceLocations;
using System.IO.Compression;
using System.IO;
using System.Security.Cryptography;
using UnityEngine.ResourceManagement.ResourceProviders;







#if UNITY_EDITOR
using UnityEditor;
#endif

/// <summary>
/// added by wsh @ 2017-12-21
/// 功能：assetbundle管理类，为外部提供统一的资源加载界面、协调Assetbundle各个子系统的运行
/// 注意：
/// 1、抛弃Resources目录的使用，官方建议：https://unity3d.com/cn/learn/tutorials/temas/best-practices/resources-folder?playlist=30089
/// 2、提供Editor和Simulate模式，前者不适用Assetbundle，直接加载资源，快速开发；后者使用Assetbundle，用本地服务器模拟资源更新
/// 3、场景不进行打包，场景资源打包为预设
/// 4、只提供异步接口，所有加载按异步进行
/// 5、采用LZMA压缩方式，性能瓶颈在Assetbundle加载上，ab加载异步，asset加载同步，ab加载后导出全部asset并卸载ab
/// 6、所有公共ab包（被多个ab包依赖）常驻内存，非公共包加载asset以后立刻卸载，被依赖的公共ab包会随着资源预加载自动加载并常驻内存
/// 7、随意卸载公共ab包可能导致内存资源重复，最好在切换场景时再手动清理不需要的公共ab包
/// 8、常驻包（公共ab包）引用计数不为0时手动清理无效，正在等待加载的所有ab包不能强行终止---一旦发起创建就一定要等操作结束，异步过程进行中清理无效
/// 9、切换场景时最好预加载所有可能使用到的资源，所有加载器用完以后记得Dispose回收，清理GC时注意先释放所有Asset缓存
/// 10、逻辑层所有Asset路径带文件类型后缀，且是AssetBundleConfig.ResourcesFolderName下的相对路径，注意：路径区分大小写
/// TODO：
/// 1、区分场景常驻包和全局公共包，切换场景时自动卸载场景公共包
/// 使用说明：
/// 1、由Asset路径获取AssetName、AssetBundleName：ParseAssetPathToNames
/// 2、设置常驻(公共)ab包：SetAssetBundleResident(assebundleName, true)---公共ab包已经自动设置常驻
/// 2、(预)加载资源：var loader = LoadAssetBundleAsync(assetbundleName)，协程等待加载完毕后Dispose：loader.Dispose()
/// 3、加载Asset资源：var loader = LoadAssetAsync(assetPath, TextAsset)，协程等待加载完毕后Dispose：loader.Dispose()
/// 4、离开场景清理所有Asset缓存：ClearAssetsCache()，UnloadUnusedAssetBundles(), Resources.UnloadUnusedAssets()
/// 5、离开场景清理必要的(公共)ab包：TryUnloadAssetBundle()，注意：这里只是尝试卸载，所有引用计数不为0的包（还正在加载）不会被清理
/// </summary>

namespace AssetBundles
{
    [Hotfix]
    [LuaCallCSharp]
    public class AssetBundleManager : MonoSingleton<AssetBundleManager>
    {
        public Dictionary<string, byte[]> scripts = new Dictionary<string, byte[]>();

        public IEnumerator Initialize()
        {
            yield break;
        }

        public IEnumerator Cleanup()
        {
            yield break;
        }

        public string DownloadUrl
        {
            get
            {
                return URLSetting.SERVER_RESOURCE_URL;
            }
        }



        public void SetAssetBundleResident(string assetbundleName, bool resident)
        {

        }



        public void AddAssetbundleAssetsCache(string assetbundleName, string postfix = null)
        {
        }
        



        public void LoadAssetAsync(string assetPath, System.Type type, Action<AsyncOperationHandle> luaOnAssetLoaded)
        {
            if (type == typeof(GameObject))
            {
                AsyncOperationHandle handle = Addressables.LoadAssetAsync<GameObject>(assetPath);
                handle.Completed += (op) =>
                {
                    System.Object o = op.Result as System.Object;
                    luaOnAssetLoaded(op);
                };
            }
            else if (type == typeof(Sprite))
            {
                AsyncOperationHandle handle = Addressables.LoadAssetAsync<Sprite>(assetPath);
                handle.Completed += (op) =>
                {
                    luaOnAssetLoaded(op);
                };
            }
            else
            {
                luaOnAssetLoaded(default);
            }
        }

        public byte[] LoadLuaScript(string scriptPath)
        {
            byte[] bytes = null;
            scripts.TryGetValue(scriptPath, out bytes);
            return bytes;
        }

        public IEnumerator PreLoadAllLuaScripts()
        {
            var handle = Addressables.LoadAssetAsync<TextAsset>(XLuaManager.luaAssetbundleAssetName);
            yield return handle;
            byte[] zipFile = handle.Result.bytes;
            using (MemoryStream zipStream = new MemoryStream(zipFile))
            using (ZipArchive archive = new ZipArchive(zipStream, ZipArchiveMode.Read))
            {
                foreach (ZipArchiveEntry entry in archive.Entries)
                {
                    if (string.IsNullOrEmpty(entry.Name)) continue;

                    using (MemoryStream ms = new MemoryStream())
                    using (Stream entryStream = entry.Open())
                    {
                        entryStream.CopyTo(ms);
                        scripts[entry.FullName] = ms.ToArray();
                    }
                }
            }

            //LoadSceneAsync("BattleScene");
        }

        public void UnloadAsset(AsyncOperationHandle handle)
        {
            Addressables.Release(handle);
        }

        public void LoadSceneAsync(string sceneId)
        {
            Debug.Log("load..." + sceneId);
            var handle = Addressables.LoadSceneAsync(sceneId, UnityEngine.SceneManagement.LoadSceneMode.Single, true);
            handle.Completed += (op) => {
                var scene = op.Result;
                //scene.ActivateAsync();
            };
        }

        public AsyncOperationHandle LoadSceneAsyncWithHandle(string sceneId)
        {
           var handle = Addressables.LoadSceneAsync(sceneId, UnityEngine.SceneManagement.LoadSceneMode.Single, true);
            handle.Completed += (op) => {
                Debug.Log(op.IsDone);
            };
            return handle;
        }

        public void LoadSceneWithCallback(string sceneId, Action<SceneInstance> action)
        {
            var handle = Addressables.LoadSceneAsync(sceneId, UnityEngine.SceneManagement.LoadSceneMode.Single, true);
            handle.Completed += (op) => {
                var scene = op.Result;
                action.Invoke(scene);
            };
        }

        void Update()
        {
        }

    }
}