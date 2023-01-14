//
//  CategoryViewController.swift
//  Quick-Bites
//
//  Created by Sefa Değirmenci on 30.12.2022.
//

import UIKit

class CategorySelectionViewController: UIViewController {
    
    @IBOutlet weak var categorySelectionCollectionView: UICollectionView!
    var cityName: String?
    private var categorySelectionDataSource = CategorySelectionDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Select a Category"
        categorySelectionDataSource.delegate = self
        categorySelectionDataSource.getListOfCategories()
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let cell = sender as? UICollectionViewCell,
            let indexPath = categorySelectionCollectionView.indexPath(for: cell),
            let category = categorySelectionDataSource.getCategory(for: indexPath.row),
            let restaurantController = segue.destination as? RestaurantSelectionViewController {
            restaurantController.category = category.name
            restaurantController.cityName = cityName
        }

    }


}

extension CategorySelectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categorySelectionDataSource.getNumberOfCategories()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as? CategorySelectionCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOffset = CGSize(width: 1, height: 2)
        cell.contentView.layer.shadowOpacity = 0.8
        cell.contentView.layer.shadowRadius = 1.0

        if let category = categorySelectionDataSource.getCategory(for: indexPath.row) {
            if category.name == "All" {
                cell.foodImageView.image = UIImage(named: self.cityName?.lowercased() ?? "istanbul")
                cell.nameLabel.text = "All Restaurants"
            } else {
                cell.foodImageView.image = UIImage(named: category.name.lowercased())
                cell.nameLabel.text = category.name
            }
        }

        return cell
    }
}

extension CategorySelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            // Return the width of the superview for the first cell
            return CGSize(width: collectionView.bounds.width, height: 200)
        } else {
            // Return a fixed width of 190 for all other cells
            return CGSize(width: 190, height: 200)
        }
    }
}

extension CategorySelectionViewController: CategorySelectionDataDelegate {

    func categoriesLoaded() {
        categorySelectionCollectionView.reloadData()
    }
    
    func refreshTokenExpired() {
        PresenterManager.shared.show(vc: .login)
    }
}

