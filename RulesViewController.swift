//
//  RulesViewController.swift
//  Othello++
//
//  Created by B++ on 4/12/18.
//  Copyright © 2018 Ben Miller. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {

    @IBOutlet weak var rulesLabel: UILabel!
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rulesLabel.text = "Rules:  \n#1: You have to take a piece on your turn \n#2: You can not eliminate a player from the game \n#3: The game is over after all squares are filled or no possible moves are left \n\nThese \nexamples \nare during \nBlues turn"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
