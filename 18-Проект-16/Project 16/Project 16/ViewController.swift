//
//  ViewController.swift
//  Project 16
//
//  Created by User on 12.12.2021.
//
import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olimpic")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand year ago!")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often caller the city of light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington,_D.C.", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View map", style: .plain, target: self, action: #selector(changeMapView))
       
    }
    @objc func changeMapView(){
        let ac = UIAlertController(title: "Change view map", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Standart", style: .default){[weak self, weak ac] _ in
            self!.mapView.mapType = MKMapType.standard
        })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default){[weak self, weak ac] _ in
            self!.mapView.mapType = MKMapType.satellite
        })
        present(ac, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else {return nil}
        
        let identifier  = "Capital"
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView!.tintColor = .black
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn

        }else {
            annotationView?.annotation = annotation
            annotationView!.tintColor = .green
        }
        return annotationView
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else {return}
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "Info", style: .default){[weak self, weak ac] _ in
            if let sb = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
                if placeName == "London"{
                    sb.town = "https://en.wikipedia.org/wiki/London"
                }else if placeName == "Oslo"{
                    sb.town = "https://en.wikipedia.org/wiki/Oslo"
                }else if placeName == "Paris"{
                    sb.town = "https://en.wikipedia.org/wiki/Paris"
                }else if placeName == "Rome"{
                    sb.town = "https://en.wikipedia.org/wiki/Rome"
                }else if placeName == "Washington,_D.C."{
                    sb.town = "https://en.wikipedia.org/wiki/Washington,_D.C."
                }
                self?.navigationController?.pushViewController(sb, animated: true)
            }
            
        })
        present(ac, animated: true)
    }


}

