//
//  ViewController.swift
//  Employees
//
//  Created by User on 01.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var titleLabel: UINavigationItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var infoButton: UIButton!
    
    private var employees = [Employee]()
    
    @IBAction func getInfoButtonPressed(_ sender: UIButton) {
        
        fetchCompanyData()
        infoButton.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetchCompanyData(){
        
        let jsonUrlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data  else {return }
            do {
                let decoder = JSONDecoder()
                let companyData = try decoder.decode(CompanyData.self, from: data)
                self.employees = companyData.company.employees
                
                DispatchQueue.main.async {
                    self.navigationItem.title = "Company name: \(companyData.company.name)"
                    self.tableView.reloadData()
                }
            } catch let error as NSError {
                
                print (error.localizedDescription)
            }
        }.resume()
    }
    
    
    
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath){
    
        
        let employeeInfo = employees.sorted(by: {$0.name < $1.name})[indexPath.row]
        cell.employeeName.text = "Name: \(employeeInfo.name)"
        cell.employeeNumber.text = "Number: \(employeeInfo.phoneNumber)"
        
        let stringArray = employeeInfo.skills.joined(separator: ", ")
        cell.employeeSkills.text = "Skills: \(stringArray)"
    }
}

// MARK: Table View Data Source

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
}

// MARK: Table View Delegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}

