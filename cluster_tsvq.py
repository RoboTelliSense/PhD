import subprocess
import math
import time

lst_ds_code=[1]#[1,2,3,4,5,6,7]
str0 = 'qsub cluster.script '
delaysecs=5;



###TSVQ
lst_tsvq_Q=[3,4,5]
i=0;
for tsvq_Q in lst_tsvq_Q:
    for ds_code in lst_ds_code:
        
        str1 = str0 + '-1    ' #PCA
        str1 = str1 + '-1 -1 -1 -1 -1'  + '    '  #RVQ
        str1 = str1 + str(tsvq_Q) + ' 2      '    #TSVQ
        str1 = str1 + '0 0 0 1    ' #bUseIPCA, bUseBPCA, bUseRVQ, bUseTSVQ
        str1 = str1 + str(ds_code) #dataset code
        i=i+1;
        print ('%03d' % i) + '    ' + str1
        subprocess.call(str1, shell=True)
        time.sleep(delaysecs)
