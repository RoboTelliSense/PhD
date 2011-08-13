#include <cv.h> 
#include <cxcore.h>
#include <highgui.h> 

#pragma comment(lib, "cv210d.lib")
#pragma comment(lib, "cxcore210d.lib")
#pragma comment(lib, "highgui210d.lib")



int main(void)
{
	int xSize		=	480;
	int ySize		=	360;

	IplImage* Img	=	cvCreateImage(cvSize(xSize,ySize),16,1);

	int i			=	0;

	for(int y = 0; y < ySize; y++)
	{
		uchar* ptr = (uchar*) Img->imageData+y*Img->widthStep;
		for(int x = 0; x < xSize; x++)
		{ 
			ptr[x] = 3;
			i++;
		}
	}

	return 1;
}

