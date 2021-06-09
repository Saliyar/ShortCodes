function b = build_b_acc(p,beta)
% b = build_b_acc(p,beta)
% LIB\BUILD_B_ACC builds the b coefficients from the beta coefficients for
% series convergence acceleration
%
if p < 2
   error('build_b_acc: p must be greater than 2') 
else
    A = build_A(p);
    n = length(beta);
    if n > 5
       error('evaluation of b(i) for i>5 not implemented in build_b_acc') 
    else
        b = A(1:n,1:n) * make_it_column(beta);
    end
    b = reshape(b,size(beta));
end
%
function A = build_A(p)
%
A = zeros(5);
%
A(1,1) = - 1 / (p-1);
A(2,1) = + 1 / 2;
A(2,2) = - 1 / p;
A(3,1) = - p / 12;
A(3,2) = + 1 / 2;
A(3,3) = - 1 / (p+1);
A(4,1) = 0;
A(4,2) = - (p+1) / 12;
A(4,3) = + 1 / 2;
A(4,4) = - 1 / (p+2);
A(5,1) = p * (p+1) * (p+2) / 720;
A(5,2) = 0;
A(5,3) = - (p+2) / 12;
A(5,4) = + 1 / 2;
A(5,5) = - 1 / (p+3);
