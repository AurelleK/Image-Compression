    
function [I, dist]=VQLSFSpectralIndex(X,CB,W)
% If your codewords are LSF coefficients, You can use this function instead of VQINDEX
% This is for speech coding
% I=VQLSFSPECTRALINDEX(X,CB,W)
% Calculates the nearest set of LSF coefficients in the codebook CB to each
% column of X by calculating their LP spectral distances.
% I is the index of the closest codeword, X is the set of LSF coefficients
% (each column is a set of coefficients) CB is the codebook, W is the
% weighting vector, if not provided it is assumed to be equal to ones(256,1)
% Esfandiar Zavarehei
% 9-Oct-05

if nargin<3
    L=256;
    W=ones(L,1);
else
    if isscalar(W)
        L=W;
        W=ones(L,1);
    elseif isvector(W)
        W=W(:);
        L=length(W);
    else
        error('Invalid input argument. W should be either a vector or a scaler!')
    end
end

NX=size(X,2);
NCB=size(CB,2);

AX=lsf2lpc(X);
ACB=lsf2lpc(CB);


D=zeros(NCB,1);

w=linspace(0,pi,L+1);
w=w(1:end-1);
N=size(AX,2)-1;
WFZ=zeros(N+1,L);
IMAGUNIT=sqrt(-1);
for k=0:N
    WFZ(k+1,:)=exp(IMAGUNIT*k*w);
end

SCB=zeros(L,NCB);
for i=1:NCB
    SCB(:,i)=(1./abs(ACB(i,:)*WFZ));
end

I=zeros(1,NX);
dist=zeros(1,NX);
for j=1:NX
    SX=(1./abs(AX(j,:)*WFZ))';    
    for i=1:NCB
        D(i)=sqrt(sum(((SX-SCB(:,i)).^2).*W));
    end
    [dist(j), I(j)]=min(D);
end