
Proc sort data=dp.model_base;by customer_id;run;

data dp.train dp.test;
set dp.model_base;
by customer_id;
if first.customer_id then do;
if ranuni(12345) < 0.7 then destination = 'train';
else destination = 'test';
retain destination;
end;
if destination = 'train' then output dp.train;
else output dp.test;
drop destination;
run;


ods graphics on;
proc logistic data=dp.train descending  outmodel=dp.model_rule ;
class ICICI_CREDIT_FLAG(ref="0") 
ICICI_DEBIT_FLAG(ref="0")
spends_GROCERY_dob_low(ref="0")  spends_GROCERY_dob_High(ref="0")
spends_ICICI_mob_low(ref="0") 
Weekend_OB_High(ref="0")

/param=glm;
model BMS_flag =
Trnx_online_AFFILIATE
spends_GROCERY_dob_High spends_GROCERY_dob_low
spends_Apparel_dob
ICICI_CREDIT_FLAG
spends_ICICI_mob_low
ICICI_DEBIT_FLAG
Weekend_OB_High
Days_on_Book
;
score data=dp.train out=dp.train_final_scores_output ;
roc;roccontrast;
run;


/*KS CALCULATION*/

proc rank data=dp.train_final_scores_output out=test_train descending ties=high groups=10; 
var p_1;
ranks r_score;
run;


Proc summary data= test_train missing nway n mean;
class  
r_score;
var  p_1;
output out=train_summary(drop=_:)    
max(p_1)        =    max_prob 
min(p_1)        =    min_prob
mean(p_1)       =    mean_prob 
n(r_score)   =    count_rscore
sum(BMS_flag)= actual
median(p_1)=pred;
run;




proc logistic inmodel=fd.model_bf;
score data=fd.test
out=val_data;
run;

data test_val;
set val_data;
if 0.592955107<=P_1<0.9815787772 then grp=1;
if 0.3882541732<=P_1<0.5926617506 then grp=2;
if 0.2394707136<=P_1<0.3879427298 then grp=3;
if 0.1258449177<=P_1<0.2392379388 then grp=4;
if 0.0985443643<=P_1<0.1257665872 then grp=5;
if 0.0576560334<=P_1<0.0981978676 then grp=6;
if 0.0561267128<=P_1<0.0566927391 then grp=7;
if 0.0436387855<=P_1<0.0555420005 then grp=8;
if 0.0264376234<=P_1<0.0435117765 then grp=9;
if 0.0028709929<=P_1<0.026371042 then grp=10;
run;

Proc summary data= test_val missing nway n mean;
class grp;
var  p_1;
output out=val_summary(drop=_:)    
max(p_1)        =    max_prob 
min(p_1)        =    min_prob
mean(p_1)       =    mean_prob 
n(grp)   =    count_rscore
sum(churn)= actual
median(p_1)=pred;
run;

proc sql;select sum(count_rscore),sum(actual) into :pop_tot,:resp_tot from val_summary; quit;

proc sql;
create table val_summary_1 as
select 
grp as Decile,
count_rscore as Population,
actual as Responders,
actual/count_rscore as Response_Rate format percent.,
actual/&resp_tot as Responder_Dist format percent.,
count_rscore/&pop_tot as Pop format percent.
from val_summary;
quit;

data val_summary_2;
set val_summary_1;
Cum_RR+Responder_Dist ;
Cum_Pop+Pop ;
KS=Cum_RR-Cum_Pop ;
format cum_RR cum_pop ks percent.;
run;


