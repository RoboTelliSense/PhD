    odir     =   'test_out/'
    dir_I       =   'img/Dudek/';
    ext_I       =   '.png';


%parameter (search window around either target center, or projected position)
    ww          =   13; %width of search window
    wh          =   13; %height of search window
    
%target
    cx          =   66; %target position
    cy          =   66;
    sw          =   33; %target size (=snippet size)
    sh          =   33;
    
    
Iroi = RVQ_2_extractTestingWindow(odir, dir_I, ext_I, f, cx, cy, ww, wh, sw, sh);
imshow(Iroi)

