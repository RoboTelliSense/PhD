// Miner.h : main header file for the Miner application
//

#if !defined(AFX_Miner_H__9CE40E42_E70F_461C_96E7_7E3912F361F3__INCLUDED_)
#define AFX_Miner_H__9CE40E42_E70F_461C_96E7_7E3912F361F3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

//#include "resource.h"

//#include "SelectImageArchiveDialog.h"
//
//#include "ImagePropertyDialog.h"
//
//#include "MapControlsDialog.h"
//
//#include "MineAttributesDialog.h"
//
//#include "DataPakDialog.h"

#include "BmpDoc.h"
#include "BmpView.h"

//#include "SignOffDialog.h"

#include "ToolSetStructures.h"

#define NUMBER_CORR_COLOR_BINS 32
#define NUMBER_CORR_COLOR_BINSP1 33
#define COLOR_EPSILON 0.0001

#define MAXNUMSNIPPETS 50000

#define NUM_CLASSES 10
#define HALFBOXHEIGHT 1
#define HALFBOXWIDTH 1

#define STRIP_HEIGHT 8

#define PAINT 101
#define NOPAINT 100

static byte bytColorCorrelationMapRed[NUMBER_CORR_COLOR_BINSP1] =
{
	255,
	255,
	255,
	255,
	48,
	48,
	48,
	48,
	191,
	191,
	191,
	191,
	40,
	40,
	40,
	40,
	127,
	127,
	127,
	127,
	32,
	32,
	32,
	32,
	63,
	63,
	63,
	63,
	24,
	24,
	24,
	24,
	0
};
static byte bytColorCorrelationMapGreen[NUMBER_CORR_COLOR_BINSP1] =
{
	255,
	255,
	48,
	48,
	255,
	255,
	48,
	48,
	191,
	191,
	40,
	40,
	191,
	191,
	40,
	40,
	127,
	127,
	32,
	32,
	127,
	127,
	32,
	32,
	63,
	63,
	24,
	24,
	63,
	63,
	24,
	24,
	0
};
static byte bytColorCorrelationMapBlue[NUMBER_CORR_COLOR_BINSP1] =
{
	255,
	48,
	255,
	48,
	255,
	48,
	255,
	48,
	191,
	40,
	191,
	40,
	191,
	40,
	191,
	40,
	127,
	32,
	127,
	32,
	127,
	32,
	127,
	32,
	63,
	24,
	63,
	24,
	63,
	24,
	63,
	24,
	0
};

#define NUMBER_TEXTURE_COLOR_BINS 18

static byte bytColorTextureMapRed[NUMBER_TEXTURE_COLOR_BINS] =
{
	255,255,0,0,0,255,
	255,255,192,192,192,255,
	128,128,0,0,
	0,
	0
	//192
};
static byte bytColorTextureMapGreen[NUMBER_TEXTURE_COLOR_BINS] =
{
	0,255,255,255,0,0,
	192,255,255,255,192,192,
	0,128,128,128,
	0,
	0
	//128
};
static byte bytColorTextureMapBlue[NUMBER_TEXTURE_COLOR_BINS] =
{
	0,0,0,255,255,255,
	192,192,192,255,255,255,
	0,0,0,128,
	0,
	0
	//128
};

/////////////////////////////////////////////////////////////////////////////
// CApp:
// See Miner.cpp for the implementation of this class
//

//class CApp : public CWinApp
//{
//public:
//		
//	CApp();
//
//	CString m_strConfigCookieFolder;
//
//	CSelectImageArchiveDialog m_SelectImageArchiveDialog;
//	SArchiveSessionState m_sttArchiveSessionState;
//	BOOL InitiateArchiveState();
//	BOOL ClearArchiveState();
//	
//	CImagePropertyDialog* m_pImagePropertyDialog;
//	SImageState m_sttImageState;
//	BOOL InitiateImageState();
//	void ClearImageState();
//	BOOL m_bImagePropertyPageMode;
//	BOOL m_bDisplayRedMode;
//	BOOL m_bDisplayGreenMode;
//	BOOL m_bDisplayBlueMode;
//	BOOL m_bDisplayRGBMode;
//	BOOL m_bDisplayDSSAMode;
//
//	// Snippet
//	SSnippetRecord m_SnippetList[MAXNUMSNIPPETS];
//	int m_nNewSnippetCnt;
//	int m_nOldSnippetCnt;
//	int m_nNewSnippetLabel;
//	int m_nGroupSnipInterval;
//	BOOL m_bSnipMode;
//
//	CBmpView* m_pBmpView;
//	CBmpDoc* m_pBmpDoc;
//
//	CMapControlsDialog* m_pMapControlsDialog;
//	BOOL m_bMapControlsPageMode;
//	BOOL InitiateMapControlsState();
//
//	CMineAttributesDialog* m_pMineAttributesDialog;
//	BOOL m_bMineAttributesMode;
//	BOOL InitiateMineAttributes();
//	void MineAttribute(CPoint,CPoint,float);
//
//	CSignOffDialog* m_pSignOffDialog;
//
//	CDataPakDialog* m_pDataPakDialog;
//
//	bool m_bZoomMode;
//	bool m_bMineMode;
//	bool m_bMineModePointMatch;
//	bool m_bMineModeBestMatch;
//	bool m_bMineModeDeepestMatch;
//	bool m_bMineModeAverageMatch;
//
//	CPoint m_ptCropEnd;
//	CPoint m_ptCropStart;
//	BOOL m_bCropMode;
//
//	int m_nCropStartX;
//	int m_nCropStartY;
//	int m_nCropEndX;
//	int m_nCropEndY;
//	int m_nCropWidth;
//	int m_nCropHeight;
//
//	int m_nSnippetWidth;
//	int m_nSnippetHeight;
//
//	CString m_strNumStages;
//	CString	m_strNumTemplatesPerStage;
//	CString m_strSnippetWidth;
//	CString m_strSnippetHeight;
//	CString m_strDataPakFidelity;
//
//	// output file parameters
//	CString	m_strCorrelationFilename;
//	CString m_strStageMapFilename;
//	CString m_strDSSAIndexFilename;
//	CString m_strInParameterFilename;
//	CString m_strOutParameterFilename;
//	CString m_strDataPakFilename;
//	CString	m_strOutFeatureMapFilename;
//
//	BOOL m_BSaveOutputState;
//
//	// application screen layout attributes
//	CRect m_rtMainClientRect;
//
//	BOOL m_bShowMiningBar;
//	CPoint m_ptBarPosition;
//
//	int m_nCallCnt;
//
//	float m_sglCorrelationDistanceThresholdLower;
//	float m_sglCorrelationDistanceThresholdUpper;
//	int m_nStageThresholdLower;
//	int m_nStageThresholdUpper;
//	int m_nPrecisionLevel;
//
//	bool m_bFeatureMapMode;
//	bool m_bOverlayMapMode;
//	bool m_bCorrelationMapMode;
//	bool m_bStageMapMode;
//	bool m_bTextureMapMode;
//	bool m_bImageOnlyMode;
//
//	void PaintImageOnly(void);
//	void PaintTextureMap(void);
//	void PaintFeatureMap(void);
//	void PaintOverlayMap(void);
//	void PaintCorrelationMap(void);
//	void PaintStageMap(void);
//	void PaintSnippetDisplay(void);
//	BOOL PaintAllSnippets(void);
//
//	int m_nNumberStages;
//	int m_nTotalProcessedPixels;
//	int m_nNumTemplatesPerStage;
//
////	byte* m_pbytImageBuf;
//	byte* m_pbytFeatureMapBuf;
//	float* m_psglCorrelationMapBuf;
//	float* m_psglGradientMapBuf;
//	byte* m_pbytPatternElementMapBuf;
//	byte* m_pbytCompositePatternElementMapBuf;
//	byte* m_pbytSnippetDisplayBuf;
//
//	float m_sglMaxCorrelationMap;
//	float m_sglMinCorrelationMap;
//	float m_sglDelCorrelationMap;
//	byte* m_pbytStageMapBuf;
////	unsigned long* m_pulDSSAIndexBuf;
//	byte* m_pbytDSSAPtupleBuf;
//
//	void HideDialogs(void);
//
//private:
//
//	BOOL GetMinerCookie();
//
//public:
//	int m_nFileNameLength;
//
//// Overrides
//	// ClassWizard generated virtual function overrides
//	//{{AFX_VIRTUAL(CApp)
//	public:
//	virtual BOOL InitInstance();
//	//}}AFX_VIRTUAL
//
//// Implementation
//	//{{AFX_MSG(CApp)
//	afx_msg void OnAppAbout();
//	afx_msg void OnFileOpen();
//	afx_msg void OnButtonCrop();
//	afx_msg void OnUpdateButtonCrop(CCmdUI* pCmdUI);
//	afx_msg void OnButtonZoom();
//	afx_msg void OnUpdateButtonZoom(CCmdUI* pCmdUI);
//	afx_msg void OnButtonViewDSSA();
//	afx_msg void OnUpdateButtonViewDSSA(CCmdUI* pCmdUI);
//	afx_msg void OnButtonViewRgb();
//	afx_msg void OnUpdateButtonViewRgb(CCmdUI* pCmdUI);
//	afx_msg void OnButtonViewRed();
//	afx_msg void OnUpdateButtonViewRed(CCmdUI* pCmdUI);
//	afx_msg void OnButtonViewBlue();
//	afx_msg void OnUpdateButtonViewBlue(CCmdUI* pCmdUI);
//	afx_msg void OnButtonViewGreen();
//	afx_msg void OnUpdateButtonViewGreen(CCmdUI* pCmdUI);
//	afx_msg void OnButtonToggleImagePropertyPage();
//	afx_msg void OnUpdateButtonToggleImagePropertyPage(CCmdUI* pCmdUI);
//	afx_msg void OnButtonToggleMapControlsPage();
//	afx_msg void OnUpdateButtonToggleMapControlsPage(CCmdUI* pCmdUI);
//	afx_msg void OnButtonCorrelationMap();
//	afx_msg void OnUpdateButtonCorrelationMap(CCmdUI* pCmdUI);
//	afx_msg void OnButtonStageMap();
//	afx_msg void OnUpdateButtonStageMap(CCmdUI* pCmdUI);
//	afx_msg void OnButtonFeatureMap();
//	afx_msg void OnUpdateButtonFeatureMap(CCmdUI* pCmdUI);
//	afx_msg void OnButtonOverlayMap();
//	afx_msg void OnUpdateButtonOverlayMap(CCmdUI* pCmdUI);
//	afx_msg void OnButtonTextureMap();
//	afx_msg void OnUpdateButtonTextureMap(CCmdUI* pCmdUI);
//	afx_msg void OnButtonImageOnly();
//	afx_msg void OnUpdateButtonImageOnly(CCmdUI* pCmdUI);
//	afx_msg void OnButtonMinePointMatch();
//	afx_msg void OnUpdateButtonMinePointMatch(CCmdUI* pCmdUI);
//	afx_msg void OnButtonMineBestMatch();
//	afx_msg void OnButtonMineAverageMatch();
//	afx_msg void OnUpdateButtonMineBestMatch(CCmdUI* pCmdUI);
//	afx_msg void OnUpdateButtonMineAverageMatch(CCmdUI* pCmdUI);
//	afx_msg void OnButtonMineDeepestMatch();
//	afx_msg void OnUpdateButtonMineDeepestMatch(CCmdUI* pCmdUI);
//	afx_msg void OnButtonShowDataPak();
//	afx_msg void OnUpdateButtonShowDataPak(CCmdUI* pCmdUI);
//	//}}AFX_MSG
//	DECLARE_MESSAGE_MAP()
//	bool m_bShowDataPak;
//};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_Miner_H__9CE40E42_E70F_461C_96E7_7E3912F361F3__INCLUDED_)
