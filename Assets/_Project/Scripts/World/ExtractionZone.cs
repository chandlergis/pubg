using UnityEngine;

namespace MetroEscape.World
{
    [RequireComponent(typeof(Collider))]
    public class ExtractionZone : MonoBehaviour
    {
        public string zoneId = "north_exit";
        public float dwellSeconds = 10f;
        public bool requiresKey;
        public string requiredKeyId;

        // TODO: track player presence, drive countdown UI, on complete -> GameManager.CompleteRaid(true)
        private void OnTriggerEnter(Collider other) { /* TODO */ }
        private void OnTriggerExit(Collider other) { /* TODO */ }
    }
}
