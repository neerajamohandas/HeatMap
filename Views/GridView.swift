//
//  GridView.swift
//  HeatMap
//
//  Created by Anand on 03/08/21.
//

import UIKit

protocol gridViewDelegate {
    
}

class GridView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var view_container: UIView!
    @IBOutlet var collection_view_data: UICollectionView!
    var view_add : UIView!
    let cell_identifier = "GridCVCell"
    var delegate: gridViewDelegate!
    var dictionary_response = NSDictionary()
    var all_data: [Symbol_category] = []
    var array_sorted: [Symbol_category] = []
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    private func nibSetup(){
        
        view_add = loadViewFromNib_()
        view_add.frame = bounds
        view_add.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view_add.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view_add)
        
        //fetch data
        self.fetchData_fromAPI()
        
        // register custom cv cell and load it
        collection_view_data.register(UINib(nibName: "GridCVCell", bundle: nil), forCellWithReuseIdentifier: cell_identifier)
        collection_view_data.delegate = self
        collection_view_data.dataSource = self
    
    }
    
    private func loadViewFromNib_() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }

    
    
    //MARK: collection view functions
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 5
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_sorted.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 50, height: 50)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collection_view_data.dequeueReusableCell(withReuseIdentifier: cell_identifier, for: indexPath) as! GridCVCell
        let symbol: Symbol_category = array_sorted[indexPath.item]
        cell.lbl_symbol_name.text = symbol.symbol
        cell.lbl_price_change.text = symbol.price_change_percentage
        
        return cell
    }

    
    //MARK: Call API and get data
    
    func fetchData_fromAPI(){
        
        let url_string = "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/synopsis.json"
        
        URLSession.shared.dataTask(with: URL(string: url_string)!) { (data, response, err) in
            
            print("API called..")
            
            if let responseData = data {
                do{
                    self.dictionary_response = try JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) as! NSDictionary
                    self.getData_fromResponse(response: self.dictionary_response)
                }catch{
                    print("No data found.")
                }
            }
            
            
        }.resume()
    }
    
    func getData_fromResponse(response: NSDictionary){
        
        var string_Long_data = ""
        var string_short_data = ""
        var string_short_covering_data = ""
        var string_Long_unwinding_data = ""
        
        var array_long = [String]()
        var array_short = [String]()
        var array_long_unwinding = [String]()
        var array_short_covering = [String]()
        
        for (key,value) in response {
            
            let keyString = key as! String
            if (keyString == "l") {
                string_Long_data = value as! String
                array_long = string_Long_data.components(separatedBy: ";")
            }else if (keyString == "lu") {
                string_Long_unwinding_data = value as! String
                array_long_unwinding = string_Long_unwinding_data.components(separatedBy: ";")
            }else if (keyString == "s") {
                string_short_data = value as! String
                array_short = string_short_data.components(separatedBy: ";")
            }else if (keyString == "sc") {
                string_short_covering_data = value as! String
                array_short_covering = string_short_covering_data.components(separatedBy: ";")
            }
        }
        
        let array_categories = [array_long,array_short,array_long_unwinding,array_short_covering]
        
        for k in 0..<4 {
        for i in 0..<array_categories[k].count{
            
            let string = array_long[i]
            let array_components = string.components(separatedBy: ",")
            let symbol_category = Symbol_category()
            symbol_category.category_code = "l"
            symbol_category.symbol = array_components[0]
            symbol_category.price = array_components[1]
            symbol_category.open_interest = array_components[2]
            symbol_category.price_change_percentage = array_components[3]
            symbol_category.open_interest_change_percentage = array_components[4]
            all_data.append(symbol_category)
            
            print("Element:- \(symbol_category.symbol)")
            print("Element:- \(symbol_category.price_change_percentage)")
        }
        }
        print("All data count :\(all_data.count)")
            
        array_sorted = all_data.sorted{ $0.price_change_percentage > $1.price_change_percentage }
        
        print(array_sorted)
        print("Array sorted..\(array_sorted.count)")
        
        
        
        
    }

}
