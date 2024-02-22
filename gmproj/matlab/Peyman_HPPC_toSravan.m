clear all; close all;
set(groot,'defaultAxesXGrid','on')
set(groot,'defaultAxesYGrid','on')

for HP_i=1:21

R1=[];tau1_hat=[];R2=[];Rs=[];tau2_hat=[];exitflag=[];


    if HP_i<10
    data=readmatrix("C:\Users\pansr\Documents\Research\PyBaMM\gmproj\data\hppc\hppc_data_cell_0" + num2str(HP_i)+".csv");
    else 
    data=readmatrix("C:\Users\pansr\Documents\Research\PyBaMM\gmproj\data\hppc\hppc_data_cell_" + num2str(HP_i)+".csv");
    
    end


Time0=data(:,1); I0=data(:,2); Vt0=data(:,3);  %current(mA)
freq=data(:,4); mag=data(:,5); Phase=data(:,6); R_Re=data(:,7); R_Im=data(:,8);
Temp=data(:,9); Q_Ah=data(:,10); Cyc_num=data(:,11); Thru=data(:,12);

[Init,Endit]=Dis_relax_time(data);

options = optimset('TolX',1e-20,'TolFun',1e-20,'MaxIter',1e5, 'MaxFunEvals', 1e5);

Cyc_uniq=unique(Cyc_num);
%% Each set
for jj=1:length(Cyc_uniq)
    Time=Time0(Cyc_num==Cyc_uniq(jj));
    I=I0(Cyc_num==Cyc_uniq(jj));
    Vt=Vt0(Cyc_num==Cyc_uniq(jj));

    %% Each step discharge
    for ii=1:size(Endit,2)
   HP_i
    ii
    jj
    Time1=Time(Time>Init(jj,ii) & Time<Endit(jj,ii));
    I1=I(Time>Init(jj,ii) & Time<Endit(jj,ii));
    Vt1=Vt(Time>Init(jj,ii) & Time<Endit(jj,ii));
    %
    tau_c=0;
    fun = @(x)Jerror(x,Vt1,Time1,tau_c,I1);
    [X_hat, fval,exitflag(jj,ii)]=fminsearch(fun,[20,10,500,10,10],options);   %R=R*1000
    if exitflag(jj,ii)==0
        [X_hat, fval,exitflag(jj,ii)]=fminsearch(fun,[20,5,1000,20,20],options);   %R=R*1000
    end
    %% recreating
    tau1_hat(jj,ii)=X_hat(1);
    R1(jj,ii)=X_hat(2);
    tau2_hat(jj,ii)=X_hat(3);
    R2(jj,ii)=X_hat(4);
    Rs(jj,ii)=X_hat(5);
    aI=-1*I1(1)/1000;
    I12= (I1-I1(1))/1000;
    y=[];
    for k=1:length(Time1)
        y(k)=Vt1(1)+Rs(jj,ii)*I12(k)/1000....
                +aI*R1(jj,ii)/1000*(1-exp(-(Time1(k)-Time1(1))/tau1_hat(jj,ii)))...
                +aI*R2(jj,ii)/1000*(1-exp(-(Time1(k)-Time1(1))/tau2_hat(jj,ii)));    
    end
    RMSEE(jj,ii)=sqrt(fval/length(Time1));
    end
end
Rtot=R1+R2+Rs;
% Swap
A_in=find(tau1_hat>tau2_hat);
temp=tau1_hat;
temp2=R1;
tau1_hat(A_in)=tau2_hat(A_in);
R1(A_in)=R2(A_in);
tau2_hat(A_in)=temp(A_in);
R2(A_in)=temp2(A_in);

%% Nan;
tau1_hat(exitflag==0)=NaN;tau2_hat(exitflag==0)=NaN;
R1(exitflag==0)=NaN; R2(exitflag==0)=NaN; Rs(exitflag==0)=NaN;
Rtottau2_hat(exitflag==0)=NaN;

%%
cell_str = num2str(HP_i,'%02.f');
file_name = strcat('r_rc/r_rc_data_cell_',cell_str,'.mat');
save(file_name,"Rs","R1","R2","tau1_hat","tau2_hat","RMSEE")

% close all
end


%%
function plt_lgnd(Cyc_uniq)
strings={};
for i=1:2:length(Cyc_uniq)
    strings=[strings, {"Cycle:"+num2str(Cyc_uniq(i))}];
end
legend(strings)
end
%}
function ax= plot_gca(newcolors)
set(gcf,'DefaultAxesColorOrder', newcolors,...
        'DefaultAxesLineStyleOrder',{'-','--',':','-.'})
ax = gca; 
end

function y= Jerror(x,Vt,Time,tau_coef, I1)
tau1_hat=x(1);
R1=x(2);
tau2_hat=x(3);
R2=x(4);
Rs=x(5);

aI=-1*I1(1)/1000;
I12= (I1-I1(1))/1000;

y=barrierPenalty(tau1_hat,0,5000,10,0);
y=y+barrierPenalty(tau2_hat,0,5000,10,0);
%  y=y+barrierPenalty(tau2_hat-tau_coef*tau1_hat,0,2000,10,0);  % tau2>coef*tau1
y=y+barrierPenalty(Rs,0,1e3,10,0);   %R=R*1000   %Rs>0
y=y+barrierPenalty(R1,0,1e3,10,0);   %R=R*1000 
y=y+barrierPenalty(R2,0,1e3,10,0);   %R=R*1000  %R2>0
    for k=1:length(Time)
        y=y+(Vt(k)-Vt(1)-Rs*I12(k)/1000....
            -aI*R1/1000*(1-exp(-(Time(k)-Time(1))/tau1_hat))...
            -aI*R2/1000*(1-exp(-(Time(k)-Time(1))/tau2_hat)))^2;
    
    end
end
