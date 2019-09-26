//
//  BaseTextViewWithDate.swift
//  Profile
//
//  Created by Milan Katiyar on 23/07/19.
//  Copyright © 2019 learning. All rights reserved.

import Foundation
import UIKit
import JTAppleCalendar

protocol BaseDateViewDelegate: class {
    
    func UpdateDateBaseText(view: BaseTextViewWithDate,text: String,select_date: Date)
}

public class BaseTextViewWithDate : UIView {
    var viewVC: UIViewController!
    var selecteddate: Date!
     var requestDate_start: Date?
    @IBOutlet weak var sView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var generic_textField: UITextField!
    weak var Delegate:BaseDateViewDelegate!
    @IBOutlet weak var attachBtn: UIButton!
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    func initializeView(){
        let podBundle = Bundle(for: BaseTextViewWithDate.self)
        let nib = UINib(nibName: "BaseTextViewWithDate", bundle: podBundle)
        mainView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.addSubview(mainView)
        mainView.frame = bounds
        mainView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        let picker : UIDatePicker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.backgroundColor = .white
        picker.addTarget(self, action: #selector(dueDateChanged), for: .valueChanged)
        generic_textField.inputView = picker
        generic_textField.delegate = self
        sView.layer.borderColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1).cgColor
        sView.layer.borderWidth = 1
        let image1 = UIImage(named: "acount_calendar")
        
        self.attachBtn.setImage(image1, for: .selected)
        self.attachBtn.setImage(image1, for: .normal)
        self.attachBtn.setImage(image1, for: .highlighted)
        
    }
    public func updateVC(vc: UIViewController) {
        self.viewVC = vc
    }
    @IBAction func calendarClicked(_ sender: Any) {
        let podBundle = Bundle(for: ProfileCalender.self)
        let story = UIStoryboard(name: "Main", bundle: podBundle)
        
        let vc = story.instantiateViewController(withIdentifier: "ProfileCalender") as! ProfileCalender
        
        vc.delegateDateUpdate = self
        vc.startDateTtl = "one"
        if selecteddate == nil {
            vc.selectedDate = Date()
        }
        else {
            vc.selectedDate = self.selecteddate
            
        }
        if requestDate_start != nil {
             vc.requestDate_start = self.requestDate_start
        }
      //  vc.requestDate_start = Date()
        viewVC.present(vc, animated: true, completion: nil)
        // viewVC.navigationController?.pushViewController(vc, animated: true)
        // presentVC(vc: vc)
        // generic_textField.becomeFirstResponder()
    }
    @objc func dueDateChanged(sender: UIDatePicker){
        
        generic_textField.text = DateUtil.convertDateToString(date: sender.date, reqFormat: DateUtil.AMADEUS_DATE)
        
    }
}
extension BaseTextViewWithDate : UITextFieldDelegate ,CalenderSelectDelegate {
    func updateCalenderSelectionDate(date_sel: Date, date_type: String) {
        let txt = DateUtil.convertDateToString(date: date_sel, reqFormat: DateUtil.AMADEUS_DATE)
        Delegate.UpdateDateBaseText(view: self, text: txt, select_date: date_sel)
      //  Delegate.UpdateDateBaseText(view: self, text: txt)
        self.generic_textField.text = txt
        
        //        selecteddate = date_sel;
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "dd MMM yyyy"
        //        dropDateTxt.text = dateFormatter.string(from: date_sel)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count ?? 0 < 1 {
            let txt = DateUtil.convertDateToString(date: Date(), reqFormat: DateUtil.AMADEUS_DATE)
            Delegate.UpdateDateBaseText(view: self, text: txt, select_date: Date())
         //   Delegate.UpdateDateBaseText(view: self, text: txt)
            self.generic_textField.text = txt
        }
        else {
            Delegate.UpdateDateBaseText(view: self, text: textField.text ?? "no text", select_date: Date())
           // Delegate.UpdateDateBaseText(view: self, text: textField.text ?? "no text")
        }
    }
}


