//
// InputViewController.swift
//

import UIKit

class InputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var inputTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    
    // セクションに表示するタイトル
    private let sectionTitle = ["日付情報", "収支入力"]
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let formatter = NSDateFormatter()
    
    let moneyInputTextField = UITextField(frame: CGRectMake(0,0,200,30))
    
    let memoTextView = UITextView(frame: CGRectMake(0, 0, 200, 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewのみ選択不可に(Cell上のtextView/textFIeldは選択可)
        inputTableView.allowsSelection = false
        
        headerTitle.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        
        //headerView.layer.borderColor = UIColor.blackColor().CGColor
        //headerView.layer.borderWidth = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // セクション0には日付情報を表示
            return 1
        } else if section == 1 {
            // セクション2には金額欄とメモ欄を表示
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            return 110
        } else {
            return 50
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
        // キーボードを数字のみにする
        moneyInputTextField.keyboardType = .NumberPad
        
        // 中央寄せ
        moneyInputTextField.textAlignment = .Center
        
        // 線をつけないと透明で見れない
        moneyInputTextField.layer.borderWidth = 1
        
        // 線をつけないと透明で見れない
        memoTextView.layer.borderWidth = 1
        
        // フォントの設定をする
        memoTextView.font = UIFont.systemFontOfSize(CGFloat(15))
        
        moneyInputTextField.placeholder = "金額入力"
        
        if indexPath.section == 0 {
            
            formatter.dateFormat = "dd/MM/yyyy"
            
            let tmpDate = formatter.dateFromString(appDelegate.selectedDate!)!
            formatter.dateFormat = "yyyy年 MM月 dd日"
            cell.textLabel?.text = formatter.stringFromDate(tmpDate)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "入力："
                // セルの右側にtextFieldを設置
                cell.accessoryView = moneyInputTextField
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "メモ："
                cell.accessoryView = memoTextView
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
        }
        
        return cell
    }
    
    // セクションの数を返す
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    // セクションのタイトルを返す
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    @IBAction func onClickSaveButton(sender: AnyObject) {
        
        let repo = Repository()
        
        // Spendの既存ID最大値を取得
        let maxId = repo.findMaxIdInSpend()
        
        let spend = Spend()
        
        formatter.dateFormat = "dd/MM/yyyy"
        
        // 既存データのID最大値+1
        spend.id = maxId + 1
        
        spend.spendMoney = Int(moneyInputTextField.text!)!
        
        spend.memo = memoTextView.text!
        
        spend.spendDate = formatter.dateFromString(appDelegate.selectedDate!)!
        
        repo.saveSpend(spend)
        
        performSegueWithIdentifier("InputToTab", sender: nil)
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
