% generate a heightmap over a given domain using layers of Perlin noise
function H = GenerateLitter(x, y)
    % First layer
    [X, Y] = meshgrid(x,y);
    H = PerlinNoise(1, X, Y);
    
    % Additional layers
    for i = 1:3 
        [xTmp, yTmp] = meshgrid(2^i*x, 2^i*y);
        H = H + PerlinNoise(0.5^i, xTmp, yTmp);
    end
end

function H = PerlinNoise(Amp, X, Y)
    % Generate the gradient on control points
    [cpx, cpy] = meshgrid(floor(X(1,1)):ceil(X(end, end)), floor(Y(1,1)):ceil(Y(end, end)));
    Gx = Amp*(randn(size(cpx)));
    Gy = Amp*(randn(size(cpy)));
    FGx = scatteredInterpolant(cpx(:), cpy(:), Gx(:));
    FGy = scatteredInterpolant(cpx(:), cpy(:), Gy(:));

    % Calculate the control points corresponding to each input coordinates
    I0 = floor(X);
    I1 = ceil(X);
    J0 = floor(Y);
    J1 = ceil(Y);

    % Calculate the distance between each coordinates and control points
    U0 = X - I0;
    U1 = X - I1;
    V0 = Y - J0;
    V1 = Y - J1;

    % Interpolate the heights on each coordinates from the gradients on control points
    N00 = FGx(I0, J0).*U0 + FGy(I0, J0).*V0;
    N01 = FGx(I0, J1).*U0 + FGy(I0, J1).*V1;
    N10 = FGx(I1, J0).*U1 + FGy(I1, J0).*V0;
    N11 = FGx(I1, J1).*U1 + FGy(I1, J1).*V1;
    
    f = @(t) 6*t.^5 - 15*t.^4 + 10*t.^3;
    n0 = (1 - f(U0)).*N00 + f(U0).*N10;
    n1 = (1 - f(U0)).*N01 + f(U0).*N11;
    H = (1 - f(V0)).*n0 + f(V0).*n1;
end
    