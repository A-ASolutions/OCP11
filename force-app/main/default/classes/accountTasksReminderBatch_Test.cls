/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-03-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   03-01-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public with sharing class accountTasksReminderBatch_Test {
    @TestSetup
    static void makeData(){

        List<Account> accounts = new List<Account>();

        //create 100 accounts

        for ( Integer i = 0; i < 100; i++ ){
            accounts.add(new Account (Name = 'batchAccount'+ i));

        }
        insert accounts; 
    }

    // create  tasks for 100 accounts

    @isTest
    static void createTasksFor100Accouts_Test(){
        Test.startTest();
        SchedulableContext sc = null;
        accountTaskReminderScheduler scheduler = new accountTaskReminderScheduler();
        scheduler.execute(sc);
        Test.stopTest();
        List<Account> accountsAfter = [SELECT Id FROM Account WHERE Name LIKE 'batchAccount%'];
        Set<Id> accountsId = new Set<Id>();

        for ( Account a : accountsAfter){
            accountsId.add(a.Id);
        }
        List<Task> tasksCreated = [SELECT Id FROM Task WHERE WhatId IN :accountsId];
        System.assertEquals(100, tasksCreated.size());

        
    
    }

    // create 20 tasks for 20 accounts while 80 accounts have tasks already

    @isTest
    static void create20TasksOutof100accounts_test(){
        List<Account> accounts = [SELECT Id FROM Account WHERE Name LIKE 'batchAccount%'];
        Set<Id> accountsId = new Set<Id>();

        for(Account a : accounts){
            accountsId.add(a.Id);
        }
        List<Task> exisitingTasks = new List<Task>();
        for( Integer i = 0; i < 80; i++) {
            Task createTasks = new Task(WhatId = accounts[i].Id,
                                       Subject = 'Call',
                                       Priority = 'Normal',
                                       IsReminderSet = true, 
                                       ReminderDateTime = DateTime.valueOfGMT(String.valueOf(DateTime.now())) + 5);
        
        exisitingTasks.add(createTasks);
             
        }
        insert(exisitingTasks);

        
        List<Task> existingTasksbeforeBatch = [SELECT Id FROM Task WHERE WhatId IN :accountsId];

        Test.startTest();

        SchedulableContext sc = null;
        accountTaskReminderScheduler scheduler = new accountTaskReminderScheduler();
        scheduler.execute(sc);
        Test.stopTest();

        List<Task> totalOfTasks = [ SELECT Id  FROM Task WHERE WhatId IN :accountsId];
        System.assertEquals(100, totalOfTasks.size());


   }


}
