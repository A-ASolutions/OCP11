/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-01-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   03-01-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public with sharing class OrderTriggerHandler_Test {
    @TestSetup
    static void makeData(){
        // create two account one with one order and the 2nd with more than one

        Account accOneOrder = new Account (Name ='WithOneOrder' );
        Account accMoreOrders = new Account (Name ='WithMoreOrders' );

        insert new Account[]{accOneOrder, accMoreOrders};

        // create contracts for the accounts
        Contract contr1 = new Contract ( AccountId = accOneOrder.Id,
                                         ContractTer= 4, 
                                         StartDate = date.today(), 
                                         Status = 'Draft');

        Contract contr2 = new Contract ( AccountId = accMoreOrders.Id,
                                         ContractTer= 6, 
                                         StartDate = date.today(), 
                                         Status = 'Draft');

    insert new Contract[]{contr1, contr2};

    contr1.Status = 'Activated';
    contr2.Status = 'Activated';

    update contr1;
    update contr2;

// insert orders
    Order orderWithone = new Order( AccountId = accOneOrder.Id, Status = 'Draft', EffectiveDate = data.today());
    Order orderWithmore1 = new Order( AccountId = accMoreOrders.Id, Status = 'Draft', EffectiveDate = data.today());
    Order orderWithmore2 = new Order( AccountId = accMoreOrders.Id, Status = 'Draft', EffectiveDate = data.today());

    insert new Order[]{orderWithone, orderWithmore1, orderWithmore2};


       
    }


// Test account with one order

@isTest
static void deleteOrderFromOneOrderAcc(){
    Account acc = [SELECT Id, Active__c  FROM Account WHERE Name = 'WithOneOrder'];
    Test.startTest();
    Order o = [SELECT Id FROM Order WHERE AccountId =: acc.Id];
    delete(o);
    Account accAfter = [SELECT Id, Active__c  FROM Account WHERE Name = 'WithOneOrder'];
    Test.stopTest();
    System.assertEquals(False, accAfter.Active__c);

}

// Test account with more orders by deleting one order

@isTest
static void deleteOrderFromMoreOrdersAccount(){
    Account acc = [SELECT Id, Active__c  FROM Account WHERE Name = 'WithMoreOrders'];
    Test.startTest();
    List<Order> o = [SELECT Id FROM Order WHERE AccountId =: acc.Id];
    delete(o.get(0));
    Account accAfter = [SELECT Id, Active__c  FROM Account WHERE Name = 'WithMoreOrders'];
    Test.stopTest();
    System.assertEquals(True, accAfter.Active__c);

}

// Test account with more orders by deleting all orders
@isTest
static void deleteAllOrdersFromMoreOrdersAccount(){
    Account acc = [SELECT Id, Active__c  FROM Account WHERE Name = 'WithMoreOrders'];
    Test.startTest();
    List<Order> o = [SELECT Id FROM Order WHERE AccountId =: acc.Id];
    delete(o);
    Account accAfter = [SELECT Id, Active__c  FROM Account WHERE Name = 'WithMoreOrders'];
    Test.stopTest();
    System.assertEquals(False, accAfter.Active__c);

}
}