function [p, yFit] = vonMisesParams(xDeg, yData)

% returns a cell array with the params for a Von Mise fit to the input data
% p{1} = thetaDeg
% p{2} = kappa
% p{3} = amplitude
% p{4} = baseline
%
% yFit is the fitted values corresponding to yData

  xRad = circ_ang2rad(xDeg);
  [thetaRad, kappa] = circ_vmpar(xRad, yData);
  vmFit = circ_vmpdf(xRad, thetaRad, kappa);
  coef = polyfit(vmFit, yData, 1);
  yFit = vmFit * coef(1) + coef(2);
  p = {circ_rad2ang(thetaRad), kappa, coef(1), coef(2)};
end