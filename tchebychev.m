function Mat = tchebychev(M,N)
[m,n] = size(M);
T = zeros(8);
for p = 0:7
    for q = 0:7      
        for x=0:m-1
            for y=0:n-1
                T(p+1,q+1)= T(p+1,q+1)+t(p,x,N)*t(q,y,N)*M(x+1,y+1);
            end
        end
        T(p+1,q+1)=T(p+1,q+1);%/(rho(p,N)%*rho(q,N));
    end
end
Mat = T;
end