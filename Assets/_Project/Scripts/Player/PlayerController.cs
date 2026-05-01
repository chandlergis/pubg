using UnityEngine;

namespace MetroEscape.Player
{
    [RequireComponent(typeof(CharacterController))]
    public class PlayerController : MonoBehaviour
    {
        [Header("Movement")]
        public float walkSpeed = 4f;
        public float sprintSpeed = 7f;
        public float crouchSpeed = 2f;
        public float lookSensitivity = 2f;

        // TODO: wire Unity Input System (move, look, sprint, crouch, jump)
        // TODO: ground check, gravity, stamina drain on sprint
        private void Update()
        {
            // TODO: move + look per frame
        }
    }
}
