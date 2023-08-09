function pacManGame()

    % Set up game variables
    board = [
        '###############'
        '#P............#'
        '#.......G.....#'
        '#.............#'
        '#......G......#'
        '#.............#'
        '###############'
    ];

    pacmanPosition = [2, 2];
    ghostPositions = [3, 8; 5, 8];

    % Main game loop
    while true
        % Display the game board
        disp(board);

        % Get user input
        move = input('Enter direction (w/a/s/d): ', 's');
        
        % Update Pac-Man's position
        newPacmanPosition = pacmanPosition;
        if move == 'w'
            newPacmanPosition(1) = newPacmanPosition(1) - 1;
        elseif move == 's'
            newPacmanPosition(1) = newPacmanPosition(1) + 1;
        elseif move == 'a'
            newPacmanPosition(2) = newPacmanPosition(2) - 1;
        elseif move == 'd'
            newPacmanPosition(2) = newPacmanPosition(2) + 1;
        end

        % Check for collisions with walls
        if board(newPacmanPosition(1), newPacmanPosition(2)) ~= '#'
            board(pacmanPosition(1), pacmanPosition(2)) = '.';
            pacmanPosition = newPacmanPosition;
            board(pacmanPosition(1), pacmanPosition(2)) = 'P';
        end

        % Update ghost positions
        for i = 1:size(ghostPositions, 1)
            ghostPositions(i, :) = ghostPositions(i, :) + [-1 1; 0 0];
        end
        
        % Check for collisions with ghosts
        for i = 1:size(ghostPositions, 1)
            if isequal(ghostPositions(i, :), pacmanPosition)
                disp('Game Over! Pac-Man was caught by a ghost.');
                return;
            end
        end

        % Pause to control game speed
        pause(0.5);
        clc;
    end
end