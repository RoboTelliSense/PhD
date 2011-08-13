clear;
clc;
close all;

cfn_csv             =   'test.csv';

f1                  =   230;
struct1.data(1)     =   123;
struct1.data(2)     =   8901;
struct1.data(3)     =   123434.4545;
struct1.data(4)     =   233656.4545;
struct1.data(5)     =   233565.456545;
struct1.data(6)     =   2312121213.4545655;

f2                  =   231;
struct2.data(1)     =   124545453.4567;
struct2.data(2)     =   844901.2345;
struct2.data(3)     =   1234.4545;
struct2.data(4)     =   236.4545;
struct2.data(5)     =   233563435.456545;
struct2.data(6)     =   231212123313.4545655;


UTIL_savecsv_struct(cfn_csv, f1, struct1);
UTIL_savecsv_struct(cfn_csv, f2, struct2);