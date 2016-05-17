import UIKit

class MoneyInputViewController: UIViewController {
    
    @IBOutlet weak var moneyField: UITextField!
    @IBOutlet weak var memoTextVIew: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 影の濃さを設定する
        memoTextVIew.layer.shadowOpacity = 0.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClickSaveButton(sender: UIButton) {
    }
    
}
