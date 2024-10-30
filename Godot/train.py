from godot_rl.wrappers.clean_rl_wrapper import CleanRLGodotEnv



ENV_PATH = ""
SHOW_WINDOW = False
SPEEDUP = 10
N_PARALLEL = 5

MAX_EPISODES = 1e10
MAX_STEPS_IN_EPISODE = 1000



envs = env = CleanRLGodotEnv(env_path=ENV_PATH, show_window=SHOW_WINDOW, speedup=SPEEDUP = 10, n_parallel=N_PARALLEL)
print(envs)#Hay que ver que hace exactamente esto


for i in range(MAX_EPISODES):
    steps = 0
    states = []
    actions = []
    rewards = []
    current_state, _ = envs.reset()#revisar que es current state, que tipo es
    actual_in_control = [True, True, True]
    previous_in_control = True#HAY QUE VER CMO HACER ESTO; VA A SER UN CAOS
    #Quitar in_control de la observacion
    while steps < MAX_STEPS_IN_EPISODE:
        if current_state[-1]