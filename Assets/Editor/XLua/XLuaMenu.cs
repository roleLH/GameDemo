using AssetBundles;
using System;
using System.IO;
using System.IO.Compression;
using UnityEditor;
using UnityEngine;
using Debug = UnityEngine.Debug;

[InitializeOnLoad]
public static class XLuaMenu
{
    [MenuItem("XLua/Copy Lua Files To AssetsPackage", false, 51)]
    public static void CopyLuaFilesToAssetsPackage()
    {
        string destination = Path.Combine(Application.dataPath, "AssetsPackage");
        destination = Path.Combine(destination, XLuaManager.luaAssetbundleAssetName);
        string source = Path.Combine(Application.dataPath, XLuaManager.luaScriptsFolder);
        GameUtility.SafeDeleteDir(destination);

        var files = Directory.GetFiles(source, "*.lua", SearchOption.AllDirectories);

        foreach (var file in files)
        {
            // 相对路径
            var relative = file.Replace(source, "").TrimStart('\\', '/');
            var destPath = Path.Combine(destination, relative) + ".bytes";

            var dir = Path.GetDirectoryName(destPath);
            if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);

            File.Copy(file, destPath, true);
        }

        AssetDatabase.Refresh();
        Debug.Log("Copy lua files over");
    }

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

        }
        catch (Exception e)
        {
            Debug.LogError($"error");
        }
    }

}
