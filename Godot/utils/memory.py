from typing import Any, Callable, List, NamedTuple, Sequence, SupportsFloat, Union
from collections import deque


class Transition(NamedTuple):
    """Representa la transición de un estado al siguiente"""
    prev_state: Any       # Estado origen de la transición
    next_state: Any       # Estado destino de la transición
    action: Any           # Acción que provocó esta transición
    reward: SupportsFloat # Recompensa obtenida
    terminated: bool      # Si se ha llegado a un estado terminal

class Memory:
    """Representa la memoria de un agente.

    Concretamente, almacenará las últimas n transiciones realizadas en
    el entorno. El tamaño de la memoria se establecerá en el momento de
    crear la memoria del mismo.

    La memoria guarda las transiciones de manera ordenada, y se podrá
    acceder a ellos por índice, de manera que el recuerdo más lejano
    estará en la posición 0 y el más reciente en la posición -1.
    """

    def __init__(self, size: int):
        """Inicializa el objeto.

        :param size: El tamaño máximo de la memoria del agente."""
        self.max_size = int(size)
        self.transitions: deque = deque(maxlen=self.max_size)

    def remember(self, transition: Transition):
        """Añade un nuevo recuerdo a la memoria del agente.

        :param transition: La transición a recordar."""
        self.transitions.append(transition)

    def batch(self, n: int) -> List[Transition]:
        """Devuelve n recuerdos aleatorios de la memoria.

        :param n: El número de recuerdos aleatorios a devolver. Si es
            superior al número de recuerdos totales devolverá todos los
            recuerdos almacenados.
        :returns: La lista de transiciones.
        """
        n = min(len(self.transitions), n)
        return random.sample(self.transitions, n)

    def __len__(self) -> int:
        """El número de recuerdos que contiene esta memoria.

        :returns: Un entero mayor o igual a 0.
        """
        return len(self.transitions)

    def __getitem__(
            self,
            key: Union[int, slice]
    ) -> Union[Transition, Sequence[Transition]]:
        """Devuelve el/los elemento/s especificados.

        :param key: El argumento que indica los elementos. Puede ser un
            entero normal o un slice.
        :returns: El/los elemento/s especificados por el índice.
        """
        return self.transitions.__getitem__(key)