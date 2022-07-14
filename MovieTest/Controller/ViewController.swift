//
//  ViewController.swift
//  MovieTest
//
//  Created by Macbook Pro on 7/13/22.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var movieListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()
    
    let adSearchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        if let textfield = sb.value(forKey: "searchField") as? UITextField {
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
        sb.searchTextField.font = UIFont(name: "kefa", size: 18)
        sb.searchTextField.textColor = .blue
        sb.searchTextField.backgroundColor = .clear
        sb.layer.borderColor = UIColor(hexString: "#28283F").cgColor
        sb.layer.borderWidth = 1
        sb.tintColor = .blue
        sb.barStyle = .default
        sb.setImage(UIImage(named: "Search Icon"), for: .search, state: .normal)
        sb.searchTextPositionAdjustment = UIOffset(horizontal: Utility.convertWidthMultiplier(constant: 10), vertical: 0)
        return sb
    }()
    
    var movieTitle = [String]()
    var movieDescription = [String]()
    var poster = [String]()
    
    var urlOfData = "https://api.themoviedb.org/3/search/movie?api_key=38e61227f85671163c275f9bd95a8803&query=marvel"
    var baseURL = "https://image.tmdb.org"
    var subDirectory = "/t/p/w500"
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    //MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        dataParsing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //MARK: - Functions
    
    func setupSubviews(){
        view.backgroundColor = .white
        
        view.addSubview(adSearchBar)
        adSearchBar.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: Utility.convertHeightMultiplier(constant: 58), paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: Utility.convertWidthMultiplier(constant: 374), height: Utility.convertHeightMultiplier(constant: 54))
        adSearchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        adSearchBar.delegate = self
        
        
        view.addSubview(movieListTableView)
        movieListTableView.anchor(top: adSearchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: Utility.convertWidthMultiplier(constant: 24), paddingBottom: 0, paddingRight: Utility.convertWidthMultiplier(constant: 24), width: 0, height: 0)
    }
    
    func dataParsing(){
        let session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=38e61227f85671163c275f9bd95a8803&query=marvel")!
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            
            // Do something…
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ... 299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(MovieList.self, from: data!)

                DispatchQueue.main.async {
                    for i in 0 ..< result.results.count{
                        self.movieTitle.append(result.results[i].originalTitle)
                        self.movieDescription.append(result.results[i].overview)
                        self.poster.append(result.results[i].posterPath)
                    }
                    Config.shared.movieTitle = self.movieTitle
                    Config.shared.movieReview = self.movieDescription
                    Config.shared.moviePoster = self.poster
                    self.movieListTableView.reloadData()
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        })
        
        task.resume()
    }
    
    func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }

    //MARK: - Button Actions
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        cell.selectionStyle = .none
        cell.review.tag = indexPath.row
        cell.movieTitle.text = movieTitle[indexPath.row]
        cell.review.text = movieDescription[indexPath.row]
        cell.poster.load(url: URL(string: baseURL + subDirectory + poster[indexPath.row])!)
        return cell
    }
}

extension ViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let text = (searchBar.text?.lowercased())!
        let filtered = movieTitle.filter {
            $0.lowercased().range(of: text) != nil
        }
        var filteredMovieTitle = [String]()
        var filteredReview = [String]()
        var filteredPoster = [String]()

        let movieName = Config.shared.movieTitle
        let movieReview = Config.shared.movieReview
        let moviePoster = Config.shared.moviePoster

        for i in 0..<movieTitle.count
        {
            if filtered.contains(movieName[i])
            {
                filteredMovieTitle.append(movieName[i])
                filteredReview.append(movieReview[i])
                filteredPoster.append(moviePoster[i])
            }
        }

        if searchBar.text == "" || filtered.count == 0
        {
            showToast(message: "No Data Found from Keyword", font: UIFont(name: "kefa", size: Utility.convertHeightMultiplier(constant: 14))!)
            movieTitle = Config.shared.movieTitle
            movieDescription = Config.shared.movieReview
            poster = Config.shared.moviePoster
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.movieListTableView.reloadData()
            })
        }
        else
        {
            movieTitle = filteredMovieTitle
            movieDescription = filteredReview
            poster = filteredPoster
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.movieListTableView.reloadData()
            })
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("canceled searbar")
        movieTitle = Config.shared.movieTitle
        movieDescription = Config.shared.movieReview
        poster = Config.shared.moviePoster
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.movieListTableView.reloadData()
        })

        searchBar.searchTextField.text = nil
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

