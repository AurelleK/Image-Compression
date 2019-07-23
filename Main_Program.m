%------------------------Main Program---------------------------
%realize by TCHAGNA KOUANOU AURELLE
      %Image compression using Chebyshev transform with a vector Wantization based on K-Means and %Splitting Method for learning and a entropy coding. update 23 july 2019
             
format long
% insert your image here in the same folder that this file
  II=imread('Lenna.png');
% II=imread('Pepper.png');
 %II=imread('GoldHill.jpg');
 %II=imread('Baboon.jpg');
%  II=imread('rachis_cervical.jpg');
I2=rgb2gray(II);
I=im2double(I2);
[nl2 nc2 np2]=size(I2)

%I=I-128;
[m,n]=size(I);%get image size
%image compression phasis
fun = @(block_struct) compress(block_struct.data);%performed a Chebyshevtransforming 

tic % allow to get a compression and decompression time
Icompress=blockproc(I,[8 8],fun);
% Qvector quantization ( Kmeans + Splitting)
Lb=64; % codebbok length. you can change it to 8 16, 32, 64, 128, 256, 512
[book scan]=KmeansVQ(Icompress, Lb);
%scan=zigzag(Icompress);%perform a zigzag scan
%------------satrt of Huffman encoding----------------------
string=scan;        
symbol=[];                                %variables initialization
count=[];
j=1;
%-------------------------loop for symbols separation-------------
for i=1:length(string)                   
  flag=0;    
  flag=ismember(symbol,string(i));      %symbols
      if sum(flag)==0
      symbol(j) = string(i);
      k=ismember(string,string(i));
      c=sum(k);                           
      count(j) = c;
      j=j+1;
      end 
end    
ent=0;
total=sum(count);                         %
prob=[];                                         
%-------------
for i=1:1:size((count)');                   
prob(i)=count(i)/total;
ent=ent-prob(i)*log2(prob(i));            
end
var=0;
%--------------------function ------------
[dict avglen]=huffmandict(symbol,prob);    
% ecrire les dictionnaires.
         temp = dict;
         for i = 1:length(temp)
         temp{i,2} = num2str(temp{i,2});
         var=var+(length(dict{i,2})-avglen)^2;  %
         end
         
%--------------------Huffman Coding-----------           
sig_encoded=huffmanenco(string,dict);
te=toc;
tps=num2str(te)
%--------------start of decoding phasis--------------------
%----Huffman Decoding----------------------
deco=huffmandeco(sig_encoded,dict);
equal = isequal(string,deco);
%origin=invzigzag(scan_deco,m,n);%performed and invzigzag;
%---------Chebyshev decoding
% dequantification
origin=KmeansVDQ(book,deco);
% Chebyshev inverse
fun = @(block_struct) decompress(block_struct.data);
Idecompress=blockproc(origin,[8 8],fun);
Idecompress = im2uint8(Idecompress);
%Idecompress=Idecompress+128;
erreur=I2-Idecompress;

%-----display original image and decompressed image
subplot(131),imshow(I2),title('originale image ');
subplot(132),imshow(Idecompress),title('decompressed image ');
subplot(133),imshow(erreur),title('error image ');
%evaluation of compression rate
taille_I=nl2*nc2;
%taille_Icompresse=length(temp);
taux_compression=100-(length(sig_encoded)/(taille_I*8))*100%compression rate
 CR=(length(sig_encoded)/(taille_I*8))        
%evaluation of mean square error, peak signal of noise ratio

[PSNR,MSE,MAXERR,L2RAT]=measerr(I2,Idecompress)
Mae=mae(erreur)




