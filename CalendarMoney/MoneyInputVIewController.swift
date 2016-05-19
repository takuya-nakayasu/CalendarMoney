import UIKit

class MoneyInputViewController: UIViewController {
    
    @IBOutlet weak var moneyField: UITextField!
    @IBOutlet weak var memoTextVIew: UITextView!
    
    var repo: Repository! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 影の濃さを設定する
        memoTextVIew.layer.shadowOpacity = 0.5
        
        repo = Repository()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClickSaveButton(sender: UIButton) {
        
        // Spendの既存ID最大値を取得
        let maxId = repo.findMaxIdInSpend()
        
        let spend = Spend()
        
        // 既存データのID最大値+1
        spend.id = maxId + 1
        
        spend.spendMoney = Int(moneyField.text!)!
        
        spend.memo = memoTextVIew.text!
        
        repo.saveSpend(spend)
        
        performSegueWithIdentifier("toCalendarView", sender: nil)
    }
    
}
