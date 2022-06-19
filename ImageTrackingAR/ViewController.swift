//
//  ViewController.swift
//  ImageTrackingAR
//
//  Created by Kushagra Sharma on 17/06/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var image:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        
        // Set the scene to the view
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARPhotos", bundle: Bundle.main) else{
            
            print("No Images Available")
            return
        }
        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 2
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//        if let safeImage = trackedImages.first?.name{
//            image = safeImage
//        }
//
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
            if let safeImageName = imageAnchor.referenceImage.name{
                image = safeImageName
            }
            var plantScene = SCNScene()
            if let safePlantScene = SCNScene(named: "art.scnassets/\(image).scn"){
                plantScene = safePlantScene
            }
            let plantNode = plantScene.rootNode.childNodes.first!
            plantNode.position = SCNVector3Zero
//            plantNode.position.y = -0.05
            plantNode.position.z = 0.02
//            planeNode.eulerAngles.x = -.pi/2
            
            planeNode.addChildNode(plantNode)
            
        }
        return node
    }
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//
//            //1. If Out Target Image Has Been Detected Than Get The Corresponding Anchor
//            guard let currentImageAnchor = anchor as? ARImageAnchor else { return }
//
//            //2. Get The Targets Name
//            if let safeImageName = currentImageAnchor.referenceImage.name{
//                image = safeImageName
//            }
//
//
//            //3. Get The Targets Width & Height
//            let width = currentImageAnchor.referenceImage.physicalSize.width
//            let height = currentImageAnchor.referenceImage.physicalSize.height
//
//            //4. Log The Reference Images Information
//            print("""
//                Image name = \(image)
//                Image Width = \(width)
//                Image Height = \(height)
//                """)
//        }
}
