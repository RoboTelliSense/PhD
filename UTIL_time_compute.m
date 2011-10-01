function [tim_T_sec tim_fps]=   UTIL_time_compute(end_time, tim_T_sec)

    tim_t_sec               =   end_time;                                   %time for this run
    tim_T_sec               =   tim_T_sec + tim_t_sec(f);                   %total time for all runs
    tim_fps                 =   f/tim_T_sec;                                %frames per sec for this run