using UnityEngine;

namespace MetroEscape.Weapons
{
    public class Weapon : MonoBehaviour
    {
        public WeaponConfig config;
        public int currentAmmo;

        public void Fire()
        {
            // TODO: cooldown gate, raycast from camera, apply damage to IDamageable, recoil pattern, muzzle FX
        }

        public void Reload()
        {
            // TODO: animate, consume ammo from inventory, restore currentAmmo
        }
    }
}
