function [ ] = HotspotPlot(mux, sigmax, muy, sigmay)
    pdx = makedist('Normal', 'mu', mux, 'sigma', sigmax);
    pdy = makedist('Normal', 'mu', muy, 'sigma', sigmay);
    
    x_left = mux + 3 * sigmax;
    x_right = mux - 3 * sigmax;

    y_btm = muy + 3 * sigmay;
    y_up = muy - 3 * sigmay;

    X = linspace(x_left, x_right);
    Y = linspace(y_btm, y_up);
    x_step = (x_right - x_left) / 99;
    y_step = (y_up - y_btm) / 99;
    
    PXY = [];
    for i = 1 : length(X)
        for j = 1 : length(Y)
            x = X(i);
            y = Y(j);
            PXY(i, j) = (pdf(pdx, x) * x_step) * (pdf(pdy, y) * y_step); % Generating 2-D Probability Distributions
        end
    end
    
    imagesc(PXY);
    axis equal
    
end