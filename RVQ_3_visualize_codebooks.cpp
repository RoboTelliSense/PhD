#include "stdafx.h"
#include <iostream>
#include <math.h>
#include "VQlib.h"

using namespace std;

#define PIXELSPERPATTERN 65 // max is determined by size (in pixels) of enclosing snippet boxes on popup window
//using namespace System::Runtime::InteropServices;


int			nSnippetWidth;
int			nSnippetHeight;

void				miner_PaintPatternStageCore			(double* dblDSSABuf, byte* pbytPattern, ts_params* ts, int nSnippetWidth, int nSnippetHeight);
void				UTIL_save_imageBuffer_to_file		(unsigned char* data, char* filename, int width, int height);
CString				STR_FILE_CreatefilenameFromFrameNumber(int FileNumber);
void UTIL_save_imageBuffer_to_file(unsigned char* data, char* filename, int width, int height);

//-------------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------------
void main  (int argc, char** argv)	
{
	// Initialize function parameters to get codebooks

	//image
		int				nImageWidth					=	640;
		int				nImageHeight				=	480;

	//snippet
		CString			strSnippetWidth				=	"11";
		CString			strSnippetHeight			=	"41";
		int				nSnippetWidth				=	11;
		int				nSnippetHeight				=	41;

	//datapak
		CString			strEcbkFilename				=	"codebooks.ecbk";
		CString			strDcbkFilename				=	"codebooks.dcbk";
		int				nNumStages					=	8;
		unsigned int	uiNumTemplatesPerStage_plus1	=	3;
		float			fDataPakFidelity			=	1000;

	//image
		int				intBitsPerPixel				=	32;
		int				nNumberPlanesPerImage		=	6;
		int				nRedPlaneLayerIndex			=	1;
		int				nGreenPlaneLayerIndex		=	2;
		int				nBluePlaneLayerIndex		=	3;

	ts_params ts;
	dssa_params dssa;
	dssa.ecbk_filename	=	strEcbkFilename.GetBuffer(0);
	dssa.dcbk_filename	=	strDcbkFilename.GetBuffer(0);
	dssa.cbk_size		=	uiNumTemplatesPerStage_plus1;//(unsigned)atoi(strNumTemplatesPerStage.GetBuffer(0));
	int img_width		=	nImageWidth;
	int img_height		=	nImageHeight;
	int vec_width		=	nSnippetWidth;//atoi(strSnippetWidth);
	int vec_height		=	nSnippetHeight;// atoi(strSnippetHeight);
	
	ts.tsh.vec_width	=	vec_width;
	ts.tsh.vec_height	=	vec_height * nNumberPlanesPerImage;
	dssa.vec_size		=	vec_width * vec_height * nNumberPlanesPerImage;
	


	ts.num_vecs = 0;
	ts.num_samples = 0;

	int intBytesPerRGB;

	if ( intBitsPerPixel == 32 )
	{
		intBytesPerRGB = 4;
	}
	else
	if ( intBitsPerPixel == 24 )
	{
		intBytesPerRGB = 3;
	}
	else
	{
		// COMPLAIN and Quit!!!!!
	}

	int intPixelsPerDisplayedSnippet = PIXELSPERPATTERN;

	int intMaxSnippetDim = MAX(nSnippetHeight, nSnippetWidth);
	
	int intScaleFactor = intPixelsPerDisplayedSnippet / intMaxSnippetDim;

	int nPadWidth = (intScaleFactor*nSnippetWidth*intBytesPerRGB) % 2;//sizeof(LONG); // rows must fill LONG boundaries

	cntrl_params cntrl;
	cntrl.bpp = 4;
	cntrl.encode_only = 0;
	cntrl.threshold = 0.0;
	cntrl.markov_stage = (int)MAXNUMSTAGES - 1;
//	if ( m_bRemoveMeans == TRUE )
//	{
//		cntrl.mean = 1;
//	}
//	else
//	{
		cntrl.mean = 0;
//	}
	cntrl.stop_snr = fDataPakFidelity;//cntrl.stop_snr = atof(strDataPakFidelity);

	
	

	CVQlib VQlib;

	/*Get existing codebooks.*/
	int status = VQlib.get_cbks (&ts, &dssa, &cntrl);



	byte* bytPatternBuf = new byte[(intScaleFactor*intMaxSnippetDim*intBytesPerRGB + nPadWidth)*intScaleFactor*intMaxSnippetDim];

	byte* bytPatternStageBuf = new byte[(intScaleFactor*intMaxSnippetDim*intBytesPerRGB + nPadWidth)*intScaleFactor*intMaxSnippetDim];

	int intSDisplayBytes = (intScaleFactor*intMaxSnippetDim*intBytesPerRGB + nPadWidth)*intScaleFactor*intMaxSnippetDim;

	byte* bytSBuf = new byte[(dssa.cbk_size - 1)*((intScaleFactor*intMaxSnippetDim*intBytesPerRGB + nPadWidth)*intScaleFactor*intMaxSnippetDim)];

	int intColorCodeWidth = PIXELSPERPATTERN;//(int)(1.4 * nSnippetWidth);

	int intColorCodeHeight = (int)(0.4 * PIXELSPERPATTERN);

	byte* bytColorCodeBuf = new byte[(intColorCodeWidth*intBytesPerRGB + nPadWidth)*intColorCodeHeight];

	int i;

	byte* pbytPattern;

	double* cv_ptr1;

	double* cv_ptr2;

	double* cv_ptr3;

	pbytPattern = bytPatternBuf;

	//if ( sttArchiveSessionState.m_strPixelType == "uint8" )
	{
		for ( int n = 0; n < (int)(dssa.cbk_size - 1); n++ )
		{
			pbytPattern = bytSBuf + n * intSDisplayBytes;

			if ( nSnippetWidth > nSnippetHeight )
			{
				int intZeroPad = nSnippetWidth - nSnippetHeight;

				for ( int i = 0; i < intZeroPad / 2; i++ )
				{
					for ( int l = 0; l < intScaleFactor; l++ )
					{
						for ( int j = 0; j < nSnippetWidth; j++ )
						{
							for ( int k = 0; k < intScaleFactor; k++ )
							{
								*pbytPattern = 0;
								++pbytPattern;
								*pbytPattern = 0;
								++pbytPattern;
								*pbytPattern = 0;
								++pbytPattern;
								if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
							}
						}

						// BMP's must be padded to long boundaries
						for ( int j = 0; j < nPadWidth; j++ )
						{
							*pbytPattern++ = 0;
						}
					}
				}
			}
			for ( int i = 0; i < nSnippetHeight; i++ )
			{
				for ( int l = 0; l < intScaleFactor; l++ )
				{
					cv_ptr1 = dssa.enc_cbks[0].vecs
						+ n * ts.tsh.vec_width * ts.tsh.vec_height
						+ nSnippetWidth * nSnippetHeight * (nRedPlaneLayerIndex - 1)
						+ i * ts.tsh.vec_width;
					cv_ptr2 = dssa.enc_cbks[0].vecs
						+ n * ts.tsh.vec_width * ts.tsh.vec_height
						+ nSnippetWidth * nSnippetHeight * (nGreenPlaneLayerIndex - 1)
						+ i * ts.tsh.vec_width;
					cv_ptr3 = dssa.enc_cbks[0].vecs
						+ n * ts.tsh.vec_width * ts.tsh.vec_height
						+ nSnippetWidth * nSnippetHeight * (nBluePlaneLayerIndex - 1)
						+ i * ts.tsh.vec_width;

					if ( nSnippetWidth < nSnippetHeight )
					{
						int intZeroPad = nSnippetHeight - nSnippetWidth;

						for ( int j = 0; j < intZeroPad / 2; j++ )
						{
							for ( int k = 0; k < intScaleFactor; k++ )
							{
								*pbytPattern = 0;
								++pbytPattern;
								*pbytPattern = 0;
								++pbytPattern;
								*pbytPattern = 0;
								++pbytPattern;
								if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
							}
						}
					}

					for ( int j = 0; j < nSnippetWidth; j++ )
					{
						for ( int k = 0; k < intScaleFactor; k++ )
						{
							*pbytPattern = (byte)*cv_ptr3;
							++pbytPattern;
							*pbytPattern = (byte)*cv_ptr2;
							++pbytPattern;
							*pbytPattern = (byte)*cv_ptr1;
							++pbytPattern;
							if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
						}

						++cv_ptr1;
						++cv_ptr2;
						++cv_ptr3;
					}

					if ( nSnippetWidth < nSnippetHeight )
					{
						int intZeroPad = nSnippetHeight - nSnippetWidth;

						for ( int j = 0; j < intZeroPad / 2; j++ )
						{
							for ( int k = 0; k < intScaleFactor; k++ )
							{
								*pbytPattern = 0;
								++pbytPattern;
								*pbytPattern = 0;
								++pbytPattern;
								*pbytPattern = 0;
								++pbytPattern;
								if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
							}
						}
					}

					// BMP's must be padded to long boundaries
					for ( int j = 0; j < nPadWidth; j++ )
					{
						*pbytPattern++ = 0;
					}

				}
			}
			if ( nSnippetWidth > nSnippetHeight )
			{
				int intZeroPad = nSnippetWidth - nSnippetHeight;

				for ( int i = 0; i < intZeroPad / 2; i++ )
				{
					for ( int l = 0; l < intScaleFactor; l++ )
					{
						for ( int j = 0; j < nSnippetWidth; j++ )
						{
							for ( int k = 0; k < intScaleFactor; k++ )
							{
								*pbytPattern = 0;
								++pbytPattern;
								*pbytPattern = 0;
								++pbytPattern;
								*pbytPattern = 0;
								++pbytPattern;
								if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
							}
						}

						// BMP's must be padded to long boundaries
						for ( int j = 0; j < nPadWidth; j++ )
						{
							*pbytPattern++ = 0;
						}
					}
				}
			}

		}
	}

	//stages
	double* dblDSSAStageBuf = new double[ts.tsh.vec_height * ts.tsh.vec_width];
	double* pdblDSSAStage;
	double* cv_ptr;

	int j=0;
	for ( int s = 0; s < nNumStages; s++ )
	{
		for ( int n = 0; n < (int)(dssa.cbk_size - 1); n++ )
		{
			if (s==0)  //top stage
			{
				CString str, str_n, str_j;
				str_n.Format("%d", n);
				str_j = STR_FILE_CreatefilenameFromFrameNumber(j);
				str = /*"stage0_template"*/  str_j + ".bmp";
				UTIL_save_imageBuffer_to_file(bytSBuf + n * intSDisplayBytes, str.GetBuffer(), nSnippetWidth, nSnippetHeight);
				cout<<str.GetBuffer()<<endl;
			}
			else if (s>0)
			{
				pdblDSSAStage = dblDSSAStageBuf;
				cv_ptr = dssa.enc_cbks[s].vecs + n * ts.tsh.vec_width * ts.tsh.vec_height;
				for ( i = 0; i < ts.tsh.vec_height * ts.tsh.vec_width; i++ )
				{
					*pdblDSSAStage = *cv_ptr;
					++pdblDSSAStage;
					++cv_ptr;
				}
				miner_PaintPatternStageCore(dblDSSAStageBuf, bytPatternStageBuf, &ts, nSnippetWidth, nSnippetHeight);
				
				CString str, str_n, str_s, str_j;
				str_n.Format("%d", n);
				str_s.Format("%d", s);
				str_j = STR_FILE_CreatefilenameFromFrameNumber(j);
				str = /*"stage" +*/ str_j /*"_template" +*/ + ".bmp";
				UTIL_save_imageBuffer_to_file(bytPatternStageBuf, str.GetBuffer(),nSnippetWidth, nSnippetHeight);
				cout<<str.GetBuffer()<<endl;
			}
			j++;
		}
	}

	return;
}

//-------------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------------
void miner_PaintPatternStageCore(
	double* dblDSSABuf,
	byte* pbytPattern,
	ts_params* ts,
	int nSnippetWidth,
	int nSnippetHeight
)
{


	int			nRedPlaneLayerIndex			=	1;
	int			nGreenPlaneLayerIndex		=	2;
	int			nBluePlaneLayerIndex		=	3;

	int intBitsPerPixel = 32;
	CString strBitsPerPixel = "32";

	int intBytesPerRGB;

	if ( intBitsPerPixel == 32 )
	{
		intBytesPerRGB = 4;
	}
	else
	if ( intBitsPerPixel == 24 )
	{
		intBytesPerRGB = 3;
	}

	int intPixelsPerDisplayedSnippet = PIXELSPERPATTERN;

	int intMaxSnippetDim = MAX(nSnippetHeight,nSnippetWidth);
	
	int intScaleFactor = intPixelsPerDisplayedSnippet / intMaxSnippetDim;

	int nPadWidth = (intScaleFactor*nSnippetWidth*intBytesPerRGB) % 2;//sizeof(LONG); // rows must fill LONG boundaries

	double* cv_ptr1;

	double* cv_ptr2;

	double* cv_ptr3;

	CString strPixelType="uint8";

	if ( strPixelType == "uint8" )
	{
		if ( nSnippetWidth >= nSnippetHeight )
		{
			int intZeroPad = nSnippetWidth - nSnippetHeight;

			for ( int i = 0; i < intZeroPad / 2; i++ )
			{
				for ( int l = 0; l < intScaleFactor; l++ )
				{
					for ( int j = 0; j < nSnippetWidth; j++ )
					{
						for ( int k = 0; k < intScaleFactor; k++ )
						{
							*pbytPattern = 0;
							++pbytPattern;
							*pbytPattern = 0;
							++pbytPattern;
							*pbytPattern = 0;
							++pbytPattern;

							if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
						}
					}
					// BMP's must be padded to long boundaries
					for ( int j = 0; j < nPadWidth; j++ )
					{
						*pbytPattern++ = 0;
					}
				}
			}
			for ( int i = 0; i < nSnippetHeight; i++ )
			{
				for ( int l = 0; l < intScaleFactor; l++ )
				{
					cv_ptr1 = dblDSSABuf
						+ nSnippetWidth * nSnippetHeight * (nRedPlaneLayerIndex - 1)
						+ i * ts->tsh.vec_width;
					cv_ptr2 = dblDSSABuf
						+ nSnippetWidth * nSnippetHeight * (nGreenPlaneLayerIndex - 1)
						+ i * ts->tsh.vec_width;
					cv_ptr3 = dblDSSABuf
						+ nSnippetWidth * nSnippetHeight * (nBluePlaneLayerIndex - 1)
						+ i * ts->tsh.vec_width;

					for ( int j = 0; j < nSnippetWidth; j++ )
					{
						for ( int k = 0; k < intScaleFactor; k++ )
						{
							*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(*cv_ptr3 + 128.0))));
							++pbytPattern;
							*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(*cv_ptr2 + 128.0))));
							++pbytPattern;
							*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(*cv_ptr1 + 128.0))));
							++pbytPattern;

							if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
						}

						++cv_ptr1;
						++cv_ptr2;
						++cv_ptr3;
					}
					// BMP's must be padded to long boundaries
					for ( int j = 0; j < nPadWidth; j++ )
					{
						*pbytPattern++ = 0;
					}
				}
			}
			for ( int i = 0; i < intZeroPad / 2; i++ )
			{
				for ( int l = 0; l < intScaleFactor; l++ )
				{
					for ( int j = 0; j < nSnippetWidth; j++ )
					{
						for ( int k = 0; k < intScaleFactor; k++ )
						{
							*pbytPattern = 0;
							++pbytPattern;
							*pbytPattern = 0;
							++pbytPattern;
							*pbytPattern = 0;
							++pbytPattern;

							if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
						}
					}
					// BMP's must be padded to long boundaries
					for ( int j = 0; j < nPadWidth; j++ )
					{
						*pbytPattern++ = 0;
					}
				}
			}
		}
		else
		{
			int intZeroPad = nSnippetHeight - nSnippetWidth;

			for ( int i = 0; i < nSnippetHeight; i++ )
			{
				for ( int l = 0; l < intScaleFactor; l++ )
				{
					cv_ptr1 = dblDSSABuf
						+ nSnippetWidth * nSnippetHeight * (nRedPlaneLayerIndex - 1)
						+ i * ts->tsh.vec_width;
					cv_ptr2 = dblDSSABuf
						+ nSnippetWidth * nSnippetHeight * (nGreenPlaneLayerIndex - 1)
						+ i * ts->tsh.vec_width;
					cv_ptr3 = dblDSSABuf
						+ nSnippetWidth * nSnippetHeight * (nBluePlaneLayerIndex - 1)
						+ i * ts->tsh.vec_width;

					for ( int j = 0; j < intZeroPad / 2; j++ )
					{
						for ( int k = 0; k < intScaleFactor; k++ )
						{
							*pbytPattern = 0;
							++pbytPattern;
							*pbytPattern = 0;
							++pbytPattern;
							*pbytPattern = 0;
							++pbytPattern;

							if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
						}
					}

					for ( int j = 0; j < nSnippetWidth; j++ )
					{
						for ( int k = 0; k < intScaleFactor; k++ )
						{
							*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(*cv_ptr3 + 128.0))));
							++pbytPattern;
							*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(*cv_ptr2 + 128.0))));
							++pbytPattern;
							*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(*cv_ptr1 + 128.0))));
							++pbytPattern;

							if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
						}

						++cv_ptr1;
						++cv_ptr2;
						++cv_ptr3;
					}

					for ( int j = 0; j < intZeroPad / 2; j++ )
					{
						for ( int k = 0; k < intScaleFactor; k++ )
						{
							*pbytPattern = 0;
							++pbytPattern;
							*pbytPattern = 0;
							++pbytPattern;
							*pbytPattern = 0;
							++pbytPattern;

							if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
						}
					}

					// BMP's must be padded to long boundaries
					for ( int j = 0; j < nPadWidth; j++ )
					{
						*pbytPattern++ = 0;
					}
				}
			}
		}
	}
	else
	if ( strPixelType == "uint16" )
	{
//		float sglMaxADC = 1024.0;  // 11 bits for IKONOS
//		float sglMaxPix = 255.0;
//		float sglADtoPixScaleFactor = sglMaxPix / sglMaxADC;
//		double sglMaxADC = pow(2.0,atof(sttArchiveSessionState.m_strBitsPerPixel));
//		double sglMaxPix = 255.0;
//		double sglADtoPixScaleFactor = sglMaxPix / sglMaxADC;

		double dblTmp;
		double gamma = 0.7;
		double dblMaxSampleVal =  -10000000.0;// 1.0; //-100000000000.0;
		double dblMinSampleVal =   10000000.0;//0.0; // 100000000000.0;

		// 16 is a magic number = arbitrarily selected for setting granularity
		gamma = gamma * atof(strBitsPerPixel) / 8.0;

		int i;

		for ( i = 0; i < nSnippetHeight; i++ )
		{
			cv_ptr1 = dblDSSABuf
				+ nSnippetWidth * nSnippetHeight * (nRedPlaneLayerIndex - 1)
				+ i * ts->tsh.vec_width;
			cv_ptr2 = dblDSSABuf
				+ nSnippetWidth * nSnippetHeight * (nGreenPlaneLayerIndex - 1)
				+ i * ts->tsh.vec_width;
			cv_ptr3 = dblDSSABuf
				+ nSnippetWidth * nSnippetHeight * (nBluePlaneLayerIndex - 1)
				+ i * ts->tsh.vec_width;

			for ( int j = 0; j < nSnippetWidth; j++ )
			{
				if ( *cv_ptr3 < dblMinSampleVal )
				{
					dblMinSampleVal = *cv_ptr3;
				}
				if ( *cv_ptr3 > dblMaxSampleVal )
				{
					dblMaxSampleVal = *cv_ptr3;
				}
				if ( *cv_ptr2 < dblMinSampleVal )
				{
					dblMinSampleVal = *cv_ptr2;
				}
				if ( *cv_ptr2 > dblMaxSampleVal )
				{
					dblMaxSampleVal = *cv_ptr2;
				}
				if ( *cv_ptr1 < dblMinSampleVal )
				{
					dblMinSampleVal = *cv_ptr1;
				}
				if ( *cv_ptr1 > dblMaxSampleVal )
				{
					dblMaxSampleVal = *cv_ptr1;
				}

				++cv_ptr1;
				++cv_ptr2;
				++cv_ptr3;
			}
		}

		double sglMaxADC = (float)pow((dblMaxSampleVal - dblMinSampleVal),gamma);
		double sglMaxPix = 255.0;
		
		double sglADtoPixScaleFactor = sglMaxPix / sglMaxADC;

		for ( i = 0; i < nSnippetHeight; i++ )
		{
			for ( int l = 0; l < intScaleFactor; l++ )
			{
				cv_ptr1 = dblDSSABuf
					+ nSnippetWidth * nSnippetHeight * (nRedPlaneLayerIndex - 1)
					+ i * ts->tsh.vec_width;
				cv_ptr2 = dblDSSABuf
					+ nSnippetWidth * nSnippetHeight * (nGreenPlaneLayerIndex - 1)
					+ i * ts->tsh.vec_width;
				cv_ptr3 = dblDSSABuf
					+ nSnippetWidth * nSnippetHeight * (nBluePlaneLayerIndex - 1)
					+ i * ts->tsh.vec_width;

				for ( int j = 0; j < nSnippetWidth; j++ )
				{
					for ( int k = 0; k < intScaleFactor; k++ )
					{
						/*
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,((float)*cv_ptr3 * sglADtoPixScaleFactor))));
						++pbytPattern;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,((float)*cv_ptr2 * sglADtoPixScaleFactor))));
						++pbytPattern;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,((float)*cv_ptr1 * sglADtoPixScaleFactor))));
						++pbytPattern;
						*/

						/*
						dblTmp = *cv_ptr3 - dblMinSampleVal;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(sglADtoPixScaleFactor * *cv_ptr3))));
						++pbytPattern;

						dblTmp = *cv_ptr2 - dblMinSampleVal;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(sglADtoPixScaleFactor * *cv_ptr2))));
						++pbytPattern;

						dblTmp = *cv_ptr1 - dblMinSampleVal;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(sglADtoPixScaleFactor * *cv_ptr1))));
						++pbytPattern;
						*/

						dblTmp = *cv_ptr3 - dblMinSampleVal;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(sglADtoPixScaleFactor * pow(dblTmp,gamma)))));
						++pbytPattern;

						dblTmp = *cv_ptr2 - dblMinSampleVal;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(sglADtoPixScaleFactor * pow(dblTmp,gamma)))));
						++pbytPattern;

						dblTmp = *cv_ptr1 - dblMinSampleVal;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(sglADtoPixScaleFactor * pow(dblTmp,gamma)))));
						++pbytPattern;

						if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
					}

					++cv_ptr1;
					++cv_ptr2;
					++cv_ptr3;
				}
				// BMP's must be padded to long boundaries
				for ( int j = 0; j < nPadWidth; j++ )
				{
					*pbytPattern++ = 0;
				}
			}
		}
	}
	else
	if ( strPixelType == "int16" )
	{
//		float sglMaxADC = 4096.0;  // 12 bits for mammograms
//		float sglMaxPix = 255.0;
//		float sglADtoPixScaleFactor = sglMaxPix / sglMaxADC;
		double sglMaxADC = pow(2.0,atof(strBitsPerPixel));
		double sglMaxPix = 255.0;
		double sglADtoPixScaleFactor = sglMaxPix / sglMaxADC;

		for ( int i = 0; i < nSnippetHeight; i++ )
		{
			for ( int l = 0; l < intScaleFactor; l++ )
			{
				cv_ptr1 = dblDSSABuf
					+ nSnippetWidth * nSnippetHeight * (nRedPlaneLayerIndex - 1)
					+ i * ts->tsh.vec_width;
				cv_ptr2 = dblDSSABuf
					+ nSnippetWidth * nSnippetHeight * (nGreenPlaneLayerIndex - 1)
					+ i * ts->tsh.vec_width;
				cv_ptr3 = dblDSSABuf
					+ nSnippetWidth * nSnippetHeight * (nBluePlaneLayerIndex - 1)
					+ i * ts->tsh.vec_width;

				for ( int j = 0; j < nSnippetWidth; j++ )
				{
					for ( int k = 0; k < intScaleFactor; k++ )
					{
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,((float)*cv_ptr3 * sglADtoPixScaleFactor))));
						++pbytPattern;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,((float)*cv_ptr2 * sglADtoPixScaleFactor))));
						++pbytPattern;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,((float)*cv_ptr1 * sglADtoPixScaleFactor))));
						++pbytPattern;
						if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
					}

					++cv_ptr1;
					++cv_ptr2;
					++cv_ptr3;
				}
				// BMP's must be padded to long boundaries
				for ( int j = 0; j < nPadWidth; j++ )
				{
					*pbytPattern++ = 0;
				}
			}
		}
	}
	else
	if ( strPixelType == "float32" )
	{
		double dblTmp;
		double gamma = 0.7;
		double dblMaxSampleVal =  -10000000.0;// 1.0; //-100000000000.0;
		double dblMinSampleVal =   10000000.0;//0.0; // 100000000000.0;

		// 16 is a magic number = arbitrarily selected for setting granularity
		gamma = gamma * atof(strBitsPerPixel) / 16.0;

		int i;
		
		for ( i = 0; i < nSnippetHeight; i++ )
		{
			cv_ptr1 = dblDSSABuf
				+ nSnippetWidth * nSnippetHeight * (nRedPlaneLayerIndex - 1)
				+ i * ts->tsh.vec_width;
			cv_ptr2 = dblDSSABuf
				+ nSnippetWidth * nSnippetHeight * (nGreenPlaneLayerIndex - 1)
				+ i * ts->tsh.vec_width;
			cv_ptr3 = dblDSSABuf
				+ nSnippetWidth * nSnippetHeight * (nBluePlaneLayerIndex - 1)
				+ i * ts->tsh.vec_width;

			for ( int j = 0; j < nSnippetWidth; j++ )
			{
				if ( *cv_ptr3 < dblMinSampleVal )
				{
					dblMinSampleVal = *cv_ptr3;
				}
				if ( *cv_ptr3 > dblMaxSampleVal )
				{
					dblMaxSampleVal = *cv_ptr3;
				}
				if ( *cv_ptr2 < dblMinSampleVal )
				{
					dblMinSampleVal = *cv_ptr2;
				}
				if ( *cv_ptr2 > dblMaxSampleVal )
				{
					dblMaxSampleVal = *cv_ptr2;
				}
				if ( *cv_ptr1 < dblMinSampleVal )
				{
					dblMinSampleVal = *cv_ptr1;
				}
				if ( *cv_ptr1 > dblMaxSampleVal )
				{
					dblMaxSampleVal = *cv_ptr1;
				}

				++cv_ptr1;
				++cv_ptr2;
				++cv_ptr3;
			}
		}

		float sglMaxADC = (float)pow((dblMaxSampleVal - dblMinSampleVal),gamma);
		float sglMaxPix = 255.0;
		
		float sglADtoPixScaleFactor = sglMaxPix / sglMaxADC;

		for ( i = 0; i < nSnippetHeight; i++ )
		{
			for ( int l = 0; l < intScaleFactor; l++ )
			{
				cv_ptr1 = dblDSSABuf
					+ nSnippetWidth * nSnippetHeight * (nRedPlaneLayerIndex - 1)
					+ i * ts->tsh.vec_width;
				cv_ptr2 = dblDSSABuf
					+ nSnippetWidth * nSnippetHeight * (nGreenPlaneLayerIndex - 1)
					+ i * ts->tsh.vec_width;
				cv_ptr3 = dblDSSABuf
					+ nSnippetWidth * nSnippetHeight * (nBluePlaneLayerIndex - 1)
					+ i * ts->tsh.vec_width;

				for ( int j = 0; j < nSnippetWidth; j++ )
				{
					for ( int k = 0; k < intScaleFactor; k++ )
					{
						dblTmp = *cv_ptr3 - dblMinSampleVal;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(sglADtoPixScaleFactor * pow(dblTmp,gamma)))));
						++pbytPattern;

						dblTmp = *cv_ptr2 - dblMinSampleVal;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(sglADtoPixScaleFactor * pow(dblTmp,gamma)))));
						++pbytPattern;

						dblTmp = *cv_ptr1 - dblMinSampleVal;
						*pbytPattern = (byte)(MAX(0.0,MIN(255.0,(sglADtoPixScaleFactor * pow(dblTmp,gamma)))));
						++pbytPattern;

						if ( intBitsPerPixel == 32 ) *pbytPattern++ = 0;
					}

					++cv_ptr1;
					++cv_ptr2;
					++cv_ptr3;
				}
				// BMP's must be padded to long boundaries
				for ( int j = 0; j < nPadWidth; j++ )
				{
					*pbytPattern++ = 0;
				}
			}
		}
	}
}

//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
CString STR_FILE_CreatefilenameFromFrameNumber(int FileNumber)
{
	CString sFileNumber;
	sFileNumber.Format("%d", FileNumber);
	CString FileName;

	if		(FileNumber < 10)							FileName = "0000"	+	sFileNumber ;
	else if (FileNumber >9 && FileNumber < 100)			FileName = "000"	+	sFileNumber ;
	else if (FileNumber >99 && FileNumber < 1000)		FileName = "00"		+	sFileNumber ;
	else if (FileNumber >999 && FileNumber < 10000)		FileName = "0"		+   sFileNumber ;
	else if (FileNumber >9999 && FileNumber < 100000)	FileName = 		        sFileNumber ;

	return FileName;
}