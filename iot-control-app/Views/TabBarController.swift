//
//  TabBarController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 11/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit

protocol TabBarDatasource {
    func setRequestsBadge(n: Int)
}

class TabBarController: UITabBarController, TabBarDatasource {

    override func viewDidLoad() {
        super.viewDidLoad()
		UserController.tabBarData = self
        UserController().loadUsersRequests {
        }
    }
    
    func setRequestsBadge(n: Int) {
        self.tabBar.items![2].badgeValue = String(n)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
