function [mm Index]=KmeansVQ(X,L)
%---------------------------------------------------------------------------------------------%
% Fonction effectuant de Vector Quantization: K-Means Algorithm with Spliting Method for Training
% 
% inputs:
% X: a matrix each column of which is a data vector
% L: codebook size 
% 
% Outputs:
% M: the codebook as the centroids of the clusters
% Index: Index 
% by Aurelle Tchagna le 23 july 2019

%I1=imread('rachis_cervical.jpg');
%I3=rgb2gray(I1);
%I3=im2double(I2);
%X=im2double(I3);
[n,m]=size(X);%recuperation de la taile de l'image
e=.01; % X---> [X-e*X and X+e*X] Percentage for Spliting
eRed=0.75; % Rate of reduction of split size, e, after each spliting. i.e. e=e*eRed;
DT=.005; % The threshold in improvement in Distortion before terminating and spliting again
DTRed=0.75; % Rate of reduction of Improvement Threshold, DT, after each spliting
MinPop=0.10; % The population of each cluster should be at least 10 percent of its quota (N/LC)
             % Otherwise that codeword is replaced with another codeword
%L=8;

d=size(X,1); % Dimension
N=size(X,2); % Number of Data points
isFirstRound=1; % First Itteration after Spliting

if numel(L)==1
    M=mean(X,2); % Mean Vector
    CB=[M*(1+e) M*(1-e)]; % Split to two vectors
else
    CB=L; % If the codebook is passed to the function just train it
    L=size(CB,2);
    e=e*(eRed^fix(log2(L)));
    DT=DT*(DTRed^fix(log2(L)));
end

LC=size(CB,2); % Current size of the codebook

Iter=0;
Split=0;
IsThereABestCB=0;
maxIterInEachSize=20; % The maximum number of training itterations at each 
                      % codebook size (The codebook size starts from one 
                      % and increases thereafter)
EachSizeIterCounter=0;
while 1
    %Distance Calculation
    [minIndx, dst]=VQIndex(X,CB); % Find the closest codewords to each data vector
   ide=minIndx;
    ClusterD=zeros(1,LC);
    Population=zeros(1,LC);
    LowPop=[];
    % Find the Centroids (Mean of each Cluster)
    for i=1:LC
        Ind=find(minIndx==i);
        if length(Ind)<MinPop*N/LC % if a cluster has very low population just remember it
            LowPop=[LowPop i];
        else
            CB(:,i)=mean(X(:,Ind),2);
            Population(i)=length(Ind);
            ClusterD(i)=sum(dst(Ind));
        end        
    end
    if ~isempty(LowPop)
        [temp MaxInd]=maxn(Population,length(LowPop));
        CB(:,LowPop)=CB(:,MaxInd)*(1+e); % Replace low-population codewords with splits of high population codewords
        CB(:,MaxInd)=CB(:,MaxInd)*(1-e);
        
        %re-train
        [minIndx, dst]=VQIndex(X,CB);
        ide2=minIndx;
        livre=CB;
        ClusterD=zeros(1,LC);
        Population=zeros(1,LC);
        
        for i=1:LC
            Ind=find(minIndx==i);
            if ~isempty(Ind)
                CB(:,i)=mean(X(:,Ind),2);
                Population(i)=length(Ind);
                ClusterD(i)=sum(dst(Ind));
            else %if no vector is close enough to this codeword, replace it with a random vector
                CB(:,i)=X(:,fix(rand*N)+1);
               % disp('A random vector was assigned as a codeword.')
                isFirstRound=1;% At least another iteration is required
            end                
        end
    end
    Iter=Iter+1;
    if isFirstRound % First itteration after a split (dont exit)
        TotalDist=sum(ClusterD(~isnan(ClusterD)));
        DistHist(Iter)=TotalDist;
        PrevTotalDist=TotalDist;        
        isFirstRound=0;
    else
        TotalDist=sum(ClusterD(~isnan(ClusterD)));  
        DistHist(Iter)=TotalDist;
        PercentageImprovement=((PrevTotalDist-TotalDist)/PrevTotalDist);
        if PercentageImprovement>=DT %Improvement substantial
            PrevTotalDist=TotalDist; %Save Distortion of this iteration and continue training
            isFirstRound=0;
        else%Improvement NOT substantial (Saturation)
            EachSizeIterCounter=0;
            if LC>=L %Enough Codewords?
                if L==LC %Exact number of codewords
                  %  disp(TotalDist)
                    break
                else % Kill one codeword at a time
                    [temp, Ind]=min(Population); % Eliminate low population codewords
                    NCB=zeros(d,LC-1);
                    NCB=CB(:,setxor(1:LC,Ind(1)));
                    CB=NCB;
                    LC=LC-1;
                    isFirstRound=1;
                end
            else %If not enough codewords yet, then Split more
                CB=[CB*(1+e) CB*(1-e)];
                e=eRed*e; %Split size reduction
                DT=DT*DTRed; %Improvement Threshold Reduction
                LC=size(CB,2);
                isFirstRound=1;
                Split=Split+1;
                IsThereABestCB=0; % As we just split this codebook, there is no best codebook at this size yet
              %  disp(LC)
            end
        end
    end    
    if ~IsThereABestCB
        BestCB=CB;
        BestD=TotalDist;
        IsThereABestCB=1;
    else % If there is a best CB, check to see if the current one is better than that
        if TotalDist<BestD
            BestCB=CB;
            BestD=TotalDist;
        end
    end
    EachSizeIterCounter=EachSizeIterCounter+1;
    if EachSizeIterCounter>maxIterInEachSize % If too many itterations in this size, stop training this size
        EachSizeIterCounter=0;
        CB=BestCB; % choose the best codebook so far
        IsThereABestCB=0;
        if LC>=L %Enough Codewords?
            if L==LC %Exact number of codewords
              %  disp(TotalDist)
                break
            else % Kill one codeword at a time
                [temp, Ind]=min(Population);
                NCB=zeros(d,LC-1);
                NCB=CB(:,setxor(1:LC,Ind(1)));
                CB=NCB;
                LC=LC-1;
                isFirstRound=1;
            end
        else %Split
            CB=[CB*(1+e) CB*(1-e)];
            e=eRed*e; %Split size reduction
            DT=DT*DTRed; %Improvement Threshold Reduction
            LC=size(CB,2);
            isFirstRound=1;
            Split=Split+1;
            IsThereABestCB=0;
          %  disp(LC)
        end
    end        
  %  disp(TotalDist)
    p=Population/N;
    save CBTemp CB p DistHist
end
mm=CB;

p=Population/N;

disp(['Iterations = ' num2str(Iter)])
disp(['Split = ' num2str(Split)])
Index=ide;

% % decoder l'image
% Index=ide;
% 
% 
% I=[I3,II];
% imshow(I)
% %----------------evaluons l'erreur quadratique moyenne----------------
% s=0;
% for i=1:n
%     for j=1:m
%         s=s+((abs(I3(i,j)-II(i,j))^2));
%     end
% end
% RMS=s/(m*n);
% %evaluons le rapport signal bruit(peak noise.....
% %PNSR=10*log10((255^2)/RMS)
% [PSNR,MSE,MAXERR,L2RAT]=measerr(I3,II)%



