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
        self.title = "Select a category"
        
        categorySelectionDataSource.delegate = self
        categorySelectionDataSource.getListOfCategories()
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
        
        if let category = categorySelectionDataSource.getCategory(for: indexPath.row) {
            cell.nameLabel.text = category.name
            cell.foodImageView.image = UIImage(named: category.name.lowercased())
        }
        
        return cell
    }
}
extension CategorySelectionViewController: CategorySelectionDataDelegate {
    func categoriesLoaded() {
        categorySelectionCollectionView.reloadData()
    }
}
