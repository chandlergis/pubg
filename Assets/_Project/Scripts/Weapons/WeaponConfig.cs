using UnityEngine;

namespace MetroEscape.Weapons
{
    [CreateAssetMenu(menuName = "MetroEscape/Weapon Config")]
    public class WeaponConfig : ScriptableObject
    {
        public string displayName;
        public int damagePerShot = 30;
        public float fireRateRpm = 600f;
        public int magSize = 30;
        public float reloadSeconds = 2.5f;
        public float verticalRecoil = 1.0f;
        public float horizontalRecoil = 0.5f;
        public float effectiveRangeMeters = 50f;

        // TODO: ammo type ref, attachment slots, audio refs, muzzle flash prefab
    }
}
