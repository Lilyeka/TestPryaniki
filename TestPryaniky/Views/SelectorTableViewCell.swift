//
//  SelectorTableViewCell.swift
//  TestPryaniky
//
//  Created by Лилия Левина on 16.07.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//

import UIKit

protocol SelectorTableViewCellDelegate {
    func pickerDidSelect(item: Variant)
}

class SelectorTableViewCell: UITableViewCell {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    var delegate: SelectorTableViewCellDelegate?
    
    var dataModel: SelectorData?
    
    var textField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return textField
    }()
    
    var pickerView: UIPickerView = {
        var pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    // MARK: - Init
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    func configureSubViews(dataModel: SelectorData) {
        self.dataModel = dataModel
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(dataModel.selectedId, inComponent: 0, animated: true)
        
        self.contentView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15.0).isActive = true
        textField.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15.0).isActive = true
        textField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -15.0).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15.0).isActive = true
        
        textField.text = dataModel.variants[dataModel.selectedId].text
        textField.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
    
    
    @objc func donePicker(_ sender: UIBarButtonItem) {
        textField.text = dataModel?.variants[pickerView.selectedRow(inComponent: 0)].text
        self.contentView.endEditing(true)
    }
    
    @objc func cancelPicker(_ sender: UIBarButtonItem) {
        self.contentView.endEditing(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension SelectorTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataModel!.variants.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataModel!.variants[row].text
    }
}

extension SelectorTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(type(of: dataModel!.variants[row]))
        
        textField.text = dataModel!.variants[row].text
        delegate?.pickerDidSelect(item: dataModel!.variants[row])
    }
}

