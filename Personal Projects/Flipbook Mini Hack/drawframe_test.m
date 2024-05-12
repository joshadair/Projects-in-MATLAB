function drawframe_test(f)
    % Define some constants
    N = 200;  % number of points
    M = 10;   % number of colors
    s = 0.5;  % scale factor
    t = 0.1;  % time step
    %phase = mod(f,2);
    phase = 1;

    % Create a grid of points
    [x, y] = meshgrid(linspace(-1, 1, N), linspace(-1, 1, N));

    % Define a function to compute the color of each point
    t = f * 0.01;
    xoff = sin(t * 2 * pi);
    yoff = cos(t * 4 * pi);
    scale = 1 + 0.1 * sin(t * 2 * pi);
    color = @(x, y, t, phase) mod(sin(2*pi*(x+xoff)*scale*t + phase) + cos(2*pi*(y+yoff)*scale*t + phase) + 0.5*sin(4*pi*(x+xoff)*scale*t + phase) + 0.2*cos(6*pi*(y+yoff)*scale*t + phase) * (1 - 0.5*(f/48)), 1);    
    
    % Create a colormap with M colors
    cmap = turbo(M);

    % Initialize the frame
    frame = zeros(N, N, 3);

    % Loop over each point in the grid
    for i = 1:N
        for j = 1:N
            % Compute the color of the point
            c = color(x(i, j), y(i, j), f*t, phase);

            % Map the color to the colormap
            c = cmap(ceil(M*c), :);

            % Assign the color to the frame
            frame(i, j, :) = c;
        end
    end

    % Display the frame
    imagesc(frame);
    axis off;
  