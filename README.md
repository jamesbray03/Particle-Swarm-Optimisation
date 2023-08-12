# Particle Swarm Optimization (PSO) for PID Controller Optimization

This MATLAB script demonstrates the use of Particle Swarm Optimization (PSO) to optimize PID controllers for a given control system. The goal is to find the PID controller parameters (Kp, Ki, and Kd) that result in optimal performance for the control system.

## Control System and Transfer Function

The control system's plant is represented by a transfer function G(s). It assumes unity negative feedback and optimises PID controllers to reduce overall error.

![image](https://github.com/James-Bray19/PSO-Control-System-Tuning/assets/47334864/145edf92-d92e-439e-895b-e24c026abaa9)

## PSO Parameters

Several parameters control the behavior of the PSO algorithm:

- `maxIterations`: Maximum number of optimization iterations.
- `population`: Number of particles in the swarm.
- `inertiaWeight`, `inertiaDamping`: Parameters controlling particle inertia for momentum.
- `cognitiveWeight`, `cognitiveDecrease`: Parameters controlling self-awareness component.
- `socialWeight`, `socialIncrease`: Parameters controlling swarm awareness component.
- `maxVelocity`: Maximum speed of particle movement.

## Control System Parameters

The PID controller parameters are constrained within specified ranges:

- `min_Kp`, `max_Kp`: Minimum and maximum values for Kp.
- `min_Ki`, `max_Ki`: Minimum and maximum values for Ki.
- `min_Kd`, `max_Kd`: Minimum and maximum values for Kd.

If after running the program the swarm converges on an edge, consider changing your domain here.

## Objective Function

The performance of each PID controller can be evaluated using an objective function. Different performance criteria can be selected by modifying the `ObjectiveFunction` function. Currently, the script uses the Integral of Time x Absolute Error (ITAE) as the performance metric. These functions are from [this paper](https://insightsociety.org/ojaseit/index.php/ijaseit/article/view/93/98), and evaluate the total error in the step response.

## Visualization

The optimization progress and particle movement are visualized in a 3D graph. The unity feedback step responses with and without the PID controller are shown after the iteration cycle is complete.

## How to Use

1. Ensure you have MATLAB installed.
2. Open the directory containing these scripts.
3. Adjust the control system parameters, PSO parameters, and objective function as needed.
4. Run the `PSO.m` script in MATLAB to perform PSO optimization and visualize the results.

## Notes

- This script is provided for educational purposes and as a starting point for PSO-based PID controller optimization. It can be further customized and extended based on specific control system requirements.

Please feel free to modify, improve, or adapt this code to suit your specific needs.
