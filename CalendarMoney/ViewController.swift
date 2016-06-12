import UIKit

extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
    
    class func WhiteGray() -> UIColor {
        return UIColor(red: 231.0 / 255, green: 232.0 / 255, blue: 226.0 / 255, alpha: 1.0)
    }
    
    class func lightGray() -> UIColor {
        return UIColor(red: 140.0 / 255, green: 140.0 / 255, blue: 140.0 / 255, alpha: 1.0)
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let dateManager = DateManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = NSDate()
    var today = NSDate()
    let weekArray = ["日", "月", "火", "水", "木", "金", "土"]
    var calendarLabels: [String] = []
    
    var spendMoneys: [Int] = []
    
    var appDelegate: AppDelegate!
    
    let repo = Repository()
    // 月の支出額合計
    var sum = 0
    
    // 前月ボタン
    @IBOutlet weak var headerPrevBtn: UIButton!
    // 次月ボタン
    @IBOutlet weak var headerNextBtn: UIButton!
    // YYYY年M月
    @IBOutlet weak var headerTitle: UILabel!
    // ヘッダー
    @IBOutlet weak var calenderHeaderView: UIView!
    // カレンダー
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    // 金額合計ラベル
    @IBOutlet weak var sumMonthLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        
        // カレンダー背景色
        calenderCollectionView.backgroundColor = UIColor.whiteColor()
        
        // カレンダーのヘッダにM/yyyy(今月)を代入
        headerTitle.text = changeHeaderTitle(selectedDate)
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // 今月の合計金額を算出する
        spendMoneys = []
        sum = sumSpendMoneyInMonth(today)
        sumMonthLabel.text = "-\(sum)円"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CollectionViewのSection数を返す(セクション０：曜日　セクション１：日付)
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // CollectionViewのCell件数を設定
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの桁数を変える
        if section == 0 {
            return 7 // 曜日を表示するセクションだから7
        } else {
            dateManager.daysAcquisition()
            dateManager.dateForCellAtIndexPath()
            return dateManager.numberOfItems
        }
    }
    
    // Cellが表示されるときに呼ばれる、1個のセルを描画する際に呼び出される
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CalendarCell
        
        //セル背景色
        cell.backgroundColor = UIColor.whiteColor()
        
        // Cellのテキストカラー
        // 日曜は赤
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.lightRed()
        // 土曜は青
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.lightBlue()
        } else {
            cell.textLabel.textColor = UIColor.grayColor()
        }
        // テキスト配置
        if indexPath.section == 0 {
            // 曜日を配置
            cell.textLabel.text = weekArray[indexPath.row]
            
            //曜日をタップしたときの背景色(セルと同じ色)
            cell.selectedBackgroundView = dateManager.cellSelectedBackgroundView(UIColor.whiteColor())
            
            //曜日枠線
            dateManager.border(cell, borderWidth: 1.0, borderColor: UIColor.whiteColor().CGColor)
            
            // 曜日はタッチできないようにする
            cell.userInteractionEnabled = false
        } else {
            // indexを日付に変換して代入
            cell.textLabel.text = dateManager.conversionDateFormat(indexPath)
            
            //indexPathをyyyy-MM-ddへ変換
            let yyyyMMddIndexPath = dateManager.nsIndexPathformatYYYYMMDD(indexPath)
            
            //今日の年月日をyyyy-MM-ddへ変換
            let yyyyMMddToday = dateManager.formatYYYYMMDD(today)
            
            //表示月をMMへ変換
            let mmSelectedDate = dateManager.formatMM(selectedDate)
            
            //indexPathをMMへ変換
            let mmIndexPath = dateManager.nsIndexPathformatMM(indexPath)
            
            if (yyyyMMddIndexPath == yyyyMMddToday) {
                
                //今日の枠線
                dateManager.border(cell, borderWidth: 2.0, borderColor: UIColor.greenColor().CGColor)
                
                // 今日の日付をappDelegateに渡す
                appDelegate.selectedDate = "\(cell.textLabel.text!)/\(headerTitle.text!)"
                
            } else {
                
                //今日以外の枠線
                dateManager.border(cell, borderWidth: 1.0, borderColor: UIColor.whiteColor().CGColor)
            }
            
            
            //前月・次月日付背景色を設定
            if (((mmSelectedDate - 1) == mmIndexPath) ||
                ((mmSelectedDate + 1) == mmIndexPath) ||
                (mmSelectedDate == 12 && mmIndexPath == 1) ||
                (mmSelectedDate == 1 && mmIndexPath == 12)) {
                
                if (yyyyMMddIndexPath == yyyyMMddToday) {
                    
                    //枠線をクリア
                    dateManager.border(cell, borderWidth: 1.0, borderColor: UIColor.whiteColor().CGColor)
                }
                
                // 表示している月以外の日付の背景をグレーにする
                cell.backgroundColor = UIColor.WhiteGray()
                
                // 表示している月以外の日付はタッチできないようにする
                cell.userInteractionEnabled = false
                
            }
            
            //日付をタップしたときの背景色
            cell.selectedBackgroundView = dateManager.cellSelectedBackgroundView(UIColor.lightGrayColor())
            
            calendarLabels.append(cell.textLabel.text!)
        }
        
        return cell
    }
    
    // セルのサイズを設定
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        let height: CGFloat = width * 1.0
        return CGSizeMake(width, height)
    }
    
    // セルの垂直方向のマージンを設定
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    // セルの水平方向のマージンを設定
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellMargin
    }
    
    /**
     年と月をM/yyyyの形式で返す
     
     - parameter date: 本日の日付
     
     - returns: M/yyyy
    */
    func changeHeaderTitle(date: NSDate) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "M/yyyy"
        let selectMonth = formatter.stringFromDate(date)
        return selectMonth
    }
    
    // 前月ボタンタップ時
    @IBAction func tappedHeaderPrevBtn(sender: UIButton) {
        selectedDate = dateManager.prevMonth(selectedDate)
        print("selectedDate:\(selectedDate)")
        sum = sumSpendMoneyInMonth(selectedDate)
        sumMonthLabel.text = "-\(sum)円"
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
        calendarLabels = []
    }
    
    // 次月ボタンタップ時
    @IBAction func tappedHeaderNextBtn(sender: UIButton) {
        selectedDate = dateManager.nextMonth(selectedDate)
        print("selectedDate:\(selectedDate)")
        sum = sumSpendMoneyInMonth(selectedDate)
        sumMonthLabel.text = "-\(sum)円"
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
        calendarLabels = []
    }
    
    // セルをタップしたら呼び出し
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("touch2:\(indexPath.row)")
        print("touch:\(calendarLabels[indexPath.row])/\(headerTitle.text!)")
        appDelegate.selectedDate = "\(calendarLabels[indexPath.row])/\(headerTitle.text!)"
    }
    
    @IBAction func headerSegmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tappedPrevButton()
        case 1:
            tappedNextBtn()
        default:
            print("SegmentedControlChangedError")
        }
    }
    @IBAction func swipedRight(sender: UISwipeGestureRecognizer) {
        tappedPrevButton()
    }
    
    @IBAction func swipedLeft(sender: UISwipeGestureRecognizer) {
        tappedNextBtn()
    }
    
    func tappedNextBtn() {
        selectedDate = dateManager.nextMonth(selectedDate)
        print("selectedDate:\(selectedDate)")
        sum = sumSpendMoneyInMonth(selectedDate)
        sumMonthLabel.text = "-\(sum)円"
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
        calendarLabels = []
    }
    
    func tappedPrevButton() {
        selectedDate = dateManager.prevMonth(selectedDate)
        print("selectedDate:\(selectedDate)")
        sum = sumSpendMoneyInMonth(selectedDate)
        sumMonthLabel.text = "-\(sum)円"
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
        calendarLabels = []
    }
    
    /// 今月の支出金額を集計する
    func sumSpendMoneyInMonth(day: NSDate) -> Int {
        
        let spends = repo.findSpendList()
        spendMoneys = []
        
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        
        var equalYear = true
        var equalMonth = true
        print("day:\(day)")
        for spend in spends {
            
            // 今年の支出の場合はtrue
            equalYear = calendar.isDate(spend.spendDate, equalToDate:  day, toUnitGranularity: .NSYearCalendarUnit)
            
            // 今月の支出の場合はtrue
            equalMonth = calendar.isDate(spend.spendDate, equalToDate: day, toUnitGranularity: .NSMonthCalendarUnit)
            
            // 今月分の支出のみ集計
            if equalYear && equalMonth {
                spendMoneys.append(spend.spendMoney)
            }
        }
        // 消費金額の合計を返却
        return spendMoneys.reduce(0, combine: { $0 + $1 })
    }
}

