% RANSAC ellipszis illesztés demo
clear all
% minta adatok
d = load('ellipdata.txt'); % teljes ellipszis
x = d(:,1);  y = d(:,2); nd = length(x);
tol = 0.25;  % hiba küszöb
k = 300;  % iterációk száma
nmax = 0; % nincs még konszenzus halmaz
figure(1); hold on
plot(x,y,'ko')
for i=1:k
  while 1
    % öt pont véletlenszerű kiválasztása
    is = randperm(nd,5);
    % x^2+Bxy+Cy^2+Dx+Ey+F=0 ellipszis paramétereinek meghatározása
    A = [x(is).*y(is), y(is).^2, x(is), y(is), ones(5,1)];
    b = -x(is).^2; p = A\b;
    % ellipszis, ha B^2-4*C < 0  
    if (p(1)^2-4*p(2))<0
      break
    end
  end
  ell = @(x,y) x.^2+p(1)*x.*y+p(2)*y.^2+p(3)*x+p(4)*y+p(5);
  % gradiens norma
  gnorm = @(x,y) sqrt((2*x+p(1)*y+p(3)).^2+(p(1)*x+2*p(2)*y+p(4)).^2);
  % az adatok ellipszistől mért távolságai gradienssel súlyozva
  t = abs(ell(x,y))./gnorm(x,y);
  xk = x(t<tol);  yk = y(t<tol); % illeszkedő adatok
  nin = length(xk);  % konszenzus halmaz elemszáma
  if nin > nmax  % jobb mint idáig
    xin = xk; yin = yk; nmax = nin;
    bp = p;  % legjobb ellipszis
  end
end

printf("maximális konszenzus halmaz elemszáma: %d\n",nmax)
plot(xin,yin,'go')
ell = @(x,y) x.^2+bp(1)*x.*y+bp(2)*y.^2+bp(3)*x+bp(4)*y+bp(5);
ezplot(ell,[0,6,0,6])
%title(["konszenzus halmaz elemszáma: ",num2str(nmax)])
% LKN ellipszis illesztés (Fitzgibbon et al. 1996)
D = [xin.*xin, xin.*yin, yin.*yin, xin, yin, ones(size(xin))];
S = D'*D;
C(6,6)=0; C(1,3)=2; C(2,2)=-1; C(3,1)=2;
[gevec, geval] = eig(inv(S)*C);
[posR, posC] = find(geval>0 & ~isinf(geval));
pls = gevec(:,posC);
a = (pls./pls(1))(2:end);
ells = @(x,y) x.^2+a(1)*x.*y+a(2)*y.^2+a(3)*x+a(4)*y+a(5);
h = ezplot(ells,[0,6,0,6]);
set(h,"Color","red");
title(["konszenzus halmaz elemszáma: ",num2str(nmax)])
legend("adatok","konform","ellipszis","LKN illesztés")
% ellipszis középpontja a=(A B C D E F), Rosin(1999)
a = pls;
xc = (a(2)*a(5)-2*a(3)*a(4))/(4*a(1)*a(3)-a(2)^2);
yc = (a(2)*a(4)-2*a(1)*a(5))/(4*a(1)*a(3)-a(2)^2);
% fél nagy és kistengely
a1 = sqrt(-2*(a(6)-(a(3)*a(4)^2-a(2)*a(4)*a(5)+a(1)*a(5)^2)/(4*a(1)*a(3)-a(2)^2)) ...
            /(a(1)+a(3) - sqrt(a(2)^2+(a(1)-a(3))^2)) );
a2 = sqrt(-2*(a(6)-(a(3)*a(4)^2-a(2)*a(4)*a(5)+a(1)*a(5)^2)/(4*a(1)*a(3)-a(2)^2)) ...
            /(a(1)+a(3) + sqrt(a(2)^2+(a(1)-a(3))^2)) );
% elfordulás szöge
theta = 0.5*atan(a(2)/(a(1)-a(3)));
printf("Az ellipszis adatai: \n");
printf("xc: %.3f  yc: %.3f\n",xc,yc);  % xc: 2.694  yc: 1.875, eredeti: (3,2)
printf("a1: %.3f  a2: %.3f\n",a1,a2);  % a1: 1.129  a2: 1.590, eredeti: 1.5, 2.5
printf("theta: %.1f\n fok", theta*180/pi); % theta: 36.4, eredeti: 30

% teljes ellipszisre, ellipdata.txt:
%maximális konszenzus halmaz elemszáma: 62
%Az ellipszis adatai:
%xc: 2.953  yc: 1.973
%a1: 1.504  a2: 2.561
%theta: 29.7

% RANSAC nélküli LKN illesztés
% LKN ellipszis illesztés (Fitzgibbon et al. 1996)
D = [x.*x, x.*y, y.*y, x, y, ones(size(x))];
S = D'*D;
C(6,6)=0; C(1,3)=2; C(2,2)=-1; C(3,1)=2;
[gevec, geval] = eig(inv(S)*C);
[posR, posC] = find(geval>0 & ~isinf(geval));
pls = gevec(:,posC);
a = (pls./pls(1))(2:end);
ells = @(x,y) x.^2+a(1)*x.*y+a(2)*y.^2+a(3)*x+a(4)*y+a(5);
figure(2); hold on
plot(x,y,'ko')
h = ezplot(ells,[0,6,0,6]);
set(h,"Color","red");
title("LKN illesztés az összes adatra")
legend("adatok","LKN illesztés")
% ellipszis középpontja a=(A B C D E F), Rosin(1999)
a = pls;
xc = (a(2)*a(5)-2*a(3)*a(4))/(4*a(1)*a(3)-a(2)^2);
yc = (a(2)*a(4)-2*a(1)*a(5))/(4*a(1)*a(3)-a(2)^2);
% fél nagy és kistengely
a1 = sqrt(-2*(a(6)-(a(3)*a(4)^2-a(2)*a(4)*a(5)+a(1)*a(5)^2)/(4*a(1)*a(3)-a(2)^2)) ...
            /(a(1)+a(3) - sqrt(a(2)^2+(a(1)-a(3))^2)) );
a2 = sqrt(-2*(a(6)-(a(3)*a(4)^2-a(2)*a(4)*a(5)+a(1)*a(5)^2)/(4*a(1)*a(3)-a(2)^2)) ...
            /(a(1)+a(3) + sqrt(a(2)^2+(a(1)-a(3))^2)) );
% elfordulás szöge
theta = 0.5*atan(a(2)/(a(1)-a(3)));
printf("Az ellipszis adatai: \n");
printf("xc: %.3f  yc: %.3f\n",xc,yc);  
printf("a1: %.3f  a2: %.3f\n",a1,a2);  
printf("theta: %.1f\n fok", theta*180/pi);

%Az ellipszis adatai:
%xc: 2.538  yc: 2.371
%a1: 2.288  a2: 2.010
%theta: -10.4
