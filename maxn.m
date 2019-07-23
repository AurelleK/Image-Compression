function [v, i]=maxn(x,n)
% [V, I]=MAXN(X,N)
% APPLY TO VECTORS ONLY!
% This function returns the N maximum values of vector X with their indices.
% V is a vector which has the maximum values, and I is the index matrix,
% i.e. the indices corresponding to the N maximum values in the vector X

if nargin<2
    [v, i]=max(x); %Only the first maximum (default n=1)
else
    n=min(length(x),n);
    [v, i]=sort(x);
    v=v(end:-1:end-n+1);
    i=i(end:-1:end-n+1);    
end