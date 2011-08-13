#include <cv.h> 
#include <cxcore.h>
#include <highgui.h> 

#pragma comment(lib, "cv210d.lib")
#pragma comment(lib, "cxcore210d.lib")
#pragma comment(lib, "highgui210d.lib")


//----------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------
int main(int argc, char** argv)
{

	////////////////////////////////////////
	//INITIALIZATION
	////////////////////////////////////////

		//command line parameters
			char*  cfn_I_rgb	= argv[1];
			char*  cfn_Itmp_rgb = argv[2];
			
			cfn_I_rgb		= "PHI_508_padded.png";
			cfn_Itmp_rgb	= "PHI_trg_padded.png";

			cvLoadImage("img\\I1.pgm", 0);


		//hold min/max values of template matching operation
			double min_val;	
			double max_val;
			CvPoint min_loc;
			CvPoint max_loc;
			double range;
			double scale;
			double bias;

		//input images
			//load input RGB images
			IplImage* I_rgb			=	cvLoadImage(cfn_I_rgb);
			IplImage* Itmp_rgb		=	cvLoadImage(cfn_Itmp_rgb);

																		cvNamedWindow("template");
																		cvShowImage("template", Itmp_rgb);
			
																		cvNamedWindow("input");
																		cvShowImage("input", I_rgb);
			
																		cvWaitKey(0);


			//convert input images to gray
			IplImage* I_gry			=	cvCreateImage(cvSize(I_rgb->width,		I_rgb->height),		IPL_DEPTH_8U, 1);
			IplImage* Itmp_gry		=	cvCreateImage(cvSize(Itmp_rgb->width,	Itmp_rgb->height),	IPL_DEPTH_8U, 1);
			
										cvCvtColor(I_rgb,		I_gry,		CV_BGR2GRAY);
										cvCvtColor(Itmp_rgb,	Itmp_gry,	CV_BGR2GRAY);

		//output image	 
			int iw					=	I_gry->width  - Itmp_gry->width + 1;
			int ih					=	I_gry->height - Itmp_gry->height +1;
			IplImage* I_nSSD		=	cvCreateImage(cvSize(iw, ih), IPL_DEPTH_32F, 1);
			IplImage* I_nccorr		=	cvCreateImage(cvSize(iw, ih), IPL_DEPTH_32F, 1);
			IplImage* I_ccoeff		=	cvCreateImage(cvSize(iw, ih), IPL_DEPTH_32F, 1);



	////////////////////////////////////////
	//OPERATIONS
	////////////////////////////////////////


	//template matching
										cvMatchTemplate	(I_gry,		Itmp_gry,	I_nSSD,		CV_TM_SQDIFF_NORMED				);	
										cvMatchTemplate	(I_gry,		Itmp_gry,	I_nccorr,	CV_TM_CCORR_NORMED				);
										cvMatchTemplate	(I_gry,		Itmp_gry,	I_ccoeff,	CV_TM_CCOEFF_NORMED);

										cvMinMaxLoc		(I_nSSD,	&min_val,	&max_val,	&min_loc,	&max_loc,	0	);
										cvMinMaxLoc		(I_nccorr,	&min_val,	&max_val,	&min_loc,	&max_loc,	0	);
										cvMinMaxLoc		(I_ccoeff,	&min_val,	&max_val,	&min_loc,	&max_loc,	0	);



	/*	
		//normalized SSD
		cvScale(I_nSSD, I_nSSD, -1, 1);  //invert err, so new value = 1-err
		cvMinMaxLoc( I_nSSD, &min_val, &max_val, &min_loc, &max_loc, 0);

		cvScale(I_nSSD, I_nSSD, 100, 0); //scale to 0:100
		cvMinMaxLoc( I_nSSD, &min_val, &max_val, &min_loc, &max_loc, 0);

		//correlation coefficient
		cvScale(I_ccoeff, I_ccoeff, 0.5, 0.5); //bring correlation coefficient from -1:1 to 0:1
		cvMinMaxLoc( I_ccoeff, &min_val, &max_val, &min_loc, &max_loc, 0);

		cvScale(I_ccoeff, I_ccoeff, 100, 0); //bring correlation coefficient from 0:1 to 0:100
		cvMinMaxLoc( I_ccoeff, &min_val, &max_val, &min_loc, &max_loc, 0);

		//normalized cross-correlation		
		cvScale(I_nccorr, I_nccorr, 100, 0);
		cvMinMaxLoc( I_nccorr, &min_val, &max_val, &min_loc, &max_loc, 0);
	*/

	//save result
		cvSaveImage("out1.png", I_nSSD);
		cvSaveImage("out2.png", I_nccorr);
		cvSaveImage("out3.png", I_ccoeff);

		//cvNamedWindow("CCoeff_normed", 1);
		//cvShowImage("CCoeff_normed", OUTimg_gry);
		//cvWaitKey(0);

	//wrap up
		cvReleaseImage(&I_rgb);
		cvReleaseImage(&Itmp_rgb);

		cvReleaseImage(&I_gry);
		cvReleaseImage(&Itmp_gry);

		cvReleaseImage(&I_nSSD);
		cvReleaseImage(&I_nccorr);
		cvReleaseImage(&I_ccoeff);

		return 1;

}