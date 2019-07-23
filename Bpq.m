function matrice = Bpq(p,q,N)
    B = zeros(8);
for i=0:7
    for j=0:7
        B(i+1,j+1) = t(p,i,N)*t(q,j,N);        
    end
end
matrice  = B;
end