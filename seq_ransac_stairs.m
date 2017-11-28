% sorozatos RANSAC egyenes illesztés 
clear all; close all
% minta adatok
d = load('stairs4.dat');
x = d(:,1);  y = d(:,2); 
tol = 0.01;  % hiba küszöb
k = 100;  % iterációk száma
m = 4; % modellek száma
figure(1); hold on;
plot(x,y,"k*");
for n = 1:m
  nd = length(x);
  nmax = 0; % nincs még konszenzus halmaz
  for i=1:k
    % két pont véletlenszerű kiválasztása
    is = randperm(nd,2);
    % ax+by-1=0 egyenes paramétereinek meghatározása
    A = d(is,:); b = [1; 1]; p = A\b;
    % az adatok egyenestől mért távolságai
    t = abs(p(1)*x+p(2)*y-1)/sqrt(p(1)^2+p(2)^2);
    xk = x(t<tol);  yk = y(t<tol); % illeszkedő adatok
    nin = length(xk);  % konszenzus halmaz elemszáma
    if nin > nmax  % jobb mint idáig
      xin = xk; yin = yk; nmax = nin;
      xout = x(t>=tol); yout = y(t>=tol); % nem konszenzus halmaz
      bp = p;  % legjobb egyenes
    end
  end
  pls = polyfit(xin,yin,1); % LKN egyenes illesztés
  plot(xin,yin,"g*")
  line = @(x,y) bp(1)*x + bp(2)*y - 1;
  ezplot(line,[0,1,0,1]) % egyenes felrajzolása
  % a konszenzus halmaz elemeit eltávolítjuk
  x = xout; y = yout; d = [x,y];
end
axis equal; ylim([0,1]);
title("Sorozatos RANSAC egyenes illesztés");


