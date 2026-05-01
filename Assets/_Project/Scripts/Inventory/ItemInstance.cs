namespace MetroEscape.Inventory
{
    [System.Serializable]
    public class ItemInstance
    {
        public ItemConfig config;
        public int stackCount = 1;
        // TODO: durability, attachments (for weapons), per-instance state
    }
}
