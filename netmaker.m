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