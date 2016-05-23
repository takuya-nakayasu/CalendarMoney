import UIKit

class MoneyInputViewController: UIViewController {
    
    @IBOutlet weak var moneyField: UITextField!
    @IBOutlet weak var memoTextVIew: UITextView!
    @IBOutlet weak var selectDateLabel: UILabel!
    
    var repo: Repository! = nil
    
    var appDelegate: AppDelegate!
    
    var formatter: NSDateFormatter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 影の濃さを設定する
        memoTextVIew.layer.shadowOpacity = 0.5
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        var tmpDate = formatter.dateFromString(appDelegate.selectedDate!)!
        formatter.dateFormat = "yyyy/MM/dd"
        selectDateLabel.text = formatter.stringFromDate(tmpDate)
        
        repo = Repository()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClickSaveButton(sender: UIButton) {
        
        // Spendの既存ID最大値を取得
        let maxId = repo.findMaxIdInSpend()
        
        let spend = Spend()
        
        formatter.dateFormat = "dd/MM/yyyy"
        
        // 既存データのID最大値+1
        spend.id = maxId + 1
        
        spend.spendMoney = Int(moneyField.text!)!
        
        spend.memo = memoTextVIew.text!
        
        spend.spendDate = formatter.dateFromString(appDelegate.selectedDate!)!
        
        repo.saveSpend(spend)
        
        performSegueWithIdentifier("toCalendarView", sender: nil)
    }
    
}
