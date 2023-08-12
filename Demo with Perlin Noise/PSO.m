%% PSO to find the global minimum of a height map

%% Parameters
maxIterations = 500;      % maximum number of iterations
numParticles = 30;        % number of particles in the swarm
inertiaWeight = 80;       % weight controlling the particle's inertia for momentum
inertiaDamping = 0.995;   % let inertia decrease over time
cognitiveWeight = 8;      % weight for the cognitive (self-awareness) component
cognitiveDecrease = 0.99; % let cognitive component decrease over time
socialWeight = 0.5;       % weight for the social (swarm awareness) component
socialIncrease = 1.02;    % let social component increase over time
maxSpeed = 0.05;          % maximum speed of particle movement

% size of the domain
xSize = 0:0.01:3; 
ySize = 0:0.01:3;

%% Initialise terrain and particles
% initialise terrain
H = GenerateTerrain(xSize, ySize);

% initialise particles
swarm = cell(1, numParticles);
for i = 1:numParticles
    swarm{i} = ParticleClass(rand(1, 2) * 3);
end

%% Display terrain and particles and current best
% display terrain
h = surf(xSize, ySize, 0.2*H);
h.EdgeColor = 'none';
colormap(gray);
axis([0 3 0 3 -3 15]);
axis square
hold on;

% display particles
particlePlots = gobjects(1, numParticles);
for i = 1:numParticles
    particlePlots(i) = plot3(swarm{i}.position(1), swarm{i}.position(2), 3, 'r.', 'MarkerSize', 10);
end

% initialise plot for the current best value
linePlot = plot3([0, 0], [0, 0], [-3, 3], 'g', 'LineWidth', 2);

%% Main PSO loop
globalBestValue = Inf;
for iteration = 1:maxIterations

    % update best values
    for i = 1:numel(swarm)
        p = swarm{i};

        % handle out of bounds
        try
            p.value = H(round(p.position(2) / 0.01) + 1, round(p.position(1) / 0.01) + 1);
        catch
            p.value = Inf;
        end

        % local values
        if p.value < p.bestValue
            p.bestValue = p.value;
            p.bestPosition = p.position;

            % global values
            if p.bestValue <= globalBestValue
                globalBestValue = p.bestValue;
                globalBestPosition = p.bestPosition;
            end
        end
        swarm{i} = p;
    end
    
    % plot best global value
    set(linePlot, 'XData', [globalBestPosition(1), globalBestPosition(1)], ...
                  'YData', [globalBestPosition(2), globalBestPosition(2)], ...
                  'ZData', [-3, 3]);
    
    % move particles
    for i = 1:numel(swarm)
        p = swarm{i};

        p.velocity = inertiaWeight * p.velocity + ...
                     cognitiveWeight * rand(1, 2) .* (p.bestPosition - p.position) + ...
                     socialWeight * rand(1, 2) .* (globalBestPosition - p.position);
        
        % limit velocity
        if norm(p.velocity) > maxSpeed
            p.velocity = (p.velocity / norm(p.velocity)) * maxSpeed;
        end
        
        % move particle
        p.position = p.position + p.velocity;
        
        % plot particle
        set(particlePlots(i), 'XData', p.position(1), 'YData', p.position(2), 'ZData', 3);
        swarm{i} = p;
    end
    
    % change weighting over time
    inertiaWeight = inertiaWeight * inertiaDamping;
    cognitiveWeight = cognitiveWeight * cognitiveDecrease;
    socialWeight = socialWeight * socialIncrease;

    drawnow;
    pause(0.01);
end
