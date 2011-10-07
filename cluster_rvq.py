import subprocess
import math
import time

lst_ds_code=[1]#[1,2,3,4,5,6,7]
str0 = 'qsub cluster.script '
delaysecs=5;


#RVQ
rvq_Q=8
lst_M=[4,14]#[2,4,8,12,16]
tSNR=1000
lmbd=0
lst_tstI=[1,2,3,4]
i=0;
for M in lst_M:
    for tstI in lst_tstI:
        for ds_code in lst_ds_code:
            
            str1 = str0 + '-1    ' #PCA
            str1 = str1 + str(rvq_Q) + ' ' + str(M) + ' ' + str(tSNR) + ' ' + str(lmbd) + ' ' + str(tstI) + '    '  #RVrvq_Q
            str1 = str1 + '-1 -1    ' #TSVrvq_Q
            str1 = str1 + '0 0 1 0    ' #bUseIPCA, bUseBPCA, bUseRVrvq_Q, bUseTSVrvq_Q
            str1 = str1 + str(ds_code) #dataset code
            i=i+1;
            print ('%03d' % i) + '    ' + str1
            subprocess.call(str1, shell=True)
            time.sleep(delaysecs)
