function drawframe_dice(f)  
    close(gcf)

    % Internal variables
    n=10;
    f=n*f;
    numSides=6;

    % Seed random generator and roll dice
    rng(1);
    rolls=randi([1,numSides],1,f);
    counts=histcounts(rolls,1:numSides+1);
    probs=counts/f;

    % Top segment of figure for histogram of dice roll frequencies
    subplot(4,1,1:3)
    bar(probs)
    %annotation('line',[.13 .91],[.585 .585],Color='r',LineStyle='--',LineWidth=2)
    annotation('line',[.13 .9],[.55 .55],Color='r',LineStyle='--',LineWidth=2)
    annotation('textbox',[.2 .4 .5 .5],'String','Expected probability is: 1/6 or 0.1667...',Color='r',FitBoxToText='on',LineStyle='none',FontSize=8)
    ylim([0 0.4])
    title(['Dice Roll Simulation - ',num2str(f),' Rolls'])

    % Bottom segment of figure for visualizing dice rolls
    subplot(4,1,4)
    text(0.5,0.7,'Current Rolls: ','FontSize',12,'HorizontalAlignment','center')
    text(0.5,0.3,char(9855+rolls(end-(n-1):end)),'FontSize',24,'HorizontalAlignment','center')
    axis off
end
