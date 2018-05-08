function out=wnlfit(x,y,xe,ye,modelFun,start)
% uses non-linear regression to fit y=f(x)
% Inputs:   
%     x - independent variable 
%     y - dependent variable
%     xe - x uncertainties
%     ye - y uncertainties
%     func - model function handle
%     start - parameter initialization
%     
%     x,y,xe,ye are vectors of the same length
% 
% Requires Statistics Toolbox, follows Mathworks demo
% calls errorbarxy by James Rooney, must be in same folder (or addpath())
% Andy Briggs April 14,2011

if size(x) ~= size(y)
    error('x and y must be the same size');
end    
if isempty(xe) && isempty(ye)
    w=ones(size(y,1),size(y,2));
elseif isempty(ye)
    w=sqrt(xe.^2).^-1;
elseif isempty(xe)
    w=sqrt(ye.^2).^-1;
else
    w=sqrt(xe.^2+ye.^2).^-1;
end

yw = sqrt(w).*y;
modelFunw = @(b,x) sqrt(w).*modelFun(b,x);
[bFitw,rw,Jw,Sigmaw,msew] = nlinfit(x,yw,modelFunw,start);
seFitw = sqrt(diag(Sigmaw))';


xgrid = linspace(min(x),max(x),1000)';
[yFitw, deltaw] = nlpredci(modelFun,xgrid,bFitw,rw,'cov',Sigmaw);


errorbarxy(x,y,xe,ye,xe,ye,'k.','k');
hold on;
plot(xgrid,yFitw,'b-',xgrid,yFitw+deltaw,'b:',xgrid,yFitw-deltaw,'b:');
hold off;

out.param=bFitw;
out.paramerr=seFitw;
out.fit=yFitw;
out.fitconf=deltaw;

for i=1:size(bFitw,2)
    fprintf('Parameter %u: p(%u) = %6e +/- %1e \n',i,i,bFitw(i),seFitw(i));
end