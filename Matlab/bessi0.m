function result = bessi0(x)

ax = abs(x);
result = zeros(size(x));

% ax<3.75
k = find(ax<3.75);
y=x(k)./3.75;
y=y.^2;
result(k)=1.0+y.*(3.5156229+y.*(3.0899424+y.*(1.2067492 ...
    +y.*(0.2659732+y.*(0.360768e-1+y.*0.45813e-2)))));

% ax>=3.75
k = find(ax>=3.75);
y=3.75./ax(k);
result(k)=(exp(ax(k))./sqrt(ax(k))).*(0.39894228+y.*(0.1328592e-1 ...
    +y.*(0.225319e-2+y.*(-0.157565e-2+y.*(0.916281e-2 ...
    +y.*(-0.2057706e-1+y.*(0.2635537e-1+y.*(-0.1647633e-1 ...
    +y.*0.392377e-2))))))));
return