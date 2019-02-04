load ('q2_2_data.mat');
%disp(data);
x=[trD valD];
trb=[trLb;valLb];
[d,n]=size(x);
disp(n);
f=-1*(ones(n,1));
H=zeros(n,n);
w=zeros(d,10);
A=[];
b=[];
beq =0;
lb=zeros(n,1);
c=0.1;
ub=c*ones(n,1);
y=zeros(size(trb,1),1);
bias=zeros(10,1);
alpha = zeros(size(trb,1),10);
for i=1:10
    for j=1:length(trb)
        if(trb(j)==i)
            y(j)=1;
        else
            y(j)=-1;
        end
    end
    Aeq = y';
    X = x'*x;
    disp(size(X));
    H = double((y * transpose(y).*X));
    
    alpha(:, i) = quadprog(H, f, A, b, Aeq, beq, lb, ub);
    alpha_temp=alpha(:,i);
    w_temp=y.*alpha(:,i);
    w(:,i)=x*w_temp;
    alpha_valid = alpha_temp(alpha_temp > 0.001 & c - alpha_temp > 0.001);
    index = alpha_temp==alpha_valid(1);
    bias(i)=y(index)-(w(:,i)' * x(:, index));
     
end
disp(bias)
%% 
[d1, n1] = size(tstD);
ypred1 =zeros(1, n1);
to_check = zeros(1, 10);
for i = 1:n1
    for j = 1:10
        to_check(j) = w(:, j)' * tstD(:, i)+bias(j);
    end
    [temp_value, temp_index] = max(to_check);
    ypred1(i) = temp_index;
end
% [d2, n2] = size(valD);
% ypred2 =zeros(1, n1);
% to_check1 = zeros(1, 10);
% for i = 1:n1
%     for j = 1:10
%         to_check1(j) = w(:, j)' * valD(:, i)+bias(j);
%     end
%     [temp_value1, temp_index1] = max(to_check1);
%     ypred2(i) = temp_index1;
% end
%  accuracy=sum(valLb==single(ypred1'))/length(valLb);
% disp(accuracy);
%% 
series = linspace(1, 3190, 3190);
%disp(to_check)
series = series';
ypred1 = ypred1';
series(:,2) = ypred1;
% 
csvwrite('submission_new.csv', series);
            