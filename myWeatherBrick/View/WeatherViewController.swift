

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let fetchManager = FetchWeatherManager()
    let locationManager = CLLocationManager()
    let backgroundImageView = UIImageView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var stack = UIStackView()
    
    let cityNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let temperatureLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let degreeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let infoButton = UIButton()
    let findButton = UIButton()
    
    let descriptionWeatherLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let imageViewBrickOnRope = UIImageView()
    let refreshControl = UIRefreshControl()
    var latitude: Double = 0
    var longitude: Double = 0
    var activityIndicator = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupView()
        setupViewBrickOnRope()
        startLocationManager()
        setupRefreshControl()
        setupActivityIndicator()
        setupButtom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            temperatureLabel.topAnchor.constraint(equalTo: imageViewBrickOnRope.bottomAnchor),
            
            degreeLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 10),
            degreeLabel.topAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -10),
            degreeLabel.widthAnchor.constraint(equalToConstant: 50),
            degreeLabel.heightAnchor.constraint(equalTo: temperatureLabel.heightAnchor),
            
            descriptionWeatherLabel.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),
            descriptionWeatherLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            descriptionWeatherLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
//            cityNameLabel.widthAnchor.constraint(equalToConstant: 200),
//            cityNameLabel.bottomAnchor.constraint(equalTo: infoButton.topAnchor, constant: -15),
//            cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            cityNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            infoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            infoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 160),
            infoButton.heightAnchor.constraint(equalToConstant: 60),
            
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.bottomAnchor.constraint(equalTo: infoButton.topAnchor, constant: -15)
            
        ])
    }
    func setupButtom(){
        contentView.addSubview(infoButton)
        infoButton.layer.cornerRadius = 15
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.setTitle("INFO", for: .normal)
        infoButton.backgroundColor = .systemOrange
        infoButton.addTarget(self, action: #selector(pushPopView), for: .touchUpInside)
        
        findButton.setImage(UIImage(named: "icon_search"), for: .normal)
        findButton.addTarget(self, action: #selector(pushFindButton), for: .touchUpInside)
    }
    
    @objc func pushFindButton(){
        
        let alert = UIAlertController(title: "Find City", message: "Enter city name on English:", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Find", style: .default) { _ in
            guard let city = alert.textFields?.first?.text else {return}
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            print("_______------___----_City!!!! = \(city)")
            self.fetchManager.fetchWeatherForCityName(cityName: city) { weather in
                DispatchQueue.main.async {
                    self.updateView(weather: weather)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField { textField in
            textField.placeholder = "Input City name:"
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    @objc func pushPopView(){
        let infoView = InfoView()
        view.addSubview(infoView)
    }
    
    func setupView(){
        view.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "image_background")
        backgroundImageView.frame = view.bounds
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(degreeLabel)
        contentView.addSubview(descriptionWeatherLabel)
        setupStack()
    }
    
    func setupStack(){
        let gpsImage = UIImageView(image: UIImage(named: "icon_location"))
        gpsImage.contentMode = .scaleAspectFit
        stack = UIStackView(arrangedSubviews: [gpsImage,cityNameLabel,findButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        contentView.addSubview(stack)
    }
    
    func setupViewBrickOnRope(){
        contentView.addSubview(imageViewBrickOnRope)
        imageViewBrickOnRope.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
        imageViewBrickOnRope.contentMode = .scaleAspectFit
        imageViewBrickOnRope.image = UIImage()
    }
    
    func setupActivityIndicator(){
        contentView.addSubview(activityIndicator)
        activityIndicator.frame = CGRect(x: contentView.frame.width/2, y: contentView.frame.height/2, width: 0, height: 0)
        activityIndicator.style = .large
    }
    
    func setupScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.frame = view.bounds
        contentView.frame = scrollView.bounds
        scrollView.contentSize = contentView.frame.size
    }
    
    func setupRefreshControl(){
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc func didPullToRefresh() {
        locationManager.startUpdatingLocation()
        print("start location")
        refresh()
        refreshControl.endRefreshing()
    }
    
    func startLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                self.locationManager.pausesLocationUpdatesAutomatically = true
                self.locationManager.startUpdatingLocation()
            } else {
                let alert = UIAlertController(title: "У тебя выключен GPS", message: "Включи его в настройках", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    func refresh(){
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        fetchManager.fetchWeatherForCoordinates(latitude: latitude, longitude: longitude) { weather in
            DispatchQueue.main.async {
                self.updateView(weather: weather)
                self.activityIndicator.stopAnimating()
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5){
                    print("Stop location")
                    self.locationManager.stopUpdatingLocation()
                }
            }
        }
    }
    
    func updateView(weather: FinalWeather?){
        if let weather = weather {
            temperatureLabel.text = weather.temperature
            cityNameLabel.text = weather.country + ", " + weather.nameCity
            descriptionWeatherLabel.text = weather.description
            degreeLabel.text = "°"
            imageViewBrickOnRope.image = UIImage(named: weather.image)
            windOfBrick(windSpeed: weather.wind)
            
            if (701...799).contains(weather.id) {
                imageViewBrickOnRope.alpha = 0.15
            } else {
                imageViewBrickOnRope.alpha = 1.0
            }
            
        } else {
            temperatureLabel.text = ""
            cityNameLabel.text = "Not found"
            descriptionWeatherLabel.text = ""
            degreeLabel.text = ""
            imageViewBrickOnRope.image = UIImage(named: "image_without_stone_")
            UIView.animate(withDuration: 2, delay: 1) {
                self.imageViewBrickOnRope.transform = CGAffineTransformMakeRotation(CGFloat(0))
            }
        }
    }
    
    func windOfBrick(windSpeed: Double){
        print("windSpeed = \(windSpeed)")
        if windSpeed > 4 {
            UIView.animate(withDuration: 2, delay: 1) {
                self.imageViewBrickOnRope.transform = CGAffineTransformMakeRotation(CGFloat(45))
            }
        } else {
            UIView.animate(withDuration: 2, delay: 1) {
                self.imageViewBrickOnRope.transform = CGAffineTransformMakeRotation(CGFloat(0))
            }
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            latitude = lastLocation.coordinate.latitude
            longitude = lastLocation.coordinate.longitude
            refresh()
        }
    }
}


