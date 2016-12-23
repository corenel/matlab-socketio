function [Time_stamp, Level_1, Level_2] = sim_tank_2 (mdl,paramNameValStruct)
    % Run sim
    simOut = sim(mdl,paramNameValStruct);

    % Get data
    Time_stamp = simOut.get('tout');
    Level_1  = simOut.get('yout').get('L1').Values;
    Level_2  = simOut.get('yout').get('L2').Values;

    % Plot and save
    % plot(Level_1); hold on;
    % plot(Level_2);
    % title('Level States')
    % xlabel('Time');
    % legend('x1','x2')
    % saveas(gcf,'sim.png')
end
