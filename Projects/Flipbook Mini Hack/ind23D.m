function ind23D(input)
    % Check if the input is a valid indexed image
    if ~isnumeric(input) || ~ismatrix(input)
        error('Input must be a 2D indexed image.');
    end

    % Get the size of the indexed image
    [rows, cols] = size(input);

    % Create a figure for the 3D bar plot
    figure;

    % Use the indexed image colormap
    colormap('default');
    cmap = colormap;

    % Loop through each pixel in the indexed image
    for row = 1:rows
        for col = 1:cols
            % Get the pixel value
            value = input(row, col);

            % Skip zero values (background)
            if value == 0
                continue;
            end

            % Get the corresponding color from the colormap
            color = cmap(value, :);

            % Create a bar at the pixel location with height equal to the pixel value
            bar3(row, col, value, 'FaceColor', color, 'EdgeColor', color);            
            hold on;
        end
    end

    % Set axis labels
    xlabel('Row');
    ylabel('Column');
    zlabel('Pixel Value');

    % Set axis limits
    xlim([1, rows+1]);
    ylim([1, cols+1]);
    zlim([0, max(input(:))]);

    % Set view angle
    view(45, 45);

    % Title
    title('3D Bar Plot of Indexed Image');

    % Show colorbar
    colorbar;
end