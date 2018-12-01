function[dataX,S1,S2,Did,Tid]=getdata1(~,~)

matrix = csvread('data/matrix.csv',1,3);
dataX = matrix';
ncol = 10000;
s = RandStream('mt19937ar','Seed',0);
x = randperm(s,size(dataX,2),ncol);
columns = dataX(:,x);
dataX = columns;
S1 = get_similarity_matrix(dataX);
S2 = get_similarity_matrix(dataX');

Did=[]; Tid=[];
end

