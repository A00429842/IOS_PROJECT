//
//  MapPreviewViewController.swift
//  GetGoingClass
//
//  Created by shaunyan on 2019-02-22.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit
import MapKit


class MapPreviewViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var places: [PlaceDetails]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setMapViewCoordinate()
        // Do any additional setup after loading the view.
    }    
    

    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setMapViewCoordinate() {
        mapView.delegate = self
        let annotations = places.compactMap {(place:PlaceDetails) -> MKAnnotation? in
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            guard let coordinate = place.coordinate else { return nil }
            annotation.coordinate = coordinate
            
            return annotation
        }
        mapView.addAnnotations(annotations)
        //mapView.fitAll(annotations)
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

extension MapPreviewViewController: MKMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }

        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reusablePin")
        // allowing to show extra information in the pin view
        view.canShowCallout = true
        // "i" button
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.pinTintColor = UIColor.blue

        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation
        
        let launchingOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
        if let coordinate = location?.coordinate {
            location?.mapItem(coordinate: coordinate).openInMaps(launchOptions: launchingOptions)
        }
    }
}

extension MKAnnotation {
    func mapItem(coordinate: CLLocationCoordinate2D) -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placemark)
    }
}


