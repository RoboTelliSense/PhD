import subprocess
import math

lst_ds_code=[2]
str0 = 'qsub cluster.script '

#RVQ
Q=8
lst_M=[2,4,8,12,16]
tSNR=1000
lmbd=0
lst_tstI=[1,2,3,4]


i=0;
for M in lst_M:
    for tstI in lst_tstI:
        for ds_code in lst_ds_code:
            
            str1 = str0 + '-1    ' #PCA
            str1 = str1 + str(Q) + ' ' + str(M) + ' ' + str(tSNR) + ' ' + str(lmbd) + ' ' + str(tstI) + '    '  #RVQ
            str1 = str1 + '-1 -1    ' #TSVQ
            str1 = str1 + '0 0 1 0    ' #bUseIPCA, bUseBPCA, bUseRVQ, bUseTSVQ
            str1 = str1 + str(ds_code) #dataset code
            i=i+1;
            print ('%03d' % i) + '    ' + str1
            subprocess.call(str1, shell=True)
            

#BPCA
#----
print ('%03d' % 21) + '    ' + str0 + ' 4    -1,-1,-1,-1,-1,     -1,-1,   0,1,0,0   ' + str(ds_code)
subprocess.call(str1, shell=True)

print ('%03d' % 22) + '    ' + str0 + ' 8    -1,-1,-1,-1,-1,     -1,-1,   0,1,0,0   ' + str(ds_code)
subprocess.call(str1, shell=True)

print ('%03d' % 23) + '    ' + str0 + ' 16    -1,-1,-1,-1,-1,     -1,-1,   0,1,0,0   ' + str(ds_code)
subprocess.call(str1, shell=True)


      


#TSVQ
#----
print ('%03d' % 24) + '    ' + str0 + ' -1    -1,-1,-1,-1,-1,     3,2,   0,0,0,1   ' + str(ds_code)
subprocess.call(str1, shell=True)

print ('%03d' % 25) + '    ' + str0 + ' -1    -1,-1,-1,-1,-1,     4,2,   0,0,0,1   ' + str(ds_code)
subprocess.call(str1, shell=True)

print ('%03d' % 26) + '    ' + str0 + ' -1    -1,-1,-1,-1,-1,     5,2,   0,0,0,1   ' + str(ds_code)
subprocess.call(str1, shell=True)  



#IPCA
#----
print ('%03d' % 27) + '    ' + str0 + ' 4    -1,-1,-1,-1,-1,     -1,-1,   1,0,0,0   ' + str(ds_code)
subprocess.call(str1, shell=True)

print ('%03d' % 28) + '    ' + str0 + ' 8    -1,-1,-1,-1,-1,     -1,-1,   1,0,0,0   ' + str(ds_code)
subprocess.call(str1, shell=True)

print ('%03d' % 29) + '    ' + str0 + ' 16    -1,-1,-1,-1,-1,     -1,-1,   1,0,0,0   ' + str(ds_code)
subprocess.call(str1, shell=True)
