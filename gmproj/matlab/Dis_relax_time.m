%% Finding discharge relaxation points
function [Init,Endit]=Dis_relax_time(data)

pulse_amp=2000;

Time0=data(:,1); I0=data(:,2); Vt0=data(:,3);  %current(mA)
Cyc_num=data(:,11); 

Cyc_uniq=unique(Cyc_num);

%% In each cycle
Init=[];
for i=1:length(Cyc_uniq)
   
    Time=Time0(Cyc_num==Cyc_uniq(i));
    I=I0(Cyc_num==Cyc_uniq(i));
    I_diff=diff(I);
%    figure(i);plot(Time,I)

    indices0=find(I_diff>pulse_amp-600 & I_diff<pulse_amp+600);
    indices=indices0(I(indices0-1)<0);
    Time_indices=Time(indices);

    if length(indices)<size(Init,2)
        Time_indices=[Time_indices; 0];
    end

    Init(i,:)=Time_indices;
end
    Init=Init-3;
    Endit=Init+1700;

end