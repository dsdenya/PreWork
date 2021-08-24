//
//  SettingsViewController.swift
//  Framework
//
//  Created by Aloha on 8/23/21.
//

import UIKit

class SettingsViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    //UI- Weak Var for Default Tip Label and Default Tip Segmented Control
    @IBOutlet weak var Default_Tip_Label: UILabel!
    @IBOutlet weak var DefaultTipButton: UISegmentedControl!
    
    //UI Weak Var for Default Currency Label and Default Currency Pin Wheel.
    @IBOutlet weak var Default_Currency_Label: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //Mark- Properties
    var currencyCode: [String] = []
    var values: [Double] = []
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        

        // Do any additional setup after loading the view.
        
        fetchJSON()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCode[row]
    }
    
   //Place Holder
    
    func fetchJSON(){
        guard let url = URL(string: "https://open.er-api.com/v6/latest/USD")
        else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            //Error
            if error != nil{
                print(error!)
                return
            }
            //Unwraps data
            guard let safeData = data else {return}
            
            //decodes JSON data
            do {
                let results = try JSONDecoder().decode(CurrencyRates.self, from: safeData)
                //print(results.rates)
                self.currencyCode.append(contentsOf: results.rates.keys)
                self.values.append(contentsOf: results.rates.values)
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
            } catch {
                print (error)
            }
        }.resume()
    }
}
   



