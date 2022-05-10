function [V,D] = eigtrivpd( A,B,nr )
% nr = 1 : normalisation de la norme des vecteurs par rapport à B : V'BV=I
if nargin < 3
    nr = 0;
end
if nargin == 1
    [V,D] = eig(A);
else
    [V,D] = eig(A,B);
end
D = diag(D);
n = length(D);
[Dord,ordre] = sort(D,'descend');
for i=1:n
    Vord(:,i) = V(:,ordre(i));
end
V = Vord;
D = Dord;

if nr == 1
    for i = 1:n % pour avoir Wn'*Wn=Ip !! nécessaire ?
        V(:,i) = V(:,i) / sqrt(V(:,i)'*B*V(:,i)) ;
    end
end

