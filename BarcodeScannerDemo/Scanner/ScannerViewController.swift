// source: https://www.hackingwithswift.com/example-code/media/how-to-scan-a-barcode

import AVFoundation
import UIKit

class ScannerViewController: UIViewController {
    
    private var scannerView: ScannerView?
    private var overlayView: OverlayView?
    private var codeLabel: UILabel = UILabel()
    private var scannedCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        let vcBounds = view.bounds
        let scanArea = calculateScanArea(from: vcBounds)
        
        scannerView = ScannerView(frame: vcBounds, scanArea: scanArea)
        view.addSubview(scannerView!)
        scannerView?.delegate = self
        
        overlayView = OverlayView(frame: vcBounds, maskRect: scanArea)
        view.addSubview(overlayView!)
        
        overlayView?.closeButton.addTarget(self, action: #selector(close), for: UIControl.Event.touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scannerView?.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scannerView?.stopRunning()
    }
    
    func calculateScanArea(from rect: CGRect) -> CGRect {
        let x = rect.minX + 30
        let y = rect.maxY / 3
        let width = rect.width - 60
        let height = rect.height / 3
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Styling
extension ScannerViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - ScannerViewDelegate
extension ScannerViewController: ScannerViewDelegate {
    func scannerViewDidFoundBarCode(_ scannerView: ScannerView, code: String) {
        scannedCode = code
        
        performSegue(withIdentifier: "goToResults", sender: self)
    }
}


// MARK: - Transition
extension ScannerViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults", let destinationVC = segue.destination as? ResultsViewController {
            destinationVC.codeToDisplay = scannedCode
        }
    }
}
