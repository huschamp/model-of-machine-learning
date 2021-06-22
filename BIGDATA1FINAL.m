clear;
clc;
x=randi([1,100],500,1);
y=randi([1,50],500,1);
x1=randi([1,100],500,1);
y1=randi([51,100],500,1);
m=[x y];
m=unique(m,'rows');
x=m(:,1);
y=m(:,2);
m1=[x1 y1];
m1=unique(m1,'rows');
x1=m1(:,1);
y1=m1(:,2);
dlmwrite('C:\big\mat.txt', m, 'newline', 'pc');
dlmwrite('C:\big\mat1.txt', m1, 'newline', 'pc');
vx=randi([1,100], 9000,1);
vy=randi([1,100], 9000,1);
vm=[vx vy];
vm=unique(vm,'rows');
vx=vm(:,1);
vy=vm(:,2);
vxcopy=vx;
vycopy=vy;
qeys=[];
qexs=[];
qeys1=[];
qexs1=[];
%%%%%%
G=[];
for i=2:length(x)
   if x(i)==x(i-1)
       i=i+1;
   else
       G=[G i-1];
   end;
end;
G=[G length(x)];
xBline=unique(x);
yBline=[];
for i=1:length(xBline)
    yBline=[yBline y(G(i))];
end;
%
G1=[];
for i=2:length(x1)
   if x1(i)==x1(i-1)
       i=i+1;
   else
       G1=[G1 i];
   end;
end;
G1=[G1 length(x1)];
xBline1=unique(x1);
yBline1=[];
for i=1:length(xBline1)
    yBline1=[yBline1 y1(G1(i))];
end;
yBline1(length(yBline1))=[];
yBline1=[y1(1) yBline1];
if length(xBline1)<length(xBline)
    xx=xBline1;
else
    xx=xBline;
end;
yy=[];
L=[length(G) length(G1)]
for i=1:(min(L))
   % if length(xx)>length(G1)
   %     i+1;
   % end;
   % if length(G)>length(G1)
   %     i+1;
   % end;
    raz=(yBline(i)+yBline1(i))/2;
    yy=[yy raz];
end;
xG=G;
xG1=G1;
%%%%%%%%
subplot(2,2,1)
plot(x,y,'.')
hold on
plot(x1,y1,'k.')
hold on
%plot(vx,vy,'r.')
hold on
%cc=spline(xx,yy)
plot(xx,yy,'g-')
subplot(2,2,2)
plot(x,y,'.')
hold on
plot(x1,y1,'k.')
hold on
plot(vx,vy,'r.')
hold on
plot(xx,yy,'g-')
vm=[vx vy];
S=0;
k=1;
ff=length(x);
ff1=length(x1);
while S~=1
    if k>25
        break;
    end;
    H=[];
    %k=input('Kol-vo sosedei');
    %for i=1:(size(vx)-1)
    r=[10000];
    r1=[10000];
    black=0;
    blue=0;
    vxBlue=[];
    vxBlack=[];
    vyBlue=[];
    vyBlack=[];
    count=0;
    H1=[];
    zz=0;
    xcopy=x;
    ycopy=y;
    unknowx=[];
    unknowy=[];
    x1copy=x1;
    y1copy=y1;
    d=1;
    cv=0;
    Hw=[];
    Hw1=[];
    for d=1:(length(x)+length(x1))
        if cv==2
            vx=x1(-1*(length(x))+d);
            vy=y1(-1*(length(x))+d);
            x1=x1copy;
            y1=y1copy;
            x1copy=x1;
            y1copy=y1;
            x1(-1*(length(x))+d)=[];
            y1(-1*(length(x))+d)=[];
        else
            vx=x(d);
            vy=y(d);
            x=xcopy;
            y=ycopy;
            xcopy=x;
            ycopy=y;
            x(d)=[];
            y(d)=[];
        end; 
        for i=1:(size(vx))
            for t=1:k
                for j=1:(size(x)+1-t-1)
                            l=abs(vx(i)-x(j));
                            h=abs(vy(i)-y(j));
                            g=l^2+h^2;
                            gw=1/g;
                            if j<length(x1)+1-t-1
                                l1=abs(vx(i)-x1(j));
                                h1=abs(vy(i)-y1(j));
                                g1=l1^2+h1^2;
                                gw1=1/g1;
                            end;
                            if g<r(t)
                                r(t)=g;
                                H=[];
                                H=[H j];
                                Hw(t)=gw;
                            end;
                            if g1<r1(t)
                                r1(t)=g1;
                                H1=[];
                                H1=[H1 j];
                                Hw1(t)=gw1;
                               % Hw1=[Hw1 j];
                            end;
                end;
                b=H(1);
                x(b)=[];
                y(b)=[];
                x1(H1)=[];
                y1(H1)=[];
                if t~=k
                    r=[r 10000];
                    r1=[r1 10000];
                end;
            end;
            x=xcopy;
            y=ycopy;
            x1=x1copy;
            y1=y1copy;
            for u=1:k
                if r1(u)>r(u)
                blue=blue+1;
               % vxBlue=[vxBlue vx(i)];
               % vyBlue=[vyBlue vy(i)];
                end;
                if r1(u)<r(u)
                black=black+1;
               % vxBlack=[vxBlack vx(i)];
              %  vyBlack=[vyBlack vy(i)];
                end;
                if r1(u)==r(u)
                    count=count+1;
                    if Hw(u)>Hw1(u)
                        blue=blue+1;
                    else
                        black=black+1;
                    end;
                end;
            end;
            if black>blue
                vxBlack=[vxBlack vx(i)];
                vyBlack=[vyBlack vy(i)];
            end;
            if black<blue
                vxBlue=[vxBlue vx(i)];
                vyBlue=[vyBlue vy(i)];
            end;
            if black==blue
                 zz=zz+1;
                Weight=0;
                Weight1=0;
                for u=1:k
                    Weight=Weight+Hw(u);
                    Weight1=Weight1+Hw1(u);
                end;
                if Weight>Weight1
                    vxBlue=[vxBlue vx(i)];
                    vyBlue=[vyBlue vy(i)];
                else 
                    vxBlack=[vxBlack vx(i)];
                    vyBlack=[vyBlack vy(i)];
                end;
               % unknowx=[unknowx vx(i)];
                %unknowy=[unknowy vy(i)];
            end;
            r=[10000];
            r1=[10000];
            count=0;
            blue=0;
            black=0;
        end;
        if d==(length(x))
            cv=2;
        end;
    end;
    l=0;
    for i=1:size(vxBlue)
        if vxBlue(i)==x(i)
            l=l+1;
        end;
    end;
    ex=isempty(setxor(vxBlue,x));
    ey=isempty(setxor(vyBlue,y));
    ex1=isempty(setxor(vxBlack,x1));
    ey1=isempty(setxor(vyBlack,y1));
    qex=setxor(vxBlue,x);
    qey=setxor(vyBlue,y);
    qex1=setxor(vxBlack,x1);
    qey1=setxor(vyBlack,y1);
    qeys=[qeys length(qey)];
    qeys1=[qeys1 length(qey1)];
    qexs=[qexs length(qex)];
    qexs1=[qexs1 length(qex1)];
    if ex==1 && ey==1 && ex1==1 && ey1==1
        S=1;
    end;
    k=k+3;
end;
if S~=1
    q=[qeys1;qeys;qexs;qexs1];
    minM=[]
    for i=1:length(qeys)
        min1=qeys(i)+qeys1(i)+qexs(i)+qexs1(i);
        minM=[minM min1];
    end;
    [Mmin,k]=min(minM);%наилучший k
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    H=[];
    %k=input('Kol-vo sosedei');
    %for i=1:(size(vx)-1)
    r=[10000];
    r1=[10000];
    black=0;
    blue=0;
    vxBlue=[];
    vxBlack=[];
    vyBlue=[];
    vyBlack=[];
    count=0;
    H1=[];
    zz=0;
    xcopy=x;
    ycopy=y;
    unknowx=[];
    unknowy=[];
    x1copy=x1;
    y1copy=y1;
    d=1;
    cv=0;
    Hw=[];
    Hw1=[];
    for d=1:(length(x)+length(x1))
        if cv==2
            vx=x1(-1*(length(x))+d);
            vy=y1(-1*(length(x))+d);
            x1=x1copy;
            y1=y1copy;
            x1copy=x1;
            y1copy=y1;
            x1(-1*(length(x))+d)=[];
            y1(-1*(length(x))+d)=[];
        else
            vx=x(d);
            vy=y(d);
            x=xcopy;
            y=ycopy;
            xcopy=x;
            ycopy=y;
            x(d)=[];
            y(d)=[];
        end; 
        for i=1:(size(vx))
            for t=1:k
                for j=1:(size(x)+1-t-1)
                            l=abs(vx(i)-x(j));
                            h=abs(vy(i)-y(j));
                            g=l^2+h^2;
                            gw=1/g;
                            if j<length(x1)+1-t-1
                                l1=abs(vx(i)-x1(j));
                                h1=abs(vy(i)-y1(j));
                                g1=l1^2+h1^2;
                                gw1=1/g1;
                            end;
                            if g<r(t)
                                r(t)=g;
                                H=[];
                                H=[H j];
                                Hw(t)=gw;
                            end;
                            if g1<r1(t)
                                r1(t)=g1;
                                H1=[];
                                H1=[H1 j];
                                Hw1(t)=gw1;
                               % Hw1=[Hw1 j];
                            end;
                end;
                b=H(1);
                x(b)=[];
                y(b)=[];
                x1(H1)=[];
                y1(H1)=[];
                if t~=k
                    r=[r 10000];
                    r1=[r1 10000];
                end;
            end;
            x=xcopy;
            y=ycopy;
            x1=x1copy;
            y1=y1copy;
            for u=1:k
                if r1(u)>r(u)
                blue=blue+1;
               % vxBlue=[vxBlue vx(i)];
               % vyBlue=[vyBlue vy(i)];
                end;
                if r1(u)<r(u)
                black=black+1;
               % vxBlack=[vxBlack vx(i)];
              %  vyBlack=[vyBlack vy(i)];
                end;
                if r1(u)==r(u)
                    count=count+1;
                    if Hw(u)>Hw1(u)
                        blue=blue+1;
                    else
                        black=black+1;
                    end;
                end;
            end;
            if black>blue
                vxBlack=[vxBlack vx(i)];
                vyBlack=[vyBlack vy(i)];
            end;
            if black<blue
                vxBlue=[vxBlue vx(i)];
                vyBlue=[vyBlue vy(i)];
            end;
            if black==blue
                 zz=zz+1;
                Weight=0;
                Weight1=0;
                for u=1:k
                    Weight=Weight+Hw(u);
                    Weight1=Weight1+Hw1(u);
                end;
                if Weight>Weight1
                    vxBlue=[vxBlue vx(i)];
                    vyBlue=[vyBlue vy(i)];
                else 
                    vxBlack=[vxBlack vx(i)];
                    vyBlack=[vyBlack vy(i)];
                end;
               % unknowx=[unknowx vx(i)];
                %unknowy=[unknowy vy(i)];
            end;
            r=[10000];
            r1=[10000];
            count=0;
            blue=0;
            black=0;
        end;
        if d==(length(x))
            cv=2;
        end;
    end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,2,3)
plot(vxBlack,vyBlack,'k.')
hold on;
plot(vxBlue,vyBlue,'.')
hold on;
plot(unknowx,unknowy,'*g')
vx=vxcopy;
vy=vycopy;
vxBlue=[];
vyBlue=[];
vxBlack=[];
vyBlack=[];
unknowx=[];
unknowy=[];
for i=1:(size(vx))
            for t=1:k
                for j=1:(size(x)+1-t-1)
                            l=abs(vx(i)-x(j));
                            h=abs(vy(i)-y(j));
                            g=l^2+h^2;
                            gw=1/g;
                            if j<length(x1)+1-t-1
                                l1=abs(vx(i)-x1(j));
                                h1=abs(vy(i)-y1(j));
                                g1=l1^2+h1^2;
                                gw1=1/g1;
                            end;
                            if g<r(t)
                                r(t)=g;
                                H=[];
                                H=[H j];
                                Hw(t)=gw;
                            end;
                            if g1<r1(t)
                                r1(t)=g1;
                                H1=[];
                                H1=[H1 j];
                                Hw1(t)=gw1;
                               % Hw1=[Hw1 j];
                            end;
                end;
                b=H(1);
                x(b)=[];
                y(b)=[];
                x1(H1)=[];
                y1(H1)=[];
                if t~=k
                    r=[r 10000];
                    r1=[r1 10000];
                end;
            end;
            x=xcopy;
            y=ycopy;
            x1=x1copy;
            y1=y1copy;
            for u=1:k
                if r1(u)>r(u)
                blue=blue+1;
                end;
                if r1(u)<r(u)
                black=black+1;
                end;
                if r1(u)==r(u)
                    count=count+1;
                    if Hw(u)>Hw1(u)
                        blue=blue+1;
                    else
                        black=black+1;
                    end;
                end;
            end;
            if black>blue
                vxBlack=[vxBlack vx(i)];
                vyBlack=[vyBlack vy(i)];
            end;
            if black<blue
                vxBlue=[vxBlue vx(i)];
                vyBlue=[vyBlue vy(i)];
            end;
            if black==blue
                zz=zz+1;
                Weight=0;
                Weight1=0;
                for u=1:k
                    Weight=Weight+Hw(u);
                    Weight1=Weight1+Hw1(u);
                end;
                if Weight>Weight1
                    vxBlue=[vxBlue vx(i)];
                    vyBlue=[vyBlue vy(i)];
                else 
                    vxBlack=[vxBlack vx(i)];
                    vyBlack=[vyBlack vy(i)];
                end;
                %unknowx=[unknowx vx(i)];
                %unknowy=[unknowy vy(i)];
            end;
            r=[10000];
            r1=[10000];
            count=0;
            blue=0;
            black=0;
end;
subplot(2,2,4)
plot(vxBlack,vyBlack,'k.')
hold on;
plot(vxBlue,vyBlue,'.')
hold on;
plot(unknowx,unknowy,'*g')
vBm=[vxBlue;vyBlue];
G=[];
for i=2:length(vxBlue)
   if vxBlue(i)==vxBlue(i-1)
       i=i+1;
   else
       G=[G i-1];
   end;
end;
G=[G length(vxBlue)];
vxBline=unique(vxBlue);
vyBline=[];
for i=1:length(vxBline)
    vyBline=[vyBline vyBlue(G(i))];
end;
%%%%%%%%
G1=[];
for i=2:length(vxBlack)
   if vxBlack(i)==vxBlack(i-1)
       i=i+1;
   else
       G1=[G1 i];
   end;
end;
G1=[G1 length(vxBlack)];
vxBline1=unique(vxBlack);
vyBline1=[];
for i=1:length(vxBline1)
    vyBline1=[vyBline1 vyBlack(G1(i))];
end;
vyBline1(length(vyBline1))=[];
vyBline1=[vyBlack(1) vyBline1];
vxx=vxBline1;
vyy=[];
for i=1:length(vxBline1)
    raz=(vyBline(i)+vyBline1(i))/2;
    vyy=[vyy raz];
end;
lin1=plot(vxx,vyy,'r-')
set(lin1,'linewidth',1);