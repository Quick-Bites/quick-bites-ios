//
//  CategoryViewController.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 30.12.2022.
//

import UIKit
import DropDown

class CategorySelectionViewController: UIViewController {

    @IBOutlet weak var categorySelectionCollectionView: UICollectionView!
    @IBOutlet weak var cityDropDownView: UIView!
    @IBOutlet weak var dropdownButton: UIButton!
    var cityName: String?
    private var cityArray: [String]? = []
    let cityDropDown = DropDown()
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBAction func tappedDropDownButton(_ sender: Any) {
        cityDropDown.show()
    }
    private var categorySelectionDataSource = CategorySelectionDataSource()
    private var citySelectionDataSource = CitySelectionDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Quick Bites"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: #selector(rightButtonTapped))

        cityDropDown.anchorView = cityDropDownView
        cityDropDown.bottomOffset = CGPoint(x: 0, y: (cityDropDown.anchorView?.plainView.bounds.height)!)
        cityDropDown.topOffset = CGPoint(x: 0, y: -(cityDropDown.anchorView?.plainView.bounds.height)!)
        cityDropDown.direction = .bottom
        cityDropDown.width = 200
        citySelectionDataSource.delegate = self
        citySelectionDataSource.getListOfCities()

        categorySelectionDataSource.delegate = self
        categorySelectionDataSource.getListOfCategories()
        self.cityName = LocationHelper.cityName
    }

    @objc func rightButtonTapped() {
        let storyboard = UIStoryboard(name: "UserInfo", bundle: nil)
        if let destinationViewController = storyboard.instantiateViewController(withIdentifier: "UserInfoViewController") as? UserInfoViewController {
            show(destinationViewController, sender: self)
        }
    }
}

extension CategorySelectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cityName = self.cityName,
           CitySelectionDataSource.cityArray.contains(where: { $0.name.lowercased() == cityName.lowercased()}) {
            return categorySelectionDataSource.getNumberOfCategories()
        } else {
            return categorySelectionDataSource.getNumberOfCategories() - 1
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as? CategorySelectionCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOffset = CGSize(width: 1, height: 2)
        cell.contentView.layer.shadowOpacity = 0.8
        cell.contentView.layer.shadowRadius = 1.0

        if let cityName = self.cityName,
           CitySelectionDataSource.cityArray.contains(where: { $0.name.lowercased() == cityName.lowercased() }) {
            if let category = categorySelectionDataSource.getCategory(for: indexPath.row) {
                if category.name == "All" {
                    UIView.animate(withDuration: 1) {
                        cell.foodImageView.alpha = 0.0
                        cell.nameLabel.alpha = 0.0
                        cell.foodImageView.image = UIImage(named: cityName.lowercased())
                        cell.nameLabel.text = "Restaurants in \(cityName)"
                        cell.foodImageView.alpha = 1.0
                        cell.nameLabel.alpha = 1.0
                    }
                } else {
                    cell.foodImageView.image = UIImage(named: category.name.lowercased())
                    cell.nameLabel.text = category.name
                }
            }
        } else {
            if let category = categorySelectionDataSource.getCategory(for: indexPath.row + 1) {
                cell.foodImageView.image = UIImage(named: category.name.lowercased())
                cell.nameLabel.text = category.name
            }
        }

        return cell
    }
}

extension CategorySelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            if let cityName = self.cityName,
               CitySelectionDataSource.cityArray.contains(where: { $0.name.lowercased() == cityName.lowercased()}) {
                // Return the width of the superview for the first cell
                return CGSize(width: collectionView.bounds.width, height: 200)
            }
            return CGSize(width: 190, height: 200)
        } else {
            // Return a fixed width of 190 for all other cells
            return CGSize(width: 190, height: 200)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cityName = self.cityName,
            CitySelectionDataSource.cityArray.contains(where: { $0.name.lowercased() == cityName.lowercased()}) {

            // Perform segue to next view controller
            let storyboard = UIStoryboard(name: "RestaurantSelection", bundle: nil)
            if let restaurantController = storyboard.instantiateViewController(withIdentifier: "RestaurantSelectionViewController") as? RestaurantSelectionViewController {

                if let category = categorySelectionDataSource.getCategory(for: indexPath.row) {
                    restaurantController.category = category.name
                    restaurantController.cityName = cityName
                }

                self.navigationController?.pushViewController(restaurantController, animated: true)
            }
        } else {
            let message = "Please select a city from the dropdown menu before continuing"
            let alert = UIAlertController(title: "Please select a city", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension CategorySelectionViewController: CategorySelectionDataDelegate {

    func categoriesLoaded() {
        categorySelectionCollectionView.reloadData()
    }

    func refreshTokenExpired() {
        PresenterManager.shared.show(nextViewController: .login)
    }
}

extension CategorySelectionViewController: CitySelectionDataDelegate {

    func citiesLoaded() {
        self.cityArray = CitySelectionDataSource.cityArray.map {$0.name}
        if let cityArray = self.cityArray {
            self.cityDropDown.dataSource = cityArray
            if let index = cityDropDown.dataSource.firstIndex(of: "Istanbul") {
                self.cityDropDown.selectRow(at: index)
                self.cityNameLabel.text = self.cityName ?? "Select a City"
            }
            cityDropDown.selectionAction = {(index: Int, _: String) in
                self.cityNameLabel.text = cityArray[index]
                self.cityNameLabel.textColor = .black
                self.cityName = cityArray[index]
                self.categorySelectionCollectionView.reloadData()
            }
        }
    }
}
