//  BitcoinTicker


import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
   
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["GBP","EUR","USD"]
    let currencySym = [ "£","€", "$"]
  
    var currencySelect = ""
    var finalURL = ""
   
   
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        
    }

    
   
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
  
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return  currencyArray[row]
    }
    
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        currencySelect = currencySym[row]
        getbitcoinPrice(url: finalURL)
    }

    
    //MARK: - Networking
 
    func getbitcoinPrice(url: String ) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess!")
                    let bitcoinPriceJSON : JSON = JSON(response.result.value!)

                    self.updatebitcoinPrice(json: bitcoinPriceJSON)

                }
                
                else {
            
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
 //MARK: - JSON Parsing

    func updatebitcoinPrice(json : JSON) {
        
        if let bitcoinPriceResult = json["ask"].double {
            bitcoinPriceLabel.text = "\(currencySelect)\(bitcoinPriceResult)"
        }
   
        else {
            bitcoinPriceLabel.text = "Price Error"
        }
        
        
    }
    


}

