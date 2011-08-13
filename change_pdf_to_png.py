import subprocess
import os

txt_gs = 'gswin32c -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -r150 -sOutputFile='
txt_ffmpeg = 'ffmpeg -r 5 -i inputImages_%04d.png -vcodec mpeg4 -qscale 1 out.mp4'
out_dir = 'C:\\salman\\portable\\RVQ_xplatform1\\results_1___Dudek___________Nw_10000_w_0_Np_0600__iPCA_016__bPCA_016__RVQ__08_02_1000__TSVQ_03\\'

for file in os.listdir(out_dir):
    #print file
    basename, extension = os.path.splitext(file)
    if (extension == '.pdf'):
        infile  = out_dir + file
        outfile = out_dir + basename + '.png'
        cmd = txt_gs + outfile + ' ' + infile
        print cmd
        subprocess.call(cmd, shell=True)

#subprocess.call()        
