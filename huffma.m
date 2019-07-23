%Author Name:Falak Shah
%Target: To huffman encode and decode user entered string
%--------------------------------------------------------------------------
string=input('enter the string in inverted commas');         %input string
symbol=[];                                %initialise variables
count=[];
j=1;
%------------------------------------------loop to separate symbols and how many times they occur
for i=1:length(string)                   
  flag=0;    
  flag=ismember(symbol,string(i));      %symbols
      if sum(flag)==0
      symbol(j) = string(i);
      k=ismember(string,string(i));
      c=sum(k);                         %no of times it occurs  
      count(j) = c;
      j=j+1;
      end 
end    
ent=0;
total=sum(count);                         %total no of symbols
prob=[];                                         
%-----------------------------------------for loop to find probability and
%entropy
for i=1:1:size((count)');                   
prob(i)=count(i)/total;
ent=ent-prob(i)*log2(prob(i));            
end
var=0;
%-----------------------------------------function to create dictionary
[dict avglen]=huffmandict(symbol,prob);    
% print the dictionary.
         temp = dict;
         for i = 1:length(temp)
         temp{i,2} = num2str(temp{i,2});
         var=var+(length(dict{i,2})-avglen)^2;  %variance calculation
         end
         temp
%-----------------------------------------encoder  and decoder functions           
sig_encoded=huffmanenco(string,dict);
deco=huffmandeco(sig_encoded,dict);
equal = isequal(string,deco);
%-----------------------------------------decoded string and output
%variables
str ='';
for i=1:length(deco)    
str= strcat(str,deco(i));
end
str
ent
avglen
var