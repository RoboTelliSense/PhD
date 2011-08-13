function [tgtID, topleft_x, topleft_y, w, h, cx, cy] = RVQ_0_readGroundTruth(GT, fidx)

            tgtID               =   GT(fidx,1);
            f                   =   GT(fidx,2);
            topleft_x           =   GT(fidx,3);
            topleft_y           =   GT(fidx,4);
            w                   =   GT(fidx,5);
            h                   =   GT(fidx,6);
            cx                  =   round(topleft_x + w /2);  %target center, x coordinate
            cy                  =   round(topleft_y + h/2);   %target center, y coordinate