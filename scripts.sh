








/cd++ -mmodel1_3_0_0_4.ma -eevents.ev -Dtesting.txt -oout.out -l > mylog

/cd++ -mmodel1_3_0_0_4.ma -eevents.ev -Dtesting.txt -oout.out -F -l > mylog




perl  rtgen1/rtgenerator1.pl model1_3_0_0_4.ma 3 0 0 4; echo model1_3_0_0_4.ma,3,0,0,4,>>results.txt; ../cd++ -mmodel1_3_0_0_4.ma -eevents.ev -t00:01:00:00 2>>results.txt -oout.out -l >mylog




../cd++ -mmodel3.ma -e10events.ev -oout.hie -l > mylog.hie

../cd++ -mmodel3.ma -e10events.ev -oout.fla -F -l > mylog.fla





perl  rtgen3/rtgenerator3.pl models/model3_10_0_0_10.ma 10 0 0 10



../cd++ -mmodels/model3_10_0_0_10.ma -e10events.ev -oout.hie -l > mylog.hie


../cd++ -mmodels/model3_10_0_0_10.ma -e10events.ev -oout.fla -F -l > mylog.fla