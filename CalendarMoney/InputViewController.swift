//
// InputViewController.swift
//

import UIKit

class InputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var inputTableView: UITableView!
    
    // セクションに表示するタイトル
    private let sectionTitle = ["日付情報", "カテゴリ選択", "収支入力"]
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewのみ選択不可に(Cell上のtextView/textFIeldは選択可)
        inputTableView.allowsSelection = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // セクション0には日付情報を表示
            return 1
        } else if section == 1 {
            
            return 1
        } else if section == 2{
            // セクション2には金額欄とメモ欄を表示
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 1 {
            return 110
        } else if indexPath.section == 1 {
            return 110
        } else {
            return 50
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) 
        
        let moneyInputTextField = UITextField(frame: CGRectMake(0,0,200,30))
        
        let memoTextView = UITextView(frame: CGRectMake(0, 0, 200, 100))
        
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
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            
            let tmpDate = formatter.dateFromString(appDelegate.selectedDate!)!
            formatter.dateFormat = "yyyy年 MM月 dd日"
            cell.textLabel?.text = formatter.stringFromDate(tmpDate)
            
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "入力："
                // セルの右側にtextFieldを設置
                cell.accessoryView = moneyInputTextField
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "メモ："
                cell.accessoryView = memoTextView
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
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
