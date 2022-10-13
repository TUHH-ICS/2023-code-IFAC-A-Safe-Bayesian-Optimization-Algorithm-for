clear all
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex')
set(groot, 'defaultTextInterpreter','latex')
set(groot, 'defaultAxesFontsize',15)
set(groot, 'defaultTextFontsize',20)
set(groot, 'defaultLegendFontSize',15)


% load('Lab_MO_Origami_dim1_descent.mat');
% load('Lab_data_dim1_random2.mat')

%load("/home/jannis/master/master_thesis/matlab/own_lab/20220509_BayOpt_PAM_data/data_measurement/XFEL_PAM_measurement_corrected.mat")
load("BAM_data.mat")
id=~cellfun(@isempty,data{1,2});
Y=data{1,2};
Y=Y(id);
X=data{1,1};
X=X(id);

n=16;
yt = data{1,2}{n,1};
xt = data{1,1}{n,1};
o = data{1,2}{n-1,1};
yt2=data{1,2}{n,1};

% cond_t=[
%     -10 -0.31;
%     -0.031 0;
%     0 1.2;
%     0.00001 0.21;
%     -0.12 -0.0145;
%     -0.00026 -0.000008
% %     ];
% cond_t=[
%     -19.7 -0.31;
%     -0.031 0;
%     0 1.2;
%     0.00001 0.21;
%     -0.12 -0.0145;
%     -0.00026 -0.000008
%     ];
% cond_t=[
%     -1.7 -0.37;
%     -0.005 -0.0002;
%     0 0.8;
%     0.0001 0.06;
%     0.05 10;
%     0.0005 0.05;
%     -0.11 0;
%     -0.025 -0.00001;
%     -0.25 -0.01
%     -0.0006 -0.00001 
%     ];
cond_t=[
    -1.7 -0.37;
    -0.005 -0.0002;
    0 0.8;
    0.0001 0.06;
    0.05 10;
    0.0005 0.05;
    -5 0;
    -0.16 -0.0001
    ];
for i = 1:size(xt,1)
    xt(i,:)=backwardCoordTransf(cond_t,xt(i,:));
    xt(i,:)=forwardCoordTransf(cond_t,xt(i,:),1);
end
% for i = 1:length(yt)
%     xt(i,:)=forwardCoordTransf(cond_t,xt(i,:));
% end
cond = repmat([-1,1],size(cond_t,1),1);


inf_ = {@infGaussLik};
mean_ = {@meanConst};
lik_ = {@likGauss};
cov_ = {@(varargin)covMaternard(3,varargin{:})};
hyp.mean = [5];
hyp.lik = log(2);
hyp.cov = log([(cond(:,2)-cond(:,1))/7; 10]);
acq = {@EI};
algo_data.start = size(o,1);
l = data{1,3};
algo_data.l = l(n,1)
[~,id]=min(yt2(1:algo_data.start));
algo_data.x_vec = xt(id,:); 
opts.plot = 1;
opts.termCondAcq = .005;
opts.samples = 1e2;
opts.safeOpt = 0;
opts.newSafeOpt = 0;
opts.minFunc.mode=2;

hyp = gpTrain(hyp,inf_,mean_,cov_,lik_,xt,yt,opts,[]);
plot_post(hyp,inf_,mean_,cov_,lik_,xt,yt,build_testP(cond(algo_data.l,:),opts.samples),algo_data,opts)


function Xs=build_testP(cond, samples)
    D = size(cond,1);
    xs=zeros(samples,D);
    for i=1:D
        xs(:,i)=linspace(cond(i,1),cond(i,2),samples);
    end
    n = size(xs,1);
    if D==2
        Xs = zeros(n^D,D);
        for i=1:n
            if mod(i,2)==0
                Xs((i-1)*n+1:i*n,2)=flip(xs(:,2));
            else
                Xs((i-1)*n+1:i*n,2)=xs(:,2);
            end
            Xs((i-1)*n+1:i*n,1)=ones(n,1)*xs(i,1); 
        end
    else 
        Xs=xs;
    end
end

function plot_post(hyp,inf_,mean_,cov_,lik_,xt,yt,xs,algo_data,opts)
    start = algo_data.start;
    l = algo_data.l;
    D = length(l);
    if size(xt,2) ~= D
        x_vec = repmat(algo_data.x_vec,[size(xs,1),1]);
        x_vec(:,l) = xs;
        xs = x_vec;
    end
    [mu,var,~,~] = gp(hyp,inf_,mean_,cov_,lik_,xt,yt,xs);
    se = 2*sqrt(var);
%     mu = zeros(size(xs));
%     se = 2*ones(size(xs));
    if D == 2
        fig=figure(2);
        plot3(xs(:,l(1)),xs(:,l(2)),se+mu,xs(:,l(1)),xs(:,l(2)),-se+mu)
        %fill3([Xs(:,1);flip(Xs(:,1))],[Xs(:,2);flip(Xs(:,2))],[se+mu;flip(-se+mu,1)],[9 9 9]/10)
        hold on
        %plot(xs,mu)
        plot3(xt(start:end-1,l(1)),xt(start:end-1,l(2)),yt(start:end-1),'k*', 'MarkerSize',10)
        plot3(xt(end,l(1)),xt(end,l(2)),yt(end,:),'k*','Color','g', 'MarkerSize',20)
        xlabel Kp
        ylabel Ki
%         if any(yt > 150)
%             zlim([0,150])
%         end
        hold off
    else
         fig=figure(2);
         fig.Position(3:4) = [560,420];
        if opts.safeOpt
            se = opts.acqFunc.beta*sqrt(var);
            s = sprintf("$$%d%ssigma$$ confidence",opts.acqFunc.beta,"\");
        else
            s = "$$2\sigma$$ confidence";
        end
        p1 = fill([xs(:,l);flip(xs(:,l),1)],[se+mu;flip(-se+mu,1)],[9 9 9]/10);
        hold on
        p2 = plot(xs(:,l),mu, 'Color','r');
        %title('Posterior','Interpreter','latex')
        %p3 = plot(xt(end,l),yt(end),'k*','Color','r', 'MarkerSize',15);
%         [yopt,I]=min(yt);
% 
%         T = 1;
%         algo_data.f=@(x) 0.3375*x.^3-2.7125*x.^2+5.325*x-1.0;
%         f = algo_data.f(xs);
%         p4 = plot(xs,f,'k-.');
%           
%         S = xs(se+mu < T);
%         [u_max,I] = min(se+mu);
%         y_vert = T:0.1:T+2;
%         M = xs(mu-se <= u_max & se + mu < T);%-se(I)+mu(I) & se+mu<T);
%         p5 = plot(S(3:end-2),ones(length(S)-4,1)*T+0.5,'gs','MarkerFaceColor','g');
%         if length(M)>10
%             p6=plot(M(3:end-2),ones(size(M(3:end-2,1)))*T+1.5,'rs','MarkerFaceColor','r');
%         else
%             p6=plot(M(2:end-1),ones(size(M(2:end-1,1)))*T+1.5,'rs','MarkerFaceColor','r');
%         end
%         p7 = plot(S([3,end-2]),ones(2,1)*T+1,'bs','MarkerFaceColor','b');
% 
%         plot(S(1)*ones(size(y_vert)),y_vert,'k:',S(end)*ones(size(y_vert)),y_vert,'k:');
        if opts.safeOpt
            yline(opts.safeOpts.threshold,'--','threshold','LineWidth',2);
        end
         %yline(yopt,'b:',"$f_n^*$",'Interpreter','latex',"FontSize",15,"LineWidth",1.5)
        if start < size(xt,1)
            p8 = plot(xt(start:end,l),yt(start:end),'k*', 'MarkerSize',10);
            legend([p1,p2,p8],s,"mean","test point", "Interpreter",'latex', 'location', 'northoutside','NumColumns',4,"FontSize",14) %"target function",'$$\mathcal{S}$$','$$\mathcal{M}$$','$$\mathcal{G}$$',
        else
           legend([p1,p2],s,"mean","test point", "Interpreter",'latex', 'location', 'northoutside','NumColumns',4,"FontSize",14) %"target function",'$$\mathcal{S}$$','$$\mathcal{M}$$','$$\mathcal{G}$$',
        end
        
        xlabel('$$x_*$$','interpreter','latex',"FontSize",15)
        ylabel('$J(x_*)$','interpreter','latex',"FontSize",15)
        set(gca,'TickLabelInterpreter','latex');
        hold off
        %ylim([9,17]);
        %exportgraphics(fig,"plots/"+sprintf('post_Safe_Nr_%d.pdf',length(xt)),"ContentType","vector")
        %pause(2)
    end
end