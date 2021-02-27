/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-27-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-27-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
global with sharing class acountTasksReminderBatch implements Database.Batchable<sObject> {
    global acountTasksReminderBatch() {

    }
// Query accounts without orders
    global Database.QueryLocator start (Database.BatchableContext info){

        return Database.getQueryLocator('SELECT Id FROM Account WHERE Id NOT IN (SELECT Id FROM Order)');
        }

        global void execute( Database.BatchableContext info, List<Account> scope){
            List<Task> tasks = [SELECT Id, WhatId  FROM Task WHERE Subject= 'Call'];
            List<Task> reminderTasksToCreate = new List<Task>();
            Set<Id> accountsWithTasksReminders = new Set<Id>();
            
            // add Account Ids with reminder tasks to a set

            for( Task reminderTask : tasks){
                accountsWithTasksReminders.add(reminderTask.WhatId);
            }

            for(Account accountToCheck : scope){
                if (!accountsWithTasksReminders.Contains(accountToCheck.Id)){
                Task reminderTask = new Task( WhatId = accountToCheck.Id, 
                                              Subject = 'Call',
                                              Status = 'Not Started', 
                                              Priority = 'Normal',
                                              IsReminderSet = true, 
                                              ReminderDateTime = DateTime.valueOfGMT(String.valueOf(DateTime.now())) + 5);
        
                reminderTasksToCreate.add(reminderTask);
                }
            }
            if (!reminderTasksToCreate.isEmpty()){
                insert(reminderTasksToCreate);
            }
           

        }
        global void finish(Database.BatchableContext info){

        }
    }