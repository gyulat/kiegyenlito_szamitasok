% RANSAC egyenes illesztés demo
clc; clear all; close all
% minta adatok
d = load('linedata.txt');
x = d(:,1);  y = d(:,2); nd = length(x);
% küszöb érték
tol = 0.05;
% iterációk száma
k = 16;
%k = 32;
% konszenzus halmaz elemszáma
nmax = 0;
figure(1)
for i=1:k
  % két pont véletlenszerű kiválasztása
  is = randperm(nd,2);
  % rajz az összes/kiválasztott pontokról
  plot(x,y,'marker','o','markerfacecolor','black')
  clf; hold on
  g = plot(x,y,'ko');
  set(g,'markerfacecolor','black');
  hold on
  h = plot(x(is),y(is),'ro');
  set(h,'markerfacecolor','red');
  % ax+by-1=0 egyenes paramétereinek meghatározása
  A = d(is,:); b = [1; 1]; p = A\b;
  % egyenes felrajzolása
  line = @(x,y) p(1)*x + p(2)*y - 1;
  ezplot(line,[0,1,0,1]);
  ts = sprintf("%d. iteráció",i);
  title(ts);
  pause()
  % az adatok egyenestől mért távolságai
  t = abs(p(1)*x+p(2)*y-1)/sqrt(p(1)^2+p(2)^2);
  xk = x(t<tol);
  yk = y(t<tol);
  % konszenzus halmaz elemszáma
  nin = length(xk);
  if nin > nmax
    xin = xk; yin = yk; nmax = nin;
    bp = p;  % legjobb egyenes
  end
  % konszenzus halmaz pontjai
  g = plot(xk,yk,'go');
  set(g,'markerfacecolor','green');
  ts = sprintf("%d. iteráció,  %d illeszkedő pont",i,nin);
  title(ts);
  pause()
  hold off
end

% maximális konszenzus halmaz
clf; hold on
g = plot(x,y,'ko');
set(g,'markerfacecolor','black');
h = plot(xin,yin,'go');
set(h,'markerfacecolor','green');
line = @(x,y) bp(1)*x + bp(2)*y - 1;
ezplot(line,[0,1,0,1])
% LKN egyenes illesztés
pls = polyfit(xin,yin,1);
bline = @(x) pls(1)*x + pls(2);
h = ezplot(bline,[0,1,0,1]);
set(h, 'Color','r')
title(["konszenzus halmaz pontjai száma: ",int2str(nmax)])
pause()
close all
