//
//  GreyViewController.swift
//  RxPager
//
//  Created by xperi on 2017. 7. 26..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit

class GreyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	var didSelectRow: ((String) -> ())?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		automaticallyAdjustsScrollViewInsets = false
	}
	
	// MARK: - Table view data source
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 10
	}
	
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
		cell.textLabel?.text = "Example at index \(indexPath.row + 1)"
		
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		didSelectRow?("Detail for index \(indexPath.row + 1)")
		tableView.deselectRow(at: indexPath as IndexPath, animated: true)
	}
	
}
