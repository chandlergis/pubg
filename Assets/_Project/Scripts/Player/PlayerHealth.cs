using UnityEngine;

namespace MetroEscape.Player
{
    public enum BodyPart { Head, Chest, Limb }

    public class PlayerHealth : MonoBehaviour
    {
        public int maxHp = 100;
        public int Hp { get; private set; }

        private void Awake() { Hp = maxHp; }

        public void TakeDamage(int amount, BodyPart part)
        {
            // TODO: apply armor mitigation by hit part, headshot multiplier, death handling
        }

        public void Heal(int amount)
        {
            // TODO: clamp, play VFX
        }
    }
}
