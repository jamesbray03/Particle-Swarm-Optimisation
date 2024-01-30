%% PSO to find the global minimum of a height map

%% Parameters
maxIterations = 1000;      % maximum number of iterations (run time)
numBins = 5;               % number of bins in the swarm
inertiaWeight = 80;        % weight controlling the particle's inertia for momentum
inertiaDamping = 1;     % let inertia decrease over time
cognitiveWeight = 10;      % weight for the cognitive (self-awareness) component
cognitiveDecrease = 1; % let cognitive component decrease over time
socialWeight = 5;          % weight for the social (swarm awareness) component
socialIncrease = 0;     % let social component increase over time
maxSpeed = 0.2;            % maximum speed of particle movement
cleanSpeed = 0.1;          % amount of litter one bin can pick up in a location
cleanRadius = 20;          % area bin can clean

% size of the area
xSize = 0:0.01:3; 
ySize = 0:0.01:3;

%% Initialise litter and bins
% initialise litter
H = max(0, GenerateLitter(xSize, ySize));

% initialise bins
swarm = cell(1, numBins);
for i = 1:numBins
    swarm{i} = SeaBin(rand(1, 2) * 3);
end

%% Display litter and bins
% display terrain
h = surf(xSize, ySize, H);
h.EdgeColor = 'none';
customColorMap = colormap(parula);
customColorMap(1, :) = [0, 0, 0];
colormap(customColorMap);
axis([0 3 0 3 -3 15]);
axis square
hold on;

% display bins
binPlots = gobjects(1, numBins);
for i = 1:numBins
    binPlots(i) = plot3(swarm{i}.position(1), swarm{i}.position(2), 3, 'r.', 'MarkerSize', 10);
end

%% Main PSO loop
globalBestValue = Inf;
for iteration = 1:maxIterations

    % update best values
    for i = 1:numel(swarm)
        bin = swarm{i};
        
        % snap to nearest value in the litter array
        binRow = round(bin.position(2) / 0.01) + 1;
        binCol = round(bin.position(1) / 0.01) + 1;

        % handle out of bounds
        try
            bin.value = -H(binRow, binCol);
        catch
            bin.value = Inf;
        end

        % local values
        if bin.value < bin.bestValue
            bin.bestValue = bin.value;
            bin.bestPosition = bin.position;

            % global values
            if bin.bestValue <= globalBestValue
                globalBestValue = bin.bestValue;
                globalBestPosition = bin.bestPosition;
            end
        end

        % pick up litter
        for row = max(1, binRow - cleanRadius):min(size(H, 1), binRow + cleanRadius)
            for col = max(1, binCol - cleanRadius):min(size(H, 2), binCol + cleanRadius)
                % check if the cell is cleaned
                if (row - binRow)^2 + (col - binCol)^2 <= cleanRadius^2
                    % Reduce the height of the cell
                    H(row, col) = max(0, H(row, col) - cleanSpeed);
                end
            end
        end
        

        swarm{i} = bin;
    end
    
    % move bins
    for i = 1:numel(swarm)
        bin = swarm{i};

        bin.velocity = inertiaWeight * bin.velocity + ...
                     cognitiveWeight * (0.8 + 0.2*rand(1, 2)) .* (bin.bestPosition - bin.position) + ...
                     socialWeight * (0.8 + 0.2*rand(1, 2)) .* (globalBestPosition - bin.position);
        
        % limit velocity
        if norm(bin.velocity) > maxSpeed
            bin.velocity = (bin.velocity / norm(bin.velocity)) * maxSpeed;
        end
        
        % move particle
        bin.position = bin.position + bin.velocity;
        
        % plot particle
        set(binPlots(i), 'XData', bin.position(1), 'YData', bin.position(2), 'ZData', 3);
        swarm{i} = bin;
    end
    
    % change weighting over time
    inertiaWeight = inertiaWeight * inertiaDamping;
    cognitiveWeight = cognitiveWeight * cognitiveDecrease;
    socialWeight = socialWeight * socialIncrease;

    % re-plot litter
    set(h, 'ZData', H);

    drawnow;
    pause(0.01);
end
