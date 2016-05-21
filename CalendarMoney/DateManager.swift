import UIKit

extension NSDate {
    /**
     一月前の日付を返す
    */
    func monthAgoDate() -> NSDate {
        let addValue = -1 // 一つ前の月を表示したいので「-1」
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }

    /**
     一月後の日付を返す
     */
    func monthLaterDate() -> NSDate {
        let addValue: Int = 1
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addValue
        return calendar.dateByAddingComponents(dateComponents, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
}


class DateManager: NSObject {
    
    var currentMonthOfDates = [NSDate]() // 表記する月の配列
    var selectedDate = NSDate()
    let daysPerWeek: Int = 7
    var numberOfItems: Int!
    
    // 月ごとのセルの数を返すメソッド
    func daysAcquisition() -> Int {
        let rangeOfWeeks = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.WeekOfMonth, inUnit: NSCalendarUnit.Month, forDate: firstDateOfMonth())
        let numberOfWeeks = rangeOfWeeks.length // 月が持つ週の数
        numberOfItems = numberOfWeeks * daysPerWeek // 週の数*列の数
        return numberOfItems
    }
    
    // 月の初日を取得
    func firstDateOfMonth() -> NSDate {
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day],
                                                                 fromDate: selectedDate)
        components.day = 1
        let firstDateMonth = NSCalendar.currentCalendar().dateFromComponents(components)
        return firstDateMonth!
    }
    
    // 表記する日にちの取得
    func dateForCellAtIndexPath(numberOfItems: Int) {
        // ①「月の初日が週の何日目か」を計算する
        let ordinalityOfFirstDay = NSCalendar.currentCalendar().ordinalityOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.WeekOfMonth, forDate: firstDateOfMonth())
        for var i = 0; i < numberOfItems; i++ {
            // ②「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
            let dateComponents = NSDateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            // ③表示する月の初日から②で計算した差を引いた日付を取得
            let date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: firstDateOfMonth(), options: NSCalendarOptions(rawValue: 0))!
            // ④配列に追加
            currentMonthOfDates.append(date)
        }
    }
    
    /**
     CellのindexPathを日付に変換
     
     - parameter indexPath: Cellのインデックス
     
     -returns: 日付
    */
    func conversionDateFormat(indexPath: NSIndexPath) -> String {
        dateForCellAtIndexPath(numberOfItems)
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "d"
        return formatter.stringFromDate(currentMonthOfDates[indexPath.row])
    }
    
    // 前月の表示
    func prevMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthAgoDate()
        return selectedDate
    }
    
    // 次月の表示
    func nextMonth(date: NSDate) -> NSDate {
        currentMonthOfDates = []
        selectedDate = date.monthLaterDate()
        return selectedDate
    }
    
    //セル背景色
    func cellSelectedBackgroundView(color: UIColor) -> UIView {
        let cellSelectedBackgroundView = UIView()
        cellSelectedBackgroundView.backgroundColor = color
        return cellSelectedBackgroundView
    }
    
    //今日の枠線表示の比較用年月日
    func nsIndexPathformatYYYYMMDD(indexPath: NSIndexPath) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(currentMonthOfDates[indexPath.row] as! NSDate)
    }
    
    //yyyyMMdd変換
    func formatYYYYMMDD(date: NSDate) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let yyyyMMdd = formatter.stringFromDate(date)
        return yyyyMMdd
    }
    
    //MM変換
    func formatMM(date: NSDate) -> Int {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MM"
        let mm = formatter.stringFromDate(date)
        return Int(mm)!
    }
    
    //今月以外の日付背景をグレーにするための比較用月
    func nsIndexPathformatMM(indexPath: NSIndexPath) -> Int {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MM"
        return Int(formatter.stringFromDate(currentMonthOfDates[indexPath.row] as! NSDate))!
    }
    
    //枠線
    func border(cell: AnyObject, borderWidth: CGFloat, borderColor: CGColor){
        cell.layer.borderWidth = borderWidth
        cell.layer.borderColor = borderColor
    }
    
    
}
