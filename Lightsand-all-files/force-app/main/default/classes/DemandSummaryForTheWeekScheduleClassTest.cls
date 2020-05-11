@isTest
public class DemandSummaryForTheWeekScheduleClassTest
{
    static testMethod void DemandSummaryWeekScheduledTest(){
      DemandSummaryForTheWeekScheduleClass demandscheduled = new  DemandSummaryForTheWeekScheduleClass();
        SchedulableContext ctx;
        demandscheduled.execute(ctx);
    }
}