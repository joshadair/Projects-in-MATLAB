function drawframe_test2(f)
    % drawframe - Animation of a rotating point on a circle with two springs

    % Parameters
    radius = 4;                     % Radius of the circle
    angularVelocity = 2 * pi / 48;  % Angular velocity for 48 frames
    springConstant = 0.5;           % Spring constant

    % Compute angle based on the frame number
    theta = angularVelocity * f;

    % Calculate the coordinates of the point on the circle
    x = radius * cos(theta);
    y = radius * sin(theta);

    % Coordinates of the fixed point
    fixedPointX = 0;
    fixedPointY = 0;

    % Plot the circle
    t = linspace(0, 2 * pi, 100);
    circleX = radius * cos(t);
    circleY = radius * sin(t);

    plot(circleX, circleY, 'b-', 'LineWidth', 2);
    hold on;

    % Plot the rotating point
    plot(x, y, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

    % Plot the fixed point
    plot(fixedPointX, fixedPointY, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

    % Plot the x-direction spring
    plot([fixedPointX x], [fixedPointY y], 'k-', 'LineWidth', 1.5);

    % Plot the y-direction spring
    plot([fixedPointX fixedPointX], [fixedPointY y], 'k-', 'LineWidth', 1.5);

    % Calculate and plot the forces
    forceX = springConstant * (fixedPointX - x);
    forceY = springConstant * (fixedPointY - y);
    
    text(-4.5, 3, sprintf('Force X: %.2f\nForce Y: %.2f', forceX, forceY), 'FontSize', 10);

    % Set axis properties
    axis equal;
    axis([-5 5 -5 5]);
    title('Rotating Point on a Circle with Two Springs');
    xlabel('X-axis');
    ylabel('Y-axis');

    % Display frame number
    text(3.5, -4.5, ['Frame: ' num2str(f)], 'FontSize', 10);

    hold off;

    % Pause to create animation effect
    pause(0.1);
end
