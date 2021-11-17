import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionLabel: UILabel!
    // API key: 061928dcda3383cad5f19acf2b53c640
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
}

extension WeatherViewController: UITextViewDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            searchTextField.placeholder = "Search"
            return true
        } else {
            searchTextField.placeholder = "Enter a location"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}
    
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionLabel.text = weather.conditionName.description
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - Example
protocol ProductDetailViewControllerDelegate: AnyObject {
    func updateProduct(_ product: [Int: String])
}

class ProductListViewController: UIViewController, ProductDetailViewControllerDelegate {
    func updateProduct(_ product: [Int : String]) {
        print(product)
    }
    
    var list: [[Int: String]] = [
        [1: "Trung Duc"],
        [2: "Cong"],
        [3: "Son Le"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let button = UIButton()
        button.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
        button.setTitle("Push to detail", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(pushToDetail), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    @objc func pushToDetail() {
        let controller = ProductDetailViewController(product: list[2])
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}



class ProductDetailViewController: UIViewController {
    
    weak var delegate: ProductDetailViewControllerDelegate?
    private let product: [Int: String]
    
    init(product: [Int: String]) {
        self.product = product
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let button = UIButton()
        button.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
        button.setTitle("Change name", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(changeName), for: .touchUpInside)
        
        let label = UILabel()
        label.frame = CGRect(x: 300, y: 200, width: 100, height: 100)
        label.text = product.values.first
        
        view.addSubview(button)
        view.addSubview(label)
    }
    
    @objc func changeName() {
        let nameToChange = "ABC"
        delegate?.updateProduct([2: nameToChange])
        navigationController?.popViewController(animated: true)
    }
}
