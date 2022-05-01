function [Phi] = Autocorrelation(x,N,Z)
    for i=1:Z
        ans = 0;
        for k=1:N
            if k-i>0
                ans = ans + x(k)*x(k-i);
            end
        end
        Phi(i) = 1/N * ans;
    end
end

