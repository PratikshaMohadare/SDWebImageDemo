//
//  ViewController.swift
//  SDWebImageDemo
//
//  Created by Pratiksha on 03/10/23.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    var dogAllData: DataDog?
    var dogImgLinks = [String]()
    
    public let url = URL(string: "https://dog.ceo/api/breed/hound/images")
    
    @IBOutlet var myCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData(){
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            guard let data = data, error == nil else {
                print("Error occured while Accessing Data")
                return
            }
            var dogObject: DataDog?
            do{
                dogObject = try JSONDecoder().decode(DataDog.self, from: data)
            } catch{
                print("Error decoding JSON \(error)")
            }
            self.dogAllData = dogObject
            self.dogImgLinks = self.dogAllData!.message
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        })
        task.resume()
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return dogImgLinks.count
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
     if let imageURL = URL(string: dogImgLinks[indexPath.row]){
         cell.myImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
         cell.myImageView.sd_imageIndicator?.startAnimatingIndicator()
         cell.myImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "empty-image"), options: .continueInBackground, completed: nil)
         cell.myImageView.contentMode = .scaleToFill
         cell.myImageView.layer.cornerRadius = cell.myImageView.frame.height/2
    } else {
        print("Invalid URL")
        cell.myImageView.image = UIImage(named: "empty-image")
    }
   return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = (collectionView.frame.size.width-20)/2
    return CGSize(width: size, height: size)
  }
}
