function P_str = P_to_str(P)
    P_str = sprintf('%g\t%g\t%g\t%g\n%g\t%g\t%g\t%g\n%g\t%g\t%g\t%g\n%g\t%g\t%g\t%g\n', ...
                    P(1,1), P(1,2), P(1,3), P(1,4), ...
                    P(2,1), P(2,2), P(2,3), P(2,4), ...
                    P(3,1), P(3,2), P(3,3), P(3,4), ...
                    P(4,1), P(4,2), P(4,3), P(4,4));
end