# Lunar Leap
![Lunar Leap]()

**A realistic orbital mechanics space simulator** made in **Godot 4**.

Navigate the Earth-Moon system with accurate physics, switching between a strategic **Map View** and an immersive **Ship View**.

> **Note**: This is an **early development project**. Many features are still being implemented.

## Features

- Realistic orbital mechanics (elliptical, parabolic and hyperbolic trajectories)
- Earth-Moon gravitational system
- Dual camera system: Map View and Ship View
- Spacecraft attitude control (pitch, yaw, roll)
- Live orbital information (periapsis, apoapsis, velocity, etc.)
- Time acceleration controls

## Tech Stack

- **Godot 4.6**
- GDScript
- Custom orbital mechanics tools
- Jolt Physics

## Project Structure

- `scenes/` — Main scenes (game, ship, map)
- `scripts/` — Core logic and managers
- `addons/orbital_tools/` — Orbital simulation addon
- `assets/` — Textures and resources

## Getting Started

1. Clone the repository **including submodules**:
   ```bash
   git clone --recursive https://github.com/Mauxx-Studio/Lunar-Leap-game.git
