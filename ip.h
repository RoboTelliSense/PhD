/*
$Id: ip.h,v 1.1 1996/12/06 15:52:40 cbarnes Exp cbarnes $
$Log: /CadCac/Swcm/Classifier/ip.h $
* 
* 1     11/17/97 9:50a Lmrs7
* Original source code for classifier.
Revision 1.1  1996/12/06 15:52:40  cbarnes
Initial revision


*/


#ifndef __INCiph
#define __INCiph


enum image_types {ITN,DEN,GMC};
/*--------------------------------------*/
/*Tags for different image types:       */
/*      ITN - intensity images          */
/*      DEN - density images            */
/*      GMC - gamma corrected images    */
/*--------------------------------------*/


enum display_types {MONO,COLOR};
/*--------------------------------------*/
/*Tags for different display types:     */
/*      MONO - Monochrome               */
/*      COLOR - Color image             */
/*--------------------------------------*/


/*-------------------------------------------------------------------
image header - to be used for all two-dimensional files.
-------------------------------------------------------------------*/
typedef struct{
enum header_types hdr_type;    /*(4 bytes) header type flag*/
char name[32];                 /*(32 bytes) image name*/
char width[8];                 /*(8 bytes) image width in pixels*/
char height[8];                /*(8 bytes) image width in pixels*/
enum image_types img_type;     /*(4 bytes) image type flag*/
enum display_types dis_type;   /*(4 bytes) display type flag*/ 
enum sensor_types sen_type;    /*(4 bytes) sensor type flag*/
enum data_types dt;            /*(4 bytes) data types flag*/
enum complex_flag cf;          /*(4 bytes) complex or real flag*/ 
char comment[3*80];            /*(240 bytes) text comment space*/
char a[200];                   /*space to fill up 512 total bytes*/
}image_header;


extern void view_img_hdr(image_header*);


#endif /* __INCiph */