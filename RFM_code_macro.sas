
data flags_6; 
set dp.base_1;
run;
/**/


%macro rfm(base_data,unique_id,final_data,ranked_data);

%macro hh(name);

data fft_&name.;
set &base_data.;
if &name. eq . then rank_d=9999;
run;

proc rank data=fft_&name.(where=(&name. <> .)) out=ffd_&name. groups=10 ties=mean;
var &name.;
ranks rank_&name.;
run;

data ff_&name.;
set  ffd_&name.
fft_&name.(where=(rank_d=9999));
rank_&name.=rank_&name.+1;
if rank_d=9999 then rank_&name.=0;
run;

proc freq data=ff_&name.; tables  rank_&name.; run;
%mend;




%macro hh1(name);

data fft_&name.;
set &base_data.;
if &name. eq . then rank_d=9999;
run;

proc rank data=fft_&name.(where=(&name. <> .) ) out=ffd_&name. descending groups=10 ties=mean;
var &name.;
ranks rank_&name.;
run;

data ff_&name.;
set  ffd_&name.
fft_&name.(where=(rank_d=9999));
rank_&name.=rank_&name.+1;
if rank_d=9999 then rank_&name.=0;
run;

proc freq data=ff_&name.; tables  rank_&name.; run;

%mend;

proc contents data=&base_data. out=qq varnum; run;

data _null_;
set qq(where=(upcase(name) not like '%RECENCY%' and name not="&unique_id."));
call execute(cats('%hh(',name,');'));
run;

data _null_;
set qq(where=(upcase(name) like '%RECENCY%' and name not="&unique_id."));
call execute(cats('%hh1(',name,');'));
run;


proc sort data=&base_data.; by &unique_id.; run;

%macro sorting(name);
proc sort data=ff_&name.(keep=&unique_id. rank_&name.); by &unique_id.; run;
%mend;

data _null_;
set qq(where=(name not="&unique_id."));
call execute(cats('%sorting(',name,');'));
run;

data pp; set qq; new_name=cats("ff_",name); where name not = "&unique_id.";run;
proc sql; select new_name into :var separated by '   ' from pp; quit;


data &final_data.;
merge
&base_data.
&var;
by &unique_id.;
run;


data &final_data.;
set &final_data.;
total_score=sum(of rank_:);
run;

proc rank data=&final_data. out=&ranked_data. descending groups=10;
var total_score;
ranks ranking;
run;

proc freq data=&ranked_data.; tables ranking/list missing; run;

proc means data=&ranked_data. StackODSOutput 
n min mean max; 
class ranking;
var total_score;
ods output summary=LongPctls;
run;

%mend;


/*base file should only have customer id or member id and variables divided into 2 parts: recency and non recency variables*/
/*id whether customer id or member id*/
/*final base name*/
/*ranked base name*/

%rfm(flags_6,member_id,dp.base_2,dp.Rank_base);

