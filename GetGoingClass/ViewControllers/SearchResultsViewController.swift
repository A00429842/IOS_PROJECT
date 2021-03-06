//
//  SearchResultsViewController.swift
//  GetGoingClass
//
//  Created by shaunyan on 2019-01-23.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var mapViewButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: - Properties

    var places: [PlaceDetails]!

    // MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchResultTableViewCell")
        updateSorting()
    }
    

    
    @IBAction func showMapPreview(_ sender: UIBarButtonItem) {
        guard let mapPreviewViewController = UIStoryboard(name: "Mapview", bundle: nil).instantiateViewController(withIdentifier: "MapPreviewViewController") as? MapPreviewViewController else{ return }
        
        mapPreviewViewController.places = places
        present(mapPreviewViewController, animated: true, completion: nil)
    }
    
    @IBAction func segmentedObserver(_ sender: UISegmentedControl) {
        updateSorting()
    }
    
    private func updateSorting() {
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            places = places.sorted(by: { $0.name ?? "" < $1.name ?? "" })
        }else if(segmentedControl.selectedSegmentIndex == 1)
        {
            places = places.sorted(by: { $0.rating ?? 0.0 > $1.rating ?? 0.0 })
        }
        tableView.reloadData()

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
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell") as? SearchResultTableViewCell else { return UITableViewCell() }
        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        cell.vicinityLabel.text = place.address
        if let placeRating = place.rating {
            cell.rating.rating = Int(placeRating.rounded(.down))
        }
        guard let iconStr = place.icon,
            let iconURL = URL(string: iconStr),
            let imageData = try? Data(contentsOf: iconURL) else {
                cell.iconImageView.image = UIImage(named: "StarEmpty")
                return cell
        }
        cell.iconImageView.image = UIImage(data: imageData)
        return cell
    }
    
    
    func presentDetails(place: PlaceDetails) {
        guard let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        
        detailsViewController.place = place
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        

    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row was selected at \(indexPath.section) \(indexPath.row)")
        let place = places[indexPath.row]
        presentDetails(place: place)

    }
}
