# DALI

> DALI Multi Agent Systems Framework

DALI is a meta interpreter built on top of **SWI-Prolog**.

![DALI Logo](img/DALI_logo.png)

## Installation

DALI is built upon the [SWI-Prolog](https://www.swi-prolog.org/) interpreter (open-source).

The recommended way to run DALI is through **[DALIA](https://github.com/AAAI-DISIM-UnivAQ/dalia_swi_prolog)**, a containerized launcher that handles all setup automatically via Docker.

### Quick Start with DALIA (Recommended)

1. Install [Docker](https://docs.docker.com/engine/install/)
2. Clone both repositories:
   ```sh
   git clone github.com/AAAI-DISIM-UnivAQ/DALI_swi_prolog.git
   git clone https://github.com/AAAI-DISIM-UnivAQ/dalia_swi_prolog.git
   cd dalia
   ```
3. Run an example MAS:
   ```sh
   ./run --dali ../DALI --src example --token <YOUR_OPENAI_API_KEY>
   ```

See the [DALIA README](https://github.com/AAAI-DISIM-UnivAQ/dalia_swi_prolog) for full usage details and examples.

## Architecture

When launched, the system starts the following components inside a Docker container:

- **Linda server** (`active_server_wi.pl`) — blackboard-based communication hub
- **FIPA user client** (`active_user_wi.pl`) — interactive message prompt
- **AI Oracle** (Python) — LLM bridge for `acquire_knowledge/2` calls
- **1 DALI metainterpreter per agent** (`active_dali_wi.pl`)

## Usage Examples

DALI is shipped with two ready-to-run example projects (located in the DALIA repository):

### Example 1: Emergency Response (`example`)

A multi-agent emergency response system with 9 agents: `sensor`, `coordinator`, `logger`, `communicator`, `evacuator`, `manager`, `responder`, `mary`, `john`.

```sh
./run --dali ../DALI --src example --token <YOUR_OPENAI_API_KEY>
```

In the user prompt, send a sensor event:

```prolog
sensor.
me.
send_message(sense(fire, rome), me).
```

**Expected flow:**
1. **sensor** detects fire, logs the event, sends alarm to coordinator
2. **coordinator** queries the AI oracle, dispatches evacuator, manager, and communicator
3. **evacuator** evacuates the location, reports back
4. **manager** dispatches equipment (firetruck), reports back
5. **communicator** notifies mary and john
6. **coordinator** (when both evacuated + equipped) dispatches responder
7. **responder** responds at location with equipment, reports done

### Example 2: Smart Agriculture (`case_study_smart_agriculture`)

A multi-agent precision agriculture system with 6 agents: `soil_sensor`, `weather_monitor`, `crop_advisor`, `irrigation_controller`, `farmer_agent`, `logger`.

```sh
./run --dali ../DALI --src case_study_smart_agriculture --token <YOUR_OPENAI_API_KEY>
```

In the user prompt, send soil and weather data:

```prolog
% Read soil data (moisture=20, pH=6.5, field=north_field)
soil_sensor.
me.
send_message(read_soil(20, 6.5, north_field), me).

% High temperature + drought forecast
weather_monitor.
me.
send_message(weather_update(42, 15, drought), me).

% Acidic soil in east field
soil_sensor.
me.
send_message(read_soil(50, 4.0, east_field), me).

% Frost warning
weather_monitor.
me.
send_message(weather_update(0, 80, frost), me).
```

**Expected flow:**
1. **soil_sensor** / **weather_monitor** receive data and forward to crop_advisor
2. **crop_advisor** queries the AI oracle for agricultural advice
3. **crop_advisor** sends irrigation commands and advisory notifications
4. **irrigation_controller** activates irrigation for the relevant field
5. **farmer_agent** receives notifications about actions taken

## Development Setup

To create a new DALI MAS:

1. Create a new folder inside the DALIA repository (e.g., `my_project`)
2. Create `instances.json` mapping agent names to type files:
   ```json
   {
       "agent1": "agent1Type",
       "agent2": "agent2Type"
   }
   ```
3. Create a `types/` subfolder with `.txt` files for each agent type
4. Launch with: `./run --dali ../DALI --src my_project`

### Agent Type File Guidelines

- Use `t60.` (or `t1.` for fast polling) as the first line to set the agent cycle time
- External events use `:>` operator with `E` suffix: `myEventE(X) :> ...`
- Actions use `:>` operator with `A` suffix: `myActionA(X) :> ...`
- Helper predicates must use `:-` and always have at least one variable argument
- Use `messageA(agent, send_message(event(Args), Me))` to send messages
- Use `acquire_knowledge(Context, Fact)` to query the AI oracle
- Each agent should define only **one** external event to avoid `simultaneity_interval` issues

## Release History

Check [release history](https://github.com/AAAI-DISIM-UnivAQ/DALI_swi_prolog/releases) page.

## Software architecture

Analyze architectural diagrams in the [DALI visualization](DALI_Architecture_Diagram.md)

## Contacts

Giovanni De Gasperis – email: giovanni.degasperis-at-univaq-it

Distributed under the Apache License 2.0. See ``LICENSE`` for more information.

[http://github.com/AAAI-DISIM-UnivAQ](http://github.com/AAAI-DISIM-UnivAQ)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request to our ```dev``` branch

## Examples of Applications

* in Robotics: coordination among store delivery robots: 
   [![Delivery robots cordination](https://img.youtube.com/vi/1dfWthhUovk/0.jpg)](https://www.youtube.com/watch?v=1dfWthhUovk)
[Video](https://youtu.be/1dfWthhUovk) from S. Valentini:

## References

* DALI 1.0 original URL: http://www.di.univaq.it/stefcost/Sito-Web-DALI/WEB-DALI (no more active)
* COSTANTINI, Stefania. [The DALI Agent-Oriented Logic Programming Language: Summary and References 2015.](https://people.disim.univaq.it/stefcost/pubbls/Dali_References.pdf)
* COSTANTINI S, TOCCHIO A. [A logic programming language for multi-agent systems.](docs/DALI_Language_description.pdf) Logics in Artificial Intelligence, Springer Berlin Heidelberg, 2002, pp:1-13.
* COSTANTINI S, TOCCHIO A. *The DALI logic programming agent-oriented language.* In Logics in Artificial Intelligence Springer Berlin Heidelberg, 2004, pp:685-688.
* COSTANTINI S, TOCCHIO A. *DALI: An Architecture for Intelligent Logical Agents.* In: AAAI Spring Symposium: Emotion, Personality, and Social Behavior. 2008. pp:13-18.
* BEVAR V, COSTANTINI S, TOCCHIO A, DE GASPERIS G. *A multi-agent system for industrial fault detection and repair.* In: Advances on Practical Applications of Agents and Multi-Agent Systems. Springer Berlin Heidelberg, 2012. pp:47-55.
* DE GASPERIS, G, BEVAR V, COSTANTINI S, TOCCHIO A, PAOLUCCI A. *Demonstrator of a multi-agent system for industrial fault detection and repair.* In: Advances on Practical Applications of Agents and Multi-Agent Systems. Springer Berlin Heidelberg, 2012. pp:237-240.
* DE GASPERIS Giovanni. *DETF 1st Release (Version 14.08a).* Zenodo. [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1044488.svg)](https://doi.org/10.5281/zenodo.1044488), 2014, August 6. 
* COSTANTINI, Stefania; DE GASPERIS, Giovanni; NAZZICONE, Giulio. *DALI for cognitive robotics: principles and prototype implementation.* In: International Symposium on Practical Aspects of Declarative Languages. Springer, Cham, 2017. p. 152-162.
* COSTANTINI, Stefania, DE GASPERIS, Giovanni, PITONI Valentina, SALUTARI Agnese. [DALI: A multi agent system framework for the web, cognitive robotic and complex event processing.](http://ceur-ws.org/Vol-1949/CILCpaper05.pdf), [CILC 2017](http://cilc2017.unina.it), 32nd Italian Conference on Computational Logic
26-28 September 2017, Naples, Italy
* RAFANELLI, Andrea; COSTANTINI, Stefania; DE GASPERIS, Giovanni. [A Multi-Agent-System framework for flooding events. 2022](https://ceur-ws.org/Vol-3261/paper11.pdf). WOA 2022: 23rd Workshop From Objects to Agents, September 1–2, Genova, Italy
* COSTANTINI, Stefania. [Ensuring trustworthy and ethical behaviour in intelligent logical agents](https://academic.oup.com/logcom/article/32/2/443/6513773). Journal of Logic and Computation, 2022, 32.2: 443-478.
