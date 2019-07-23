function D=decompress(I)
%mat=quantum(25);
%A=irle(I);
%B=invzigzag(I,8,8);
%C=I.*mat;
D=invtchebychev(I,8);
D';