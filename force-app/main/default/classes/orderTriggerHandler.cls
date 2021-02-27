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
public with sharing class orderTriggerHandler {


    public static void deactivateAccountsWithoutOrders(List<Order> orders) {
        
        List<Account> accountstoDeactivate = new List<Account>();
        Set<Id> accountsWithOrderDeleted = new Set<Id>();
        Set<Id> accountswithOrdersRemaining = new Set<Id>();

        // Adding the order's accountId to a set
        for(Order o: orders){
        if (String.isNotBlank(o.accountId)){
            accountsWithOrderDeleted.add(o.accountId);

          }

        }

        // Query Accounts and orders 

        List<Account> accountsWithOrders = [SELECT Id, Active__c FROM Account WHERE Id IN :accountsWithOrderDeleted];
        List<Order> ordersAccounts = [SELECT Id, AccountId  FROM Order WHERE AccountId IN :accountsWithOrderDeleted];

        // Add the order Account Id to a set

        for (Order o : ordersAccounts){
            accountswithOrdersRemaining.add(o.AccountId);
        }
        // if the account id is not in the set of the accounts with remaining orders then deactivate the account

        for (Account a : accountsWithOrders){
            if (!accountswithOrdersRemaining.contains(a.Id)){
            account.Active__c = false;
            accountstoDeactivate.add(a);
            }
        }
        update(accountstoDeactivate);


    }
}
