//
//  HomeVC.swift
//  HeatMap
//
//  Created by Anand on 03/08/21.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var btn_ALL: UIButton!
    @IBOutlet weak var btn_L: UIButton!
    @IBOutlet weak var btn_SC: UIButton!
    @IBOutlet weak var btn_S: UIButton!
    @IBOutlet weak var btn_LU: UIButton!
    @IBOutlet weak var searchBar_symbol: UISearchBar!
    @IBOutlet weak var view_grid: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set corner radius of buttons
        btn_ALL.layer.cornerRadius = btn_ALL.frame.width * 0.2
        btn_L.layer.cornerRadius = btn_L.frame.width * 0.2
        btn_SC.layer.cornerRadius = btn_SC.frame.width * 0.2
        btn_S.layer.cornerRadius = btn_S.frame.width * 0.2
        btn_LU.layer.cornerRadius = btn_LU.frame.width * 0.2

        
    }
 
    

}
