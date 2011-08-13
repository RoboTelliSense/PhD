//originally, the output was .sml 
//i have changed to .raw to easily view in Irfan View.  In IrfanView, make sure to add a header size of 512

//C std library
	#include <math.h>
	#include <stdio.h>
	#include <stdlib.h>

//C++ library
	#include <string>
	#include <iostream>
	#include <fstream>
	#include <sstream>

	using namespace std;
	

//enum
	enum header_types	{IMG,TSH,CBK,MCBK};
	enum data_types		{CHR,UCH,SRT,USRT,dsINT,dsUINT,LNG,ULNG,FLT,DBL,ALNG,AFLT,SPECIAL_AFLT};
	enum complex_flag	{REAL,CPLX};

//struct
	typedef struct{
			enum header_types hdr_type;		/*(4 bytes) header type flag*/
			char ts_name[32];				/*(32 bytes) training set name*/
			char num_vecs[8];				/*(8 bytes) number of vectors in structTrg*/
			int sw;							/*(4 bytes) vector width in pixels*/
			int shc;						/*(4 bytes) vector height in pixels*/
			enum data_types dt;				/*(4 bytes) data types flag*/
			enum complex_flag cf;			/*(4 bytes) complex or real flag*/
			char comment[3*80];				/*(240 bytes) text comment space*/
			char a[212];					/*space to fill up 512 total bytes*/
	}structTrgHeader;

//function prototypes
	int readFile_SED			(	string		strLine,  //SED: snippet extraction details file
									int&		idx,
									int&		cls_label,
									string&		cfn_I, 
									int&		iw,		// image width
									int&		ih,		//image height
									int&		bx,		//bounding box, top left x, top left y, as opposed to center x, center y which are bcx and bcy
									int&		by
									);

	int vectorizePositiveExamples_6chPlanar_512byteHeader          
													(
													string		cfn_poscsv,		//positive examples, details in csv file
													string		cfn_posraw,		//positive examples, vectorized
													int			sw,
													int			sh,
													int			sc,
													bool		bVerbose
													);

//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
int main(int argc, char** argv)
{
	//input parameters
		if (argc < 5)
		{
			cout<<"not enough arguments."<<endl;
			return -1;
		}	
		string  cfn_poscsv(argv[1]);						//positive examples details in .csv file
		int		sw						=	atoi(argv[2]);	//snippet, width
		int		sh						=	atoi(argv[3]);	//snippet, height
		int		sc						=	6;				//snippet, number of channels (fixed)
		string	cfn_posraw(argv[4]);						//positive examples vectorized with 512 byte header
		bool	bVerbose(argv[5]);							//verbose mode
		
	

	vectorizePositiveExamples_6chPlanar_512byteHeader	(	cfn_poscsv,
															cfn_posraw,
															sw,
															sh,
															sc,
															bVerbose
														);


	return 1;
}





//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
int vectorizePositiveExamples_6chPlanar_512byteHeader			(	string		cfn_poscsv,
																	string		cfn_posraw,
																	int			sw,
																	int			sh,
																	int			sc,
																	bool		bVerbose
																)


{

	ifstream		ifs_poscsv(cfn_poscsv.c_str());  //snippet extraction details

															//error checking
															if (!ifs_poscsv.is_open())
															{
																cout<<"FILE OPEN ERROR: positive examples (.csv) file not opened"<<endl;
																return -1;
															}
															//else
															//	cout<<"FILE OPEN: SED (.csv) file"<<endl;																	
	string			strLine;

	long 			lngSnippetOffset;
	long 			lngSnippetSkipSize;


	ifstream		ifs_I;
	ofstream		ofs_posraw;
	

	int				idx, cls_label, iw, ih, bcx, bcy, bx, by;	

	structTrgHeader		ts_hdr;

	int				intBytesPerPixel;

	string 			cfn_Iold = "";
	string 			cfn_I;

	int				intSnippetCnt = 0;
	int 			i;
	int				nHalfSnippetWidth;
	int				nHalfSnippetHeight;
	int				intNumSnippetPixels;
	int				intNumSnippetBytes;
	int				header_size;


	unsigned char	intUsed;
	unsigned char	intUnused;
	char*			bytSnippetBuf;
	char*			pbytSnippet;


													// error checking
	
													//Check to see if snippet sizes are either both odd or both even
													if ( sw % 2 != 0 && sh % 2 != 1 )
													{
														cout<<"Snippet width and height must be both either an odd or even number of pixels.";
														return -1;
													}
													if ( sw % 2 != 1 && sh % 2 != 0 )
													{
														cout<<"Snippet width and height must be both either an odd or even number of pixels.";
														return -1;
													}

													// Check to see if snippet sizes are too large
													if ( sw > 73 || sh > 73 )
													{
														cout<<"Snippet width and height must be less than 73 pixels.";
														return -1;
													}

	// Initialize snippet parameters
	nHalfSnippetWidth		=	sw / 2;
	nHalfSnippetHeight		=	sh / 2;

	// Form data module header.
	ts_hdr.hdr_type			=	TSH;
								sprintf		(ts_hdr.ts_name, cfn_posraw.c_str());
								sprintf		(ts_hdr.num_vecs, "%d", 0);
	ts_hdr.shc				=	sh * sc;
	ts_hdr.sw				=	sw;

	intBytesPerPixel		=	1;   //pixel type: uint8
	ts_hdr.dt				=	UCH; //"


	intNumSnippetPixels		=	sw * sh;
	intNumSnippetBytes		=	intNumSnippetPixels * intBytesPerPixel;

	bytSnippetBuf			=	new char[intNumSnippetBytes];
	ts_hdr.cf				=	REAL;

	
	

	//------------
	ofs_posraw.open(cfn_posraw.c_str(), ios::binary);
													

															//error checking
															if (!ofs_posraw.is_open())
															{
																cout<<"FILE OPEN ERROR: concatenated snippets (.raw) file not opened"<<endl;
																return -1;
															}
															//else
															//	cout<<"FILE OPEN: concatenated snippets (.raw) file"<<endl;

	

	// Write data module header.
	header_size = sizeof(structTrgHeader);
	ofs_posraw.write( (char*)&ts_hdr, header_size );

	intUsed					=	1;
	intUnused				=	0;
	i						=	0;

//#define old
	do
	{
		getline(ifs_poscsv, strLine);
		readFile_SED(strLine, idx, cls_label, cfn_I, iw, ih, bx, by);
		bcx = bx + (sw-1)/2;
		bcy = by + (sh-1)/2;

		// Odd square snippets
		if ( sw % 2 != 0 && sh % 2 != 0 )
		{
			if ( bcx >= nHalfSnippetWidth &&
				 bcy >= nHalfSnippetHeight )
			{
				if ( bcx <= (iw - nHalfSnippetWidth ) &&
					 bcy <= (ih - nHalfSnippetHeight ) )
				{
					
					// Open input image file
					if (cfn_I.compare(cfn_Iold) != 0)
					{
						// Close last input image file
						if ( cfn_Iold.compare("") != 0 )
						{
							ifs_I.close(); //step 1: image file
						}
						cfn_posraw = cfn_I;
						ifs_I.open(cfn_posraw.c_str(), ios::binary); //step 2: image file

															//error checking
															if (!ifs_I.is_open())
															{
																cout<<"FILE OPEN ERROR: image (.raw) file not opened"<<endl;
																return -1;
															}
															//else
															//	cout<<"FILE OPEN: image (.raw) file"<<endl;


						cfn_Iold = cfn_I;
					}

					for ( int l = 0; l < sc; l++ )
					{
						// Compute offset to snippet center
						lngSnippetOffset
							= l * iw * ih * intBytesPerPixel
							+((bcy - nHalfSnippetHeight) * iw
							+ (bcx - nHalfSnippetWidth)) * intBytesPerPixel;

						ifs_I.seekg(lngSnippetOffset, ios::beg);//step 3: image file
						// Compute offets for snippet rows
						lngSnippetSkipSize = (iw - sw) * intBytesPerPixel;

						// Extract snippet
						pbytSnippet = bytSnippetBuf;
						for ( int i = 0;  i < sh; i++ )
						{
							ifs_I.read(pbytSnippet, sw * intBytesPerPixel);//step 4: image file
							ifs_I.seekg	(lngSnippetSkipSize, ios::cur ); //step 5: image file

							pbytSnippet += sw * intBytesPerPixel;
						}

						// Write snippet to data module file
						ofs_posraw.write( bytSnippetBuf, intNumSnippetBytes);
					}

					intSnippetCnt += 1;
				}
				else
				{
					
				}
			}
			else
			{
				
			}

		}

		if (bVerbose)
			cout<<intSnippetCnt<<endl;

		if (ifs_poscsv.eof())
			break;

	}
	while (1);




	// Close input image file
		ifs_I.close(); //step 6: image file
		// Update data module header.
		sprintf		(ts_hdr.num_vecs, "%d", intSnippetCnt);


		ofs_posraw.seekp		( 0L, ios::beg );
		ofs_posraw.write	( (char*)&ts_hdr, sizeof(structTrgHeader) );

		// Deallocate buffers
		delete bytSnippetBuf;


		ofs_posraw.close();


		ifs_poscsv.close();

		return 1;


}

//----------------------------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------------------------
int readFile_SED(	string		strLine, 
								int&		idx,
								int&		cls_label,
								string&		cfn_I, 
								int&		iw, 
								int&		ih, 
								int&		bx, 
								int&		by
							)
{
	
	string strField;
	int field_cnt;

	stringstream ssLine(strLine);	//string  ->stringstream ->string	 ->stringstream
									//strLine ->ssLine       ->strField  ->ssField
									//first stringstream  (ssLine)  helps in going from one string to another, i.e. line to field     
									//second stringstream (ssField) helps in converting a string to numbers, etc.
	field_cnt=1;

	//go over fields in line
	while (getline( ssLine, strField, ',' ))
	{
		stringstream ssField( strField );
		if		(field_cnt==1)	ssField>>cfn_I;	//complete filename of the image
		else if (field_cnt==2)	ssField>>iw;	//image width
		else if (field_cnt==3)	ssField>>ih;	//image height
		else if (field_cnt==4)	ssField>>bx;	//bounding box, top left x, as opposed to bcx, which is the bounding box, center x
		else if (field_cnt==5)	ssField>>by;	//bounding box, top left y, as opposed to bcy, which is the bounding box, center y
		field_cnt++;
	}
	
	return 1;
}
