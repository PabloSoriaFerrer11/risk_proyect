# risk_project

Proyecto para simulación de partidas tipo Risk.
Es una simple idea sacado de una partidas que jugue hace tiempo en un discord. 

## Idea

La idea es crear una aplicación WEB y/o Andriod para poder gestionar partidas de tipo Risk en las que las batallas se juegan de la forma que se especifique la partida.

Serán [partidas por turnos](#ejemplo-de-partida), en la que los equipos tendrán que enviar sus turnos a la vez poniendose de acuerdo como facción.

Más abajo se explica el funcionamiento de una partida.

## Tecnología

La aplicación esta desarrollada completamente con el lenguaje DART y el frameWork de Flutter.

## Ejemplo de Partida

- Un administrador creará una partida seleccionando el mapa en el que se vaya a jugdar la partida. Este administrador tambien pondrá una fecha máxima para unirse jugadores y empezar la primera fase de la partda (Aparción).
- A este administrador se le proporcionará un código (Id) y una contraseña e invitará a otros jugadores pasandole el inidentficador y contraseña. Solo una cantidad de jugadores se podrán unir. Un jugador, con solo *el código* podrá consultar la partida sin necesidad de inicar sesión.
- Los jugadores en conjunto, como un clan, deberán ponerse de acuerdo para decidir la acción que realizará su facción dependiendo de la [fase](#fases) en la que se encuentre la partida.
  
### Fases
  1. Aparición: Solo se juega el primer turno de la partida. La facción decide donde aparecer en el mapa como conjunto.
  2. Movimientos y Acuerdos: Si se implementa alguna forma de comercio. 
  3. Batalla: Las batallas son resueltas en el juego o de la forma acordada.
  4. Tributos: Despues de la resolución de batallas, cada facción recogería tributos de las provincias restantes. 
  5. Mejora: Con lo recaudado, deciden si mejorar provincias , sacar héroes o mejorar tropas.

## Experiencia Propia

La partida que yo jugué fueron asi:
  - **Contexto** El mapa en el que jugamos fue un mapa de TWWH2. Todos los jugadores estabamos en un discord separados por equipos donde habían seleccionado la facción principal de una raza.




