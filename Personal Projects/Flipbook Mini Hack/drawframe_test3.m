function drawframe_test3(f)
    % Set up figure and axis
    if f==1
    figure;
    ax = gca;
    ax.Color = [1 1 1];
    xlim([0 2*pi]);
    ylim([-1 1]);
    end
    
    % Initialize waveform
    x = linspace(0, 2*pi, 100);
    y = sin(x);
    [X, Y] = meshgrid(x, y);
    plot(x, y);
    
    % Set number of Fourier coefficients to display
    N = 10;
    
    % Animate Fourier Transform
    for i = 1:N
        y_fourier = fft2(Y);
        y_fourier = real(y_fourier);
        hold on
        plot(x, y_fourier);
    end
end