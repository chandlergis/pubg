using System.Collections.Generic;
using UnityEngine;
using MetroEscape.Inventory;

namespace MetroEscape.World
{
    public class LootSpawner : MonoBehaviour
    {
        [System.Serializable]
        public class LootEntry
        {
            public ItemConfig item;
            public float weight = 1f;
        }

        public List<LootEntry> table = new();
        public int rollCount = 3;
        public Transform[] spawnPoints;

        // TODO: weighted roll on raid start, instantiate worldPrefab at spawn points
        public void SpawnLoot()
        {
            // TODO
        }
    }
}
