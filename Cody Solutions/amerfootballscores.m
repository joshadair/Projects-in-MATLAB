function [t1_combs, t2_combs] = amerfootballscores(s1, s2)
    t1_combs = [];
    t2_combs = [];

    % Generate all possible combinations for team 1
    for tds_team1 = 0:s1/6
        for xpts_1_team1 = 0:min(tds_team1, s1 - 6*tds_team1)
            for xpts_2_team1 = 0:min(tds_team1 - xpts_1_team1, s1 - 6*tds_team1 - xpts_1_team1)
                for saf_team1 = 0:(s1 - 6*tds_team1 - xpts_1_team1 - 2*xpts_2_team1)/2
                    for fgs_team1 = 0:(s1 - 6*tds_team1 - xpts_1_team1 - 2*xpts_2_team1 - 2*saf_team1)/3
                        for dxpts_1_team1 = 0:(s1 - 6*tds_team1 - xpts_1_team1 - xpts_2_team1 - 2*saf_team1 - 3*fgs_team1)
                            for dxpts_2_team1 = 0:(s1 - 6*tds_team1 - xpts_1_team1 - xpts_2_team1 - 2*saf_team1 - dxpts_1_team1)/2
                                combination_team1 = [tds_team1, xpts_1_team1, xpts_2_team1, saf_team1, fgs_team1, dxpts_1_team1, dxpts_2_team1];
                                if sum(combination_team1 .* [6, 1, 2, 2, 3, 1, 2]) == s1
                                    t1_combs = [t1_combs; combination_team1];
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    % Generate all possible combinations for team 2
    for tds_team2 = 0:s2/6
        for xpts_1_team2 = 0:min(tds_team2, s2 - 6*tds_team2)
            for xpts_2_team2 = 0:min(tds_team2 - xpts_1_team2, s2 - 6*tds_team2 - xpts_1_team2)
                for saf_team2 = 0:(s2 - 6*tds_team2 - xpts_1_team2 - 2*xpts_2_team2)/2
                    for fgs_team2 = 0:(s2 - 6*tds_team2 - xpts_1_team2 - 2*xpts_2_team2 - 2*saf_team2)/3
                        for dxpts_1_team2 = 0:(s2 - 6*tds_team2 - xpts_1_team2 - xpts_2_team2 - 2*saf_team2 - 3*fgs_team2)
                            for dxpts_2_team2 = 0:(s2 - 6*tds_team2 - xpts_1_team2 - xpts_2_team2 - 2*saf_team2 - dxpts_1_team2)/2
                                combination_team2 = [tds_team2, xpts_1_team2, xpts_2_team2, saf_team2, fgs_team2, dxpts_1_team2, dxpts_2_team2];
                                if sum(combination_team2 .* [6, 1, 2, 2, 3, 1, 2]) == s2
                                    t2_combs = [t2_combs; combination_team2];
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    % Calculate maximum tds_team2 from team2_combinations
    max_tds_team2 = max(t2_combs(:, 1));

    % Calculate maximum tds_team1 from team1_combinations
    max_tds_team1 = max(t1_combs(:, 1));

    % Apply filters to team1_combinations
    t1_combs = t1_combs(...
        t1_combs(:, 6) <= max_tds_team2 & ...
        t1_combs(:, 7) <= max_tds_team2 & ...
        t1_combs(:, 6) + t1_combs(:, 7) <= max_tds_team2, :);

    % Apply filters to team2_combinations
    t2_combs = t2_combs(...
        t2_combs(:, 6) <= max_tds_team1 & ...
        t2_combs(:, 7) <= max_tds_team1 & ...
        t2_combs(:, 6) + t2_combs(:, 7) <= max_tds_team1, :);
end