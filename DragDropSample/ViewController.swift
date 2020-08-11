//
//  ViewController.swift
//  Drag&Drop
//
//  Created by Gaurav on 11/08/20.
//  Copyright © 2020 Gaurav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionviewA: UICollectionView!
    @IBOutlet weak var collectionviewB: UICollectionView!
    var sourceindexpath: IndexPath = []
       var dogarry = ["dog1.jpg", "dog2.jpg", "dog3.jpg", "dog4.jpg", "dog5.jpg", "dog6.jpg"  ,"dog7.jpg"]
       var catarry = ["cat1.jpg", "cat2.jpg", "cat3.jpg", "cat4.jpg", "cat5.jpg", "cat6.jpg"  ,"cat7.jpg"]
    
    
  override func viewDidLoad() {
            super.viewDidLoad()
            collectionviewB?.dragDelegate = self
            collectionviewB.dragInteractionEnabled = true
            collectionviewA.dropDelegate = self
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

    }

    //MARK: - UICollectionViewDataSource
    extension ViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == collectionviewA {
                return dogarry.count
            } else {
                return catarry.count
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == self.collectionviewA {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogCollectionViewCell", for: indexPath) as! DogCollectionViewCell
                cell.configureCell(image: UIImage(named: dogarry[indexPath.row])!)
                return cell
            } else if collectionView == self.collectionviewB {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionViewCell", for: indexPath) as! CatCollectionViewCell
                cell.configureCell(image: UIImage(named: catarry[indexPath.row])!)
                return cell
            } else {
                return UICollectionViewCell()
            }
        }
        
    }

    
    extension ViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == self.collectionviewA {
                return CGSize(width: self.collectionviewA.frame.size.width/3.2, height: self.collectionviewA.frame.size.width/3.2)
            } else if collectionView == self.collectionviewB {
                return CGSize(width: collectionviewB.frame.width / 3.2, height: collectionviewB.frame.width / 3.2 )
            } else {
                return CGSize(width: 0, height: 0)
            }
        }
        
    }

 
    extension ViewController: UICollectionViewDragDelegate {
        func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
            let dragedItem = self.dragedItem(forPhotoAt: indexPath)
            return [dragedItem]
        }
        
        
       
        private func dragedItem(forPhotoAt indexPath: IndexPath) -> UIDragItem {
            let imageName = self.catarry[indexPath.row]
            let itemProvider = NSItemProvider(object: imageName as NSItemProviderWriting)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = imageName
            self.sourceindexpath = indexPath
            return dragItem
        }
        
    }

    extension ViewController: UICollectionViewDropDelegate {
        func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {

            let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
            dropandinsert(at: destinationIndexPath, with: coordinator)
        }
        
        
        private func dropandinsert(at destinationIndexPath: IndexPath, with coordinator: UICollectionViewDropCoordinator) {
            let destinationIndexPath: IndexPath
            
            if let indexPath = coordinator.destinationIndexPath {
                destinationIndexPath = indexPath
            } else {
                let section = collectionviewA.numberOfSections - 1
                let row = collectionviewA.numberOfItems(inSection: section)
                destinationIndexPath = IndexPath(row: row, section: section)
            }
            
            coordinator.session.loadObjects(ofClass: NSString.self) { items in
                guard let string = items as? [String] else { return }
                
                var indexPaths = [IndexPath]()
                
                for (index, value) in string.enumerated() {
                    let indexPath = IndexPath(row: self.sourceindexpath.row + index, section: destinationIndexPath.section)
                    self.dogarry.insert(value, at: indexPath.row)
                    indexPaths.append(indexPath)
                }
                self.catarry.remove(at: self.sourceindexpath.row)
                self.collectionviewB.reloadData()
                self.collectionviewA.insertItems(at: indexPaths)
            }
        }
        
    }

