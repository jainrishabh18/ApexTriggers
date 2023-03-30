trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete) { //NOPMD
    
    switch on Trigger.OperationType {
        when BEFORE_INSERT {
            CaseTriggerHandler.beforeInsert(Trigger.new);
        }
        
        when AFTER_INSERT {
            CaseTriggerHandler.AfterInsert(Trigger.new);
        }

        when BEFORE_UPDATE {
            CaseTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }

        when AFTER_UPDATE {
            CaseTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        
        when BEFORE_DELETE {
            CaseTriggerHandler.beforeDelete(Trigger.old);
        }
        
        when AFTER_DELETE {
            CaseTriggerHandler.afterDelete(Trigger.old);
        }
    }
}