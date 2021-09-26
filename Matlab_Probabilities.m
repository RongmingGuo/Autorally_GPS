
%% Basic Probabilities in Matlab
% Probability Density Functions (PDF)
mu1 = 0;
sigma1 = 1;
pd = makedist('Normal', 'mu', mu1, 'sigma', sigma1); % this creates a type-distribution variable
prob1 = pdf(pd, 3); % 1) The distribution object; 2) the value you want to evaluate on

% Plotting -------------------------------
x_vec = -3 : 0.1 : 3;
plot(x_vec, pdf(pd, x_vec)); % 1-d Normal Distribution, pdf Plotting

% Probability Distribution, Discretified
x_left = -3;
x_right = 3;
x_step = 0.1;

%------------------------------------------
X = x_left : x_step: x_right;
Y = x_step * pdf(pd, X); % left-riehmann approximation
bar(X, Y)

%% 2-D Probability Distributions
x_left = -3;
x_right = 3;
x_step = 0.1;

y_btm = -3;
y_up = 3;
y_step = 0.1;

X = x_left : x_step : x_right;
Y = y_btm : y_step: y_up;

% Plotting
PXY = [];
for i = 1 : length(X)
    for j = 1 : length(Y)
        x = X(i);
        y = Y(j);
        PXY(i, j) = (pdf(pd, x) * x_step) * (pdf(pd, y) * y_step); % Generating 2-D Probability Distributions
    end
end

imagesc(PXY);
axis equal

mu = 0;
sigma = 1;
sz = [10 10];
A = normrnd(mu, sigma, sz);
imagesc(A);
axis equal