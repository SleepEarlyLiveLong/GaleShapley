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
% ��û���к��ǵ���ʱ����ƥ��ɹ��ˣ�ͬʱ��ƥ��Ҳ���ȶ���
% ��ʵ�������� M_sg �� F_cp ���ô���һ����:
% while �������ȿ�����sum(M_sg)>0����������δȫ�ѵ���Ҳ������
% ~all(F_cp),��Ů����δȫ�ҵ�����
while sum(M_sg)>0
    % M: courtship
    for i=1:Num                                 % ����ÿ������
        if M_sg(i)==1                           % �������ǰ�ǵ���
            for j=1:Num                         % �Ͱ�ϲ���̶ȴӸߵ��͸�ÿλŮ������(����Ů���Ƿ���)
                if M(i,j)~=0                    % ѡ��û�оܾ����Լ���Ů������ϲ������һ��
                    for k=1: Num                % ��������
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
        if sum(F_mark(i,:)~=0)                          % ÿ���յ������Ů��(�����Ƿ���)
            for j=1:Num
                
                if F_mark(i,j)==1                       % ֻ����������ϲ��������������
                    F_cp(i)=F(i,j);                     % �������Ů������CP
                    M_cp(F(i,j))=i;                     % ��Ӧ������Ҳ����CP
                    M_sg(F(i,j))=0;                     % ͬʱ���Ǹ�����ժ���˵�����ñ��
                    if j<Num                              % ���Ů�����ܵ����鲻�������Լ��ϲ�������������Ը���ϲ���������оܾ�Ȩ
                        for k=j+1:Num                   % ��鿴����ϲ��������(��)�����ܿ��ܲ�ֹһ�������Ƿ���������
                            if F_mark(i,k)==1           % ����
                                F_mark(i,k)=0;          % ��ô�����ӵ�����������������(����֮ǰ�����飬�������ѵ�����)
                                for s=1:Num             
                                    if M(F(i,k),s)==i
                                        M(F(i,k),s)=0;  % Ȼ�����������һ�ź��˿�(��������ѷ���)
                                        M_sg(F(i,k))=1; % ���Ǹ��������»ص�����������
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
            continue;                   % ����ʱ����û�յ������Ů��
        end
    end
    times = times+1;
    fprintf("��%d��ƥ�����\n",times);
    
    % ����ÿ���˶��Լ���/Ů���ѵ�����̶�
    % ����ÿ������
    for i=1:Num                             
        if M_sg(i)~=1                       % ����ÿ���ǵ��������
            for j=1:Num                     
                if M(i,j)~=0
                    Mlove_rank(i)=j;        % ��������ǰ��Ů��������jϲ����
                    break;
                end
            end
        end
    end
    % ����ÿ��Ů��
    for i=1:Num
        if sum(F_mark(i,:))~=0               % ����ÿ���ǵ����Ů��
            for j=1:Num
                if F_mark(i,j)~=0
                    Flove_rank(i)=j;        % ��Ů����ǰ������������jϲ����
                    break;
                end
            end
        end
    end
    % ����ÿ��ƥ�����Ů���Լ���Ů��/���ѵ�ϲ���̶�
    Mlove_score(times)=sum(Mlove_rank)/Num;
    Flove_score(times)=sum(Flove_rank)/Num;
end
fprintf("ȫ��ƥ����ɣ�һ��ƥ����%d��\n",times);
            
%% showing the result 
% ��ͼ����ƥ�����ʱÿ���˶��Լ���/Ů���ѵ�����̶�
figure;
plot(Mlove_rank,'.','Markersize',10,'color','b');hold on;
plot(Flove_rank,'.','Markersize',10,'color','r');
xlabel('����');ylabel('ϲ���̶�');text(0,-1,'��ϲ��');text(0,Num+1,'����ôϲ��');
axis([0 Num+1 0 Num+1]);legend('����','Ů��');
% ��ͼ����ÿ���˶��Լ���/Ů���ѵ�����̶����������ӵı仯�̶�
figure;
plot(Mlove_score,'-*','color','b');hold on;
plot(Flove_score,'-*','color','r');
xlabel('ƥ�����');ylabel('ϲ���̶�');text(0,0,'��ϲ��');text(0,Num,'����ôϲ��');
axis([0 times+1 0 Num+1]);legend('����','Ů��');

%%