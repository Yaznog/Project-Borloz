function [Phi] = Autocorrelation(x,N,i)
    ans = 0;
    for k=1:N
        if k-i>0
            ans = ans + x(k)*x(k-i);
        end
    end
    Phi = ans/N;
end