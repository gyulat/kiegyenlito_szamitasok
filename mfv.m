x=[-12.5 -6.7 -2 -1.5 0.1 2.4 6.8 9.8 15 23.5 30];
M1=mean(x);
epsilon1=0.5*sqrt(3)*(max(x)-min(x));
itermax=30;
for j=1:itermax
    szaml=0; szaml2=0;
    nev=0; nev2=0;
    seg=0; seg2=0;
if j==1
        epsilon(j)=epsilon1;
        M(j)=M1;
    else
        for i=1:length(x)
            seg=(x(i)-M(j-1))^2;
            szaml=szaml+3*((seg)/(((epsilon(j-1)^2)+seg)^2));
            nev=nev+(1/((epsilon(j-1)^2)+seg)^2);
        end
        epsilon(j)=sqrt(szaml/nev);
        for i=1:length(x)
            seg2=(epsilon(j-1)^2)/((epsilon(j-1)^2)+((x(i)-M(j-1))^2));
            szaml2=szaml2+(seg2*x(i));
            nev2=nev2+seg2;
        end
        M(j)=szaml2/nev2;
    end
end

M
epsilon
