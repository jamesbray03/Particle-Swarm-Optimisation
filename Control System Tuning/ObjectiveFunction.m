function value = ObjectiveFunction(Kp, Ki, Kd, G)

    % find the error in the system
    C = tf([Kd Kp Ki], [0 1 0]);
    [e, t] = step(1/(1+C*G));

    % select from the following based on requirements

    %% ISE (Integral of Squared Error)

%     value = trapz(t, e.^2);   

    % - prioritize steady-state accuracy
    % - suitable for systems where overshoot is a concern
    % - may lead to increased settling time
         
    %% IAE (Integral of Absolute Error)

%     value = trapz(t, abs(e));  

    % - effective in reducing overshoot
    % - less sensitive to extreme errors than ISE
    % - might result in a less smooth response compared to ISE
    % - could lead to more pronounced oscillations
       
    %% ITSE (Integral of Time-weighted Squared Error)

%     value = trapz(t, (e.^2) .* t); 

    % - time weighting factor addresses both steady-state and transient performance
    % - emphasis on squared error may still lead to a compromise in transient response
    
    %% ITAE (Integral of Time-weighted Absolute Error)

    value = trapz(t, abs(e) .* t);

    % - less likely to prioritize steady-state accuracy at the expense of transient response
    % - the emphasis on absolute error may lead to an impact on the overall system accuracy

end
