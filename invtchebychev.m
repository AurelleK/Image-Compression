function Mat = invtchebychev(M,N)
[m,n] = size(M);
T = zeros(8);
for x = 0:7
    for y = 0:7
        for p=0:m-1
            for q=0:n-1
                mat = Bpq(p,q,N);
                T(x+1,y+1)= T(x+1,y+1)+(mat(x+1,y+1)*M(p+1,q+1));
            end
        end
    end
end
Mat = T;
end