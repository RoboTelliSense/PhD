%%
%% This is file `gt-ece-thesis.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% gt-ece-thesis.dtx  (with options: `class')
%% 
%% This is a generated file.
%% 
%% Copyright (C) 2004 by Daniel Allred <djallred@ece.gatech.edu>
%% 
%% This file may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.2
%% of this license or (at your option) any later version.
%% The latest version of this license is in:
%% 
%%    http://www.latex-project.org/lppl.txt
%% 
%% and version 1.2 or later is part of all distributions of LaTeX
%% version 1999/12/01 or later.
%% 
\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{gt-ece-thesis}
   [2005/01/11 v1.1 GT ECE thesis template]
\newif\iftitlepage
   \titlepagetrue
\newif\ifapprovalpage
   \approvalpagetrue
\newif\iffigurespage
   \figurespagetrue
\newif\iftablespage
   \tablespagetrue
\newif\ifcontentspage
   \contentspagetrue
\newif\ifsymbolspage
   \symbolspagefalse
\newif\ifglossarypage
   \glossarypagefalse
\newif\ifbibpage
   \bibpagetrue
\newif\ifcontinuouscount
   \continuouscounttrue
\newif\ifmastersthesis
   \mastersthesisfalse
\newif\ifmultivolume
   \multivolumefalse
\newif\ifsinglespacednotes
   \singlespacednotestrue
\newif\ifcampanile
   \campaniletrue
\newif\ifexpandedSignatures
   \expandedSignaturesfalse
\newif\if@proposal
   \@proposalfalse
\newif\if@proposaltitle
   \@proposaltitlefalse
\newif\if@draft
   \@draftfalse
\newif\if@copyright
   \@copyrightfalse
\newif\if@times
   \@timestrue
\newif\if@hyperrefused
   \@hyperrefusedfalse
\newif\if@etd
   \@etdfalse
\DeclareOption{draft}{
   \@drafttrue
   \typeout{GT-ECE-THESIS Class Option: ``draft''}
   \ExecuteOptions{10pt,twoside,openany,doublespaced,normalmargins}
   \PassOptionsToClass{draft}{report}
   \newcommand{\tlDRAFT}%
      {\raisebox{ 3ex}[0pt][0pt]{\llap{\sffamily\scriptsize DRAFT\ \ }}}
   \newcommand{\trDRAFT}%
      {\raisebox{ 3ex}[0pt][0pt]{\rlap{\sffamily\scriptsize \ \ DRAFT}}}
   \newcommand{\blDRAFT}%
      {\raisebox{-3ex}[0pt][0pt]{\llap{\sffamily\scriptsize DRAFT\ \ }}}
   \newcommand{\brDRAFT}%
      {\raisebox{-3ex}[0pt][0pt]{\rlap{\sffamily\scriptsize \ \ DRAFT}}}
}%

\DeclareOption{proposal}{
   \@proposaltrue
   \@proposaltitletrue
   \typeout{GT-ECE-THESIS Class Option: ``proposal''}
   \approvalpagefalse
   \ExecuteOptions{10pt,oneside,openany,doublespaced,proposalmargins}
}%

\DeclareOption{proposalwithchap}{
   \@proposalfalse
   \@proposaltitletrue
   \typeout{GT-ECE-THESIS Class Option: ``proposalwithchap (proposal with chapters)''}
   \approvalpagefalse
   \ExecuteOptions{10pt,oneside,openany,doublespaced}
}%

\DeclareOption{ETD}{
   \@etdtrue
   \expandedSignaturestrue
   \typeout{GT-ECE-THESIS Class Option: ``Electronic Thesis and Dissertation (ETD)''}
}%

\DeclareOption{gtTOC}{
   \@gttoctrue
   \typeout{GT-ECE-THESIS Class Option: ``gtTOC - Special TOC formatting invoked''}
}%

\DeclareOption{noTimes}{
   \@timesfalse
   \typeout{GT-ECE-THESIS Class Option: Default font (Times Roman) turned off. CMR will be used instead.}
}%

\newcommand{\@marginsize}{}
\DeclareOption{narrowmargins}{\renewcommand{\@marginsize}{0}}
\DeclareOption{normalmargins}{\renewcommand{\@marginsize}{1}}
\DeclareOption{widemargins}{\renewcommand{\@marginsize}{2}}
\DeclareOption{proposalmargins}{\renewcommand{\@marginsize}{3}}

\newcommand{\@thesisptsz}{}
\DeclareOption{10pt}{\renewcommand{\@thesisptsz}{10pt}}
\DeclareOption{11pt}{\renewcommand{\@thesisptsz}{11pt}}
\DeclareOption{12pt}{\renewcommand{\@thesisptsz}{12pt}}

\newcommand{\@thesisside}{}
\DeclareOption{twoside}{\renewcommand{\@thesisside}{twoside}}
\DeclareOption{oneside}{\renewcommand{\@thesisside}{oneside}}

\newcommand{\@thesisopen}{}
\DeclareOption{openany}{\renewcommand{\@thesisopen}{openany}}
\DeclareOption{openright}{\renewcommand{\@thesisopen}{openright}}

\newcommand{\@thesislnsp}{}
\DeclareOption{singlespaced}{\renewcommand{\@thesislnsp}{1}}
\DeclareOption{oneandahalfspaced}{
   \ifdim \@thesisptsz = 12pt
      \renewcommand{\@thesislnsp}{1.24}
   \fi
   \ifdim \@thesisptsz = 11pt
      \renewcommand{\@thesislnsp}{1.21}
   \fi
   \ifdim \@thesisptsz = 10pt
      \renewcommand{\@thesislnsp}{1.25}
   \fi
}
\DeclareOption{doublespaced}{
   \ifdim \@thesisptsz = 12pt
      \renewcommand{\@thesislnsp}{1.66}
   \fi
   \ifdim \@thesisptsz = 11pt
      \renewcommand{\@thesislnsp}{1.62}
   \fi
   \ifdim \@thesisptsz = 10pt
      \renewcommand{\@thesislnsp}{1.67}
   \fi
}

\DeclareOption*{
   \typeout{GT-ECE-THESIS Class Info: The option, \CurrentOption, is}
   \typeout{\space\space\space not an explicit option of the GT-ECE-THESIS class and }
   \typeout{\space\space\space is therefore being passed on to the report class.}%
   \PassOptionsToClass{\CurrentOption}{report}%
}
\ExecuteOptions{12pt,letterpaper,oneside,openright,doublespaced,normalmargins,final}
\ProcessOptions

\typeout{GT-ECE-THESIS Class Info: Begin loading of LaTeX report class.}
\LoadClass[\@thesisptsz,\@thesisside,\@thesisopen]{report}
\typeout{GT-ECE-THESIS Class Info: Finished loading of LaTeX report class.}

\if@times
   \typeout{GT-ECE-THESIS Class Info: Begin loading of TIMES ROMAN font packages.}
   \RequirePackage{textcomp}
   \RequirePackage{latexsym}
   \RequirePackage{amsmath}
   \RequirePackage{amsfonts}
   \RequirePackage{amssymb}
   \RequirePackage{txfonts}
   \ifdim \@thesisptsz < 12pt
      \typeout{GT-ECE-THESIS Class Warning: The selected font size is smaller than allowed for a final copy.}
      \if@draft
      \else
         \typeout{GT-ECE-THESIS Class Warning: Font size has been changed to 12 pt because this is not a draft copy.}
         \renewcommand{\@thesisptsz}{12pt}
      \fi
   \fi
   \typeout{GT-ECE-THESIS Class Info: Finished loading of TIMES ROMAN font packages.}
\else
   \ifdim \@thesisptsz < 11pt
      \typeout{GT-ECE-THESIS Class Warning: The selected font size is smaller than allowed for a final copy.}
      \if@draft
      \else
         \typeout{GT-ECE-THESIS Class Warning: Font size has been changed to 11 pt because this is not a draft copy.}
         \renewcommand{\@thesisptsz}{11pt}
      \fi
   \fi
\fi

\ifcampanile
   \typeout{GT-ECE-THESIS Class Info: Begin loading of graphics package(for campanile).}
   \RequirePackage{graphics}
   \typeout{GT-ECE-THESIS Class Info: Finished loading of graphics package(for campanile).}
\fi

\typeout{GT-ECE-THESIS Class Info: Begin loading of required packages.}
\RequirePackage{calc}
\RequirePackage{chngcntr}
\typeout{GT-ECE-THESIS Class Info: Finished loading of required packages.}
\newcommand{\settocstring}[1]{%
   \renewcommand{\contentsname}{#1}}%
\newcommand{\setlofstring}[1]{%
   \renewcommand{\listfigurename}{#1}}%
\newcommand{\setlotstring}[1]{%
   \renewcommand{\listtablename}{#1}}%
\newcommand{\setbibstring}[1]{%
   \renewcommand{\bibname}{#1}}%
\newcommand{\setindstring}[1]{%
   \renewcommand{\indexname}{#1}}%
\newcommand{\setchpstring}[1]{%
   \renewcommand{\chaptername}{#1}}%
\newcommand{\setappstring}[1]{%
   \renewcommand{\appendixname}{#1}}%
\newcommand{\setprtstring}[1]{%
   \renewcommand{\partname}{#1}}%
\newcommand{\setabsstring}[1]{%
   \renewcommand{\abstractname}{#1}}%
\newcommand{\setfigstring}[1]{%
   \renewcommand{\figurename}{#1}}%
\newcommand{\settabstring}[1]{%
   \renewcommand{\tablename}{#1}}%
\newcommand{\symbolsname}{}
\newcommand{\setlosstring}[1]{%
   \renewcommand{\symbolsname}{#1}}%
\newcommand{\dedicatename}{}
\newcommand{\setdedstring}[1]{%
   \renewcommand{\dedicatename}{#1}}%
\newcommand{\thanksname}{}
\newcommand{\setackstring}[1]{%
   \renewcommand{\thanksname}{#1}}%
\newcommand{\glossaryname}{}
\newcommand{\setglostring}[1]{%
   \renewcommand{\glossaryname}{#1}}%
\newcommand{\sectionname}{Section}
\newcommand{\setsecstring}[1]{%
   \renewcommand{\sectionname}{#1}}%
\settocstring{Table of Contents}
\setlofstring{List of Figures}
\setlotstring{List of Tables}
\setdedstring{Dedication}
\setackstring{Acknowledgments}
\setabsstring{Summary}
\setlosstring{List of Symbols}
\setglostring{List of Terms}

\setprtstring{Volume}
\setchpstring{Chapter}
\setsecstring{Section}
\setappstring{Appendix}
\setfigstring{Figure}
\settabstring{Table}

\setbibstring{References}
\setindstring{Index}
\newcommand{\settocdepth}[1]{%
   \addtocontents{toc}{\protect\setcounter{tocdepth}{#1}}}%
\newcommand{\chapter@tocdepth}{}%
\newcommand{\appendix@tocdepth}{}%
\newcommand{\section@tocdepth}{}%
\newcommand{\setchaptertocdepth}[1]{%
   \renewcommand{\chapter@tocdepth}{#1}}%
\newcommand{\setappendixtocdepth}[1]{%
   \renewcommand{\appendix@tocdepth}{#1}}%
\newcommand{\setsectiontocdepth}[1]{%
   \renewcommand{\section@tocdepth}{#1}}%
\newcommand{\setfrontpagestyle}[1]{%
  \gdef\front@pagestyle{#1}
}
\newcommand{\setbodypagestyle}[1]{%
  \gdef\body@pagestyle{#1}
}
\newcommand{\setendpagestyle}[1]{%
  \gdef\back@pagestyle{#1}
}
\newcommand{\comment}[1]{}%
\AtBeginDocument{
   \providecommand{\texorpdfstring}[2]{#1}
   \providecommand{\phantomsection}{}

   \ifx\pdfbookmark\undefined
      \def\pdfbookmark[#1]#2#3{}%
      \typeout{GT-ECE-THESIS Class Info: pdfbookmark was undefined, but has now been defined.}
   \fi%

   \newif\ifHy@nesting
      \Hy@nestingfalse

   \ifx\Hy@StepCount\undefined
      \typeout{GT-ECE-THESIS Class Info: The hyperref package is NOT being used.}
      \@hyperrefusedfalse
      \def\hyper@makecurrent#1{}
      \def\Hy@raisedlink#1{}
      \def\hyper@@anchor#1{}
      \let\@currentHref\@empty
      \Hy@nestingfalse
   \else
      \@hyperrefusedtrue
      \Hy@nestingtrue
      \typeout{GT-ECE-THESIS Class Info: The hyperref package has been loaded.}
   \fi%

   \if@hyperrefused%
      \typeout{This should not be output.}
      \hypersetup{%
         plainpages=true,
         breaklinks=true,% not default in dvips mode, so we must specify
         hypertexnames=false,%not ideal, but needed when pagenums duplicate (`i' vs. `1')
         pageanchor=true,
         colorlinks=true,
         linkcolor={blue},
         citecolor={green},
         urlcolor={red},
         pagecolor={cyan},
         anchorcolor={black}
      }
      %\ifHy@nesting
      \long\def\@caption#1[#2]#3{%
         \hyper@makecurrent{\@captype}%
         \par\addcontentsline{\csname ext@#1\endcsname}{#1}{%
            \protect\numberline{\csname fnum@#1\endcsname}{\ignorespaces #2}}%
         \begingroup
            \@parboxrestore
            \if@minipage
               \@setminipage
            \fi
            \normalsize
            \@makecaption{\csname fnum@#1\endcsname}{%
               \ignorespaces
               \ifHy@nesting
                  \hyper@@anchor{\@currentHref}{#3}%
               \else
                  \Hy@raisedlink{\hyper@@anchor{\@currentHref}{\relax}}#3%
               \fi
            }%
            \par
         \endgroup
      }
      %\else
      %\fi
      \let\Hy@float@caption\@caption
      \@ifpackageloaded{float}{%
         \def\Hy@float@caption{%
            \hyper@makecurrent{\@captype}%
            \float@caption
         }
         \let\HyOrg@float@makebox\float@makebox
         \renewcommand{\float@makebox}[1]{%
            \HyOrg@float@makebox{%
               #1\relax
               \hyper@@anchor{\@currentHref}{\relax}%
            }% \HyOrg@float@makebox
         }% \renewcommand
      }{}%
   \else
      \long\def\@caption#1[#2]#3{%
         \par
         \addcontentsline{\csname ext@#1\endcsname}{#1}%
            {\protect\numberline{\csname fnum@#1\endcsname}{\ignorespaces #2}}%
         \begingroup
            \@parboxrestore
            \if@minipage%
               \@setminipage%
            \fi%
            \normalsize%
            \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par%
         \endgroup
      }
     \let\noHyper@caption\@caption
   \fi %\if@hyperrefused

   \@newlinestretch{\@thesislnsp}
   \if@draft
   \else
      \ifdim \@thesislnsp pt < 1.62pt
         \typeout{GT-ECE-THESIS Class Warning: line spacing is not double spaced}
      \fi
   \fi
}% End of AtBeginDocument
\newcommand{\@newlinestretch}[1]{%
   \renewcommand{\baselinestretch}{#1}%
   \@textsize%
}
\newenvironment{longquote}%
   {\begin{quote}\@newlinestretch{1}}{\end{quote}}
\newenvironment{longquotation}%
   {\begin{quotation}\@newlinestretch{1}}{\end{quotation}}
\newenvironment{singlespace}%
   {\begin{newspacing}{1}}{\end{newspacing}}
\newenvironment{oneandahalfspace}{%
   \ifdim \@thesisptsz = 12pt%
      \begin{newspacing}{1.24}%
   \fi%
   \ifdim \@thesisptsz = 11pt%
      \begin{newspacing}{1.21}%
   \fi%
   \ifdim \@thesisptsz = 10pt%
      \begin{newspacing}{1.25}%
   \fi}%
   {\end{newspacing}}%
\newenvironment{doublespace}{%
   \ifdim \@thesisptsz = 12pt%
      \begin{newspacing}{1.66}%
   \fi%
   \ifdim \@thesisptsz = 11pt%
      \begin{newspacing}{1.62}%
   \fi%
   \ifdim \@thesisptsz = 10pt%
      \begin{newspacing}{1.67}%
   \fi}%
   {\end{newspacing}}%
\newenvironment{newspacing}[1]%
   {\par\begingroup\@newlinestretch{#1}}%
   {\par\vskip\parskip\vskip\baselineskip\endgroup%
   \vskip-\parskip\vskip-\baselineskip}
\ifsinglespacednotes
   \let\tmp@footnotetext=\@footnotetext
   \renewcommand{\@footnotetext}[1]{%
       \@newlinestretch{1}%
       \tmp@footnotetext{#1}%
       \@newlinestretch{\@thesislnsp}%
   }
   \let\tmp@mpfootnotetext=\@mpfootnotetext
   \renewcommand{\@mpfootnotetext}[1]{%
      \@newlinestretch{1}%
      \tmp@@mpfootnotetext{#1}%
      \@newlinestretch{\@thesislnsp}%
   }
   \let\tmp@marginparreset=\@marginparreset
   \renewcommand{\@marginparreset}{%
      \@newlinestretch{1}%
      \tmp@marginparreset%
      \@newlinestretch{\@thesislnsp}%
   }
\fi
\setlength{\skip\footins}{.75\baselineskip}
\ifsinglespacednotes
\else
   \let\oldtextsize=\@textsize
   \footnotesize
   \setlength{\marginparpush}{\baselineskip}
   \setlength{\footnotesep}{\baselineskip}
   \oldtextsize
\fi
\let\@textsize=\normalsize
\let\tmp@tiny=\tiny
\let\tmp@scriptsize=\scriptsize
\let\tmp@footnotesize=\footnotesize
\let\tmp@small=\small
\let\tmp@normalsize=\normalsize
\let\tmp@large=\large
\let\tmp@Large=\Large
\let\tmp@LARGE=\LARGE
\let\tmp@huge=\huge
\let\tmp@Huge=\Huge
\renewcommand{\tiny}{\let\@textsize=\tmp@tiny\@textsize}
\renewcommand{\scriptsize}{\let\@textsize=\tmp@scriptsize\@textsize}
\renewcommand{\footnotesize}{\let\@textsize=\tmp@footnotesize\@textsize}
\renewcommand{\small}{\let\@textsize=\tmp@small\@textsize}
\renewcommand{\normalsize}{\let\@textsize=\tmp@normalsize\@textsize}
\renewcommand{\large}{\let\@textsize=\tmp@large\@textsize}
\renewcommand{\Large}{\let\@textsize=\tmp@Large\@textsize}
\renewcommand{\LARGE}{\let\@textsize=\tmp@LARGE\@textsize}
\renewcommand{\huge}{\let\@textsize=\tmp@huge\@textsize}
\renewcommand{\Huge}{\let\@textsize=\tmp@Huge\@textsize}
\renewcommand{\ps@empty}{
  \let\@mkboth\@gobbletwo
  \def\@oddfoot{
    \if@draft
      \blDRAFT\hfil{\slshape\small\today}\hfil\brDRAFT
    \fi
  }%
  \let\@evenfoot\@oddfoot
  \def\@oddhead{
    \if@draft
      \tlDRAFT\hfil{\slshape\small\today}\hfil\trDRAFT
    \fi
  }%
  \let\@evenhead\@oddhead
}
\renewcommand{\ps@plain}{%
   \let\@mkboth\@gobbletwo%
   \def\@oddfoot{%
      \if@draft\blDRAFT\fi%
      \hfil\thepage\hfil%
      \if@draft\brDRAFT\fi%
   }%
   \let\@evenfoot\@oddfoot%
   \def\@oddhead{%
      \if@draft%
         \tlDRAFT\hfil{\slshape\small\today}\hfil\trDRAFT%
      \fi%
   }%
   \let\@evenhead\@oddhead%
}
\if@twoside % if two-sided printing
   \renewcommand{\ps@headings}{%
      \let\@mkboth\markboth%
      \def\@oddfoot{%
         \if@draft%
            \blDRAFT\hfil{\slshape\small\today}\hfil\brDRAFT%
         \fi%
      }%
      \let\@evenfoot\@oddfoot%
      \def\@oddhead{%
         \if@draft\tlDRAFT\fi%
         {\slshape\rightmark}\hfil%
         \thepage%
         \if@draft\trDRAFT\fi%
      }%
      \def\@evenhead{%
         \if@draft\tlDRAFT\fi%
         \thepage\hfil%
         {\slshape\leftmark}%
         \if@draft\trDRAFT\fi%
      }%
      \def\chaptermark##1{%
         \markboth
         {\MakeUppercase{%
            \ifnum\c@secnumdepth >\m@ne%
               \@chapapp\ \thechapter. \ %
            \fi ##1}%
         }{}%
      }%
      \def\sectionmark##1{%
         \markright%
         {\MakeUppercase{%
            \ifnum\c@secnumdepth >\z@%
               \thesection. \ %
            \fi ##1}%
         }%
      }%
   }%ps@headings
\else % if one-sided printing
   \renewcommand{\ps@headings}{%
      \let\@mkboth\markboth%
      \def\@oddfoot{%
         \if@draft%
            \blDRAFT\hfil%
            {\slshape\small\today}\hfil\brDRAFT%
         \fi%
      }%
      \def\@oddhead{%
         \if@draft\tlDRAFT\fi%
         {\slshape\rightmark}\hfil%
         \thepage%
         \if@draft\trDRAFT\fi%
      }%
      \def\chaptermark##1{%
         \markright%
         {\MakeUppercase{%
            \ifnum\c@secnumdepth >\m@ne%
               \@chapapp\ \thechapter. \ %
            \fi ##1}%
         }%
      }%
   }%ps@headings
\fi % @twoside
\renewcommand{\ps@myheadings}{%
   \let\@mkboth\@gobbletwo%
   \def\@oddfoot{%
      \if@draft%
         \blDRAFT\hfil{\slshape\small\today}\hfil\brDRAFT%
      \fi%
   }%
   \let\@evenfoot\@oddfoot%
   \def\@oddhead{%
     \if@draft\tlDRAFT\fi%
     {\slshape\rightmark}\hfil%
     \thepage%
     \if@draft\trDRAFT\fi%
   }%
   \def\@evenhead{%
     \if@draft\tlDRAFT\fi%
     \thepage\hfil%
     {\slshape\leftmark}%
     \if@draft\trDRAFT\fi%
   }%
   \let\chaptermark\@gobble\let\sectionmark\@gobble%
}%ps@myheadings
\if@twoside % if two-sided printing
  \newcommand{\ps@gtthesis}{%
    \let\@mkboth\markboth%
    \def\@oddfoot{%
      \if@draft%
        \blDRAFT\hfil%
        {\slshape\small\today}\hfil\brDRAFT%
      \fi%
    }%
    \let\@evenfoot\@oddfoot%
    \def\@oddhead{%
      \if@draft\tlDRAFT\fi%
      {\slshape\rightmark}\hfil%
      \thepage%
      \if@draft\trDRAFT\fi%
    }%
    \def\@evenhead{%
      \if@draft\tlDRAFT\fi%
      \thepage\hfil%
      {\slshape\leftmark}%
      \if@draft\trDRAFT\fi%
    }%
    \def\chaptermark##1{%
      \markboth%
      {\textsc{%
        \ifnum\c@secnumdepth >\m@ne%
          \@chapapp\ \thechapter. \ %
        \fi ##1}%
      }{}%
    }%
    \def\sectionmark##1{%
      \markright%
      {\textsc{%
        \ifnum\c@secnumdepth >\z@%
          \thesection. \ %
        \fi ##1}%
      }
    }%
  }%ps@gtthesis
\else % if one-sided printing
  \newcommand{\ps@gtthesis}{%
    \let\@mkboth\markboth%
    \def\@oddfoot{%
      \if@draft%
        \blDRAFT\hfil%
        {\slshape\small\today}\hfil\brDRAFT%
      \fi%
    }%
    \def\@oddhead{%
      \if@draft\tlDRAFT\fi%
      {\slshape\rightmark}\hfil%
      \thepage%
      \if@draft\trDRAFT\fi%
    }%
    \def\chaptermark##1{%
      \markright%
      {\textsc{%
        \ifnum\c@secnumdepth >\m@ne%
          \@chapapp\ \thechapter. \ %
        \fi ##1}%
      }
    }%
  }%ps@gtthesis
\fi % @twoside
\setlength{\voffset}{-1in}
\setlength{\hoffset}{-1in}
\setlength{\textheight}{\paperheight}
\setlength{\textwidth}{\paperwidth}
\ifcase\@marginsize % set narrow margins: 1 1/4 in. left, 3/4 in. others
   \addtolength{\textheight}{-1.5in}
   \setlength{\topmargin}{0.0in}
   \setlength{\headsep}{.25in}
   \setlength{\footskip}{.25in}
   \addtolength{\textwidth}{-2in}
   \setlength{\oddsidemargin}{1.25in}
   \setlength{\evensidemargin}{.75in}
   \setlength{\marginparwidth}{.5in}
   \setlength{\marginparsep}{.125in}
   \or % set normal margins: 1.5 in. left, 1 in. others
   \addtolength{\textheight}{-2in}
   \setlength{\topmargin}{0.5in}
   \setlength{\headsep}{0.5in}   % reduced by headheight, below
   \setlength{\headheight}{0.0in}
   \setlength{\footskip}{0.5in}
   \addtolength{\textwidth}{-2.5in}
   \setlength{\oddsidemargin}{1.5in}
   \setlength{\evensidemargin}{1in}
   \setlength{\marginparwidth}{.75in}

   \setlength{\marginparsep}{.125in}
   \or % set wide margins: 1.5in. left, 1in. others, 2in. top
   \addtolength{\textheight}{-3in}
   \setlength{\topmargin}{1in}
   \setlength{\headsep}{.5in} % reduced by headheight, below
   \setlength{\footskip}{0.5in}
   \addtolength{\textwidth}{-2.5in}
   \setlength{\oddsidemargin}{1.5in}
   \setlength{\evensidemargin}{1in}
   \setlength{\marginparwidth}{.75in}
   \setlength{\marginparsep}{.125in}
   \or % set proposal margins: 1.25in. left and right, 1in. top and bottom
   \addtolength{\textheight}{-2in}
   \setlength{\topmargin}{0.5in}
   \setlength{\headsep}{0.5in}   % reduced by headheight, below
   \setlength{\headheight}{0.0in}
   \setlength{\footskip}{0.5in}
   \addtolength{\textwidth}{-2.5in}
   \setlength{\oddsidemargin}{1.25in}
   \setlength{\evensidemargin}{1.25in}
   \setlength{\marginparwidth}{.75in}
   \setlength{\marginparsep}{.125in}
\fi%@marginsize
\addtolength{\headsep}{-\headheight}
\newenvironment{FrontMatter}{
   \typeout{******** FrontMatter Begins ********}%
   \@newlinestretch{1.0}%
   \pagenumbering{roman}%
   \pagestyle{\front@pagestyle}%
   \iftitlepage%
      \typeout{Titlepage.}%
      \maketitle%
   \fi%
   \ifmultivolume%
      \part{}%
   \fi%
   \ifapprovalpage%
      \typeout{approval Page.}%
      \makeapproval%
   \fi%
   \settoheight{\gt@tmpa}{i}% This and the next line provide vertical
   \addtolength{\footskip}{0.5\gt@tmpa}% centering of page number in footer.
   \@newlinestretch{\@thesislnsp}%
}
{
   \if@draft%
   \else%
      \if@twoside%
         \if@openright%
            \cleardoublepage%
         \fi%
      \fi%
   \fi%
   \newpage%
   \typeout{******** FrontMatter Ends ********}%
}%
\long\def\@title{}
\def\@author{}
\def\@major{Electrical and Computer Engineering}
\def\@dept{School of Electrical and Computer Engineering}
\def\@principaladvisor{}
\def\@principaladvisortitle{}
\def\@principaladvisoraffil{}
\def\@committeechair{}
\def\@committeechairtitle{}
\def\@committeechairaffil{}
\def\@firstreader{}
\def\@firstreadertitle{}
\def\@firstreaderaffil{}
\def\@secondreader{}
\def\@secondreadertitle{}
\def\@secondreaderaffil{}
\def\@thirdreader{}
\def\@thirdreadertitle{}
\def\@thirdreaderaffil{}
\def\@fourthreader{}
\def\@fourthreadertitle{}
\def\@fourthreaderaffil{}
\def\@fifthreader{}
\def\@fifthreadertitle{}
\def\@fifthreaderaffil{}
\def\@sixthreader{}
\def\@sixthreadertitle{}
\def\@sixthreaderaffil{}
\def\@graddate{\ifcase\the\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space \number\the\year}
\def\@approvaldate{\ifcase\the\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space \number\the\day, \number\the\year}
\def\@copyrightyear{\number\the\year}
\def\@bibfiles{}
\renewcommand{\author}[1]%
   {\ifx\empty#1\empty\else\gdef\@author{#1}\fi}
\renewcommand{\title}[1]%
   {\ifx\empty#1\empty\else\gdef\@title{\MakeUppercase{#1}}\fi}
\newcommand{\major}[1]%
   {\ifx\empty#1\empty\else\gdef\@major{#1}\fi}
\newcommand{\multiLineTitle}[1]%
   {\ifx\empty#1\empty\else\gdef\@title{#1}\fi}
\newcommand{\dept}[1]%
   {\ifx\empty#1\empty\else\gdef\@dept{#1}\fi}
\newcommand{\copyrightyear}[1]{%
   \ifx\empty#1\empty\else%
      \gdef\@copyrightyear{#1}%
      \@copyrighttrue%
   \fi}
\newcommand{\graddate}[1]%
   {\ifx\empty#1\empty\else\gdef\@graddate{#1}\fi}
\newcommand{\approvaldate}[1]%
   {\ifx\empty#1\empty\else\gdef\@approvaldate{#1}\fi}
\newcounter{numGeneralReaders}
\newcounter{numSpecialReaders}
\setcounter{numGeneralReaders}{0} %set to zero to start
\setcounter{numSpecialReaders}{0} %set to zero to start
\newcommand{\numdecode}[1]{%
   \ifcase\csname the#1\endcsname\or first\or second\or third\or%
   fourth\or fifth\or sixth\fi}
\newcommand{\advis@r}{Advisor} % default spelling
\newif\ifadvisor@present
\advisor@presentfalse
\newcommand{\addadvisor}[3]{
   \addtocounter{numSpecialReaders}{1}
   \ifx\empty#1\empty\else\gdef\@principaladvisor{#1}\fi%
   \ifx\empty#2\empty\else\gdef\@principaladvisortitle{#2}\fi%
   \ifx\empty#3\empty\else\gdef\@principaladvisoraffil{#3}\fi%
   \advisor@presenttrue
}
\newcommand{\addadviser}[3]{%
   \addadvisor{#1}{#2}{#3}%
   \renewcommand{\advis@r}{Adviser}%
} % \principaladviser
\newif\ifchair@present
\chair@presentfalse
\newcommand{\addchair}[3]{
   \addtocounter{numSpecialReaders}{1}
   \ifx\empty#1\empty\else\gdef\@committeechair{#1}\fi%
   \ifx\empty#2\empty\else\gdef\@committeechairtitle{#2}\fi%
   \ifx\empty#3\empty\else\gdef\@committeechairaffil{#3}\fi%
   \chair@presenttrue
}
\newcommand{\addreader}[3]{
   \addtocounter{numGeneralReaders}{1}
   \ifx\empty#1\empty
   \else
      \expandafter\gdef\csname @\numdecode{numGeneralReaders}reader\endcsname{#1}
   \fi
   \ifx\empty#2\empty
   \else
      \expandafter\gdef\csname @\numdecode{numGeneralReaders}readertitle\endcsname{#2}
   \fi
   \ifx\empty#3\empty
   \else
      \expandafter\gdef\csname @\numdecode{numGeneralReaders}readeraffil\endcsname{#3}
   \fi
}
\newcommand{\bibfiles}[1]%
   {\ifx\empty#1\empty\else\gdef\@bibfiles{#1}\fi}
\newcommand{\contents}{%
   \newpage%
   \ifcontentspage%
      \maketableofcontents%
   \fi%
   \iftablespage%
      \makelistoftables%
   \fi%
   \iffigurespage%
      \makelistoffigures%
   \fi%
   \ifsymbolspage%
      \makelistofsymbols%
   \fi%
   \ifglossarypage%
      \makeglossary%
   \fi%
}
\renewcommand{\maketitle}{%
   \normalfont%
   \begingroup%
      \@newlinestretch{1}%
      \begin{titlepage}%
         \phantomsection%
         \if@proposal
            \pdfbookmark[1]{Titlepage}{title}%
         \else
            \pdfbookmark[0]{Titlepage}{title}%
         \fi%
         \title@top%
         \vfill%
         \title@middle%
         \vfill%
         \title@bottom%
         \setcounter{page}{1}%
      \end{titlepage}% this has a \newpage
   \endgroup%
   \setcounter{page}{2}%
}
\newcommand{\title@top}{%
   \begin{center}%
      \begin{doublespace}%
         \Large\bfseries{\@title}%
      \end{doublespace}%
   \end{center}%
}%
\newcommand{\title@middle}{
   \begin{center}
      \ifmastersthesis%
         {A Thesis}%
      \else%
         {A Dissertation}%
      \fi%
      \if@proposaltitle%
         {\ Proposal}
      \fi%
      \\
      Presented to\\
      The Academic Faculty\\
      \ \\
      By\\
      \ \\
      {\@author}\\%
      \vspace*{1in}
      In Partial Fulfillment\\%
      of the Requirements for the Degree\\%
      \ifmastersthesis%
         {Master of Science\\}%
      \else%
         {Doctor of Philosophy\\}%
      \fi%
      in\\%
      \@major\\
   \end{center}
}
\newcommand{\title@bottom}{
   \begin{center}%
      \ifcampanile%
         \scalebox{0.22}{\includegraphics{figs/logo_GTcampanile}}%
         \ \\%
      \fi%
      \@dept\\%
      Georgia Institute of Technology\\%
      \@graddate\\%
      \if@copyright%
         \ \\%
         Copyright \copyright\ {\@copyrightyear} by {\@author}%
      \fi%
   \end{center}%
}%
\toksdef\ta=0 \toksdef\tb=2 % token list registers for temp use
\long\def\myrightappenditem#1\to#2{\ta={#1}\tb=\expandafter{#2}%
   \edef#2{\the\tb\the\ta}}
\long\def\myleftappenditem#1\to#2{\ta={#1}\tb=\expandafter{#2}%
   \edef#2{\the\ta\the\tb}}
\newlength{\signature@width}
\def\First@signatures{}
\def\Second@signatures{}
\newcommand{\signature}[3]{%
   \ifx\empty#1\empty%
   \else%
      \parbox[t]{\signature@width}{%
         \if@etd\else\rule{\signature@width}{.01in}\\ \fi
         {#1 \hfill}\\
         \ifexpandedSignatures
            {\small\itshape#2 \hfill}\\%
            %{#2 \hfill}\\%
            {\small\itshape#3 \hfill}\\
            %{#3 \hfill}\\
         \fi
         \vspace{.25in}}
   \fi%
}

\newcommand{\signature@bodyonecol}{%
   \begin{flushright}
      \makebox[\signature@width]{Approved by: \hfill}\\
   \end{flushright}
   \vspace*{0.3in}
   \hfill
   \begin{minipage}[t]{\signature@width}%
      \begin{flushright}%
         \First@signatures
      \end{flushright}
   \end{minipage}
   \begin{flushright}
      \vspace*{.3in}
      \if@etd%
         \makebox[\signature@width]{Date Approved: \@approvaldate \hfill}\\
      \else%
         \makebox[\signature@width]{Date Approved: \leaders\hrule height0.01in\hfill\kern\z@}\\
      \fi%
   \end{flushright}
}

\newcommand{\signature@bodytwocol}{%
   \begin{flushleft}
      Approved by:\\
   \end{flushleft}
   \vspace*{0.3in}
   \begin{minipage}[t]{\signature@width}%
      \begin{flushleft}%
         \First@signatures
      \end{flushleft}
   \end{minipage}
   \hfill
   \begin{minipage}[t]{\signature@width}%
      \begin{flushright}%
         \Second@signatures
      \end{flushright}
   \end{minipage}
   \begin{flushright}
      \vspace*{.3in}
      \if@etd%
         \makebox[\signature@width]{Date Approved: \@approvaldate \hfill}\\
      \else%
         \makebox[\signature@width]{Date Approved: \leaders\hrule height0.01in\hfill\kern\z@}\\
      \fi%
   \end{flushright}
}
\def\add@Firstsig#1{\myrightappenditem#1\to\First@signatures}
\def\add@Secondsig#1{\myrightappenditem#1\to\Second@signatures}
\newcommand{\makeapproval}{%
   \if@openright\cleardoublepage\else\clearpage\fi
   \phantomsection%
   \pdfbookmark[0]{Signatures}{signatures}%
   % do not addtocontents (although it is in bookmarklist)
   \newcounter{totalReaders}%
   \setcounter{totalReaders}{0}%
   \addtocounter{totalReaders}{\value{numGeneralReaders}}%
   \addtocounter{totalReaders}{\value{numSpecialReaders}}%
   \ifnum \value{totalReaders} < 5  %Case for one column
      \let\signature@body\signature@bodyonecol
      \setlength{\signature@width}{0.52\textwidth}
      % Two or more of the following are actually empty, but we can add them
      % all anyway.
      \ifchair@present
         \sbox\@tempboxa{\@committeechair, Committee Chair}%
         \ifdim \wd\@tempboxa >\signature@width
            \add@Firstsig{\signature{\@committeechair}{\@committeechairtitle}{\@committeechairaffil}}
         \else
    \add@Firstsig{\signature{\@committeechair, Committee Chair}{\@committeechairtitle}{\@committeechairaffil}}
         \fi
      \fi
      \ifadvisor@present
         \sbox\@tempboxa{\@principaladvisor, \advis@r}%
         \ifdim \wd\@tempboxa >\signature@width
            \add@Firstsig{\signature{\@principaladvisor}{\@principaladvisortitle}{\@principaladvisoraffil}}
         \else
    \add@Firstsig{\signature{\@principaladvisor, \advis@r}{\@principaladvisortitle}{\@principaladvisoraffil}}
         \fi
      \fi
      \add@Firstsig{\signature{\@firstreader}{\@firstreadertitle}{\@firstreaderaffil}}
      \add@Firstsig{\signature{\@secondreader}{\@secondreadertitle}{\@secondreaderaffil}}
      \add@Firstsig{\signature{\@thirdreader}{\@thirdreadertitle}{\@thirdreaderaffil}}
      \add@Firstsig{\signature{\@fourthreader}{\@fourthreadertitle}{\@fourthreaderaffil}}
   \else   %Case for two columns
      \let\signature@body\signature@bodytwocol
      \setlength{\signature@width}{0.48\textwidth}
      \ifchair@present
         \sbox\@tempboxa{\@committeechair, Committee Chair}%
         \ifdim \wd\@tempboxa >\signature@width
            \add@Firstsig{\signature{\@committeechair}{\@committeechairtitle}{\@committeechairaffil}}
         \else
            \add@Firstsig{\signature{\@committeechair, Committee Chair}{\@committeechairtitle}{\@committeechairaffil}}
         \fi
      \fi
      \ifadvisor@present
         \sbox\@tempboxa{\@principaladvisor, \advis@r}%
         \ifdim \wd\@tempboxa >\signature@width
            \add@Firstsig{\signature{\@principaladvisor}{\@principaladvisortitle}{\@principaladvisoraffil}}
         \else
            \add@Firstsig{\signature{\@principaladvisor, \advis@r}{\@principaladvisortitle}{\@principaladvisoraffil}}
         \fi
      \fi
      \add@Firstsig{\signature{\@firstreader}{\@firstreadertitle}{\@firstreaderaffil}}
      \ifnum \value{numGeneralReaders} > 6  % Case for four in first column, totalReaders = 7 or 8
         \add@Firstsig{\signature{\@secondreader}{\@secondreadertitle}{\@secondreaderaffil}}
         \ifnum \value{numSpecialReaders} = 1 % case when no chair or advisor
            \add@Firstsig{\signature{\@thirdreader}{\@thirdreadertitle}{\@thirdreaderaffil}}
         \else
            \add@Secondsig{\signature{\@thirdreader}{\@thirdreadertitle}{\@thirdreaderaffil}}
         \fi
         \add@Secondsig{\signature{\@fourthreader}{\@fourthreadertitle}{\@fourthreaderaffil}}
         \add@Secondsig{\signature{\@fifthreader}{\@fifthreadertitle}{\@fifthreaderaffil}}
         \add@Secondsig{\signature{\@sixthreader}{\@sixthreadertitle}{\@sixthreaderaffil}}
      \else   % Case for only 3 in first column (here totalReaders = 5 or 6)
         \ifnum \value{numSpecialReaders} = 0 % case when no chair or advisor
            \add@Firstsig{\signature{\@secondreader}{\@secondreadertitle}{\@secondreaderaffil}}
            \add@Firstsig{\signature{\@thirdreader}{\@thirdreadertitle}{\@thirdreaderaffil}}
         \fi
         \ifnum \value{numSpecialReaders} = 1 % case when only either chair or advisor
            \add@Firstsig{\signature{\@secondreader}{\@secondreadertitle}{\@secondreaderaffil}}
            \add@Secondsig{\signature{\@thirdreader}{\@thirdreadertitle}{\@thirdreaderaffil}}
         \fi
         \ifnum \value{numSpecialReaders} = 2 % case when both chair and advisor
            \add@Secondsig{\signature{\@secondreader}{\@secondreadertitle}{\@secondreaderaffil}}
            \add@Secondsig{\signature{\@thirdreader}{\@thirdreadertitle}{\@thirdreaderaffil}}
         \fi
         % All or none of these may be empty, but they can be added anyway always to second column
         \add@Secondsig{\signature{\@fourthreader}{\@fourthreadertitle}{\@fourthreaderaffil}}
         \add@Secondsig{\signature{\@fifthreader}{\@fifthreadertitle}{\@fifthreaderaffil}}
         \add@Secondsig{\signature{\@sixthreader}{\@sixthreadertitle}{\@sixthreaderaffil}}
      \fi
   \fi
   \title@top
   \vfill
   \signature@body%
   \relax%
   \thispagestyle{empty}%
}
\newlength{\gt@tmpa}
\newcommand{\maketableofcontents}{%
   \if@openright\cleardoublepage\else\clearpage\fi
   % must clear page here, so that phantomsection\addcontentsline is on the correct page
   \phantomsection%
   \if@proposal
      \pdfbookmark[1]{\contentsname}{toc}%
   \else
      \pdfbookmark[0]{\contentsname}{toc}%
   \fi
   \settoheight{\gt@tmpa}{A}
   \set@tocspacing{\gt@tmpa}
   {\@newlinestretch{1}
      \tableofcontents
   }
   \newpage
}
\newlength{\baseskip@value}
\newlength{\beforepartskip@value}
\newlength{\beforechapskip@value}
\newlength{\beforesecskip@value}
\newlength{\beforesubsecskip@value}
\newlength{\beforesubsubsecskip@value}
\newlength{\beforeparaskip@value}
\newlength{\beforesubparaskip@value}
\newlength{\beforefigskip@value}
\newlength{\beforetableskip@value}
\newlength{\zeroskip@value}
\newcommand{\set@tocspacing}[1]{%
   \setlength{\baseskip@value}{#1}
   \setlength{\beforepartskip@value}{     2.0\baseskip@value    plus    \p@}
   \setlength{\beforechapskip@value}{     1.5\baseskip@value    plus    \p@}
   \if@proposal
      \setlength{\beforesecskip@value}{   1.0\baseskip@value    plus    \p@}
   \else
      \setlength{\beforesecskip@value}{                  \z@    plus  .2\p@}
   \fi
   \setlength{\beforesubsecskip@value}{                  \z@    plus  .2\p@}
   \setlength{\beforesubsubsecskip@value}{               \z@    plus  .2\p@}
   \setlength{\beforeparaskip@value}{                    \z@    plus  .2\p@}
   \setlength{\beforesubparaskip@value}{                 \z@    plus  .2\p@}
   \ifdim \@thesislnsp pt > 1.1pt %check to see if not single-spaced
      \ifdim \@thesislnsp pt >1.4pt %check to see if not one and half spaced
         %\setlength{\beforepartskip@value}{2.0\baseskip@value    plus    \p@}
         %\setlength{\beforechapskip@value}{1.25\baseskip@value    plus    \p@}
         \setlength{\beforefigskip@value}{1.25\baseskip@value   plus  .2\p@}
         \setlength{\beforetableskip@value}{1.25\baseskip@value plus  .2\p@}
      \else %this is the case when it is one and a half spaced
         %\setlength{\beforepartskip@value}{1.0\baseskip@value    plus    \p@}
         %\setlength{\beforechapskip@value}{0.45\baseskip@value    plus    \p@}
         \setlength{\beforefigskip@value}{0.45\baseskip@value   plus  .2\p@}
         \setlength{\beforetableskip@value}{0.45\baseskip@value plus  .2\p@}
      \fi
   \else
      \setlength{\beforefigskip@value}{                  \z@    plus  .2\p@}
      \setlength{\beforetableskip@value}{                \z@    plus  .2\p@}
   \fi
   \setlength{\zeroskip@value}{\z@}
}
\newcommand*{\l@part@pagenumfont}[1]{}
\renewcommand*{\l@part}[2]{%
   \ifnum \c@tocdepth >-2\relax
      \addpenalty{-\@highpenalty}%
      \addvspace{\beforepartskip@value}%
      \setlength\@tempdima{3em}%
      \begingroup
         \parindent \z@ \rightskip \@pnumwidth
         \parfillskip -\@pnumwidth
         \interlinepenalty\@M
         {\leavevmode
            \large \bfseries #1\hfil \hb@xt@\@pnumwidth{\hss \l@part@pagenumfont{#2}}}
         \par
         \nobreak
         \global\@nobreaktrue
         \everypar{\global\@nobreakfalse\everypar{}}%
      \endgroup
   \fi}
\newif\if@firstchap
   \@firstchaptrue
\renewcommand*\l@chapter[2]{%
   \if@proposal
      \ifnum \c@tocdepth >\z@
         \addpenalty{-\@highpenalty}%
         \if@firstchap
            \@firstchapfalse
         \else
            \addvspace{\beforechapskip@value}%
         \fi
         \if@times
            \setlength\@tempdima{6.8em}%
         \else
            \setlength\@tempdima{8.3em}%
         \fi
         \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \bfseries
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak\normalfont\normalcolor
            \leaders\hbox{$\m@th
               \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
                mu$}
            \hfill
            \nobreak
            \hb@xt@\@pnumwidth{\hss #2}
            \par
            \penalty\@highpenalty
         \endgroup
      \fi
   \else
      \ifnum \c@tocdepth >\m@ne
         \addpenalty{-\@highpenalty}%
         \if@firstchap
            \@firstchapfalse
         \else
            \addvspace{\beforechapskip@value}%
         \fi
         \if@times
            \setlength\@tempdima{6.8em}%
         \else
            \setlength\@tempdima{8.3em}%
         \fi
         \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \bfseries
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak\normalfont\normalcolor
            \leaders\hbox{$\m@th
               \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
               mu$}
            \hfill
            \nobreak
            \hb@xt@\@pnumwidth{\hss #2}
            \par
            \penalty\@highpenalty
         \endgroup
      \fi
   \fi
}
\if@proposal
   \let\l@section=\l@chapter
   \renewcommand*\l@subsection{%
      \let\currentskip@value=\beforesecskip@value
      \gtece@dottedtocline{2}{2.0em}{2.3em}}
   \renewcommand*\l@subsubsection{%
      \let\currentskip@value=\beforesubsecskip@value
      \gtece@dottedtocline{3}{4.3em}{3.2em}}
   \renewcommand*\l@paragraph{%
      \let\currentskip@value=\beforesubsubsecskip@value
      \gtece@dottedtocline{4}{7.5em}{4.1em}}
   \renewcommand*\l@subparagraph{%
      \let\currentskip@value=\beforeparaskip@value
      \gtece@dottedtocline{5}{10.5em}{5em}}
\else
   \renewcommand*\l@section{%
      \let\currentskip@value=\beforesecskip@value
      \gtece@dottedtocline{1}{2.0em}{2.3em}}
   \renewcommand*\l@subsection{%
      \let\currentskip@value=\beforesubsecskip@value
      \gtece@dottedtocline{2}{4.3em}{3.2em}}
   \renewcommand*\l@subsubsection{%
      \let\currentskip@value=\beforesubsubsecskip@value
      \gtece@dottedtocline{3}{7.5em}{4.1em}}
   \renewcommand*\l@paragraph{%
      \let\currentskip@value=\beforeparaskip@value
      \gtece@dottedtocline{4}{10.5em}{5em}}
   \renewcommand*\l@subparagraph{%
      \let\currentskip@value=\beforesubparaskip@value
      \gtece@dottedtocline{5}{12.5em}{6em}}
\fi %if@proposal
\newcommand*{\gtece@dottedtocline}[5]{%
   \ifnum #1>\c@tocdepth \else
      \vskip \currentskip@value%
      {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
      \parindent #2\relax\@afterindenttrue
      \interlinepenalty\@M
      \leavevmode
      \@tempdima #3\relax
      \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
      {#4}\nobreak
      \leaders\hbox{$\m@th
         \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
         mu$}\hfill
      \nobreak
      \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
      \par}%
   \fi}
\newcommand{\makelistoffigures}{%
   \if@openright\cleardoublepage\else\clearpage\fi
   % must clear page here, so that phantomsection\addcontentsline is on the correct page
   \phantomsection%
   \if@proposal
      \addcontentsline{toc}{section}{%
         \texorpdfstring{\MakeUppercase{\listfigurename}}{\listfigurename}}%
   \else
      \addcontentsline{toc}{chapter}{%
         \texorpdfstring{\MakeUppercase{\listfigurename}}{\listfigurename}}%
   \fi
   \settoheight{\gt@tmpa}{A}
   \set@tocspacing{\gt@tmpa}
   {\@newlinestretch{1.0}
      \listoffigures
   }
   \newpage
}
\newif\if@firstfig
   \@firstfigtrue
\renewcommand*\l@figure{%
  \if@firstfig
     \@firstfigfalse
     \let\currentskip@value=\zeroskip@value
  \else
     \let\currentskip@value=\beforefigskip@value
  \fi
  \gtece@dottedtocline{1}{0em}{4.8em}}%
\newcommand{\makelistoftables}{%
   \if@openright\cleardoublepage\else\clearpage\fi
   % must clear page here, so that phantomsection\addcontentsline is on the correct page
   \phantomsection%
   \if@proposal
      \addcontentsline{toc}{section}{%
         \texorpdfstring{\MakeUppercase{\listtablename}}{\listtablename}}
   \else
      \addcontentsline{toc}{chapter}{%
         \texorpdfstring{\MakeUppercase{\listtablename}}{\listtablename}}
   \fi
   \settoheight{\gt@tmpa}{A}
   \set@tocspacing{\gt@tmpa}
   {\@newlinestretch{1.0}
      \listoftables
   }
   \newpage
}
\newif\if@firsttable
   \@firsttabletrue
\renewcommand*\l@table{%
   \if@firsttable
      \@firsttablefalse
      \let\currentskip@value=\zeroskip@value
   \else
      \let\currentskip@value=\beforetableskip@value
   \fi
   \gtece@dottedtocline{1}{0em}{4.8em}}%
\newcommand{\makelistofsymbols}{}
\renewcommand{\makeglossary}{}
\renewenvironment{abstract}
{
   \typeout{*****************      Abstract     ******************}
   \if@openright\cleardoublepage\else\clearpage\fi
   \phantomsection%
   \if@proposal
      \addcontentsline{toc}{section}{%
         \texorpdfstring{\MakeUppercase{\abstractname}}{\abstractname}}%
      \chapter*{\MakeUppercase{\abstractname}}
   \else
      \addcontentsline{toc}{chapter}{%
         \texorpdfstring{\MakeUppercase{\abstractname}}{\abstractname}}%
      \chapter*{\MakeUppercase{\abstractname}}
   \fi
   %\vskip 0.5in
   \begingroup
      \hspace*{2.5em}
      %% Adjust the line spacing: if it was less than 1 1/2,
      %% increase it to 1 1/2; if it was between 1 1/2 and 2,
      %% increase it to 2; otherwise, leave it as is.
      %\ifdim \baselinestretch pt < 1.25pt \@newlinestretch{1.25}\else
      %\ifdim \baselinestretch pt < 1.66pt \@newlinestretch{1.66}\fi\fi
}
{
   \par\endgroup
}

\newcommand{\dedicationtop}{\vspace*{\stretch{1}}}
\newcommand{\dedicationbottom}{\vspace*{\stretch{1}}}
\newenvironment{dedication}
{
   \typeout{*****************    Dedication    ******************}%
   \if@openright\cleardoublepage\else\clearpage\fi%
   \phantomsection%
   \if@proposal
      \pdfbookmark[1]{Dedication}{dedication}%
   \else
      \pdfbookmark[0]{Dedication}{dedication}%
   \fi%
   \thispagestyle{empty}%
   \begingroup%
   \vspace*{\stretch{1}}%
   \begin{itshape}%
}
{
   \end{itshape}%
   \vspace*{\stretch{1}}%
   \par%
   \endgroup%
}

\newenvironment{epigraph}
{
   \typeout{*****************    Epigraph    ******************}%
   \if@openright\cleardoublepage\else\clearpage\fi%
   \phantomsection%
   \if@proposal
      \pdfbookmark[1]{Epigraph}{epigraph}%
   \else
      \pdfbookmark[0]{Epigraph}{epigraph}%
   \fi%
   \thispagestyle{empty}%
   \begingroup%
   \vspace*{\stretch{1}}%
}
{
   \vspace*{\stretch{1}}%
   \par%
   \endgroup%
}

\newenvironment{acknowledgement}
{
   \typeout{***************** Acknowledgement ******************}
   \if@openright\cleardoublepage\else\clearpage\fi
   \phantomsection%
   \if@proposal
      \addcontentsline{toc}{section}{%
         \texorpdfstring{\MakeUppercase{\thanksname}}{\thanksname}}%
      \chapter*{\MakeUppercase{\thanksname}}
   \else
      \addcontentsline{toc}{chapter}{%
         \texorpdfstring{\MakeUppercase{\thanksname}}{\thanksname}}%
      \chapter*{\MakeUppercase{\thanksname}}
   \fi
   %\vskip 0.5in
   \begingroup
}
{
   \par\endgroup
}

\newenvironment{acknowledgment}
{
   \typeout{***************** Acknowledgment ******************}
   \if@openright\cleardoublepage\else\clearpage\fi
   \phantomsection%
   \if@proposal
      \addcontentsline{toc}{section}{%
         \texorpdfstring{\MakeUppercase{\thanksname}}{\thanksname}}%
      \chapter*{\MakeUppercase{\thanksname}}
   \else
      \addcontentsline{toc}{chapter}{%
         \texorpdfstring{\MakeUppercase{\thanksname}}{\thanksname}}%
      \chapter*{\MakeUppercase{\thanksname}}
   \fi
   %\vskip 0.5in
   \begingroup
}
{
   \par\endgroup
}

\newenvironment{preface}
{
   \typeout{*****************      Preface     ******************}
   \if@openright\cleardoublepage\else\clearpage\fi
   \phantomsection%
   \if@proposal
      \addcontentsline{toc}{section}{%
         \texorpdfstring{\MakeUppercase{Preface}}{Preface}}%
      \chapter*{\MakeUppercase{Preface}}
   \else
      \addcontentsline{toc}{chapter}{%
         \texorpdfstring{\MakeUppercase{Preface}}{Preface}}%
      \chapter*{\MakeUppercase{Preface}}
   \fi
   %\vskip 0.5in
   \begingroup
}
{
   \par\endgroup
}
\newenvironment{Body}{%
   \typeout{******** Body Begins ********}%
   \if@proposal
      \renewcommand{\@chapapp}{\sectionname}
   \else
      \renewcommand{\@chapapp}{\chaptername}
   \fi
   \pagenumbering{arabic}%
   \pagestyle{\body@pagestyle}%
   \settoheight{\gt@tmpa}{1}% This and the next line provide vertical
   \addtolength{\footskip}{0.5\gt@tmpa}% centering of page number in footer.
   \@newlinestretch{\@thesislnsp}%
   \setcounter{chapter}{0}%
   \setcounter{section}{0}%
   \def\thechapter{\@arabic\c@chapter}
   \if@proposal
      \renewcommand{\thesection}{\@arabic\c@section}%
   \else
      \renewcommand{\thesection}{\thechapter.\@arabic\c@section}%
   \fi
}%
{  \if@draft%
   \else%
      \if@twoside%
         \if@openright%
            \cleardoublepage%
         \fi%
      \fi%
   \fi%
   \newpage
   \pagestyle{\body@pagestyle}%
   \typeout{******** Body Ends ********}%
} %end of Body Environment
\ifcontinuouscount
   \counterwithout{figure}{chapter}
   \counterwithout{table}{chapter}
   \counterwithout{equation}{chapter}
\fi
\def\@xfloat #1[#2]{%
   \@nodocument
   \def \@captype {#1}%
   \def \@fps {#2}%
   \@onelevel@sanitize \@fps
   \def \reserved@b {!}%
   \ifx \reserved@b \@fps
      \@fpsadddefault
   \else
      \ifx \@fps \@empty
         \@fpsadddefault
      \fi
   \fi
   \ifhmode
      \@bsphack
      \@floatpenalty -\@Mii
   \else
      \@floatpenalty-\@Miii
   \fi
   \ifinner
      \@parmoderr\@floatpenalty\z@
   \else
      \@next\@currbox\@freelist
      {%
         \@tempcnta \sixt@@n
         \expandafter \@tfor \expandafter \reserved@a
         \expandafter :\expandafter =\@fps
         \do
         {%
            \if \reserved@a h%
               \ifodd \@tempcnta
               \else
                  \advance \@tempcnta \@ne
               \fi
            \fi
            \if \reserved@a t%
               \@setfpsbit \tw@
            \fi
            \if \reserved@a b%
               \@setfpsbit 4%
            \fi
            \if \reserved@a p%
               \@setfpsbit 8%
            \fi
            \if \reserved@a !%
               \ifnum \@tempcnta>15
                  \advance\@tempcnta -\sixt@@n\relax
               \fi
            \fi
         }%
         \@tempcntb \csname ftype@\@captype \endcsname
         \multiply \@tempcntb \@xxxii
         \advance \@tempcnta \@tempcntb
         \global \count\@currbox \@tempcnta
      }%
      \@fltovf
   \fi
   \global \setbox\@currbox
   \color@vbox
   \normalcolor
   \vbox \bgroup
   \@newlinestretch{1.0}
   \hsize\columnwidth
   \@parboxrestore
   \@floatboxreset
}
\long\def\@makecaption#1#2{%
   \vskip\abovecaptionskip
   \footnotesize
   \sbox\@tempboxa{\textbf{#1.\ #2}}%
   \ifdim \wd\@tempboxa >\hsize
      \textbf{#1.\ #2}\par%
   \else
      \global \@minipagefalse
      \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
   \fi
   \vskip\belowcaptionskip%
}
%% Support for multi-volume thesis.
%%
%%   In the premable, set \multivolumetrue and then
%%   use the \part{} command where you want volume 2
%%   to begin, etc.  Do not give names to your volumes (that is,
%%   use ``\part{}'' and not ``\part{Some title}''), because
%%   the Graduate Office Guidelines do not allow separate
%%   titles for each volume.
%%
\renewcommand{\thepart}{\@Roman\c@part}
\newcounter{part@savepagenum}
\newcounter{part@pagenum}
\setcounter{part@pagenum}{-101} % can't have more than 50 parts,
\renewcommand{\part}{%
   \if@openright\cleardoublepage\else\clearpage\fi
   \thispagestyle{empty}%
   \phantomsection%
   \setcounter{part@savepagenum}{\value{page}}
   \setcounter{page}{\value{part@pagenum}}
   \if@twocolumn
      \onecolumn
      \@tempswatrue
   \else
      \@tempswafalse
   \fi
   \secdef\@part\@spart}

\def\@part[#1]#2{%
   \ifnum \c@secnumdepth >-2\relax
      \refstepcounter{part}
      \typeout{\partname\space\thepart.}%
      \addcontentsline{toc}{part}%
         {\texorpdfstring%
           {\noindent\protect\makebox[\@tocrmarg]{}%
           {\protect\makebox[\textwidth - \@tocrmarg - \@tocrmarg]% dadgum \hfill doesn't work without mbox...
           {\hfill\MakeUppercase{\partname}\space\protect{\thepart}\hspace{1em}\MakeUppercase{#1}\hfill}}}%
           {\partname \thepart}}%
   \else
      \addcontentsline{toc}{part}%
         {\texorpdfstring%
         {\MakeUppercase{#1}}%
         {#1}}%
   \fi
   \markboth{}{}
   {\interlinepenalty \@M
      \normalfont
      \ifnum \c@secnumdepth >-2\relax
         \make@parttitle{#1}%
      \else
         \make@parttitle{}%
      \fi}
   \@endpart%
}% end def\@part

\def\@spart#1{%
   {\interlinepenalty \@M
      \normalfont
      \make@parttitle{}%
   }%
   \@endpart
}% end def\@spart

\def\@endpart{%
   \vfill\newpage\addtocounter{part@pagenum}{1}%don't count this page
   \if@twoside
      \if@openright
         \null
         \thispagestyle{empty}%
         \newpage\addtocounter{part@pagenum}{1}%if we need to add another page, don't count it either
      \fi
   \fi
   \if@tempswa
      \twocolumn
   \fi
   \setcounter{page}{\value{part@savepagenum}}
}

\newcommand{\make@parttitle}[1]{%if argument is present, it's the part title
   \begingroup
      \@newlinestretch{1}%
      \phantomsection%
      \title@top
      \vspace*{0.5in}
      \begin{center}
         \begin{doublespaced}{\Large\bfseries%
         \expandafter{\partname\space\thepart}\\
         \ifx\@empty#1\@empty\else%
            \expandafter{#1}\\
         \fi%
         }\end{doublespaced}
         \ \\
         by\\
         \ \\
         {\@author}\\
      \end{center}%
      \vfill
   \endgroup%
}% end of make@parttitle
%%%%%%%%%%%%%%%%%%%%%%% Chapter Headings %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%% The Chapter headings are centered, all caps, arabic numerals.
%%   The OGS doesn't require the actual chapter label to appear at the
%%   beginning of each chapter, but it looks better that way.
%%   Use \chapterlabeltrue or \chapterlabelfalse to turn them on or off.
%%
%%%% The \chaptername and \chapter sectioning commands redefined.
%%   (this code is modified from report.cls, the
%%   standard latex report class.)
%%
\renewcommand{\chapter}{%
   \if@openright\cleardoublepage\else\clearpage\fi
   %\ifnum \value{page} = 1
   %   \thispagestyle{empty}
   %\else
      \thispagestyle{plain}
   %\fi
   \settocdepth{\chapter@tocdepth}   % Reset tocdepth in every chapter
   \global\@topnum\z@
   \@afterindentfalse
   \secdef\@chapter\@schapter   % See @chapter and @schapter for sectioning definition
}

\def\@chapter[#1]#2{%
   \def\my@temp{#1}%
   \ifx\my@temp\empty
      \chapapp@chapter{#2}
   \else
      \chapapp@chapter[#1]{#2}
   \fi
}
\def\@schapter#1{%
   \chapapp@schapter{#1}
}
%%%% Actual implementation details for chapter headings.
%%   (Compare to code in report.cls for \@chapter)
%%
\def\chapapp@chapter[#1]#2{%
   \if@proposal
      \ifnum \c@secnumdepth >\z@
         \refstepcounter{section}%
         \typeout{\@chapapp\space\thesection.}%
         % We have to use chapter for the TOC listing to satisfy the hyperref package,
         % But we still use \section commands, section numbering and everything else
         \addcontentsline{toc}{section}%
            {\texorpdfstring%
               {\protect\numberline{\MakeUppercase{\@chapapp}\space\thesection}\MakeUppercase{#1}}%
         {\@chapapp\space\thesection\space\textemdash\space#1}}%
      \else%
         % We have to use chapter for the TOC listing to satisfy the hyperref package,
         % But we still use \section commands, section numbering and everything else
         \addcontentsline{toc}{section}{\texorpdfstring{\MakeUppercase{#1}}{#1}}%
      \fi
      \sectionmark{#1}
      \if@twocolumn
         \@topnewpage[\@makechapapphead{#2}]%
      \else
         \@makechapapphead{#2}%
         \@afterheading
      \fi
   \else
      \ifnum \c@secnumdepth >\m@ne
         \refstepcounter{chapter}%
         \typeout{\@chapapp\space\thechapter.}%
         \addcontentsline{toc}{chapter}%
            {\texorpdfstring%
               {\protect\numberline{\MakeUppercase{\@chapapp}\space\thechapter}\MakeUppercase{#1}}%
         {\@chapapp\space\thechapter\space\textemdash\space#1}}%
      \else
         \addcontentsline{toc}{chapter}{\texorpdfstring{\MakeUppercase{#1}}{#1}}%
      \fi
      \chaptermark{#1}%
      \if@twocolumn
         \@topnewpage[\@makechapapphead{#2}]%
      \else
         \@makechapapphead{#2}%
         \@afterheading
      \fi
   \fi
}

\def\@makechapapphead#1{%
   \begingroup%
      \parindent \z@ \normalfont%
\@newlinestretch{1}%
      \large \bfseries \centering%
      \if@proposal
         \ifnum \c@secnumdepth >\m@ne%
            \noindent\MakeUppercase{\@chapapp}\space\thesection%
            \par\nobreak%
            \nointerlineskip%
            \vspace{1.0\baselineskip}%
            \nointerlineskip%
         \fi%
      \else
         \ifnum \c@secnumdepth >\m@ne%
            \noindent\MakeUppercase{\@chapapp}\space\thechapter%
            \par\nobreak%
            \nointerlineskip%
            \vspace{1.0\baselineskip}%
            \nointerlineskip%
         \fi%
      \fi
      \interlinepenalty\@M%
      \noindent\MakeUppercase{#1}%
      \par\nobreak%
      \nointerlineskip%
      \if@proposal%
         \vspace{1.5\baselineskip}%
      \else%
         \vspace{2\baselineskip}%
      \fi%
      \nointerlineskip%
   \endgroup
}
%%%% Starred chapter heading macros
%%   (Compare to code in report.cls for \@chapter)
%%
\def\chapapp@schapter#1{%
   \if@twocolumn
      \@topnewpage[\@makeschapapphead{#1}]%
   \else
      \@makeschapapphead{#1}%
      \@afterheading
   \fi}

\def\@makeschapapphead#1{%
   \begingroup%
      \parindent \z@ \normalfont%
      \@newlinestretch{1}
      \interlinepenalty\@M%
      \large \bfseries \centering%
      \noindent\MakeUppercase{#1}%
      \par\nobreak%
      \nointerlineskip%
      \if@proposal%
         \vspace{1.5\baselineskip}%
      \else%
         \vspace{2\baselineskip}%
      \fi%
      \nointerlineskip%
   \endgroup
}
\if@proposal
   \renewcommand{\section}{%
      \vspace{1in}
      \ifnum \value{page} = 1
         \thispagestyle{empty}
      \else
         \thispagestyle{plain}
      \fi
      \settocdepth{\section@tocdepth}   % Reset tocdepth in every section
      \global\@topnum\z@
      \@afterindentfalse
      \secdef\@chapter\@schapter
   }
   \renewcommand{\subsection}{%
      \@startsection{subsection}{2}{\z@}%
      {-1.0\baselineskip \@plus -0.5ex \@minus -.25ex}% \@plus 0.15\baselineskip \@minus 0.075\baselineskip}%
      {0.5ex \@plus.1ex}%
      {\@newlinestretch{1}\normalfont\large\bfseries}}
   \renewcommand{\subsubsection}{%
      \@startsection{subsubsection}{3}{\z@}%
      {-0.70\baselineskip \@plus -0.4ex \@minus -.2ex}% \@plus 0.15\baselineskip \@minus 0.075\baselineskip}%
      {1sp}%
      {\@newlinestretch{1}\normalfont\normalsize\bfseries}}
   \renewcommand{\paragraph}{%
      \@startsection{paragraph}{4}{\parindent}%
      {\z@}
      {-1em}%
      {\@newlinestretch{1}\normalfont\normalsize\bfseries}}
   \renewcommand{\subparagraph}{%
      \@startsection{subparagraph}{5}{\parindent}%
      {\z@}
      {-1em}%
      {\@newlinestretch{1}\normalfont\normalsize\itshape}}
\else
   \renewcommand{\section}{%
      \@startsection{section}{1}{\z@}%
      {-1.0\baselineskip \@plus -0.5ex \@minus -.25ex}% \@plus 0.15\baselineskip \@minus 0.075\baselineskip}%
      {0.5ex \@plus.1ex}%
      {\@newlinestretch{1}\normalfont\large\bfseries}}
   \renewcommand{\subsection}{%
      \@startsection{subsection}{2}{\z@}%
      {-0.85\baselineskip \@plus -0.4ex \@minus -.2ex}% \@plus 0.15\baselineskip \@minus 0.075\baselineskip}%
      {1sp}%
      {\@newlinestretch{1}\normalfont\normalsize\bfseries}}
   \renewcommand{\subsubsection}{%
      \@startsection{subsubsection}{3}{\z@}%
      {-0.70\baselineskip \@plus -0.4ex \@minus -.2ex}% \@plus 0.15\baselineskip \@minus 0.075\baselineskip}%
      {1sp}%
      {\@newlinestretch{1}\normalfont\normalsize\itshape}}
   \renewcommand{\paragraph}{%
      \@startsection{paragraph}{4}{\parindent}%
      {\z@}
      {-1em}%
      {\@newlinestretch{1}\normalfont\normalsize\bfseries}}
   \renewcommand{\subparagraph}{%
      \@startsection{subparagraph}{5}{\parindent}%
      {\z@}
      {-1em}%
      {\@newlinestretch{1}\normalfont\normalsize\itshape}}
\fi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%    EndMatter Environment   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Commands and environments that can (and should only be) used in  %%
%% in the EndMatter section of the document.         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% \begin{EndMatter} sets the pagestyle for the
%% postliminary sections.
%%
%% \end{EndMatter} resets the pagestyle and
%% performs any other cleanup.
%%

\newcommand{\do@indexpage}{}

\newenvironment{EndMatter}%
{%
   \typeout{******** EndMatter Begins ********}%
   \pagestyle{\back@pagestyle}%
   \settoheight{\gt@tmpa}{1}% This and the next line provide vertical
   \addtolength{\footskip}{0.5\gt@tmpa}% centering of page number in footer.
   \@newlinestretch{\@thesislnsp}%
   \setcounter{chapter}{0}%
   \setcounter{section}{0}%
   \renewcommand{\@chapapp}{\appendixname}%
   \if@proposal%
      \renewcommand{\thesection}{\@Alph\c@section}%
   \else%
      \def\thechapter{\@Alph\c@chapter}%
   \fi%
}%
{%
   \pagestyle{\body@pagestyle}%
   \typeout{******** EndMatter Ends ********}%
}%EndMatter
%%%%%%%%%%%%%%%%%%%%%%%% Appendix Headings %%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%% The \appendix sectioning command is redefined.  It essentially
%%   mimics the \chapter command and even uses the same heading
%%   typesetting commands (\@chapter and \@schapter).
%%   (this code is modified from report.cls, the standard latex
%%   report class.)  When a proposal is selected the \appendix command
%%   is equal to (on the same level with) the \section command,
%%   and not the \chapter command.  Therefore the first sectioning level
%%   underneath the appendix section should be the \subsection (only when
%%   proposal option has been selected).
%%
\renewcommand{\appendix}{%
   \if@openright\cleardoublepage\else\clearpage\fi
   \thispagestyle{plain}
   \settocdepth{\appendix@tocdepth}   % Reset tocdepth in every appendix
   \global\@topnum\z@
   \@afterindentfalse
   \secdef\@chapter\@schapter   % See @chapter and @schapter for sectioning definition
}
\newenvironment{vita}{%
   \typeout{*****************        Vita       ******************}
   \@newlinestretch{\@thesislnsp}
   \if@openright\cleardoublepage\else\clearpage\fi
   \phantomsection%
   \if@proposal
      \addcontentsline{toc}{section}{%
         \texorpdfstring{\MakeUppercase{Vita}}{Vita}}
      \chapter*{\MakeUppercase{Vita}}
   \else
      \addcontentsline{toc}{chapter}{%
         \texorpdfstring{\MakeUppercase{Vita}}{Vita}}
      \chapter*{\MakeUppercase{Vita}}
   \fi
   \@mkboth{\scshape\MakeUppercase{Vita}}%
          {\scshape\MakeUppercase{Vita}}%
   \vskip 0.5in
   \begingroup
}
{
   \par\endgroup
}%Vita
\newcommand{\references}{%
   \ifbibpage
      \typeout{*****************     References    ******************}
      \@newlinestretch{1.0}
      \if@openright\cleardoublepage\else\clearpage\fi
      \phantomsection%
      \if@proposal
         \addcontentsline{toc}{section}{%
            \texorpdfstring{\MakeUppercase{\bibname}}{\bibname}}%
      \else
         \addcontentsline{toc}{chapter}{%
            \texorpdfstring{\MakeUppercase{\bibname}}{\bibname}}%
      \fi
      \bibliography{\@bibfiles}
  \fi
}
\renewenvironment{thebibliography}[1]
{ %begin of the \begin{thebibliography}
   \begingroup
      \if@proposal%
         \chapter*{\MakeUppercase{\bibname}}%
      \else%
         \chapter*{\MakeUppercase{\bibname}}%
      \fi%
      \@mkboth{\scshape\MakeUppercase\bibname}%
              {\scshape\MakeUppercase\bibname}%
      \pagestyle{\body@pagestyle}% REFERENCES uses BODY pagestyle, not backmatter.
      \vskip 0.5in%
   \endgroup
   \list{\@biblabel{\@arabic\c@enumiv}}%
   {
      \settowidth\labelwidth{\@biblabel{#1}}%
      \leftmargin\labelwidth%
      \advance\leftmargin\labelsep%
      \@openbib@code%
      \usecounter{enumiv}%
      \let\p@enumiv\@empty%
      \renewcommand\theenumiv{\@arabic\c@enumiv}%
   }
   \sloppy
   \clubpenalty4000
   \@clubpenalty \clubpenalty
   \widowpenalty4000%
   \sfcode`\.\@m
} %end of \begin{thebibliography}
{ %begin of the \end{thebibliography}
   \def\@noitemerr{%
      \@latex@warning{Empty ``thebibliography'' environment}
      \pagestyle{\back@pagestyle}
   }%
   \endlist
} %end of \end{thebibliography}
\raggedbottom%
\setcounter{secnumdepth}{3}%
\setchaptertocdepth{1}%
\setsectiontocdepth{2}%
\if@proposal
   \setappendixtocdepth{2}%
\else
   \setappendixtocdepth{1}%
\fi
\pagestyle{plain}
\setfrontpagestyle{plain}
\setbodypagestyle{plain}
\setendpagestyle{plain}

\AtEndDocument{%
  \immediate\write\@auxout%
  {\string\@writefile{toc}{\string\setcounter{tocdepth}{3}}}
}
\brokenpenalty=10000
\endinput
%%
%% End of file `gt-ece-thesis.cls'.
