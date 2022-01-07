//
//  ViewController.swift
//  Project27
//
//  Created by User on 02.01.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageViewRaw: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }

    @IBAction func RedRawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 6{
            currentDrawType = 0
        }
        
        switch currentDrawType{
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatingSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawStar()
        default:
            break
        }
    }
    func drawRectangle(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image {ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageViewRaw.image = image
    }
    func drawCircle(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image {ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageViewRaw.image = image
    }
    func drawCheckerBoard(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image {ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0..<8{
                for col in 0..<8{
                    if (row + col).isMultiple(of: 2){
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
            
        }
        imageViewRaw.image = image
        
    }
    
    func drawRotatingSquares(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image {ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotation = 32
            let amount = Double.pi/Double(rotation)
            
            for _ in 0..<rotation{
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
        }
        imageViewRaw.image = image
        
    }
    func drawLines(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image {ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var lenght:CGFloat = 256
            
            for _ in 0..<256{
                ctx.cgContext.rotate(by: .pi/2)
                
                if first{
                    ctx.cgContext.move(to: CGPoint(x: lenght, y: 50))
                    first = false
                }else{
                    ctx.cgContext.addLine(to: CGPoint(x: lenght, y: 50))
                }
                lenght *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageViewRaw.image = image
        
    }
    
    func drawImagesAndText(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image {ctx in
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key:Any] = [
                .font:UIFont.systemFont(ofSize: 36),
                .paragraphStyle:paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributerString = NSAttributedString(string: string, attributes: attrs)
            attributerString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        imageViewRaw.image = image
        
    }
    
    func drawStar(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image {ctx in
            ctx.cgContext.translateBy(x: 256, y: 270)
            
            ctx.cgContext.move(to: radiusStar(radius: 94, ang: 0))
            
            for _ in 1...5{
                let starPoints = CGFloat(5)
                ctx.cgContext.addLine(to: radiusStar(radius: 245, ang: .pi * 2/(starPoints * 2)))
                ctx.cgContext.addLine(to: radiusStar(radius: 94, ang: .pi * 2/(starPoints)))
                
                ctx.cgContext.rotate(by: -(.pi * 2/(starPoints)))
            }
            
            ctx.cgContext.closePath()
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setLineJoin(.round)
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        imageViewRaw.image = image
    }
    
    func radiusStar(radius:CGFloat, ang:CGFloat) ->CGPoint{
        return CGPoint(x: radius * sin(ang), y: radius * cos(ang))
    }
}

