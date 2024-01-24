# Particle Swarm Optimization (PSO) for Global Minimum Search on a Height Map

<img src="https://github.com/James-Bray19/Particle-Swarm-Optimisation/assets/47334864/984c8ade-95ad-437e-b0d2-7e5fced9e09c" style="display: block; margin: auto; width: 50%;" />

This MATLAB script implements Particle Swarm Optimization (PSO) to find the global minimum of a height map. PSO is a powerful optimization technique inspired by the social behavior of birds and fish. In this script, particles traverse the search space to find the lowest point (global minimum) on a given height map.

## Parameters

- `maxIterations`: Maximum number of iterations for the PSO algorithm.
- `numParticles`: Number of particles in the swarm.
- `inertiaWeight`: Weight controlling the particle's inertia for momentum.
- `inertiaDamping`: Damping factor applied to `inertiaWeight` over iterations.
- `cognitiveWeight`: Weight for cognitive (self-awareness) component of particle movement.
- `socialWeight`: Weight for social (swarm awareness) component of particle movement.
- `maxSpeed`: Maximum speed of particle movement.
- `xSize`: Range of x-coordinates for the terrain.
- `ySize`: Range of y-coordinates for the terrain.

## Usage

1. Make sure you have MATLAB installed on your machine.
2. Clone this repository or download the script files.
3. Open MATLAB and navigate to the directory containing the script.
4. Modify the parameters as needed (e.g., adjust `maxIterations`, `numParticles`, etc.).
5. Run the script (`PSO.m`).

## Output

- The script displays the terrain and particles as they move through the search space.
- The global minimum value and position found by the PSO algorithm are displayed in the console.
- The script may take some time to complete depending on the specified parameters.

## Notes

- The particle's movement is influenced by cognitive and social components, promoting global exploration.
- This algorithm is in development and may find local minima, parameters may need tweaking.

## Acknowledgments

This script was inspired by the concept of Particle Swarm Optimization (PSO) and its application to optimization problems.
Please also see [this repo](https://github.com/rej55/MATLAB_TerrainGeneration.git) regarding the perlin noise functions
