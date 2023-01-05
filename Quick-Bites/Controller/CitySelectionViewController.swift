//
//  CitySelectionViewController.swift
//  Quick-Bites
//
//  Created by Can Usluel on 24.12.2022.
//

import UIKit

class CitySelectionViewController: UIViewController {

    @IBOutlet weak var citySelectionTableView: UITableView!
    private var citySelectionDataSource = CitySelectionDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select a city"
        // Do any additional setup after loading the view.
        citySelectionDataSource.delegate = self
        citySelectionDataSource.getListOfCities()
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if
            let cell = sender as? UITableViewCell,
            let indexPath = citySelectionTableView.indexPath(for: cell),
            let city = citySelectionDataSource.getCity(for: indexPath.row),
            let categorySelectionController = segue.destination as? CategorySelectionViewController {
            categorySelectionController.cityName = city.name
        }
    }


}

extension CitySelectionViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citySelectionDataSource.getNumberOfCities()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CitySelectionCell") as? CitySelectionTableViewCell
            else {
            return UITableViewCell()
        }

        if let city = citySelectionDataSource.getCity(for: indexPath.row) {
            cell.nameLabel.text = city.name
        } else {
            cell.nameLabel.text = ""
        }

        return cell
    }
}

extension CitySelectionViewController: CitySelectionDataDelegate {

    func citiesLoaded() {
        self.citySelectionTableView.reloadData()
    }
}
