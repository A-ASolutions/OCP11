/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-27-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global with  sharing class accountTaskReminderScheduler implements Schedulable{
 
    global void execute(SchedulableContext sc) {

        accountTasksReminderBatch batch = new accountTasksReminderBatch();
        
        Database.executeBatch(batch);
        

    }
}
