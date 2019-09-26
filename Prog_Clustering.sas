
/***************************CLUSTERING START****************************/

%let vars=
Age Freq_Girls Freq_Women Freq_Boys Freq_Infant_Kids Freq_Kitchen_HomeApp Freq_Men
QTY_Girls QTY_Women QTY_Boys QTY_Infant_Kids QTY_Kitchen_HomeApp QTY_Men
ATS_Girls ATS_Women ATS_Boys ATS_Infant_Kids ATS_Kitchen_HomeApp ATS_Men
;


proc fastclus data=dp.stdize_base_final out=cluster maxclusters=5  converge=0 cluster=clus_5 maxiter=100; var &vars.; run;
proc freq data=cluster; table clus_5;run;


data dp.result_1;
set cluster;
where clus_5 in(1,2,5);
run;

/*cluster 1=Sinlge Men, cluster 2,5=Couple with Kids*/

data dp.result_1(keep=clus_5 Cluster_Name member_id) ;
Length Cluster_Name $70.;
set dp.result_1;
if clus_5 in(2,5) then Cluster_Name="Couple with Kids";
if clus_5 in(1) then Cluster_Name="Single Men";
run;


/**************************************End****************************/


/*2 iteration for cluster */

data dp.next_base;
set cluster(drop=distance  clus_5);
where clus_5 in(4,3);
run;
/*has 12038318 observations and 23*/


%let vars=
Age Freq_Girls Freq_Women Freq_Boys Freq_Infant_Kids Freq_Kitchen_HomeApp Freq_Men
QTY_Girls QTY_Women QTY_Boys QTY_Infant_Kids QTY_Kitchen_HomeApp QTY_Men
ATS_Girls ATS_Women ATS_Boys ATS_Infant_Kids ATS_Kitchen_HomeApp ATS_Men
;


proc fastclus data=dp.next_base out=cluster maxclusters=5  converge=0 cluster=clus_5 maxiter=100; var &vars.; run;
proc freq data=cluster; table clus_5;run;



data dp.result_2;
set cluster;
where clus_5 in(1,2,3);
run;

/*cluster 1,3=couple without kids, cluster 2=Couple With Kids*/


data dp.result_2(keep=clus_5 Cluster_Name member_id) ;
Length Cluster_Name $70.;
set dp.result_2;
if clus_5 in(2) then Cluster_Name="Couple with Kids";
if clus_5 in(1,3) then Cluster_Name="Couple without Kids";
run;


/****************************END********************/

/*3 iteration for cluster */

data dp.next_base_1(DROP=distance clus_5);
set cluster;
where clus_5 in(4,5);
run;


%let vars=
Age Freq_Girls Freq_Women Freq_Boys Freq_Infant_Kids Freq_Kitchen_HomeApp Freq_Men
QTY_Girls QTY_Women QTY_Boys QTY_Infant_Kids QTY_Kitchen_HomeApp QTY_Men
ATS_Girls ATS_Women ATS_Boys ATS_Infant_Kids ATS_Kitchen_HomeApp ATS_Men
;

proc fastclus data=dp.next_base_1 out=cluster maxclusters=5  converge=0 cluster=clus_5 maxiter=100; var &vars.; run;
proc freq data=cluster; table clus_5;run;


data dp.result_3;
set cluster;
where clus_5 in(1,4,3);
run;

/*cluster 1,3=Single men, cluster 4=Single women*/


data dp.result_3(keep=clus_5 Cluster_Name member_id) ;
Length Cluster_Name $70.;
set dp.result_3;
if clus_5 in(4) then Cluster_Name="Single Women";
if clus_5 in(1,3) then Cluster_Name="Single Men";
run;

/****************end****************/


/*4 iteration for cluster */

data dp.next_base_2(drop=distance clus_5);
set cluster;
where clus_5 in(2,5);
run;

%let vars=
Age Freq_Girls Freq_Women Freq_Boys Freq_Infant_Kids Freq_Kitchen_HomeApp Freq_Men
QTY_Girls QTY_Women QTY_Boys QTY_Infant_Kids QTY_Kitchen_HomeApp QTY_Men
ATS_Girls ATS_Women ATS_Boys ATS_Infant_Kids ATS_Kitchen_HomeApp ATS_Men
;

proc fastclus data=dp.next_base_2 out=cluster maxclusters=5  converge=0 cluster=clus_5 maxiter=100; var &vars.; run;
proc freq data=cluster; table clus_5;run;

data dp.result_4;
set cluster;
where clus_5 in(2,5);
run;

/*cluster 2=Single men, cluster 5=Single women*/

data dp.result_4(keep=clus_5 Cluster_Name member_id) ;
Length Cluster_Name $70.;
set dp.result_4;
if clus_5 in(5) then Cluster_Name="Single Women";
if clus_5 in(2) then Cluster_Name="Single Men";
run;


/*5 iteration for cluster */

data dp.next_base_3(drop=distance clus_5);
set cluster;
where clus_5 in(1,3,4);
run;


  
%let vars=
Age Freq_Girls Freq_Women Freq_Boys Freq_Infant_Kids Freq_Kitchen_HomeApp Freq_Men
QTY_Girls QTY_Women QTY_Boys QTY_Infant_Kids QTY_Kitchen_HomeApp QTY_Men
ATS_Girls ATS_Women ATS_Boys ATS_Infant_Kids ATS_Kitchen_HomeApp ATS_Men
;

proc fastclus data=dp.next_base_3 out=cluster maxclusters=5  converge=0 cluster=clus_5 maxiter=100; var &vars.; run;
proc freq data=cluster; table clus_5;run;

data dp.result_5;
set cluster;
where clus_5 in(2,4);
run;

/*2=single men,4=couple with kids*/

data dp.result_5(keep=clus_5 Cluster_Name member_id) ;
Length Cluster_Name $70.;
set dp.result_5;
if clus_5 in(4) then Cluster_Name="Couple with Kids";
if clus_5 in(2) then Cluster_Name="Single Men";
run;



/*************END***************************/



/*6 iteration for cluster */

data dp.next_base_4(drop=distance clus_5);
set cluster;
where clus_5 in(1,3,5);
run;

%let vars=
Age Freq_Girls Freq_Women Freq_Boys Freq_Infant_Kids Freq_Kitchen_HomeApp Freq_Men
QTY_Girls QTY_Women QTY_Boys QTY_Infant_Kids QTY_Kitchen_HomeApp QTY_Men
ATS_Girls ATS_Women ATS_Boys ATS_Infant_Kids ATS_Kitchen_HomeApp ATS_Men
;

proc fastclus data=dp.next_base_4 out=cluster maxclusters=5  converge=0 cluster=clus_5 maxiter=100; var &vars.; run;
proc freq data=cluster; table clus_5;run;


data dp.result_6;
set cluster;
where clus_5 in(1,2,3);
run;

/*1=Couple with Kids,2=Single Women,3=Single Men*/

data dp.result_6(keep=clus_5 Cluster_Name member_id) ;
Length Cluster_Name $70.;
set dp.result_6;
if clus_5 in(1) then Cluster_Name="Couple with Kids";
if clus_5 in(2) then Cluster_Name="Single Women";
if clus_5 in(3) then Cluster_Name="Single Men";
run;


/********************END*********************/



/*7 iteration for cluster */

data dp.next_base_5(drop=distance clus_5);
set cluster;
where clus_5 in(4,5);
run;

%let vars=
Age Freq_Girls Freq_Women Freq_Boys Freq_Infant_Kids Freq_Kitchen_HomeApp Freq_Men
QTY_Girls QTY_Women QTY_Boys QTY_Infant_Kids QTY_Kitchen_HomeApp QTY_Men
ATS_Girls ATS_Women ATS_Boys ATS_Infant_Kids ATS_Kitchen_HomeApp ATS_Men
;

proc fastclus data=dp.next_base_5 out=cluster maxclusters=5  converge=0 cluster=clus_5 maxiter=100; var &vars.; run;
proc freq data=cluster; table clus_5;run;



data dp.result_7;
set cluster;
where clus_5 in(3,4);
run;

/*3,4=Single Men*/

data dp.result_7(keep=clus_5 Cluster_Name member_id) ;
Length Cluster_Name $70.;
set dp.result_7;
if clus_5 in(3,4) then Cluster_Name="Single Men";
run;


/*******************End*********/


/*8 iteration for cluster */

data dp.next_base_6(drop=distance clus_5);
set cluster;
where clus_5 in(1,2,5);
run;



%let vars=
Age Freq_Girls Freq_Women Freq_Boys Freq_Infant_Kids Freq_Kitchen_HomeApp Freq_Men
QTY_Girls QTY_Women QTY_Boys QTY_Infant_Kids QTY_Kitchen_HomeApp QTY_Men
ATS_Girls ATS_Women ATS_Boys ATS_Infant_Kids ATS_Kitchen_HomeApp ATS_Men
;

proc fastclus data=dp.next_base_6 out=cluster maxclusters=5  converge=0 cluster=clus_5 maxiter=100; var &vars.; run;
proc freq data=clu ster; table clus_5;run;

/*all cluster couple with Kids*/

data dp.result_8(keep=clus_5 Cluster_Name member_id) ;
Length Cluster_Name $70.;
set cluster;
Cluster_Name="Couple with Kids";
run;



/*Combined cluster result */

data dp.final_cluster_result;
set dp.result_1 dp.result_2 dp.result_3
    dp.result_4 dp.result_5 dp.result_6
	dp.result_7 dp.result_8;
run;

data dp.final_cluster_result;
set dp.final_cluster_result(drop=clus_5);
run;

proc freq data=dp.final_cluster_result;table Cluster_Name/list missing;run;

libname ci "/sasdata3/ci/ci_lib";

data ci.final_cluster_result;
set dp.final_cluster_result;
run;

data tt;
set dp.final_cluster_result;
where member_id=84747883;
run;
