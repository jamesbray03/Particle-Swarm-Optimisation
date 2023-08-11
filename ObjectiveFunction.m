function value = ObjectiveFunction(Kp, Ki, Kd, G, t)
    % perform a unity feedback step input response
    C = tf([Kd Kp Ki], [0 1 0]);
    CG = C*G;
    y = step(CG/(1+CG), t);

    % performance evaluation formulae
    % 

    % value = trapz(t, y.^2);        %ISE
    value = trapz(t, abs(y));      %IAE
    % value = trapz(t, (y.^2) .* t); %ITSE
    % value = trapz(t, abs(y) .* t); %ITAE
end