clear all
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex')
set(groot, 'defaultTextInterpreter','latex')
set(groot, 'defaultAxesFontsize',12)
set(groot, 'defaultTextFontsize',12)
x = zeros(1,10);
load("/home/jannis/master/master_thesis/new_algorithm/Data/SMGO_test_different_inits.mat")
%load("/home/jannis/master/master_thesis/matlab/data_dim1_optimize2_2.mat")
data_dim1_1 = data;
x(1,:) = cellfun(@min,data_dim1_1(:,2));

y = x;

fig=figure(2)
%fig.Position = [500,500, 1500,500];
yt=mean(y,2)';
std_y = std(y,[],2);

hold on
b=bar(yt,'grouped');
title('mean $$J_{opt}$$ and standard deviations','Interpreter','latex')
xtips=b.XEndPoints;
ytips=b.YEndPoints;
labels=cell(length(ytips),1);
for i = 1:length(yt)
    labels{i}=sprintf("$$%.2f \\pm %.3f$$",ytips(i),std_y(i));
end

errorbar(xtips,ytips,std_y,'k','linestyle','none');
grid on
ax = gca;
ax.Box = 'on';
set(gca,'TickLabelInterpreter','latex');
ylabel("$$J_{opt}$$ [fs]",'Interpreter','latex')
hold off
%%
% load("test_many_dim_lineBO.mat")
% data_dim1_3 = data;
y(1,:) = cell2mat(data_dim1_1(:,2));


yt=mean(y,2)';
std_y = std(y,[],2);
b=bar(yt,'grouped');
hold on
xtips=[b.XEndPoints];
ytips=[b.YEndPoints];
labels=cell(length(ytips),1);
for i = 1:length(yt)
    labels{i}=sprintf("$$%.2f \\pm %.3f$$",ytips(i),std_y(i));
end
errorbar(xtips,ytips,std_y,'k','linestyle','none');
ax = gca;
ax.Box = 'on';
ax.XTick = [1, 2 , 3];
ax.XTickLabel = {'LineBO', 'PlaneBO' 'Nelder Mead'};
grid on
hold off
%%
y=[];
y(1,:) = cellfun(@max,data_dim1_1(:,2));
%y(2,:) = cell2mat(data_dim1_2(:,3));
threshold = 50;

y=max(y);
%x=categorical({'D = 1','D = 2',});
bar(y, 'grouped')
hold on
y1=yline(threshold,'--','threshold', 'LineWidth',2);
yl.LabelHorizontalAlignment = 'left';
ax = gca;
ax.XTickLabel = "";

hold off
ylim([0 max(y)*1.05])
ylabel("$$\mbox{J}_{max}$$",'Interpreter','latex')
%%
y=[];

fig = figure(1)
%fig.Position = [0,0, 1000,500];
hold on
y = data_dim1_1(:,2);
[Y,std]=getvals(y);
X=1:length(Y);
p1=plot(X,Y,'b-',X,Y+std,'k--',X,Y-std,'k--');

title('mean $$J_{opt}$$ of lineBO applied on simulation data','Interpreter','latex')
hold off
ax = gca;
ax.Box = 'on';
grid on
set(gca,'TickLabelInterpreter','latex');
%legend("D = 1; safe","D = 1; naive", "D = 1; safe \& optimized","D = 2; safe","D = 2; naive", "D = 2; safe \& optimized",'interpreter','latex','NumColumns',2)
xlabel("iteration n","Interpreter","latex")
ylabel("$$J_{opt}(n)$$ [fs]",'Interpreter','latex')


function varargout = getvals(y)
    yt=cell(1,length(y));
    for i = 1:length(y)
        temp = y{i};
        if iscell(temp)
            temp = temp(~cellfun('isempty',temp));
            temp = temp{end};
            yt{i}=temp;
        else
            yt{i} = temp;
        end
    end
    len=max(cellfun('length',yt));
    for i = 1:length(yt)
        temp = ones(len,1)*min(yt{i});
        temp(1:length(yt{i})) = yt{i};
        for j=1:len
            yt1(i,j)=min(temp(1:j));
        end
    end
    varargout{1} = mean(yt1,1);
    if nargout == 2
        varargout{2} = std(yt1,0,1);
    end
end
