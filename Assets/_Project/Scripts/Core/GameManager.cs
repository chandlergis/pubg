using UnityEngine;

namespace MetroEscape.Core
{
    public class GameManager : MonoBehaviour
    {
        public static GameManager Instance { get; private set; }
        public GameState State { get; private set; } = GameState.Lobby;

        private void Awake()
        {
            if (Instance != null && Instance != this) { Destroy(gameObject); return; }
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }

        public void EnterRaid()
        {
            // TODO: snapshot loadout, load Raid scene, transition to LoadingRaid -> InRaid
        }

        public void CompleteRaid(bool extracted)
        {
            // TODO: if extracted -> merge raid inventory into stash; else -> drop everything
            // TODO: persist via SaveSystem.Save
            TransitionTo(GameState.RaidResult);
        }

        public void TransitionTo(GameState next)
        {
            State = next;
            // TODO: emit OnStateChanged event for UI/audio listeners
        }
    }
}
