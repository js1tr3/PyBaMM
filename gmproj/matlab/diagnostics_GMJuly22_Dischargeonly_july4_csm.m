function [Xr,fval] = diagnostics_GMJuly22_Dischargeonly_july4_csm(Q_data,Vt_data,Xi,bound)

Ctilde=max(Q_data);



% V = @(X,Q) Up_NMC622_notshifted(X(1)+Q/X(2))-Un_Graphite(X(3)+Q/X(4)); % charge Q>0
% V = @(X,Q) Up_NMC622_notshifted_dis_May18_3(X(1)+Q/X(2))-Un_Graphite_Dis_GM1(X(3)-Q/X(4));
 V = @(X,Q) NMC622_discharge_June15(X(1)+Q/X(2))-Un_Graphite_Andrew_top(X(3)-Q/X(4));

Vt_data = flipud(Vt_data);
Q_data = flipud(max(Q_data)-Q_data);



% S = [20;1/6;1;1/6;1];


% Xi(2) = Xi(2)*0.92;
% Xi(4) = Xi(4)*0.92;


% fun = @(X) (V(X,Q_data)-Vt_data)'*(V(X,Q_data)-Vt_data)...
%     +barrierPenalty(Up_NMC622_notshifted_dis_May18_3(X(1))-Un_Graphite_Dis_GM1(X(3)),4.1,4.3,0,0.01)...
%     +barrierPenalty(Up_NMC622_notshifted_dis_May18_3(Ctilde/X(2)+X(1))-Un_Graphite_Dis_GM1(-Ctilde/X(4)+X(3)), 2.6,2.8,0,0.01);
fun = @(X) (V(X,Q_data)-Vt_data)'*(V(X,Q_data)-Vt_data);
    


%         +barrierPenalty(Up_NMC622_man_shifted(X(1))-Un_Graphite(X(3)),4.1,4.3,.05,0.01)...
%         +barrierPenalty(Up_NMC622_man_shifted(Ctilde/X(2)+X(1))-Un_Graphite(-Ctilde/X(4)+X(3)), 2.9,3.1,.05,0.01);
% options = optimoptions('fmincon','ScaleProblem',true,'StepTolerance',1e-20,'MaxIter',1e4, 'MaxFunEvals', 1e5, 'PlotFcn','optimplotfval');
% options = optimoptions('paretosearch',ScaleProblem',true,'StepTolerance',1e-20,'MaxIter',1e4, 'MaxFunEvals', 1e4, 'PlotFcn','psplotbestf');

% options = optimset('TolX',1e-10,'TolFun',1e-10,'MaxIter',1e4, 'MaxFunEvals', 1e5, 'PlotFcns','psplotbestf');
% options = optimset('TolX',1e-10,'TolFun',1e-10,'MaxIter',1e4, 'MaxFunEvals', 1e5,'plotFcns','gaplotbestf');



% [Xr,fval,exitflag] = fminsearch(fun,Xi,options)  ;
% [Xr,fval,exitflag] = ga(fun,4,[],[],[],[],[-.1, 2, 0.5,2 ],[ 0.1, bound(2)+0.5, bound(3)+.2, bound(4)+0.5],[],options)  ;
% [Xr,fval,exitflag] = patternsearch(fun,bound,[],[],[],[],[-0.1, 2, 0.5,2 ],[ 0.3, bound(2)+0.5, 1, bound(4)+0.5],[],options)  ;
ub=[0.1, 5, 1 , 5];
lb=[-.1, 2, 0.5,2 ];

    options = optimoptions('fmincon', ...
                            'Display', 'iter', ...
                            'Algorithm', 'sqp', ...
                            'OptimalityTolerance', 1e-7, ...
                            'MaxFunctionEvaluations', 9000);

    problem = createOptimProblem('fmincon', 'x0', Xi, ...
            'objective', fun, ...
            'lb', lb, 'ub', ub, ...
            'options', options);
        gs = GlobalSearch;
    [Xr, fval, exitflag, output, manymins] = run(gs, problem);

% A=ones(5); A(1,1)=0; A(3,3)=0; 

% [Xr,fval,exitflag,ou] = fmincon(fun,Xi,[],[],[],[],[-.05, 2, 0.5,2 ],[ 0.2, bound(2)+0.5, bound(3)+.1, bound(4)+0.5],[],options)  ;
% [Xr,fval,exitflag] = fmincon(fun,Xi,[],[],[],[],[0.2, 2, 0.5,2 ],[ 0.4, bound(2)+.01, bound(3)+.01, bound(4)+.01],[],options)  ;

       

end
