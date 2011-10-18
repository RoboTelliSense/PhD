function I = UTIL_sampled_vals(t)

    I=find(mod((find(t==t)-1),16)==0); %Power of 2 subset
