function valeur = t(p,x,N)
if p==0
    valeur = 1/sqrt(N);
else if p==1
    valeur = ((2*x)+1-N)*sqrt(3/(N*(N*N-1)));
    else
        a1 = sqrt((4*p*p - 1)/(N*N-(p*p)))/p;
%         a2 = (1-N)*sqrt((4*(p^2)-1)/(N*N-(p^2)))/p;
        a2 = -((p-1)/p)*(sqrt((2*p+1)/(2*p-3)))*(sqrt(((N*N)-(p-1)*(p-1))/((N*N-p*p))));
    valeur = a1*(2*x+1-N)*t(p-1,x,N)+a2*t(p-2,x,N);
    end
end
end