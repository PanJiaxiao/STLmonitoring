clear;

problem = 'USA';


i = 9;
%1 2 3 4
fileload = 'USA_US101-23_1_T-1-multi-planner-simulation-result-4.mat';
load(fileload);



[up_robM, low_robM] = stl_eval_mex_pw(signal_str, phi_str, trace, tau);


signal_list = split(signal_str, ',');
num_sig = numel(signal_list);

t = trace(1, 2:50);

%% ======== signals  ======
%begin plotting
close 
f = figure(1);
subplot(2,1,1);

if startsWith(problem, 'USA')
    %[time_step,distance,a_bef_b,lan_o_1,lan_o_2]

    set(gca, 'LineWidth', 2, 'FontSize',18)
    plot(t, trace(2,2:50)', 'g', 'LineWidth', 2);
    legend('lan-o-a');
    grid on;
    xlim([0 49]);
    xticks(0:5:50);
else
    plot(t, trace(2,:)', 'm', 'LineWidth', 2);
    set(gca, 'LineWidth', 2, 'FontSize',18)
    legend({'speed'});
    grid on;
    xlim([0 30]);
    xticks(0:5:30);
end

g = title(phi_str);
set(g,'Interpreter','None')
subplot(2,1,2);
hold on;

%==================== robust ================

stairs(t(1:49), up_robM(2:50)',  'LineWidth', 2);
stairs(t(1:49), low_robM(2:50)',  'LineWidth', 2);

set(gca, 'LineWidth', 2, 'FontSize',18)
set(gcf,'position',[10,10,800,500])

if startsWith(problem, 'AFC')
    xlim([0 50]);
    xticks(0:5:50);

    ylim([-15 15]);
    yticks(-15:10:15);
  
else
    xlim([0 49]);
    xticks(0:5:49);
end


legend({'Upper robustness','Lower robustness'});
grid on;

% %=========== plain causation =================
% subplot(4,1,3);
% hold on;
% 
% stairs(t(2:end), up_plainCau(2:end)',  'LineWidth', 2);
% stairs(t(2:end), low_plainCau(2:end)',  'LineWidth', 2);
% 
% set(gca, 'LineWidth', 2, 'FontSize',18)
% set(gcf,'position',[10,10,800,500])
% if startsWith(problem, 'AFC')
%     xlim([0 50]);
%     xticks(0:5:50);
%     
%     ylim([-0.5 0.5]);
%     yticks(-0.5:0.5:0.5);
% else
%     xlim([0 30]);
%     xticks(0:5:30);
% end
% 
% legend({'violation causation (plain)','satisfaction causation (plain)'});
% grid on;

%=========== efficient causation =================
% subplot(3,1,3);
% hold on;
% 
% stairs(t(1:49), up_optCau(2:50)',  'LineWidth', 2);
% stairs(t(1:49), low_optCau(2:50)',  'LineWidth', 2);
% 
% set(gca, 'LineWidth', 2, 'FontSize',18)
% set(gcf,'position',[10,10,800,500])
% if startsWith(problem, 'AFC')
%     xlim([0 50]);
%     xticks(0:5:50);
% 
%     ylim([-15 15]);
%     yticks(-15:10:15);
% 
% else
%     xlim([0 49]);
%     xticks(0:5:49);
% end
% 
% legend({'violation causation','satisfaction causation'});
% grid on;

%%
%save2pdf('RobustOnlinePlot.pdf')   
exportgraphics(f, strcat('results/', 'Figure2b.png'),'Resolution',300)
