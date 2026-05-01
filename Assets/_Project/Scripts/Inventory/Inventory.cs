using System.Collections.Generic;
using UnityEngine;

namespace MetroEscape.Inventory
{
    public class Inventory : MonoBehaviour
    {
        public Vector2Int gridSize = new Vector2Int(8, 6);
        public List<ItemInstance> items = new();

        // TODO: bool[,] occupancy map, find-first-fit placement, rotation support
        public bool TryAdd(ItemInstance item)
        {
            // TODO: scan grid, mark occupied, append
            return false;
        }

        public bool Remove(ItemInstance item)
        {
            // TODO: clear occupancy, remove from list
            return false;
        }
    }
}
