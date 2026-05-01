using UnityEngine;

namespace MetroEscape.Inventory
{
    public enum Rarity { White, Green, Blue, Purple, Gold }
    public enum ItemType { Weapon, Ammo, Armor, Medical, Junk, Key }

    [CreateAssetMenu(menuName = "MetroEscape/Item Config")]
    public class ItemConfig : ScriptableObject
    {
        public string displayName;
        public Vector2Int gridSize = new Vector2Int(1, 1);
        public Rarity rarity = Rarity.White;
        public int sellPrice = 100;
        public ItemType type = ItemType.Junk;
        public Sprite icon;
        public GameObject worldPrefab;
    }
}
