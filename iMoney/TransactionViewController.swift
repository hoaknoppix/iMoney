//
//  ViewController.swift
//  iMoney
//
//  Created by hoaqt on 3/6/18.
//  Copyright © 2018 com.noron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

extension TransactionViewController : FECreditLoginCoordinatorDelegate {
    func initUser(user: User) {
        self.user = user
        self.navigationItem.title = "Xin chào \(user.displayName!)"
        let ref = Database.database().reference()
        ref.child("users/\(user.uid)/transactions").observeSingleEvent(of: .value, with: { (snapshot) in
            self.transactions = snapshot.value as? NSArray
            self.initTransactionTableView()
            self.transactionTableView.reloadData()
        }) { (error) in
            let alert = UIAlertController(title: "Lỗi", message: "xin hãy thử lại", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension TransactionViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (transactions != nil) else {
            return 0
        }
        return transactions!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionTableViewCell
        let index = indexPath.item
        let transaction = transactions![index] as! NSDictionary
        cell.amountLabel.text = transaction["amount"] as? String
        cell.messageLabel.text = transaction["message"] as? String
        cell.dateLabel.text = transaction["date"] as? String
        return cell
    }
}

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var transactionTableView: UITableView!
    
    var transactions : NSArray?
    
    var user : User? = nil
    
    var handle : AuthStateDidChangeListenerHandle?
    
    lazy var loginCoordinator: FECreditLoginCoordinator = {
        var coordinator = FECreditLoginCoordinator(rootViewController: self)
        coordinator.delegate = self
        return coordinator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (user == nil) {
            loginCoordinator.start()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setColorForNavigationController()
    }
    
    func initTransactionTableView() {
        transactionTableView.dataSource = self
    }
    
    func setColorForNavigationController() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

