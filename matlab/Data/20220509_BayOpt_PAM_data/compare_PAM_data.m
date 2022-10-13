clear all
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex')
set(groot, 'defaultTextInterpreter','latex')
set(groot, 'defaultAxesFontsize',15)
set(groot, 'defaultTextFontsize',15)
set(groot, 'defaultLegendFontSize',14)

new_data_str = load("matlab/own_lab/20220509_BayOpt_PAM_data/20220509_PAM_data_BayOpt/intraTrainStdDev.mat");
new_measData = new_data_str.intraTrainStdDev;
new_trainId = load("matlab/own_lab/20220509_BayOpt_PAM_data/20220509_PAM_data_BayOpt/trainId.mat");
new_trainId = new_trainId.trainId;
old_data_str = load("matlab/own_lab/20220509_BayOpt_PAM_data/data_measurement/XFEL_PAM_measurement_corrected.mat");
old_measData = old_data_str.data;
old_trainIdTemp = old_measData{5};
old_trainId = zeros(1,length(old_trainIdTemp));
for i = 1:length(old_trainIdTemp)
    t = old_trainIdTemp{i};
    k=strfind(t,'_');
    old_trainId(i) = str2double(t(k(end)+1:k(end)+10));
end

k = 1;
newData= zeros(100,length(old_trainId));
x_new=[];
for i = 1:length(old_trainId)
    k=find(old_trainId(i)<=new_trainId);
    k = k(1);
    newData(:,i)=new_measData(k-99:k);
    x_new(end+1)=new_trainId(k);
end

newData=mean(newData,1);
fig=figure(1);
p1=plot(x_new,newData);
y=old_measData{1,2}{10,1};
hold on
p2=plot(old_trainId,y);
k=find(old_trainId(1)<=new_trainId(1:end));
k=k(1);
c=floor((length(new_measData)-k+99) / 100);
new_measData2=reshape(new_measData(k-99:k-99+(c)*100-1),[100,c]);
x2 = new_trainId(k-99:100:k-99+c*100-1);
% plot(x2,mean(new_measData2,1))

grid on
load("matlab/own_lab/20220509_BayOpt_PAM_data/data_measurement/XFEL_PAM_measurement_corrected.mat")
Y=data{1,2};
id=~cellfun(@isempty,Y);
Y=Y(id);
X=data{1,1};
X=X(id);
xt = zeros(length(Y),10);
yt = zeros(length(Y),1);
id = zeros(size(yt));
ax = gca(fig);
y_vert=ax.YLim(1):ax.YLim(2);
for i = 1:length(Y)
    y_t = Y{i};
    x_t = X{i};
    l = old_trainId(length(y_t));
    p4=plot(l*ones(size(y_vert)),y_vert,'k--');
    [yt(i),id(i)]=min(y_t);
    xt(i,:) = x_t(id(i),:);
end
p3=plot(old_trainId(id),yt,'k*');
legend([p1,p2,p3,p4],"BAM1932M new Data (11.06.22)", "PAM old data (09.05.22)","Subspace Optimum", "Subspace transition")
hold off

fig2=figure(2);
% for i = 100:length(new_measData)  
%     mean_newMeas(i) = mean(new_measData(i-99:i));
% end
% plot(new_trainId,mean_newMeas)
ids_start = [1373624810
        1373624883
        1373625043
        1373625203
        1373625363
        1373625523];

ids_opt = [1373623283
        1373623443
        1373623603
        1373623763
        1373623923
        1373624083
        1373624243
        1373624403
        1373624563
        1373624723];
id_start = find(new_trainId > ids_start(1) & new_trainId < ids_start(end));
id_opt = find(new_trainId > ids_opt(1) & new_trainId < ids_opt(end));

id=find(new_trainId==old_trainId(end));
x2=new_trainId(id+1:end);
y2=new_measData(id+1:end);
plot(x2,y2)
y3=reshape(y2(1:6100),[100,61]);
x3=x2(99:100:6100);
y3=mean(y3,1);
hold on
plot(x3,y3)
id2(1)=id+(4*60)*10;
id2(2)=id2(1)+100+(2*60+50)*10;
id2(3)=id2(2)+100+(60+20)*10;
%id2(4)=id2(3);
ax = gca(fig2);
y_vert=ax.YLim(1):ax.YLim(2);
plot(new_trainId(id2)'.*ones(size(y_vert)),y_vert,'k--')
hold off

id=find(new_trainId<old_trainId(19));

dist1 = new_measData(id_opt(1)+10:id_opt(end)-10);
%dist1 = [new_measData(id2(1):id2(2)-150),new_measData(id2(3):end)];
dist2 = new_measData(id_start(1)+10:id_start(end)-10);
%dist2 = new_measData(1:id(end));

x = linspace(0,35,1000);
gamma_opt = fitdist(dist1',"Lognormal");
gamma_start = fitdist(dist2',"Lognormal");
pdf_opt = pdf(gamma_opt,x);
pdf_start = pdf(gamma_start,x);
figure(3)
histogram(dist1,20,'Normalization','pdf')
hold on
histogram(dist2,20,'Normalization','pdf')
plot(x,pdf_opt,'b-','LineWidth',1.5)
plot(x,pdf_start,'r-','LineWidth',1.5)
legend("$J_{opt}$","$J_{0}$","pdf $J_{opt}$","pdf $J_{0}$",'NumColumns',2)
xlim([0 35]);
hold off
%%
in_dir = "/home/jannis/master/master_thesis/matlab/own_lab/20220509_BayOpt_PAM_data/20220509_pam_data";
load("/home/jannis/master/master_thesis/matlab/own_lab/20220509_BayOpt_PAM_data/data_measurement/XFEL_PAM_measurement_corrected.mat")

data_name = data{1,5};
fileInfo = dir(in_dir);
files = {fileInfo.name};
files = files(3:end);
id=strfind(files,'_');
arr = zeros(length(id),1);
for i = 1:length(id)
    temp_id = id{i};
    temp = files{i};
    arr(i) = str2double(temp(temp_id(end)+1:end-4));
end
[~,I] = sort(arr);
last_data = data_name{end};
id=strfind(last_data,'_');
id = str2double(last_data(id(end)+1:end-4));
loca = find(arr>id);
loca = loca(1);
num = length(arr)-loca;
rem_data=zeros(100*num,1);
for i = loca:length(arr)
    rem_data((i-loca)*100+1:(i-loca+1)*100)=std(readPAM(in_dir+"/"+files{I(i)}),1,2);
end

id_start = find(arr(loca:end) > ids_start(1) & arr(loca:end) < ids_start(end));
id_opt = find(arr(loca:end) > ids_opt(1) & arr(loca:end) < ids_opt(end));

fig4=figure(4);
id2(1)=(4*60)*10;
id2(2)=id2(1)+100+(2*60+50)*10;
id2(3)=id2(2)+100+(60+20)*10;

% count = 143:164;
% val = zeros(length(count),100);
% for i = count
%     val(i-count(1)+1,:)=rms(readPAM(in_dir+"/"+files{I(i)}),2)';
% end
% val2_start=val;

dist1 = [rem_data(id2(1):id2(2)-150);rem_data(id2(3):end)];
dist2 = rem_data(id2(2):id2(3)-150);
dist2 = val2_start(:);

dist1 = rem_data((id_opt(1)+1)*100:(id_opt(end)-1)*100);
%dist2 = rem_data((id_start(1)+1)*100:(id_start(end)-1)*100);

histogram(dist1,20,'Normalization','pdf')
hold on
histogram(dist2,20,'Normalization','pdf')

x = linspace(0,35,1000);
gamma_opt = fitdist(dist1,"Lognormal");
gamma_start = fitdist(dist2,"Lognormal");
pdf_opt = pdf(gamma_opt,x);
pdf_start = pdf(gamma_start,x);
plot(x,pdf_opt,'b-','LineWidth',1.5)
plot(x,pdf_start,'r-','LineWidth',1.5)
legend("$J_{opt}$","$J_{0}$","pdf $J_{opt}$","pdf $J_{0}$",'NumColumns',2)
xlim([0 35]);
hold off
xlabel("$J$ [fs]")
ylabel("$\phi(J)$")

fig5 = figure(5);
gammaOpt_cdf = cdf(gamma_opt,x);
gammaInit_pdf = pdf(gamma_start,x);
int1_=trapz(x,gammaOpt_cdf.*gammaInit_pdf);
int1_ = round(int1_,2);
bar(int1_)
text(1,int1_,num2str(int1_),"HorizontalAlignment","center", "VerticalAlignment","bottom")
ylim([0,1.2])

