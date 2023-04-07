

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var fetchManager: WeatherFetchingProtocol? //FetchWeatherManager()
    
    init(fetchManager: WeatherFetchingProtocol){
        self.fetchManager = fetchManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
    private let locationManager = CLLocationManager()
    private let backgroundImageView = UIImageView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    private let infoButton = UIButton()
    private let findButton = UIButton()
    private let gpsButton = UIButton()
    private let imageViewBrickOnRope = UIImageView()
//    private let refreshControl = UIRefreshControl()
    private var buttonLabelStack = UIStackView()
    
    private let cityNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let temperatureLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let degreeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionWeatherLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var latitude: Double = 0
    var longitude: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupView()
        setupViewBrickOnRope()
        startLocationManager()
        setupActivityIndicator()
        setupButtoms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshWeather()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            temperatureLabel.topAnchor.constraint(equalTo: view.centerYAnchor),
            
            degreeLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 10),
            degreeLabel.topAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -10),
            degreeLabel.widthAnchor.constraint(equalToConstant: 50),
            degreeLabel.heightAnchor.constraint(equalTo: temperatureLabel.heightAnchor),
            
            descriptionWeatherLabel.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),
            descriptionWeatherLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            descriptionWeatherLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 160),
            infoButton.heightAnchor.constraint(equalToConstant: 60),
            
            buttonLabelStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonLabelStack.bottomAnchor.constraint(equalTo: infoButton.topAnchor, constant: -15)
        ])
    }
    
//    @objc private func didPullToRefresh() {
//        refreshWeather()
//        refreshControl.endRefreshing()
//    }
    
    @objc private func refreshGps(){
        refreshWeather()
    }
    
    @objc private func pushFindButton(){
        
        let alert = UIAlertController(title: "Find City", message: "Enter city name on English:", preferredStyle: .alert)
       
        let action = UIAlertAction(title: "Find", style: .default) { _ in
            guard let cityAlertText = alert.textFields?.first?.text else {return}
            self.isActivityAnimatingStart(true)
            self.fetchManager?.fetchWeatherForCityName(cityName: cityAlertText) { weather in
                DispatchQueue.main.async {
                    self.updateView(weather: weather)
                    self.isActivityAnimatingStart(false)
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
    
    @objc private func pushPopView(){
        let infoView = InfoView()
        view.addSubview(infoView)
    }
    
    private func setupButtoms(){
        contentView.addSubview(infoButton)
        infoButton.layer.cornerRadius = 15
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.setTitle("INFO", for: .normal)
        infoButton.backgroundColor = .systemOrange
        infoButton.addTarget(self, action: #selector(pushPopView), for: .touchUpInside)
        
        gpsButton.setImage(UIImage(named: "icon_location"), for: .normal)
        findButton.setImage(UIImage(named: "icon_search"), for: .normal)
        gpsButton.addTarget(self, action: #selector(refreshGps), for: .touchUpInside)
        findButton.addTarget(self, action: #selector(pushFindButton), for: .touchUpInside)
    }

    private func setupView(){
        view.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "image_background")
        backgroundImageView.frame = view.bounds
        view.addSubview(temperatureLabel)
        view.addSubview(cityNameLabel)
        view.addSubview(degreeLabel)
        view.addSubview(descriptionWeatherLabel)
        setupStack()
    }
    
    private func setupStack(){
        let gpsImage = UIImageView(image: UIImage(named: "icon_location"))
        gpsImage.contentMode = .scaleAspectFit
        buttonLabelStack = UIStackView(arrangedSubviews: [gpsButton,cityNameLabel,findButton])
        buttonLabelStack.translatesAutoresizingMaskIntoConstraints = false
        buttonLabelStack.axis = .horizontal
        buttonLabelStack.spacing = 5
        contentView.addSubview(buttonLabelStack)
    }
    
    private func setupViewBrickOnRope(){
        contentView.addSubview(imageViewBrickOnRope)
        imageViewBrickOnRope.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: view.frame.height/2.5)
        imageViewBrickOnRope.contentMode = .scaleAspectFit
        imageViewBrickOnRope.image = UIImage()
    }
    
    private func setupActivityIndicator(){
        contentView.addSubview(activityIndicator)
        activityIndicator.frame = CGRect(x: contentView.frame.width/2, y: contentView.frame.height/2, width: 0, height: 0)
        activityIndicator.style = .large
    }
    
    private func setupScrollView(){
       
        scrollView.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        scrollView.delegate = self
        scrollView.setContentOffset(.zero, animated: false)
        scrollView.bounces = false
       
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.frame = view.bounds
        contentView.frame = scrollView.bounds
        
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
//    private func setupRefreshControl(){
//        //scrollView.refreshControl = refreshControl
//        //refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
//    }
    
    private func startLocationManager(){
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
    
    func refreshWeather(){
        guard longitude != 0 else {return}

        isActivityAnimatingStart(true)
        
        fetchManager?.fetchWeatherForCoordinates(latitude: latitude, longitude: longitude) { weather in
            DispatchQueue.main.async {
                self.updateView(weather: weather)
                self.isActivityAnimatingStart(false)
            }
        }
    }
    
    private func isActivityAnimatingStart(_ animating: Bool){
        if animating {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func alertCityNotFound() {
        let alertNotFound = UIAlertController(title: "City not find", message: "Try input another City\nPlease!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertNotFound.addAction(action)
        present(alertNotFound, animated: true)
    }
    
    private func updateView(weather: WeatherModel?){
        if let weather = weather {
            temperatureLabel.text = weather.temperature
            cityNameLabel.text = weather.country + ", " + weather.nameCity
            descriptionWeatherLabel.text = weather.description
            degreeLabel.text = "°"
            imageViewBrickOnRope.image = UIImage(named: weather.image)
            windOfBrick(windSpeed: weather.wind)
            setupFogView(idFog: weather.id)
        } else {
            temperatureLabel.text = ""
            cityNameLabel.text = "Not found"
            descriptionWeatherLabel.text = ""
            degreeLabel.text = ""
            imageViewBrickOnRope.image = UIImage(named: "image_without_stone_")
            UIView.animate(withDuration: 2, delay: 1) {
                self.imageViewBrickOnRope.transform = CGAffineTransformMakeRotation(CGFloat(0))
            }
            alertCityNotFound()
        }
    }
    
    private func setupFogView(idFog: Int){
        if (701...799).contains(idFog) {
            imageViewBrickOnRope.alpha = 0.15
        } else {
            imageViewBrickOnRope.alpha = 1.0
        }
    }
    
    private func windOfBrick(windSpeed: Double){
        if windSpeed > 6 {
            UIView.animate(withDuration: 3, delay: 1.5, options: [.repeat, .autoreverse, .curveEaseInOut]) {
                self.imageViewBrickOnRope.transform = CGAffineTransformMakeRotation(CGFloat(0.3))
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
        }
    }
}

//MARK: - ScrollView Delegate

extension WeatherViewController: UIScrollViewDelegate {
   
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollView.setContentOffset(.zero, animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        refreshWeather()
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset, "offset")
        if scrollView.contentOffset.y == -10 {
            print("vozvrat scrolla")
            //print(scrollView.contentOffset, "offset")
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            print("fin + end")
        }
    }*/
    
}

