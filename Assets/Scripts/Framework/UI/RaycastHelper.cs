using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using XLua;

[LuaCallCSharp]
public static class RaycastHelper
{
    /// <summary>
    /// 获取当前鼠标点击下的所有UI对象（从最上层到最下层）
    /// </summary>
    /// <param name="raycaster">UI Canvas 的 GraphicRaycaster</param>
    /// <returns>RaycastResult 列表</returns>
    public static List<RaycastResult> GetMouseUIRaycastResults(GraphicRaycaster raycaster)
    {
        if (EventSystem.current == null || raycaster == null)
        {
            Debug.LogWarning("EventSystem 或 GraphicRaycaster 不存在！");
            return new List<RaycastResult>();
        }

        // 检测鼠标位置下的UI对象
        PointerEventData pointerData = new PointerEventData(EventSystem.current);
        pointerData.position = Input.mousePosition;
        List<RaycastResult> results = new List<RaycastResult>();
        raycaster.Raycast(pointerData, results);

        // //检测EventSystem的RaycastAll结果
        //List<RaycastResult> results = new List<RaycastResult>();
        //EventSystem.current.RaycastAll(pointerData, results);

        //Debug.Log("Raycaster GameObject: " + raycaster.gameObject.name);
        //Debug.Log("Raycaster Canvas: " + raycaster.GetComponent<Canvas>());
        //Debug.Log("Raycaster enabled: " + raycaster.enabled);

        //foreach (var r in results)
        //{
        //    Debug.Log("Hit: " + r.gameObject.name);
        //}
        //Debug.Log("---------------------------------");

        foreach (var r in results)
        {
            Debug.Log("Hit2: " + r.gameObject.name);
        }
        return results;
    }
    public static GameObject GetMouseUIRaycastResults2()
    {
        PointerEventData pointerData = new PointerEventData(EventSystem.current);
        pointerData.position = Input.mousePosition;

        List<RaycastResult> results = new List<RaycastResult>();
        EventSystem.current.RaycastAll(pointerData, results);

        if (results.Count > 0)
            return results[0].gameObject;

        return null;
    }
}