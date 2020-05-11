/**
 * Used to call from the process builder whether the trigger creteria is working or not.
 */
public class ExchangeProcessBuilderTemp {
    
    @InvocableMethod(label='Exchange Rate Call Process' description='Exchange Rate Call Process')
    public static void processOrder () {
     
        System.debug('My God I am being Triggered from Process Builder');
    }
  
     
}