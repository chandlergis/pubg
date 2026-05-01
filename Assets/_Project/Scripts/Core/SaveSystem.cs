using System.IO;
using UnityEngine;

namespace MetroEscape.Core
{
    public static class SaveSystem
    {
        private static string SavePath =>
            Path.Combine(Application.persistentDataPath, "save.json");

        public static void Save(SaveData data)
        {
            File.WriteAllText(SavePath, JsonUtility.ToJson(data));
        }

        public static SaveData Load()
        {
            if (!File.Exists(SavePath)) return new SaveData();
            return JsonUtility.FromJson<SaveData>(File.ReadAllText(SavePath));
        }
    }

    [System.Serializable]
    public class SaveData
    {
        public int gold;
        // TODO: stash item list, owned key ids, run statistics
    }
}
