
import Foundation
import UIKit

open class BMonthYearPickerTextField: BTextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    fileprivate var monthYearPicker: UIPickerView!
    fileprivate var years: [Int] = []
    fileprivate let yearsCount = 20
    open var listener : BDatePickerTextFieldProtocol?
    
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        monthYearPicker = UIPickerView()
        monthYearPicker.delegate = self
        monthYearPicker.dataSource = self
        monthYearPicker.showsSelectionIndicator = true
        self.inputView = monthYearPicker

        let currentYear = (Calendar.current as NSCalendar).components(.year, from: Date()).year
        
        for idx in 0...yearsCount {
            years.append(currentYear! + idx - yearsCount / 2)
        }
    }
    
    
    override func setValueFromComponent(_ value: String?) {
        // should not be implemented - text field change event should do nothing, because date picker takes control
    }
    
    
    override func setValueFromModel(_ value: AnyObject?, placeholder: Bool? = false) {
        assert(formatter != nil && formatter is DateFormatter)
        
        if modelBeingUpdated {
            return
        }
        let placeholder = placeholder != nil && placeholder == true
        
        if value is NSDate {
            self.text = (formatter as! DateFormatter).string(from: value as! Date)
            let date = value as! Date
            let cal = Calendar.current
            monthYearPicker.selectRow(cal.dateComponents([.month], from: date).month! - 1, inComponent: 0, animated: true)
            monthYearPicker.selectRow(years.index(of: cal.dateComponents([.year], from: date).year!)!, inComponent: 1, animated: true)
        } else {
            // show placeholder if it is wished, because there is no value
            self.placeholder = placeholder ? (formatter as! DateFormatter).dateFormat : ""
        }
    }
    
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return (formatter as! DateFormatter).monthSymbols.count
        } else if component == 1 {
            return years.count
        }
        return 0
    }
    
    
    open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        if component == 0 {
            label.text = (formatter as! DateFormatter).monthSymbols[row]
        } else if component == 1 {
            label.text = String(years[row])
        }
        label.sizeToFit()
        return label
    }
    
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assert(formatter != nil && formatter is DateFormatter)
        
        // sets value from UIPicker both to entity and text field
        modelBeingUpdated = true;
        
        let cal = Calendar.current
        var dateComp = (cal as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: Date())
        dateComp.year = years[monthYearPicker.selectedRow(inComponent: 1)]
        dateComp.month = monthYearPicker.selectedRow(inComponent: 0) + 1
        dateComp.day = 1
        dateComp.hour = 0
        dateComp.minute = 0
        dateComp.second = 0
        let selectedDate = cal.date(from: dateComp)!
        
        self.object.setValue(selectedDate, forKeyPath: self.keyPath)
        self.text = (formatter as! DateFormatter).string(from: selectedDate)
        modelBeingUpdated = false
        
        listener?.dateChanged()
    }
    
    
    open func setYearRange(_ begin: Int, end: Int) {
        years.removeAll(keepingCapacity: true)
        var year = begin
        while(year <= end) {
            years.append(year)
            year += 1
        }
    }
    
}

