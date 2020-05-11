public class cntr197504 {
    public list<account> accs{get;set;}
    public list<contact> contacts{get;set;}
    public boolean showContacts{get;set;}
    public string accId{get;set;}
    public cntr197504(){
        accs=[select id,name from account limit 20];  
        contacts=new list<contact>();
        showContacts=false;
    }

    public void contactList(){
        contacts=[select id,firstname,lastname from contact where accountId=:accId ];  
        showContacts=contacts.size()>0?true:false;
    }

}