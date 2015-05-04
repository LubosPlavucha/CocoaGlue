
import Foundation
import UIKit

public class BMonthYearPickerTextField: BTextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    private var monthYearPicker: UIPickerView!
    private var years: [Int] = []
    public var listener : BDatePickerTextFieldProtocol?
    
    
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
        monthYearPicker = UIPickerView()
        monthYearPicker.delegate = self
        monthYearPicker.dataSource = self
        monthYearPicker.showsSelectionIndicator = true
        self.inputView = monthYearPicker

        let currentYear = NSCalendar.currentCalendar().components(.YearCalendarUnit, fromDate: NSDate()).year
        
        for var a = 0; a < 100; a++ {
            years.append(currentYear + a - 10)
        }
    }
    
    
    override func setValueFromComponent(value: String?) {
        // should not be implemented - text field change event should do nothing, because date picker takes control
    }
    
    
    override func setValueFromModel(value: AnyObject?, placeholder: Bool? = false) {
        assert(formatter != nil && formatter is NSDateFormatter)
        
        if modelBeingUpdated {
            return
        }
        let placeholder = placeholder != nil && placeholder == true
        
        if value is NSDate {
            self.text = (formatter as! NSDateFormatter).stringFromDate(value as! NSDate)
            let date = value as! NSDate
            let cal = NSCalendar.currentCalendar()
            monthYearPicker.selectRow(cal.components(.CalendarUnitMonth, fromDate: date).month - 1, inComponent: 0, animated: true)
            monthYearPicker.selectRow(find(years, cal.components(.CalendarUnitYear, fromDate: date).year)!, inComponent: 1, animated: true)
        } else {
            // show placeholder if it is wished, because there is no value
            self.placeholder = placeholder ? (formatter as! NSDateFormatter).dateFormat : ""
        }
    }
    
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return (formatter as! NSDateFormatter).monthSymbols.count
        } else if component == 1 {
            return years.count
        }
        return 0
    }
    
    
    public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var label = UILabel()
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.blackColor()
        label.font = UIFont.boldSystemFontOfSize(14)
        if component == 0 {
            label.text = (formatter as! NSDateFormatter).monthSymbols[row] as? String
        } else if component == 1 {
            label.text = String(years[row])
        }
        label.sizeToFit()
        return label
    }
    
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assert(formatter != nil && formatter is NSDateFormatter)
        
        // sets value from UIPicker both to entity and text field
        modelBeingUpdated = true;
        
        let cal = NSCalendar.currentCalendar()
        var dateComp = cal.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: NSDate())
        dateComp.year = years[monthYearPicker.selectedRowInComponent(1)]
        dateComp.month = monthYearPicker.selectedRowInComponent(0) + 1
        dateComp.day = 1
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        let selectedDate = cal.dateFromComponents(dateComp)!
        
        self.object.setValue(selectedDate, forKeyPath: self.keyPath)
        self.text = (formatter as! NSDateFormatter).stringFromDate(selectedDate)
        modelBeingUpdated = false
        
        listener?.dateChanged()
    }
}

