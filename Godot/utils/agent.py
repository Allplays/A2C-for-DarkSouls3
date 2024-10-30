import importlib
import numpy as np
import pandas as pd

class Agent():
    def __init__(
            self,
            actor,
            critic,
            minibatch_size,
            epochs,
    ):
        self.actor = actor
        self.critic = critic
        self.minibatch_size = minibatch_size
        self.epochs = epochs

    def forward(self, state):
        return self.actor.predict(state)
    
    def value(self, state):
        return self.critic.predict(state)
    
    def learn(self, critic_dataset, actor_dataset):
        self.critic.fit(critic_dataset, batch_size = self.minibatch_size, epochs = self.epochs)
        self.actor.fit(actor_dataset, batch_size = self.minibatch_size, epochs = self.epochs)
    