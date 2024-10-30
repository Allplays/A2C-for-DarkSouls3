import numpy as np
import pandas as pd

from agent import Agent

def a2c(states, actions, rewards, agent: Agent, learning_rate = 0.05):
    y = np.array([])
    X = np.array([])
    for memory in range(len(states)):
        for i in range(len(actions[memory])):
            y = np.concatenate(y, actions[memory,:] + learning_rate*(rewards[memory,i] + agent.value(states[memory,i+1]) - agent.value(states[memory,i])))
        X = np.concatenate(X, states[memory,:-1,:])
    return pd.DataFrame({"x":X, "y":y})

def ppo(states, actions, rewards, agent:Agent, epsilon = 0.1):
    y = []
    X = []
    for memory in range(len(states)):
        for i in range(len(actions[memory])):
            advantages = rewards[memory] + agent.value(states[memory,i+1]) - agent.value(states[memory,i])
            ratios = (actions[memory, i] + advantages)/(a2c(states, actions, rewards, agent, learning_rate=0.2) + 1e-10)
            y.append(np.min(ratios*advantages, np.clip(ratios*advantages, 1-epsilon, 1+epsilon)*advantages))
        X.append(states[memory, :-1,:])
    return pd.DataFrame({"X": X, "y":y})
    

#HAY QUE REVISAR QUE ESTO TENGA SENTIDO Y QUE FUNCIONA