clear;
clc;
x=1:1:100;
X=([1:100]);
Y=([1:100]);
[Xp Yp]=meshgrid(X',Y');
ress=[Xp(:) Yp(:)];
x=randi([1,100],500,1);
y=randi([1,100],500,1);
m=[x y];
m=unique(m,'rows');
re=setdiff(ress,m,'rows');
x=m(:,1);
y=m(:,2);
kk=0.5:0.1:5;
ki=randi([1 length(kk)]);
k=kk(ki);
t=k*x+14;
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
subplot(3,1,1)
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
    classd=[classd -1];
end;
classd=classd;
md=[md; classd]';
classu=[];
for i=1:length(xu)
    classu=[classu 1];
end;
classu=classu;
xu=xu';
yu=yu';
mu=[xu,yu];
mu=mu';
mu=[mu; classu]';
mm=[md;mu];
ctrl=[];
while length(ctrl)<10000
    i=randi([1 length(re)]);
    ctrl=cat(1,ctrl,re(i,1:2));
end;
ctrl=unique(ctrl,'rows');
ctrlx=ctrl(:,1);
ctrly=ctrl(:,2);
ctrlxd=[];
ctrlyd=[];
ctrlxu=[];
ctrlyu=[];
ctrlt=k*ctrlx+14;
for i=1:length(ctrlx)
    if ctrly(i)<ctrlt(i)
        ctrlyd=[ctrlyd ctrly(i)];
        ctrlxd=[ctrlxd ctrlx(i)];
    end;
    if ctrly(i)>=ctrlt(i)
        ctrlyu=[ctrlyu ctrly(i)];
        ctrlxu=[ctrlxu ctrlx(i)];
    end;
end;
while length(ctrlxd)>170
    i=randi([1 length(ctrlxd)]);
    ctrlxd(i)=[];
    ctrlyd(i)=[];
end;
while length(ctrlxu)>170
 i=randi([1 length(ctrlxu)]);
    ctrlxu(i)=[];
    ctrlyu(i)=[];
end;
subplot(3,1,2);
plot(x1,t1,'g-','LineWidth', 2)
hold on
plot(ctrlxu,ctrlyu,'b.')
hold on
plot(ctrlxd,ctrlyd,'k.')
%z=0
class=mm(:,3);
e=ones(170);
e=e(1,:);
eminus=e*-1;
ctrlmu=[ctrlxu;ctrlyu;e];
ctrlmd=[ctrlxd;ctrlyd;eminus];
ctrlm=[ctrlmu ctrlmd];
classctrl=[e eminus];
T=class';
P=mm';
P=P(1:2,:);
o3=[];
sl=4;
os3=[];
iter3=[];
neur3=[];
PP=P;
for i=1:sl
    for j=1:sl
        for k=1:sl
            net3=feedforwardnet([i j k]);
            [net3, info]=train(net3,P,T);
            o3=[o3;sim(net3,ctrlm(1:2,:))];
            os3=[os3;info.best_perf];
            iter3=[iter3;info.num_epochs];
            neur3=[neur3;i j k];
        end;
    end;
end;
o2=[];
os2=[];
iter2=[];
neur2=[];
for i=1:sl
    for j=1:sl
            net2=feedforwardnet([i j]);
            [net2, info]=train(net2,P,T);
            o2=[o2;sim(net2,ctrlm(1:2,:))];
            os2=[os2;info.best_perf];
            iter2=[iter2;info.num_epochs];
            neur2=[neur2;i j];
            
    end;
end;
o2=roundn(o2,0);
ooo2=[];
index2=[];
imba2=os2.*iter2;
[A2 N2]=min(imba2);
o3=roundn(o3,0);
ooo3=[];
index3=[];
imba3=os3.*iter3;
[A3 N3]=min(imba3);
h=o3(4,:);
h2=o3(5,:);
lll=setxor(h,classctrl);
lll2=setxor(h2,classctrl);
for f=1:(sl^3)
    ooo3=[ooo3;setdiff((setxor(o3(f,:),classctrl,'rows')),classctrl,'rows')];
    if isempty(setxor(o3(f,:),classctrl,'rows'))==1
        index3=[index3 f];
        ooo3=[ooo3; classctrl];
    end;
end;
for f=1:(sl^2)
    ooo2=[ooo2;setdiff((setxor(o2(f,:),classctrl,'rows')),classctrl,'rows')];
    if isempty(setxor(o2(f,:),classctrl,'rows'))==1
        index2=[index2 f];
        ooo2=[ooo2; classctrl];
    end;
end;
%%%%%%%%%%%%
oshibka3=[];
oshibka2=[];
for l=1:length(ooo3(:,1))
    for p=1:length(ooo3(1,:))
        if ooo3(l,p)==classctrl(p)
            ooo3(l,p)=0;
        else
            ooo3(l,p)=1;
        end;
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%% c этого момента
for l=1:length(ooo2(:,1))
    for p=1:length(ooo2(1,:))
        if ooo2(l,p)==classctrl(p)
            ooo2(l,p)=0;
        else
            ooo2(l,p)=1;
        end;
    end;
end;
for l=1:length(ooo2(:,1))
    oshibka2=[oshibka2 sum(ooo2(l,:))];
end;
for l=1:length(ooo3(:,1))
    oshibka3=[oshibka3 sum(ooo3(l,:))];
end;
%%%%%%%%%%%%
[A2 N2]=min(oshibka2);
[A3 N3]=min(oshibka3);
imba2c=imba2;
imba3c=imba3;
imba3=os3.*iter3;
imba2=os2.*iter2;
% if length(index2)~=0 && length(index3)~=0
%     for i=1:length(imba3)
%         for j=1:length(index3)
%             if i~=index3(j)
%                 imba3(i)=2;
%             else
%                 imba3(i)=imba3c(i);
%                 break;
%             end;
%         end;
%     end;
%     for i=1:length(imba2)
%         for j=1:length(index2)
%             if i~=index2(j)
%                 imba2(i)=2;
%             else
%                 imba2(i)=imba2c(i);
%                 break;
%             end;
%         end;
%     end;
%     [A2 N2]=min(imba2);%двухслойная с наименьшим кол во нейр
%     [A3 N3]=min(imba3);
% end;
% if (length(index2)~=0 && length(index3)==0)
%      for i=1:length(imba2)
%         for j=1:length(index2)
%             if i~=index2(j)
%                 imba2(i)=2;
%             else
%                 imba2(i)=imba2c(i);
%                 break;
%             end;
%         end;
%     end;
%     [A2 N2]=min(imba2);
%      A3=1;
% end;
% if (length(index3)~=0 && length(index2)==0)
%     for i=1:length(imba3)
%         for j=1:length(index3)
%             if i~=index3(j)
%                 imba3(i)=2;
%             else
%                 imba3(i)=imba3c(i);
%                 break;
%             end;
%         end;
%     end;
%     [A3 N3]=min(imba3);
%      A2=1;
% end;
% if (length(index3)==0 && length(index2)==0)
%     o31=o3(:,1:170);
%     o32=o3(:,171:340);
%     OS31=sum(o31');
%     OS32=sum(o32');
%     o21=o2(:,1:170);
%     o22=o2(:,171:340);
%     OS21=sum(o21');
%     OS22=sum(o22');
%     OS2=OS21+OS22;
%     OS3=OS31+OS32;
%     [A2 N2]=min(abs(OS2));
%     [A3 N3]=min(abs(OS3));
% end;
if (A3+1)<=A2
    N=N3;
    i=neur3(N,1);
    j=neur3(N,2);
    k=neur3(N,3);
else
    N=N2;
    i=neur2(N,1);
    j=neur2(N,2);
end;
%funcactivpak='satlin'; %satlin
%funcactiv='satlin';
funcactivpak='tansig'; %satlin
funcactiv='tansig';
if (A3+1)<=A2
    %netposl=feedforwardnet([i j k],{'hardlim','hardlim','hardlim'});
    %netpak=feedforwardnet([i j k]),{'hardlim','hardlim','hardlim'};
    netposl=newff(PP,T,[i j k],{funcactiv,funcactiv,funcactiv});
    netpak=newff(PP,T,[i j k],{funcactivpak,funcactivpak,funcactivpak});
else
    %netposl=feedforwardnet([i j],{'hardlim','hardlim'});
    netposl=newff(PP,T,[i j],{funcactiv,funcactiv});
    netpak=newff(PP,T,[i j],{funcactivpak,funcactivpak});
    %netpak=feedforwardnet([i j],{'hardlim','hardlim'});
end;
colvo=10000;
%netposl.trainFcn='trains';
netposl.divideFcn='';
netposl.trainParam.epochs=colvo;
[netposl, infoposl]=train(netposl,PP,T);
%netpak.trainFcn='trainb';
netpak.divideFcn='';
netpak.trainParam.epochs=colvo;
[netpak, infopak]=train(netpak,PP,T);
eposl=infoposl.num_epochs;
epak=infopak.num_epochs;
P=ctrlm;
o1posl=sim(netposl,re');
if infoposl.best_perf<infopak.best_perf
    o1=sim(netposl,re');
else
    o1=sim(netpak,re');
end;
classnet=[];
o=o1';
for i=1:length(o)
    if o(i)>0
        classnet(i)=1;
    else
        classnet(i)=-1;
    end;
end;
classnet=classnet';
ooo=setxor(classctrl',classnet,'rows');
cc=ctrlm(1:2,:)';
cc=re;
m=cat(2,cc,classnet);
z=0;
sm=m;
sm=sortrows(m,3)
for i=1:length(sm)
    if sm(i,3)==1
        z=i;
        break;
    end;
end;
smd=sm(1:z-1,:);
smu=sm(z:length(sm),:);
subplot(3,1,3)
plot(x1,t1,'g-', 'LineWidth', 2);
hold on
plot(smu(:,1),smu(:,2),'b.');
hold on
plot(smd(:,1),smd(:,2),'k.');