trigger EmployeeTrigger on Employee__c (before insert, before delete, before update, after delete, after update, after insert) {    //NOPMD
	switch on Trigger.OperationType{
        when BEFORE_INSERT{
            EmployeeTriggerHandler.beforeInsert(trigger.new);
        }
        
        when BEFORE_UPDATE{
			// EmployeeTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);
        }
        
        when BEFORE_DELETE{
            // EmployeeTriggerHandler.beforeDelete(trigger.old);
        }
        
        when AFTER_INSERT{
            EmployeeTriggerHandler.afterInsert(Trigger.new);
        }
        
        when AFTER_UPDATE{
            // EmployeeTriggerHandler.afterUpdate(trigger.new, trigger.oldMap);
        }
        
        when AFTER_DELETE{
        	    EmployeeTriggerHandler.afterDelete(trigger.old, trigger.oldMap);
        }
    }
}