function [charseq,sepmat,kl]=netsep(xfilename)
[a,Q]=netmaker(xfilename);
L=sum(Q)+sum(Q');
L=max(L);
L=L(1);

[charseq,sepmat,kl]=pointout(a,Q,L);

netdraw(xfilename,charseq,sepmat);
while isempty(kl)==0
    L=kl(1);
    [charseq, sepmat,kl]=pointout(a,Q,L);
    netdraw(xfilename,charseq,sepmat);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [a,Q]=netmaker(xfilename)
x1=[xfilename '.txt'];
fid=fopen(x1);
a=fscanf(fid,'%s');
fclose(fid);
N=length(a);
%生成神奇矩阵
M=zeros(N,N);
for i=1:N
	for j=1:N
		if (a(i)==a(j))&&(i<j)
			M(i,j)=1;
		end
	end
end
for j=1:N
	m=find(M(:,j)==1);
	if length(m)>1
		M(m(2:end),j)=0;
	end
end
m=sum(M);
%寻找非重复字符坐标
n=find(m==0);
a=a(n);
%生成神奇序列
s=zeros(1,N);
m=length(n);
s(:,n)=1:m;
for i=1:N
	for j=1:N
		if M(i,j)==1
			s(:,j)=s(:,i);
		end
	end
end
%生成邻接矩阵
n=length(a);
Q=zeros(n,n);
for i=1:N-1
    Q(s(i),s(i+1))=1;
end
%去掉含标点行列
x0='，。？?“”"~·．`…；：！!,.、 —-_’《》()（）【】[]{}「」『』''□‘■';
k=length(x0);
q=zeros(k,n);
for i=1:k
    q(i,:)=(x0(i)==a);
end
q=sum(q);
k=(q==1);
a(k)=[];
Q(k,:)=[];
Q(:,k)=[];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [charseq,sepmat,kl]=pointout(a,Q,i0)  
Q0=Q;   
nn=length(a);
S1=sum(Q);
S2=sum(Q');
Sd=S1+S2;
Q(i0,:)=0;
Q(:,i0)=0;
S1=sum(Q);
S2=sum(Q');
Sd1=S1+S2; 
while Sd1~=Sd
    S1=sum(Q);
    S2=sum(Q');
    Sd1=S1+S2;
    for ii=1:nn
        if Sd(ii)~=Sd1(ii)
            Q(ii,:)=0;
            Q(:,ii)=0;
        end
    end
    S1=sum(Q);
    S2=sum(Q');
    Sd=S1+S2;
end
Sq=sum(Q);
kk=find(Sq==0);
kl=find(Sq~=0);
charseq=a(kk);
sepmat=Q0(kk,kk);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function netdraw(xfilename,charseq,sepmat)
nn=length(charseq);
for ii=1:nn
    for jj=1:nn
        if ii==jj
            sepmat(ii,jj)=0;
        end
    end
end
x2=[xfilename 'vec' '.net'];
fiid=fopen(x2,'wt');
fprintf(fiid,'%s\n',['*Vertices',' ',num2str(nn)]);
for ii=1:nn
	jj=num2str(ii);
	fprintf(fiid,'%s\n',[jj,' ','"',charseq(ii),'"']);
end
J=[];
for ii=1:nn
    for jj=1:nn
        if sepmat(ii,jj)~=0
            J=[J;[ii jj]];
        end
    end
end
nn= (J(:,1)==0);
J(nn,:)=[];
mm=length(J(:,1));
fprintf(fiid,'%s\n','*Arcs');
for ii=1:mm
	fprintf(fiid,'%d %d\n',J(ii,:));
end
fclose(fiid);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end