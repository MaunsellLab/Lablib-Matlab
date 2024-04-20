function [thetaDeg, varargout] = vonMisesFit(xDeg, yData)

  xRad = circ_ang2rad(xDeg);
  [thetaRad, kappa] = circ_vmpar(xRad, yData);
  thetaDeg = circ_rad2ang(thetaRad);
  disp(thetaDeg);
  disp(kappa);
  yData
  vmFit = circ_vmpdf(xRad, thetaRad, kappa)
  coefficients = polyfit(vmFit, yData, 1)
  yFit = vmFit * coefficients(1) + coefficients(2)
   