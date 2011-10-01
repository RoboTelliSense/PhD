function RVQtype        =   RVQ__testing_rule_string(idx)

    if (idx ==1)
        RVQtype = 'maxQ';   %max stages
    elseif (idx ==2)
        RVQtype = 'RofE';   %realm of experience
    elseif (idx ==3)
        RVQtype = 'nulE';   %null encoding
    elseif (idx ==4)
        RVQtype = 'monE';   %monotonically decreasing rmse
    end
 