function [x0, y0, r2] = gaussian2DParams(xx, yy, zz)

% returns a cell array with the params for a Von Mise fit to the input data
% p{1} = x center
% p{2} = y center
% p{3} = r^2 of fit
%
% xyFit is the fitted values corresponding to yData

  poolobj = gcp('nocreate');
  delete(poolobj);  
  
  [fitresult, zfit] = fmgaussfit(xx,yy,zz);
  x0 = fitresult(5);
  y0 = fitresult(6);
  r2 = corr2(zz, zfit);
end