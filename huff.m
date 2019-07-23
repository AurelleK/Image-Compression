function [cod,dic]=huff(scan_code)
%------------debut du codage d'huffman----------------------
string=scan_code;        
symbol=[];                                %initialisation des variables
count=[];
j=1;
%------------------------------------------boucle de separation des
%symboles
for i=1:length(string)                   
  flag=0;    
  flag=ismember(symbol,string(i));      %symboles
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
%-----------------------------------------boucle pour le calcul des
%probabilites d'aparitions des symboles
for i=1:1:size((count)');                   
prob(i)=count(i)/total;
ent=ent-prob(i)*log2(prob(i));            
end
var=0;
%--------------------fonction de creation des dictionnaires------------
[dict avglen]=huffmandict(symbol,prob);    
% ecrire les dictionnaires.
         temp = dict;
         for i = 1:length(temp)
         temp{i,2} = num2str(temp{i,2});
         var=var+(length(dict{i,2})-avglen)^2;  %calcul des variances
         end
         
%--------------------codage d'huffman-----------           
cod=huffmanenco(string,dict);
dic=dict;