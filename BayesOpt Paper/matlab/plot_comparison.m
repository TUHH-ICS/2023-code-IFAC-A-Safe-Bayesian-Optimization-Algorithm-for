clear all
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex')
set(groot, 'defaultTextInterpreter','latex')
set(groot, 'defaultAxesFontsize',10)
set(groot, 'defaultTextFontsize',10)
set(groot, 'defaultLegendFontSize',10)


Lab = 0;


if Lab
    load(data1)
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
    
    load(data2)
    data_dim1_2 = data(:,2);
    par_dim = data(:,1);
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
    load(data3)
    data_dim2_1 = data(1:end,1);
    
    x=[];
    load(data4)
    data_dim2_2 = data(:,2);
    par_dim = data(:,1);
    for i = 1:size(data_dim2_2,1)
        par_temp = par_dim{i};
        data_temp = data_dim2_2{i};
        c=cellfun("isempty",data_temp);
        par_temp = par_temp(~c);
        data_temp = data_temp(~c);
        [y(1,i),I]=min(cell2mat(data_temp(end)));
        par_temp = cell2mat(par_temp(end));
        x(end+1,:) = par_temp(I,:);
    end

    load(data5)
    data_dim3_1 = data(:,2);
    par_dim = data(:,1);
    for i = 1:size(data_dim3_1,1)
        par_temp = par_dim{i};
        data_temp = data_dim3_1{i};
        c=cellfun("isempty",data_temp);
        data_temp = data_temp(~c);
        par_temp = par_temp(~c);
        [y(2,i),I]=min(cell2mat(data_temp(end)));
        par_temp = cell2mat(par_temp(end));
        x(end+1,:) = par_temp(I,:);
    end
    load(data6)
    data_dim3_2 = data(1:end,1);
else
    load(data1)
    data_dim1_1 = data;
    x(1,:) = cell2mat(data_dim1_1(:,2));
    load(data2)
    data_dim1_2 = data;
    x(2,:) = cell2mat(data_dim1_2(:,2));
    load(data3)
    data_dim1_3 = data;
    x(3,:) = cell2mat(data_dim1_3(:,2));
    load(data4)
    data_dim2_1 = data;
    x(4,:) = cell2mat(data_dim2_1(:,2));
    load(data5)
    data_dim2_2 = data;
    x(5,:) = cell2mat(data_dim2_2(:,2));
    load(data6)
    data_dim2_3 = data;
    x(6,:) = cell2mat(data_dim2_3(:,2));
end
%%

f_alpha = 0.2;
fig=figure(3);
fig.Units = 'centimeters';
fig.Position(3:4)=[8.4,8.4];

hold on
y = data_dim1_1(:,9);
[Y,std_Y]=getvals(y);
X=1:length(Y);
[yopt,xopt]=min(Y);
p1=plot(X,Y,'-','Color',[0 0.4470 0.7410],LineWidth=1.2)
p11 = plot(xopt,yopt,'*','Color',[0 0.4470 0.7410],'MarkerSize',10)
fill([X,flip(X,2)],[Y+std_Y,flip(Y-std_Y,2)],[0 0.4470 0.7410],'FaceAlpha',2*f_alpha,'EdgeColor','none');


% y = data_dim1_2(:,1);
% [Y,std_Y]=getvals(y);
% X=1:length(Y);
% p2=plot(X,Y,'-','Color',[0.8500 0.3250 0.0980],LineWidth=1)
% [yopt,xopt]=min(Y);
% p21 = plot(xopt,yopt,'*','Color',[0.8500 0.3250 0.0980],'MarkerSize',10)
% p22 = fill([X,flip(X,2)],[Y+std_Y,flip(Y-std_Y,2)],[0.8500 0.3250 0.0980],'EdgeColor','none');
% p22.FaceAlpha = 2*f_alpha;

y = data_dim1_3(:,9);
[Y,std_Y]=getvals(y);
X=1:length(Y);
p3=plot(X,Y,'-','Color',[0.9290 0.6940 0.1250]	,LineWidth=1.2)
[yopt,xopt]=min(Y);
p31 = plot(xopt,yopt,'*','Color',[0.9290 0.6940 0.1250]	,'MarkerSize',10)
p32 = fill([X,flip(X,2)],[Y+std_Y,flip(Y-std_Y,2)],[0.9290 0.6940 0.1250],'EdgeColor','none');
p32.FaceAlpha = 2*f_alpha;

y = data_dim2_1(:,9);
[Y,std_Y]=getvals(y);
X=1:length(Y);
p4=plot(X,Y,'--','Color','k'	,LineWidth=1.2)
[yopt,xopt]=min(Y);
p41 = plot(xopt,yopt,'*','Color','k'	,'MarkerSize',10)
p42 = fill([X,flip(X,2)],[Y+std_Y,flip(Y-std_Y,2)],'k','EdgeColor','none');
p42.FaceAlpha = f_alpha;

% y = data_dim2_2(:,9);
% Y=getvals(y);
% X=1:length(Y);
% p5=plot(X,Y,'Color',[0.4660 0.6740 0.1880]	,LineWidth=1.5)
% [yopt,xopt]=min(Y);
% p51 = plot(xopt,yopt,'*','Color',[0.4660 0.6740 0.1880]	,'MarkerSize',10)

y = data_dim2_3(:,9);
[Y,std_Y]=getvals(y);
X=1:length(Y);
p6=plot(X,Y,'--','Color','r'	,LineWidth=1.2)
[yopt,xopt]=min(Y);
p61 = plot(xopt,yopt,'*','Color','r'	,'MarkerSize',10)
p62 = fill([X,flip(X,2)],[Y+std_Y,flip(Y-std_Y,2)],'r','EdgeColor','none');
p62.FaceAlpha = f_alpha;

ylim([10,30])
hold off
grid on
xlim([0,1000])
ylim([10,35])
ax = gca;
set(gca,'TickLabelInterpreter','latex');
xlabel("iteration $n$","Interpreter","latex")
ylabel("$$J_{opt}(n)$$ [fs]",'Interpreter','latex')
l1=legend([p1,p3],'SafeOpt','MoSaOpt','Interpreter','latex','NumColumns',1,'Location','Northeast','fontsize',8);
title(l1,'LineBO +','Interpreter','latex')
a=axes('Position',get(ax,'position'),'visible','off');
ax.Box = 'on';
l2 = legend(a,[p4,p6],'SafeOpt','MoSaOpt','Interpreter','latex','NumColumns',1,'fontsize',8);
title(l2,'PlaneBO + ','Interpreter','latex')
l2.Units='centimeters';
l1.Units='centimeters';
l2.Position(1:2)=[l1.Position(1)-3,l1.Position(2)];


function [Y,std_y] = getvals(y)
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
    Y = mean(yt1,1);
    std_y = std(yt1,0);
end
