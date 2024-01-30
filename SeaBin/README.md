# SeaBin Navigation Algorithm with Particle Swarm Optimization (PSO)

![image](https://github.com/James-Bray19/Particle-Swarm-Optimisation/assets/47334864/110033d4-8ea7-4096-8a49-370e1ec2c026)

## Overview:
This repository contains a navigation algorithm designed to enhance the efficiency of SeaBins in cleaning up marine litter. The algorithm utilizes Particle Swarm Optimization (PSO) to optimize the movement of SeaBins, maximizing litter collection within a specified area.

## Project Context:
This project is part of an 'Engineering You're Hired' initiative where teams were tasked to devise a solution to a real-world problem using swarm robotics. Our team chose to enhance the functionality of SeaBins by implementing a propulsion and navigation system to optimize litter collection in marine environments.

## Navigation Algorithm:
The provided code implements the navigation algorithm for SeaBins using PSO. Below are the main components of the algorithm:

![image](https://github.com/James-Bray19/Particle-Swarm-Optimisation/assets/47334864/276f6c52-3580-4257-83ae-06222fabccd9)

### Parameters:
- `maxIterations`: Maximum number of iterations for the PSO algorithm.
- `numBins`: Number of SeaBins in the swarm.
- `inertiaWeight`, `cognitiveWeight`, `socialWeight`: Parameters controlling the influence of inertia, self-awareness, and swarm awareness, respectively.
- `maxSpeed`: Maximum speed of SeaBin movement.
- `cleanSpeed`, `cleanRadius`, `detectionRadius`: Parameters defining the cleaning capability and detection range of SeaBins.

### PSO Loop:
- The PSO algorithm iteratively updates the position and velocity of SeaBins to maximize litter collection.
- Each SeaBin adjusts its movement based on its current position, best position (locally), and the global best position (globally).
- The algorithm limits SeaBin velocity to prevent excessive movement.

## How to Use:
1. **Requirements**: MATLAB environment.
2. **Execution**: Run the `PSO.m` MATLAB script.
3. **Parameter Tuning**: Adjust parameters in the script to optimize performance based on specific requirements.

## Project Conclusion:
In conclusion, our project aimed to enhance the litter collection efficiency of SeaBins through the implementation of a navigation algorithm leveraging Particle Swarm Optimization (PSO). Throughout the development process, we recognized the trade-off between maximizing litter collection and the associated increase in energy consumption. Despite this challenge, our algorithm demonstrates significant potential in improving marine litter management.

Moving forward, it's crucial to further refine our algorithm and consider strategies for mitigating the increased energy consumption, such as optimizing route planning or integrating renewable energy sources into SeaBin propulsion systems. Additionally, ongoing research and collaboration within the field of marine robotics will be essential in advancing sustainable solutions for marine litter cleanup.
