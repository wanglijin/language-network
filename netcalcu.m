function netcalcu(xfilename)
x1=[xfilename '.txt'];
fid=fopen(x1);
a=fscanf(fid,'%s');
fclose(fid);
N=length(a);
M=zeros(N,N);%生成神奇矩阵
for i=1:N
	for j=1:N
		if a(i)==a(j)
			M(i,j)=1;
		end
	end
end
for i=1:N
	for j=1:N
		if i>=j
			M(i,j)=0;
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
n=find(m==0);%寻找非重复字符坐标
a=a(n);
s=zeros(1,N);%生成神奇序列
m=length(n);
s(:,n)=1:m;
for i=1:N
	for j=1:N
		if M(i,j)==1
			s(:,j)=s(:,i);
		end
	end
end
n=length(a);
Q=zeros(n,n);%生成邻接矩阵
for i=1:N-1
    Q(s(i),s(i+1))=1;
end
x0='，。？?“”"~·．`…；：！!,.、 —-_’《》()（）【】[]{}「」『』''□‘■';%去掉含标点行列
k=length(x0);
for i=1:k
    q(i,:)=(x0(i)==a);
end
q=sum(q);
k=(q==1);
a(k)=[];
Q(k,:)=[];
Q(:,k)=[];
%
Q1=sum(Q);%out degree,row
Q2=sum(Q');%in degree,row
Q3=Q1+Q2;
Q3L=cortrans(Q3);
Q3=Q3(Q3L);
a=a(Q3L);
Q1=Q1(Q3L);
Q2=Q2(Q3L);
a=a';Q1=Q1';Q2=Q2';Q3=Q3';
Q0=[Q2 Q1 Q3];
n=length(a);
n={n};
filename=[xfilename '.xlsx'];
xlswrite(filename,[n {'出度'} {'入度'} {'度'}],1,'A1')
xlswrite(filename,a,1,'A2')
xlswrite(filename,Q0,1,'B2')
    function L=cortrans(Q)
        xam=max(Q);
        L=[];
        for i=1:xam
            l=find(Q==i);
            L=[L l];
        end
        L=L(end:-1:1);
    end
end