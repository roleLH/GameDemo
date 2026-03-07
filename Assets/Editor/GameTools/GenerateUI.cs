using System.Diagnostics;
using System.IO;
using UnityEditor;
using UnityEngine;

public class RunBatTool
{
    [MenuItem("Tools/GenerateUI")]
    static void RunBat()
    {
        // Assets 的父目录就是项目根
        string projectRoot = Directory.GetParent(Application.dataPath).FullName;

        // 拼接 Tools 目录下的 bat
        string batPath = Path.Combine(projectRoot, "Tools", "generate_ui.bat");

        ProcessStartInfo startInfo = new ProcessStartInfo();
        startInfo.FileName = "cmd.exe";
        startInfo.Arguments = "/c \"" + batPath + "\""; // /c 执行完关闭
        startInfo.UseShellExecute = true; // 使用系统 shell 执行

        Process.Start(startInfo);
    }
}