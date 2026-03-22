using AssetBundles;
using System;
using System.IO;
using System.IO.Compression;
using UnityEditor;
using UnityEngine;
using Debug = UnityEngine.Debug;

[InitializeOnLoad]
public class XLuaMenu
{
        [MenuItem("XLua/Zip Lua Scripts", false, 52)]
    public static void ZipLuaScripts()
    {
        string source = Path.Combine(Application.dataPath, XLuaManager.luaScriptsFolder);
        string destination = Path.Combine(Application.dataPath, "AssetsPackage");
        destination = Path.Combine(destination, XLuaManager.luaAssetbundleAssetName);

        try
        {
            if (File.Exists(destination))
                File.Delete(destination);

            using (FileStream fs = new FileStream(destination, FileMode.Create))
            using (ZipArchive archive = new ZipArchive(fs, ZipArchiveMode.Create))
            {
                // 遍历所有文件
                foreach (string file in Directory.EnumerateFiles(source, "*.*", SearchOption.AllDirectories))
                {
                    if (file.EndsWith(".meta") || file.EndsWith("txt") || file.EndsWith(".json"))
                        continue;

                    // 相对路径（保持目录结构）
                    string relativePath = file.Substring(source.Length + 1);
                    ZipArchiveEntry entry = archive.CreateEntry(relativePath, System.IO.Compression.CompressionLevel.Optimal);

                    // 写入文件内容
                    using (Stream entryStream = entry.Open())
                    using (FileStream fileStream = new FileStream(file, FileMode.Open))
                    {
                        fileStream.CopyTo(entryStream);
                    }
                }
            }
            Debug.Log("Zip Lua files success...");
        }
        catch (Exception e)
        {
            Debug.LogError($"error");
        }
    }

}
