//
//  ViewController.swift
//  MovieTest
//
//  Created by Macbook Pro on 7/13/22.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var gratitudeTable: UITableView = {
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
        view.addSubview(gratitudeTable)
        gratitudeTable.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: Utility.convertHeightMultiplier(constant: 0), paddingLeft: Utility.convertWidthMultiplier(constant: 24), paddingBottom: 0, paddingRight: Utility.convertWidthMultiplier(constant: 24), width: 0, height: 0)
    }
    
    func dataParsing(){
        let session = URLSession.shared
        let url = URL(string: urlOfData)!
        
        /// URL SESSION
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            
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
            
            /// JSONDECODER
            
            do {
                let result = try JSONDecoder().decode(MovieList.self, from: data!)

                DispatchQueue.main.async {
                    for i in 0 ..< result.results.count{
                        self.movieTitle.append(result.results[i].originalTitle)
                        self.movieDescription.append(result.results[i].overview)
                        self.poster.append(result.results[i].posterPath)
                    }
                    self.gratitudeTable.reloadData()
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

