%Andrew degradation calculation
% clearvars -except partt
clear
close all
load("param41.mat")
partt=param41;
% close all

set(groot,'defaultAxesXGrid','on')
set(groot,'defaultAxesYGrid','on')

%%
% 
% discharge_list=["",...                          
% "GMJuly2022_CELL016_RPT_3_P25C_5P0PSI_20230103_R0_CH039_20230103170220_36_2_4_2818579475_DISCHARGE.csv",...
% "GMJuly2022_CELL016_RPT_3_P25C_5P0PSI_20230213_R0_CH012_20230213130718_36_2_4_2818579481_DISCHARGE.csv",...
% "GMJuly2022_CELL016_RPT_3_P25C_5P0PSI_20230309_R0_CH012_20230309091051_36_2_4_2818579483_DISCHARGE.csv",...
% "GMJuly2022_CELL016_RPT_3_P25C_5P0PSI_20230404_R0_CH012_20230404091003_36_2_4_2818579492_DISCHARGE.csv",...
% "GMJuly2022_CELL016_RPT_3_P25C_5P0PSI_20230501_R0_CH012_20230501123929_36_2_4_2818579504_DISCHARGE.csv",...    
% ];

% discharge_list=["",...
%     "GMJuly2022_CELL088_RPT_4B_1_P25C_5P0PSI_20221007_R0_CH014_20221007162958_36_2_6_2818579453_DISCHARGE.csv",...
%     "GMJuly2022_CELL088_RPT_1_P25C_5P0PSI_20221114_R0_CH014_20221115071211_36_2_6_2818579467_DISCHARGE.csv",...
%     "GMJuly2022_CELL088_RPT_3_P25C_5P0PSI_20221213_R0_20221213155616_36_2_6_2818579473_DISCHARGE.csv",...
%     "GMJuly2022_CELL088_RPT_3_P25C_5P0PSI_20230213_R0_CH014_20230213130510_36_2_6_2818579480_DISCHARGE.csv",...
%     "GMJuly2022_CELL088_RPT_3_P25C_5P0PSI_20230331_R0_CH014_20230331114523_36_2_6_2818579490_DISCHARGE.csv",...
%     "GMJuly2022_CELL088_RPT_3_P25C_5P0PSI_20230519_R0_CH014_20230519143056_36_2_6_2818579508_DISCHARGE.csv"];

% discharge_list=["",...
%     "GMJuly2022_CELL081_RPT_1_P25C_5P0PSI_20221007_R0_CH018_20221007163459_36_3_2_2818579454_DISCHARGE.csv",...
%     "GMJuly2022_CELL081_RPT_1_P25C_5P0PSI_20221114_R0_CH018_20221115071355_36_3_2_2818579467_DISCHARGE.csv",...
%     "GMJuly2022_CELL081_RPT_3_P25C_5P0PSI_20221214_R0_CH018_20221214161546_36_3_2_2818579474_DISCHARGE.csv",...
%     "GMJuly2022_CELL081_RPT_3_P25C_5P0PSI_20230213_R0_CH018_20230213133903_36_3_2_2818579480_DISCHARGE.csv"];

discharge_list=["",...
    "GMJuly2022_CELL041_RPT_1_P25C_5P0PSI_20221007_R0_CH017_20221007163327_36_3_1_2818579453_DISCHARGE.csv",...
    "GMJuly2022_CELL041_RPT_1_P25C_5P0PSI_20221115_R0_CH017_20221115071316_36_3_1_2818579467_DISCHARGE.csv",...
    "GMJuly2022_CELL041_RPT_3_P25C_5P0PSI_20221214_R0_CH017_20221214161410_36_3_1_2818579474_DISCHARGE.csv",...
    "GMJuly2022_CELL041_RPT_3_P25C_5P0PSI_20230213_R0_CH017_20230213133637_36_3_1_2818579480_DISCHARGE.csv",...
    "GMJuly2022_CELL041_RPT_3_P25C_5P0PSI_20230331_R0_CH017_20230331115026_36_3_1_2818579490_DISCHARGE.csv"];

Cn_intial_39=[4.47, 4.37, 4.28, 4.26, 4.25];
C_39=[3.54, 3.47, 3.4, 3.36, 3.33];

% Cn_initial_39=
Xi=[.0;3.7;0.82;4.00;5;0;0];

% Xi=[0.2;4.5;1;3.5];
%%
Xt2=zeros(7,2);
%%
Xt2(:,1)=Xi;
% 
for i=2:length(discharge_list)
data=readmatrix(discharge_list{i});
% data=readmatrix(charge_list{i});

Dis(i).Q=data(2:end,5); Dis(i).V=data(2:end,4);
% Dis(i).Q=data(2:end,2); Dis(i).V=data(2:end,3);

Dis(i).Q=max(Dis(i).Q)-Dis(i).Q;
tempQ=Dis(i).Q; tempV=Dis(i).V;
Dis(i).Q=Dis(i).Q(tempV>=2.65 & tempQ>.01);
Dis(i).V=Dis(i).V(tempV>=2.65 & tempQ>.01);
Dis(i).Q=Dis(i).Q-Dis(i).Q(end);

%% Create RRC voltage
clear Time t aa yout
Cell_table=readtable(discharge_list{i});
aI=0.175;
Date=Cell_table(tempV>=2.65 & tempQ>.01,2);
aa=Date{:,1};
Dis(i).t=datetime(aa,'InputFormat','yyyy-MM-dd HH:mm:ssXXXX','TimeZone','America/New_York');
Dis(i).days=Dis(i).t;
Dis(i).t=Dis(i).t-Dis(i).t(1);
Dis(i).Time=seconds(Dis(i).t);

R1=partt(i).R1; R2=partt(i).R2; Rs=partt(i).RS;
tau1_hat=partt(i).tau1_hat; tau2_hat=partt(i).tau2_hat;

for k=1:length(Dis(i).Time)
    Dis(i).yout(k)=Rs*aI ...
             +aI*R1*(1-exp(-(Dis(i).Time(k))/tau1_hat))...
             +aI*R2*(1-exp(-(Dis(i).Time(k))/tau2_hat));

end

% figure(25); plot(Dis(i).Time,Dis(i).yout);
%%


% IC_con=Xt2(:,i-1);
IC_con=Xi(1:4);

% IC_con(4)=Cn_intial_04(i-1);
% IC_con(3)=C_91(i-1)/Cn_intial_39(i-1)+.02;

% [Xt2(:,i),fval2(i)] = diagnostics_GMJuly22_ch(Dis(i).Q,Dis(i).V,Xi,Xt2(:,i-1))
[Xt2(1:4,i),fval2(i)] = diagnostics_GMJuly22_Dischargeonly_july4_csm(Dis(i).Q,Dis(i).V+Dis(i).yout',Xi(1:4),IC_con)
faval_rmse(i)=sqrt(fval2(i)/length(Dis(i).Q));

% 
Qtot2(i)=max(Dis(i).Q);

Dis(i).V_tt =NMC622_discharge_June15(Xt2(1,i)+Dis(i).Q/Xt2(2,i))-Un_Graphite_Andrew_top(Xt2(3,i)-Dis(i).Q/Xt2(4,i));
% Dis(i).V_tt =Up_NMC622_notshifted(Xt2(1,i)+Dis(i).Q/Xt2(2,i))-Un_Graphite(Xt2(3,i)-Dis(i).Q/Xt2(4,i));
% Dis(i).V_tt =Up_NMC622_man_shifted(Xt2(1,i)+Dis(i).Q/Xt2(2,i))-Un_Graphite(Xt2(3,i)-Dis(i).Q/Xt2(4,i));

Xt2(5,i)=Qtot2(i);
Xt2(6,i)=Xt2(1,i)+Qtot2(i)/Xt2(2,i);
Xt2(7,i)=Xt2(3,i)-Qtot2(i)/Xt2(4,i);


% figure(2);hold on; plot(Dis(i).Q,Dis(i).V+Dis(i).yout',LineWidth=2);
%  plot(Dis(i).Q,Dis(i).V_tt,":k")

 % plot(max(Dis(i).Q)-Dis(i).Q,Dis(i).V_tt,":k",LineWidth=2)


%% DVDQ

%Using RRC corredcted voltage for dvdq
Dis(i).VRRC_correc=Dis(i).V+Dis(i).yout';

[Dis(i).Quniq,ia,ic]=unique(Dis(i).Q);
Dis(i).Vuniq=Dis(i).V(ia);
Dis(i).Vcor_uniq=Dis(i).VRRC_correc(ia);

dQ=5e-3;
Dis(i).Qint=0:dQ:3.6;
Dis(i).Vint_unfitered=interp1(Dis(i).Quniq,Dis(i).Vuniq,Dis(i).Qint);
Dis(i).Vcor_int=interp1(Dis(i).Quniq,Dis(i).Vcor_uniq,Dis(i).Qint);

% 
num_no_nans(i) = sum(~isnan(Dis(i).Vint_unfitered)); 
Num_of_nans(i)=length(Dis(i).Vint_unfitered)-num_no_nans(i);

% Dis(i).Vint=lowpass(Dis(i).Vint_unfitered(1:num_no_nans(i)),1/1/dQ,1/dQ);
Dis(i).Qnnan=Dis(i).Qint(1:num_no_nans(i));
Dis(i).Vnnan=Dis(i).Vint_unfitered(1:num_no_nans(i));

Dis(i).Vno_nan=Dis(i).Vint_unfitered(~isnan(Dis(i).Vint_unfitered));
Dis(i).Vno_nan_cor=Dis(i).Vcor_int(~isnan(Dis(i).Vcor_int));

Dis(i).Qno_nan=Dis(i).Qint(~isnan(Dis(i).Vint_unfitered))

Frameleng=21;
[b,g] = sgolay(5,Frameleng);

Dis(i).V_SG= sgolayfilt(Dis(i).Vno_nan_cor,5,Frameleng);


for j=1+5:num_no_nans(i)-5
      Dis(i).Vint= Dis(i).V_SG;  

    Dis(i).dvdq(j)= [-2, +25, -150, 600, -2100, 0, 2100, -600, 150, -25, 2]/2520*...
       [Dis(i).Vint(j-5); Dis(i).Vint(j-4); Dis(i).Vint(j-3);Dis(i).Vint(j-2);Dis(i).Vint(j-1);Dis(i).Vint(j);...
       Dis(i).Vint(j+1);Dis(i).Vint(j+2);Dis(i).Vint(j+3);Dis(i).Vint(j+4);Dis(i).Vint(j+5)]/dQ ;
end

Dis(i).dvdq_filtered=Dis(i).dvdq;


Dis(i).yout_uniq=Dis(i).yout(ia);

weight_error=zeros(1,length(Dis(i).dvdq(Frameleng:num_no_nans(i)-Frameleng)));
weight_error(Frameleng:end-Frameleng)=1;

[Dis(i).Vmodel, Dis(i).dvdqmodel]=model_V_dvdq(Xt2(1:4,i), Dis(i).Qnnan',Dis(i).Vnnan',Dis(i).dvdq);


Dis(i).yout_interp=interp1(Dis(i).Quniq, Dis(i).yout_uniq, Dis(i).Qnnan);

figure(i);
hold on;
plot(Dis(i).Qnnan(Frameleng:end-Frameleng-5), Dis(i).dvdqmodel(Frameleng:end-Frameleng));
plot(Dis(i).Qnnan(Frameleng:end-Frameleng-5), Dis(i).dvdq(Frameleng:end-Frameleng));
legend("model", "data")


figure(i+10);
hold on;
plot(Dis(i).Qnnan,flipud(Dis(i).Vmodel)'-Dis(i).yout_interp);
plot(Dis(i).Qnnan,Dis(i).Vnnan);
legend("model", "data")

Dis(i).error_dvdq=weight_error.*(Dis(i).dvdq(Frameleng:num_no_nans(i)-Frameleng)-Dis(i).dvdqmodel(Frameleng:num_no_nans(i)-Frameleng));
Dis(i).error_V=Dis(i).Vnnan-flipud(Dis(i).Vmodel)'+Dis(i).yout_interp;

rmseV(i)=rms(Dis(i).error_V);
rmsedVdQ(i)=rms(Dis(i).error_dvdq);







end
%%
 cycles=[1;2;3;4;5];

TOCSV=["Cycle",     "x_0",          "y_0",         "x_100",       "y_100","C_n","C_p","Cap", NaN, NaN,	"rmse Voltage","rmse dvdq";...  
cycles,             Xt2(7,2:end)', Xt2(6,2:end)', Xt2(3,2:end)' , Xt2(1,2:end)', Xt2(4,2:end)', Xt2(2,2:end)' ,...
     Xt2(5,2:end)', NaN*ones(length(discharge_list)-1,1), NaN*ones(length(discharge_list)-1,1),rmseV(2:end)',rmsedVdQ(2:end)'];



% TOCSV=[cyc',Ah_thru',xxt2' ,Qtot2(2:13)', (fval2(2:end))'];

% TOCSV=["Cycle",     "x_0",          "y_0",         "x_100",       "y_100","C_n","C_p","Cap", NaN, NaN,	"Fit error x 10";...  
% cycles,             Xt2(7,2:end)', Xt2(6,2:end)', Xt2(3,2:end)' , Xt2(1,2:end)', Xt2(4,2:end)', Xt2(2,2:end)' ,...
%      Xt2(5,2:end)', NaN*ones(length(discharge_list)-1,1), NaN*ones(length(discharge_list)-1,1),faval_rmse(2:end)'];

writematrix(TOCSV,"C:\Users\Hamid\Desktop\Simona\Rsults NMC\cell041_1D_Andrewtop.csv");

%% Reconstruct

function [vmodel,dvdq_model]=model_V_dvdq(X,Q,Vt_data,dVdQ)

Q = flipud(max(Q)-Q);

dQ=5e-3;

V1=NMC622_discharge_June15(X(1)+Q/X(2))-Un_Graphite_Andrew_top(X(3)-Q/X(4));

V = flipud(V1);

for j=1+5:length(Vt_data)-5
    dvdq_model(j)= [-2, +25, -150, 600, -2100, 0, 2100, -600, 150, -25, 2]/2520*...
       [V(j-5); V(j-4); V(j-3);V(j-2);V(j-1);V(j);...
       V(j+1);V(j+2);V(j+3);V(j+4);V(j+5)]/dQ ;
end


% verror=V-Vt_data;
% dvdq_error=dvdq_model-dVdQ;
vmodel=V1;


end