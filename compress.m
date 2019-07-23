function D=compress(I)
%mat=quantum(25);
A=tchebychev(I,8);
%B=A./mat;
%B=round(B);
%C=zigzag(B);
%D=rle(C);
D=A;
D';