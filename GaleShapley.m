%GaleShapley -Code for the Gale-Shapley algorithm.
% 
%   Note: You can choose different values of the parameters 'Num' 
%   to test the performance of this code.
% 
%   Copyright (c) 2018 CHEN Tianyang
%   more info contact: tychen@whu.edu.cn

clear;close all;
%% define the favor-ranking table
Num = 20;       % number of boys/girls
M = zeros(Num,Num);
F = zeros(Num,Num);
for i=1:Num
    M(i,:) = randperm(Num);     % each boy ranks the girls according to his preference
    F(i,:) = randperm(Num);     % each girl ranks the boys according to her preference
end
% M = [3,6,1,4,5,2;1,5,2,6,4,3;6,5,4,3,1,2;1,3,4,6,5,2;6,1,4,5,2,3;1,5,6,3,2,4];
% F = [5,4,3,1,6,2;1,5,6,2,3,4;2,3,1,5,6,4;3,5,4,2,6,1;4,3,5,1,2,6;3,4,1,6,5,2];
M_origin = M;
F_origin = F;
%% define couple list
M_sg = ones(Num,1);
M_cp = zeros(Num,1);
F_cp = zeros(Num,1);
Mlove_rank = zeros(Num,1);
Flove_rank = zeros(Num,1);
Mlove_score = zeros(1);
Flove_score = zeros(1);
F_mark = zeros(Num,Num);

%% maching...
times = 0;
% 当没有男孩是单身狗时，就匹配成功了，同时该匹配也是稳定的
% 其实两个数组 M_sg 和 F_cp 的用处是一样的:
% while 的条件既可以是sum(M_sg)>0，即男生并未全脱单，也可以是
% ~all(F_cp),即女生并未全找到对象
while sum(M_sg)>0
    % M: courtship
    for i=1:Num                                 % 对于每个男生
        if M_sg(i)==1                           % 如果他当前是单身
            for j=1:Num                         % 就按喜欢程度从高到低给每位女生排序(不管女生是否单身)
                if M(i,j)~=0                    % 选择没有拒绝过自己的女生中最喜欢的那一个
                    for k=1: Num                % 发出情书
                        if F(M(i,j),k)==i
                            F_mark(M(i,j),k)=1;
                            break;
                        end
                    end
                    break;
                end
            end
        end
    end
    
    % F: response
    for i=1:Num                         
        if sum(F_mark(i,:)~=0)                          % 每个收到情书的女生(不论是否单身)
            for j=1:Num
                
                if F_mark(i,j)==1                       % 只接受其中最喜欢的男生的情书
                    F_cp(i)=F(i,j);                     % 于是这个女生有了CP
                    M_cp(F(i,j))=i;                     % 对应的男生也有了CP
                    M_sg(F(i,j))=0;                     % 同时，那个男生摘掉了单身狗的帽子
                    if j<Num                              % 如果女生接受的情书不来自于自己最不喜欢的男生，即对更不喜欢的男生有拒绝权
                        for k=j+1:Num                   % 则查看更不喜欢的男生(们)——很可能不止一个——是否发来了情书
                            if F_mark(i,k)==1           % 若有
                                F_mark(i,k)=0;          % 那么首先扔掉该男生发来的情书(包括之前的情书，即现男友的情书)
                                for s=1:Num             
                                    if M(F(i,k),s)==i
                                        M(F(i,k),s)=0;  % 然后给该男生发一张好人卡(或和现男友分手)
                                        M_sg(F(i,k))=1; % 于是该男生重新回到单身狗的行列
                                        break;
                                    end
                                end
                            end
                        end
                    end
                    break;
                end
            end
        else
            continue;                   % 先暂时跳过没收到情书的女生
        end
    end
    times = times+1;
    fprintf("第%d轮匹配完成\n",times);
    
    % 分析每个人对自己男/女朋友的满意程度
    % 对于每个男生
    for i=1:Num                             
        if M_sg(i)~=1                       % 对于每个非单身的男生
            for j=1:Num                     
                if M(i,j)~=0
                    Mlove_rank(i)=j;        % 此男生当前的女友是他第j喜欢的
                    break;
                end
            end
        end
    end
    % 对于每个女生
    for i=1:Num
        if sum(F_mark(i,:))~=0               % 对于每个非单身的女生
            for j=1:Num
                if F_mark(i,j)~=0
                    Flove_rank(i)=j;        % 此女生当前的男友是她第j喜欢的
                    break;
                end
            end
        end
    end
    % 计算每轮匹配后男女对自己的女友/男友的喜欢程度
    Mlove_score(times)=sum(Mlove_rank)/Num;
    Flove_score(times)=sum(Flove_rank)/Num;
end
fprintf("全部匹配完成，一共匹配了%d轮\n",times);
            
%% showing the result 
% 作图表现匹配完成时每个人对自己男/女朋友的满意程度
figure;
plot(Mlove_rank,'.','Markersize',10,'color','b');hold on;
plot(Flove_rank,'.','Markersize',10,'color','r');
xlabel('人数');ylabel('喜爱程度');text(0,-1,'最喜欢');text(0,Num+1,'不那么喜欢');
axis([0 Num+1 0 Num+1]);legend('男生','女生');
% 作图表现每个人对自己男/女朋友的满意程度随轮数增加的变化程度
figure;
plot(Mlove_score,'-*','color','b');hold on;
plot(Flove_score,'-*','color','r');
xlabel('匹配次数');ylabel('喜欢程度');text(0,0,'最喜欢');text(0,Num,'不那么喜欢');
axis([0 times+1 0 Num+1]);legend('男生','女生');

%%