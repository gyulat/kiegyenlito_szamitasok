% sorozatos RANSAC kör illesztés 
clear all; close all
% minta adatok
d = load('circle5.dat');
x = d(:,1);  y = d(:,2); 
tol = 0.05;  % hiba küszöb
k = 100;  % iterációk száma
m = 5; % modellek száma
figure(1); hold on;
plot(x,y,"k*");
axis equal
for n = 1:m
  nd = length(x);
  nmax = 0; % nincs még konszenzus halmaz
  for i=1:k
    % három pont véletlenszerű kiválasztása
    is = randperm(nd,3);
    % (x-x0)^2 + (y-y0)^2 + R^2 = 0 kör paramétereinek meghatározása
    A = [d(is,:),ones(3,1)]; b = -[d(is,1).^2+d(is,2).^2]; p = A\b;
    xc = -0.5*p(1); yc = -0.5*p(2);
    R = sqrt((p(1)^2+p(2)^2)/4-p(3));
    % az adatok körtől mért távolságai
    t = abs(sqrt((x-xc).^2+(y-yc).^2)-R);
    xk = x(t<tol);  yk = y(t<tol); % illeszkedő adatok
    nin = length(xk);  % konszenzus halmaz elemszáma
    if nin > nmax  % jobb mint idáig
      xin = xk; yin = yk; nmax = nin;
      xout = x(t>=tol); yout = y(t>=tol); % nem konszenzus halmaz
      bp = p;  % legjobb egyenes
    end
  end
  % LKN kör illesztés
  A = [xin,yin,ones(length(xin),1)]; b = -[xin.^2+yin.^2]; p = A\b;
  xc = -0.5*p(1); yc = -0.5*p(2);
  R = sqrt((p(1)^2+p(2)^2)/4-p(3));
  plot(xin,yin,"g*")
  circle = @(x,y) sqrt((x-xc).^2+(y-yc).^2)-R;
  ezplot(circle,[-0.5,1,-0.5,1.5]) % kör felrajzolása
  % a konszenzus halmaz elemeit eltávolítjuk
  x = xout; y = yout; d = [x,y];
end
axis equal;
title("Sorozatos RANSAC kör illesztés");


