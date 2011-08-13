#include "C:\\OpenCV2.0\\include\\opencv\\highgui.h"


//lib files
//---------
#ifdef _DEBUG
	#pragma comment(lib,"c:\\OpenCV2.0_build\\lib\\debug\\cxcore200d.lib")	
	#pragma comment(lib,"c:\\OpenCV2.0_build\\lib\\debug\\cv200d.lib")
	#pragma comment(lib,"c:\\OpenCV2.0_build\\lib\\debug\\highgui200d.lib")	
#endif

//--------------------------------------------------------------------------------------------------------
//
//--------------------------------------------------------------------------------------------------------
void UTIL_save_imageBuffer_to_file(unsigned char* data, char* filename, int width, int height)
{
	int square_length;
	if (height > width)
		square_length = height;
	else
		square_length = width;
	

	IplImage* imgINP	= cvCreateImageHeader(cvSize(square_length,square_length), 8, 4);
	imgINP->imageData	= (char*)data;

	cvNamedWindow("test");
	cvShowImage("test", imgINP);
	cvWaitKey(0);

	cvSaveImage(filename, imgINP);
	cvReleaseImage(&imgINP);
}





