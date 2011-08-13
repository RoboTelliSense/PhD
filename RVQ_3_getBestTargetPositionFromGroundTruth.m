function [cix, ciy] = RVQ_3_getBestTargetPositionFromGroundTruth(gx, gy, sw, sh)

    [cix, ciy]          =   UTIL_ROI_convert_outer_to_inner_coordinates(gx,gy, sw, sh);
