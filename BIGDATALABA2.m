clear;
clc;
x=1:1:100;
X=([1:100]);
Y=([1:100]);
[Xp Yp]=meshgrid(X',Y');
ress=[Xp(:) Yp(:)];
x=randi([1,100],1000,1);
y=randi([1,100],1000,1);
m=[x y];
m=unique(m,'rows');
re=setdiff(ress,m,'rows');
x=m(:,1);
y=m(:,2);
kk=0.5:0.1:5;
ki=randi([1 length(kk)]);
k=kk(ki);
t=k*x+14;
%hold on
i=0;
t1=[];  
x1=[];
for i=1:length(t)
    if t(i)>=100
        break;
    end;
    t1=[t1 t(i)];
    x1=[x1 x(i)];
    i=i+1;
end;
xd=[];
yd=[];
xu=[];
yu=[];
for i=1:length(x)
    if y(i)<t(i)
        yd=[yd y(i)];
        xd=[xd x(i)];
    end;
    if y(i)>=t(i)
        yu=[yu y(i)];
        xu=[xu x(i)];
    end;
end;
subplot(2,1,1)
plot(x1,t1,'g-','LineWidth', 2)
hold on
plot(xu,yu,'b.')
hold on
plot(xd,yd,'k.')
xd=xd';
yd=yd';
md=[xd,yd];
md=md';
classd=[];
for i=1:length(xd)
    classd=[classd 1];
end;
classd=classd;
md=[md; classd]';
classu=[];
for i=1:length(xu)
    classu=[classu -1];
end;
classu=classu;
xu=xu';
yu=yu';
mu=[xu,yu];
mu=mu';
mu=[mu; classu]';
mm=[md;mu];
os=[];
n=0;
mN1=[];
o=[];
DT=[];
mmcopy=mm;
classificat=[];
oss=[];
%while length(mN1)<length(mm)
for j=1:10
    mN=[];
        mNN=[];
        h=0;
            while length(mN)<=length(mm)
                nrows = size(mm,1);
               % nrand = randi([1 1]); %1000
                rand_rows = randperm(nrows, 1);
                mmN = mm(rand_rows,:);
                mN=[mN;mmN];
            end;
    %        while length(mN)~=length(mm)          
     %           i=randi([1,100]);
      %          mN(i,:)=[];
       %     end;
            mN=unique(mN,'rows');
          % ctrl=[];
           ctrl=setdiff(mm,mN,'rows');
           ctrlz=ctrl;
           ctrl(:,3)=[];
         %%%%??????????????????????%%%%%%%%%  mm=mN;
           mz=cat(1,mm,ctrlz);
           classificat=[];
           n=0;
           os=[];
    for i=1:1:25
        mN=[];
        mNN=[];
        h=0;
            while length(mN)<=length(mm)
                nrows = size(mm,1);
               % nrand = randi([1 10]); %1000
                rand_rows = randperm(nrows, 1);
                mmN = mm(rand_rows,:);
                mN=[mN;mmN];
            end;
       %     while length(mN)~=length(mm)          
        %        i=randi([1,100]);
         %       mN(i,:)=[];
          %  end;
            mN=unique(mN,'rows');
          % ctrl=[];
         %%%%  ctrl=setdiff(mm,mN,'rows');
        %%%%   ctrl(:,3)=[];
        DT = fitctree(mN(:,1:2), mN(:,3)); %, 'SplitCriterion', 'deviance', 'CategoricalPredictors','all'); 
        %view(DT,'mode','graph')
        n=n+1;
        cl=predict(DT,ctrl(:,1:2));
       % while length(cl)<1000
       %   cl=[cl;0];
       % end;
        classificat=cat(2,classificat,cl);
        if n~=1
            sumclass=sum(classificat');
        else
            sumclass=classificat;
        end;
        for i=1:(length(sumclass))
            if sumclass(i)>0
                sumclass(i)=1;
            end;
            if sumclass(i)<0
                sumclass(i)=-1;
            end;
        end;
        for i=(length(sumclass)):-1:length(ctrl)+1
            sumclass(i)=[];
        end;
       if n==1
         vb=ctrl;
         vb=cat(2,vb,sumclass);
       else
           sumclass=sumclass';
           vb=cat(2,ctrl,sumclass);
       end;
     %   vb=vb;
        ooo=setxor(ctrlz,vb,'rows');
       %%%% oshibka=setdiff(mm,vb,'rows');
       % oshibka=setdiff(mz,vb,'rows');
      %%%%  oshibka=length(oshibka);
     %%%   o=[o oshibka];
        os=[os;length(ooo)/length(ctrl)];
        if n==25
            if length(oss)==0
                oss=cat(1,oss,os);
            else
                oss=cat(2,oss,os);
            end;
        end;
    end;
end;
v=0;
%%%o=o';
oss=oss';
osum=sum(oss(1:10,:));
[A z]=min(osum);
%a=mod(z,25);
%%%%n=z;%optimal chislo derev
n=z;
sx=randi([1,100],9000,1);
sy=randi([1,100],9000,1);
sm=[sx sy];
sm=unique(sm,'rows');
sm=re;
les=TreeBagger(n,mm(:,1:2),mm(:,3));%, 'OOBPredictorImportance' , 'On' );
ct=predict(les,sm(:,1:2));
ctt = str2double(ct);
%ctt=ctt;
sm=cat(2,sm,ctt);
sm=sortrows(sm,3);
z=0;
for i=1:length(sm)
    if sm(i,3)==1
        z=i;
        break;
    end;
end;
smu=sm(1:z-1,:);
smd=sm(z:length(sm),:);
subplot(2,1,2)
plot(smu(:,1),smu(:,2),'b.');
hold on
plot(smd(:,1),smd(:,2),'k.');
hold on;
plot(x1,t1,'g-', 'LineWidth', 2);
figure
plot(1:10,oss(1:10,1),'b');
hold on
plot(1:10,oss(1:10,2),'r');
hold on
plot(1:10,oss(1:10,n),'g');
hold on
plot(1:10,oss(1:10,25),'k');
