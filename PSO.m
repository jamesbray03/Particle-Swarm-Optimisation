%% Use PSO to optimise PID controllers for a given control system
 
%% Parameters

% transfer function
G = tf(1, [2 3]);

% PSO parameters
maxIterations = 300;      % maximum number of iterations
population = 50;          % number of particles in the swarm
inertiaWeight = 50;       % weight controlling the particle's inertia for momentum
inertiaDamping = 0.99;    % let inertia decrease over time
cognitiveWeight = 2;      % weight for the cognitive (self-awareness) component
cognitiveDecrease = 0.99; % let cognitive component decrease over time
socialWeight = 5;         % weight for the social (swarm awareness) component
socialIncrease = 1.3;     % let social component increase over time
maxVelocity = 1;          % maximum speed of particle movement

% control system parameters
min_Kp = 0; max_Kp = 100;
min_Ki = 0; max_Ki = 5;
min_Kd = 0; max_Kd = 40;

% the domain and resolution for the step input
time_domain = linspace(0, 1000, 1000);

%% Particle Initialisation

% give every particle a random position within the domain
swarm = cell(1, population);
for i = 1:population
    swarm{i} = ParticleClass([min_Kp + (max_Kp - min_Kp) * rand, ...
                              min_Ki + (max_Ki - min_Ki) * rand, ...
                              min_Kd + (max_Kd - min_Kd) * rand]);
end

%% Plot Initialisation

% create 3D graph
figure; hold on;
axis([min_Kp max_Kp min_Ki max_Ki min_Kd max_Kd]);
axis square; grid on; view(3);
xlabel('Kp'); ylabel('Ki'); zlabel('Kd');

% initialise plots
bestPlot = plot3(0, 0, 0, 'g.', 'MarkerSize', 15);
particlePlots = gobjects(1, population);
for i = 1:population
    particlePlots(i) = plot3(swarm{i}.position(1), ...
        swarm{i}.position(2), swarm{i}.position(3), 'r.', 'MarkerSize', 10);
end

%% Precompute Variables

% initialise best value
globalBestValue = Inf;

% precompute random numbers for velocity calculations
rand_cognitive = cognitiveWeight * rand(population, 3);
rand_social = socialWeight * rand(population, 3);

% scale velocity based on controller domains
velocityScaler = [max_Kp - min_Kp, max_Ki - min_Ki, max_Kd - min_Kd];
velocityScaler = velocityScaler / norm(velocityScaler);

reference = ones(1, numel(time_domain));

%% Main PSO loop
for iteration = 1:maxIterations

    % batch properties for parallel processing
    numBatches = maxNumCompThreads;
    batchSize = ceil(population / numBatches);

    batches = cell(1, numBatches);

    % split swarm apart
    for i = 1:numBatches
        startIdx = (i - 1) * batchSize + 1;
        endIdx = min(i * batchSize, population);
        batches{i} = swarm(startIdx:endIdx);
    end

    % update values
    parfor batchNum = 1:numBatches
        batch = batches{batchNum};

        for i = 1:numel(batch)
            % fetch controllers
            Kp = batch{i}.position(1);
            Ki = batch{i}.position(2);
            Kd = batch{i}.position(3);
            
            % check if particle is in the domain
            if Kp >= min_Kp && Kp <= max_Kp && Ki >= min_Ki && Ki <= max_Ki && Kd >= min_Kd && Kd <= max_Kd
                batch{i}.value = ObjectiveFunction(Kp, Ki, Kd, G, time_domain);
            else
                batch{i}.value = Inf;
            end
        end
    
        batches{batchNum} = batch;
    end
    
    % Reassign updated batches back to the swarm
    for batchNum = 1:numBatches
        startIdx = (batchNum - 1) * batchSize + 1;
        endIdx = min(batchNum * batchSize, population);
        swarm(startIdx:endIdx) = batches{batchNum};
    end

    % update best values
    for i = 1:population
        p = swarm{i};

        % local values
        if swarm{i}.value < swarm{i}.bestValue
            swarm{i}.bestValue = swarm{i}.value;
            swarm{i}.bestPosition = swarm{i}.position;

            % global values
            if swarm{i}.bestValue <= globalBestValue
                globalBestValue = swarm{i}.bestValue;
                globalBestPosition = swarm{i}.bestPosition;
            end
        end

        swarm{i} = p;
    end

    % move particles
    for i = 1:population
        p = swarm{i};
        
        % calculate velocity
        cognitiveComponent = rand_cognitive(i, :) .* (p.bestPosition - p.position);
        socialComponent = rand_social(i, :) .* (globalBestPosition - p.position);
        p.velocity = inertiaWeight * p.velocity + cognitiveComponent + socialComponent;
        
        % limit velocity
        velocityNorm = norm(p.velocity);
        if velocityNorm > maxVelocity
            p.velocity = (p.velocity / velocityNorm) * maxVelocity;
        end
        
        % scale velocity and move particles
        p.position = p.position + maxVelocity * p.velocity .* velocityScaler;

        swarm{i} = p;
    end
    
    % change weighting over time
    inertiaWeight = inertiaWeight * inertiaDamping;
    cognitiveWeight = cognitiveWeight * cognitiveDecrease;
    socialWeight = socialWeight * socialIncrease;

    % update best point 
    set(bestPlot, 'XData', globalBestPosition(1), ...
                  'YData', globalBestPosition(2), ...
                  'ZData', globalBestPosition(3));

    % update particle points
    for i = 1:population
        set(particlePlots(i), 'XData', swarm{i}.position(1), ...
                              'YData', swarm{i}.position(2), ...
                              'ZData', swarm{i}.position(3));
    end
    drawnow;
end

% display controllers
Kp = globalBestPosition(1);
Ki = globalBestPosition(2);
Kd = globalBestPosition(3);
disp('Best found PID controller:')
disp(['Kp = ' num2str(Kp)]);
disp(['Ki = ' num2str(Ki)]);
disp(['Kd = ' num2str(Kd)]);

% plot step responses
figure;
C = tf([Kd Kp Ki], [0 1 0]);
subplot(1, 2, 1); step(G); title('Without PID')   
subplot(1, 2, 2); step(C*G/(1+C*G)); title('With PID') 
