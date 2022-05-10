function [Phi] = Intercorrelation(x,y,N,i)
    ans = 0;
    for k=1:N
        if k-i>0
            ans = ans + x(k)*y(k-i);
        end
    end
    Phi = ans/N;
end