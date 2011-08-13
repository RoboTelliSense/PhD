function [fi, ff, POS] = UTIL_GT_convert_XML_to_txt(cfn_xml, cfn_txt, tgtID, Ih, Ih_desired, bInvert) %Ih is image Ih
    %-----------------------------            
    %INITIALIZATIONS
    %-----------------------------
        %matlab
        %------
            path(path, 'xml_toolbox');
            
            factor = Ih/Ih_desired;

        %files
        %-----
            %declarations
            BOTTOM      =   [];
            TOP         =   [];
            RIGHT       =   [];
            LEFT        =   [];
            base_X      =   [];
            base_Y      =   [];
            center_X    =   [];
            center_Y    =   [];
            POS         =   [];
            
            %read input
            xlmstr          =   fileread(cfn_xml);
            data            =   xml_parseany(xlmstr);
            F               =   length(data.OBJECT);                        %total number of frames
            class           =   data.ATTRIBUTE.CLASS
            description     =   data.ATTRIBUTE.DESCRIPTION
            fi              =   str2num(data.ATTRIBUTE.FRAME_CREATED);      %frame created
            ff              =   str2num(data.ATTRIBUTE.FRAME_DESTROYED);    %frame destroyed
            ID              =   str2num(data.ATTRIBUTE.ID);

            %output file
            fid             =   fopen(cfn_txt, 'w');
                
    %-----------------------------            
    %OPERATIONS
    %-----------------------------

            i = 1;
            for f=fi:ff
               
               bottom   =   str2num(data.OBJECT{i}.OBSERVATION{1}.BOUNDING_BOX{1}.ATTRIBUTE.BOTTOM);
               top      =   str2num(data.OBJECT{i}.OBSERVATION{1}.BOUNDING_BOX{1}.ATTRIBUTE.TOP);
               right    =   str2num(data.OBJECT{i}.OBSERVATION{1}.BOUNDING_BOX{1}.ATTRIBUTE.RIGHT);
               left     =   str2num(data.OBJECT{i}.OBSERVATION{1}.BOUNDING_BOX{1}.ATTRIBUTE.LEFT);
               BOTTOM   =   [BOTTOM bottom];
               TOP      =   [TOP top];
               RIGHT    =   [RIGHT right    ];
               LEFT     =   [LEFT left    ];
               center_X =   [center_X str2num(data.OBJECT{i}.OBSERVATION{1}.CENTROID{1}.ATTRIBUTE.CENTER_X)];
               center_Y =   [center_Y str2num(data.OBJECT{i}.OBSERVATION{1}.CENTROID{1}.ATTRIBUTE.CENTER_Y)];
               base_X   =   [base_X   str2num(data.OBJECT{i}.OBSERVATION{1}.POSITION{1}.ATTRIBUTE.BASE_X)];
               base_Y   =   [base_Y   str2num(data.OBJECT{i}.OBSERVATION{1}.POSITION{1}.ATTRIBUTE.BASE_Y)];
               
               h       =   top-bottom;     %target height
               w       =   right-left;     %target width
               if (bInvert)
                    POS = uint16([POS; [left, Ih-top, w, h]/factor]);  %original is cartesian (y increases upwards, you want y increasing downwards)
               else
                    POS = uint16([POS; [left, top, w, h]/factor]);
               end
               
               fprintf(fid, '%d, %d, %d, %d, %d, %d\n', tgtID, f, POS(i,1), POS(i,2), POS(i,3), POS(i,4));
               sprintf(     '%d, %d, %d  %d  %d  %d\n', tgtID, f, POS(i,1), POS(i,2), POS(i,3), POS(i,4))
               i       =   i+1;
            end 
    
    %-----------------------------            
    %DISPLAY
    %-----------------------------
            %figure;stem(LEFT, '.');
            %figure;stem(RIGHT, '.');
            %figure;stem(TOP, '.');
            %figure;stem(BOTTOM, '.');
            
                fclose(fid);