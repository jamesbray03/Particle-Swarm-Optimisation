% stores attributes needed for PSO
classdef ParticleClass
    properties
        position
        velocity
        value
        bestPosition
        bestValue
    end
    methods

        % Start at random assigned position with random unit velocity
        function obj = ParticleClass(initialPosition)
            obj.position = initialPosition;
            obj.velocity = rand(1, 2) * 2 - 1;
            obj.velocity = obj.velocity/norm(obj.velocity);
            obj.bestPosition = obj.position;
            obj.bestValue = Inf;
        end
    end
end