#http://commandline.org.uk/forum/topic/419/

import paramiko
import os

#parameters
dir_in_prefix = '/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/'
dir_in_list = ['results_summary_1_Dudek/', 'results_summary_2_davidin300/',
          'results_summary_3_sylv/', 'results_summary_4_trellis70/', 'results_summary_5_fish/',
          'results_summary_6_car4/', 'results_summary_7_car11/']
fn_in_list = ['results_1_Dudek.mp4', 'results_2_davidin300.mp4', 'results_3_sylv.mp4', 'results_4_trellis70.mp4',
         'results_5_fish.mp4', 'results_6_car4.mp4', 'results_7_car11.mp4']

#constants
dir_tmp = 'c:\\salman\\work\\writing\\results\\'    #local destination
dir_out = '/home/webpages/msalman/results/'         #remote destination

j=0;
for i in dir_in_list:
    j
    dir_in = dir_in_prefix + i
    fn_in = fn_in_list[j];
    
    #dependent parameters
    fn_tmp = fn_in
    fn_out = fn_in

    cfn_in = dir_in + fn_in
    cfn_tmp = dir_tmp + fn_tmp
    cfn_out = dir_out + fn_out

    #connect to source host
    paramiko.util.log_to_file('/tmp/xbeowulf.log')
    src_host = "xbeowulf1.ece.gatech.edu"
    src_port = 22
    src_transport = paramiko.Transport((src_host, src_port))
    src_password = "2illusion"
    src_username = "gtg629v"
    src_transport.connect(username = src_username, password = src_password)
    src_sftp = paramiko.SFTPClient.from_transport (src_transport)
    print("connected to remote source, initiating transfer ...")

    #transfer: remote source -> local
    src_sftp.get(cfn_in,cfn_tmp)
    src_sftp.close()
    src_transport.close()
    print("file transferred to local machine")


    j=j+1
