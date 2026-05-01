using UnityEngine;
using UnityEngine.AI;

namespace MetroEscape.AI
{
    public enum AIState { Patrol, Suspect, Combat, Search, Dead }
    public enum AIArchetype { Scav, Elite, Boss }

    [RequireComponent(typeof(NavMeshAgent))]
    public class AIController : MonoBehaviour
    {
        public AIArchetype archetype = AIArchetype.Scav;
        public AIState State { get; private set; } = AIState.Patrol;

        public float visionRangeMeters = 30f;
        public float visionConeDegrees = 90f;

        // TODO: vision cone test, hearing event subscription, target memory, weapon component
        private void Update()
        {
            // TODO: state machine tick (Patrol -> Suspect -> Combat -> Search -> Dead)
        }

        public void OnHeardSound(Vector3 source, float intensity)
        {
            // TODO: bump to Suspect, walk toward source
        }

        public void OnSpottedTarget(Transform target)
        {
            // TODO: switch to Combat, request weapon fire
        }
    }
}
