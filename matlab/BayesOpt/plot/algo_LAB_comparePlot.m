clear all
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex')
set(groot, 'defaultTextInterpreter','latex')
set(groot, 'defaultAxesFontsize',12)
set(groot, 'defaultTextFontsize',12)
set(groot, 'defaultLegendFontSize',12)

x=[];
% load('Lab_MO_Origami_dim1_random.mat')
load('Lab_MO_Origami_dim1_random.mat')
data_dim1_1 = data(:,2);
par_dim = data(:,1);
%unlocks(1) = sum(cell2mat(data(:,end)));
for i = 1:size(data_dim1_1,1)
    par_temp = par_dim{i};
    data_temp = data_dim1_1{i};
    c=cellfun("isempty",data_temp);
    par_temp = par_temp(~c);
    data_temp = data_temp(~c);
    [y(1,i),I]=min(cell2mat(data_temp(end)));
    par_temp = cell2mat(par_temp(end));
    x(end+1,:) = par_temp(I,:);
end

% load('Lab_MO_Origami_dim1_descent.mat')
load('Lab_data_dim1_descent2.mat')
data_dim1_2 = data(:,2);
par_dim = data(:,1);
%unlocks(end+1) = sum(cell2mat(data(:,end)));
for i = 1:size(data_dim1_2,1)
    par_temp = par_dim{i};
    data_temp = data_dim1_2{i};
    c=cellfun("isempty",data_temp);
    data_temp = data_temp(~c);
    par_temp = par_temp(~c);
    [y(2,i),I]=min(cell2mat(data_temp(end)));
    par_temp = cell2mat(par_temp(end));
    x(end+1,:) = par_temp(I,:);
end
% load('Lab_MO_Origami_dim2_random.mat')
load('Lab_data_dim2_random2.mat')
data_dim2_1 = data(:,2);
par_dim = data(:,1);
%unlocks(end+1) = sum(cell2mat(data(:,end)));
for i = 1:size(data_dim2_1,1)
    par_temp = par_dim{i};
    data_temp = data_dim2_1{i};
    c=cellfun("isempty",data_temp);
    data_temp = data_temp(~c);
    par_temp = par_temp(~c);
    [y(3,i),I]=min(cell2mat(data_temp(end)));
    par_temp = cell2mat(par_temp(end));
    x(end+1,:) = par_temp(I,:);
end

% data_nelder = load('Lab_data_NelderMead2.mat');
% data_nelder = data_nelder.data;
% %unlocks(end+1) = sum(cell2mat(data_nelder(:,end)));
% y(4,:) = cellfun(@min,data_nelder(:,1))';
% x(end+1:end+5,:) = cell2mat(data_nelder(:,4));

[~,I]=min(y,[],2);
I=I+[0;5;10];
x=x(I,:);

fig2=figure(2)
%fig.Position = [500,500, 1500,500];
yt=mean(y,2)';
std_y = std(y,[],2);
%std_y=std_y([1:length(std_y)/2;length(std_y)/2+1:length(std_y)]);
y=yt';
%x=categorical({'D = 1','D = 2',});
b=bar(y,'grouped');
hold on
title('mean $$J_{opt}$$ and standard deviations for all intial parameters','Interpreter','latex')
xtips=[b.XEndPoints];
ytips=[b.YEndPoints];
labels=cell(length(ytips),1);
for i = 1:length(yt)
    labels{i}=sprintf("$$%.2f \\pm %.3f$$",ytips(i),std_y(i));
end
%text(xtips(:),ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom','Interpreter','latex','FontSize',11)
% ngroups = 3;
% nbars = 2;
% x = nan(ngroups, nbars);
% for i = 1:ngroups
%     x(i,:) = b(i).XEndPoints;
% end
% Plot the errorbars
errorbar(xtips,y,std_y,'k','linestyle','none');
ax = gca;
ax.Box = 'on';
ax.XTick = 1:size(yt,2);
ax.XTickLabel = {'LineBO random','LineBO descent', 'PlaneBO random', 'Nelder Mead'};
grid on
set(gca,'TickLabelInterpreter','latex');
%hold off
ylim([0 max(yt)+1])
ylabel("$$J_{opt}$$ [fs]",'Interpreter','latex')
hold off
%%
cond_t=[
    -10 -0.31;
    -0.031 0;
    0 1.2;
    0.00001 0.21;
    -0.12 -0.0145;
    -0.00026 -0.000008
    ];

fig=figure(5);
col = ['m','b','r','g','k'];
h1=subplot(3,1,1);
pos1 = h1.Position;
title('MENHIR')
hold on
for i = 1:size(x,1)
    h(1,i)=plot(x(i,1),x(i,2),sprintf("%sx",col(i)),'MarkerSize',11);
end
xlabel("P")
ylabel("I")
xlim([-20, 0]);
ylim([-0.04,0])
grid on
hold off
h2=subplot(3,1,2);
pos2 = h2.Position;
title('LINK')
hold on
for i = 1:size(x,1)
    h(2,i)=plot(x(i,3),x(i,4),sprintf("%sx",col(i)),'MarkerSize',11);
end
xlabel("P")
ylabel("I")
xlim([0, 1.5]);
ylim([0,0.3])
grid on
hold off
h3=subplot(3,1,3);
pos3 = h3.Position;
title('ORIGAMI')
hold on
for i = 1:size(x,1)
    h(3,i)=plot(x(i,5),x(i,6),sprintf("%sx",col(i)),'MarkerSize',11);
end
xlabel("P")
ylabel("I")
xlim([-0.15, -0.01]);
ylim([-0.0003,0])
grid on
hold off
%lg=legend(h(1,:),"LineBO random", "LineBO descent", "PlaneBO random","Nelder Mead",'numColumns',2,'location','northoutside');
% lg.Position(1:2)=[0.8 0.8];
fig.Position(4) = 700;
pos1(4)=0.19;
pos2(4)=0.19;
pos3(4)=0.19;
pos1(2) = pos1(2)-0.03;
pos2(2) = pos2(2)-0.03;
pos3(2) = pos3(2)-0.03;
% pos1(1)=0.09;
% pos2(1)=0.09;
% pos3(1)=0.09;
pos1(3:4)=pos2(3:4);
set(h1,'Position',pos1)
set(h2,'Position',pos2)
set(h3,'Position',pos3)
h1.Box = 'on';
h2.Box = 'on';
h3.Box = 'on';
%fig.Position(3:4)= 1.5*fig.Position(3:4);





% fig3=figure(3)
% b=bar(unlocks,'grouped');
% ax = gca;
% ax.XTick = 1:size(unlocks,2);
% ax.XTickLabel = {'LineBO random','LineBO descent', 'PlaneBO', 'Nelder Mead'};
% grid on
% set(gca,'TickLabelInterpreter','latex');
% %hold off
% ylim([0 max(unlocks)+1])
% ylabel("$$J_{opt}$$ [fs]",'Interpreter','latex')
% hold off
%%
y=[];

fig = figure(1)
fig.Units='centimeters';
fig.Position(3:end)= [15.5,9];
%fig.Position = [0,0, 1000,500];
hold on
% y = data_dim1_1;
% [Y,std_d]=getvals(y);
% X=1:length(Y);
% p1=plot(X,Y,'r-',X,Y-std_d,'r--',X,Y+std_d,'r--')
% 
% y = data_dim1_2;
% [Y,std_d]=getvals(y);
% X=1:length(Y);
% p2=plot(X,Y,'b-',X,Y-std_d,'b--',X,Y+std_d,'b--')
% 
% y = data_dim2_1;
% [Y,std_d]=getvals(y);
% X=1:length(Y);
% p2=plot(X,Y,'y-',X,Y-std_d,'y--',X,Y+std_d,'y--')
% 
% y = data_nelder(:,1);
% [Y,std_d]=getvals(y);
% X=1:length(Y);
% p3=plot(X,Y,'g-',X,Y-std_d,'g--',X,Y+std_d,'g--')
y = data_dim1_1;
Y=getvals(y);
Yu=max(Y,[],1);
Yl=min(Y,[],1);
Y=mean(Y,1);
X=1:length(Y);
[yopt,xopt]=min(Y);
p1=plot(X,Y,'Color',[0 0.4470 0.7410],'LineWidth',1.5)
p12 = plot(X,Yu,'Color',[0 0.4470 0.7410],'LineWidth',1,'LineStyle',':')
p13 = plot(X,Yl,'Color',[0 0.4470 0.7410],'LineWidth',1,'LineStyle',':')
p11 = plot(xopt,yopt,'*','Color',[0 0.4470 0.7410],'MarkerSize',10)
y = data_dim1_2;
Y=getvals(y);
Yu=max(Y,[],1);
Yl=min(Y,[],1);
Y=mean(Y,1);
X=1:length(Y);
p2=plot(X,Y,'Color',[0.8500 0.3250 0.0980],'LineWidth',1.5)
[yopt,xopt]=min(Y);
p22 = plot(X,Yu,'Color',[0.8500 0.3250 0.0980],'LineWidth',1,'LineStyle',':')
p23 = plot(X,Yl,'Color',[0.8500 0.3250 0.0980],'LineWidth',1,'LineStyle',':')
p21 = plot(xopt,yopt,'*','Color',[0.8500 0.3250 0.0980],'MarkerSize',10)
y = data_dim2_1;
Y=getvals(y);
Yu=max(Y,[],1);
Yl=min(Y,[],1);
Y=mean(Y,1);
X=1:length(Y);
p3=plot(X,Y,'Color',[0.9290 0.6940 0.1250],'LineWidth',1.5)
[yopt,xopt]=min(Y);
p32 = plot(X,Yu,'Color',[0.9290 0.6940 0.1250],'LineWidth',1,'LineStyle',':')
p33 = plot(X,Yl,'Color',[0.9290 0.6940 0.1250],'LineWidth',1,'LineStyle',':')
p31 = plot(xopt,yopt,'*','Color',[0.9290 0.6940 0.1250],'MarkerSize',10)

% y = data_nelder;
% Y=getvals(y);
% X=1:length(Y);
% p4=plot(X,Y,'Color',[0.4940 0.1840 0.5560])
% [yopt,xopt]=min(Y);
% p41 = plot(xopt,yopt,'*','Color',[0.4940 0.1840 0.5560],'MarkerSize',10)

%title('mean $$J_{opt}$$ depending on the number of iterations n','Interpreter','latex')
hold off
%legend("D = 1; safe","D = 1; naive", "D = 1; safe \& optimized","D = 2; safe","D = 2; naive", "D = 2; safe \& optimized",'interpreter','latex','NumColumns',2)
set(gca,'TickLabelInterpreter','latex');
legend([p1,p3,p2],"LineBO Random","PlaneBO Random","LineBO Descent",'interpreter','latex','NumColumns',1,'Location','best')
xlabel("iteration $n$","Interpreter","latex")
ylabel("$$J_{opt}(n)$$ [fs]",'Interpreter','latex')
ax = gca;
ax.Box = 'on';
grid on


function [Y,std_d] = getvals(y)
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
    Y = yt1;
    std_d = std(yt1,[],1);
end
