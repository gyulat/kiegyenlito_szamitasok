% RANSAC egyenes illesztés minimális demo
clear all
% minta adatok
d = load('linedata.txt');
x = d(:,1);  y = d(:,2); nd = length(x);
tol = 0.05;  % hiba küszöb
k = 16;  % iterációk száma
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
    bp = p;  % legjobb egyenes
  end
end
printf("maximális konszenzus halmaz elemszáma: %d\n",nmax)
pls = polyfit(xin,yin,1); % LKN egyenes illesztés
printf("LKN egyenes egyenlete: y = %.3f*x %+.3f\n",pls(1),pls(2))

