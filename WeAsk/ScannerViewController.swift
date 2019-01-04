import UIKit
import WeScan
import SwiftyTesseract

class ScannerViewController: UIViewController {
    
    var questions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onAddButtonTapped(_ sender: UIBarButtonItem) {
        let scannerVC = ImageScannerController()
        scannerVC.imageScannerDelegate = self
        present(scannerVC, animated: true)
    }
}

extension ScannerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionTableViewCell
        cell.questionTextView.text = questions[indexPath.row]
        return cell
    }
}

extension ScannerViewController: ImageScannerControllerDelegate {

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        let swiftyTesseract = SwiftyTesseract(language: .english)
        swiftyTesseract.performOCR(on: results.scannedImage) { recognizedString in
            guard let recognizedString = recognizedString else { return }
            let question = recognizedString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                .replacingOccurrences(of: "\n", with: " ")
            scanner.dismiss(animated: true, completion: {
                let editQuestionVC = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "EditQuestionVC") as! EditQuestionViewController
                editQuestionVC.question = question
                self.present(editQuestionVC, animated: true)
            })
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }

}
