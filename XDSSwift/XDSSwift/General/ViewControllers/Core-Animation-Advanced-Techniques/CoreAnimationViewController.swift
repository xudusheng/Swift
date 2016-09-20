//
//  CoreAnimationViewController.swift
//  XDSSwift
//
//  Created by zhengda on 16/7/26.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit
import GLKit
class CoreAnimationViewController: XDSRootViewController {
    var secondPointer:UIView?;
    var minutePointer:UIView?;
    var hourPointer:UIView?;
    var timer:Timer?;
    
    @IBOutlet weak var browView: UIView!
    @IBOutlet weak var subView1: UIView!
    @IBOutlet weak var subView2: UIView!
    @IBOutlet var cubeContentView: UIView!
    @IBOutlet var faces: [UIView]!
    let cubeWidth = 100;
    
    let LIGHT_DIRECTION =  GLKVector3Make(0, 1, -0.5);
    let AMBIENT_LIGHT:Float = 0.5;
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        self.timer?.invalidate();
        self.timer = nil;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swiftRootTableViewControllerDataInit();
        self.createSwiftRootTableViewControllerUI();
    }

    //MARK: - UI相关
    func createSwiftRootTableViewControllerUI(){
//        self.mapImage();
//        self.createClock();
//        self .createCubeUI();
//        self.createMatchstick();
        self.createFlameBlast();
    }
    
    //TODO:火焰爆炸（CAEmitterLayer）
    func createFlameBlast() -> Void {
        self.view.addSubview(self.cubeContentView);
//        self.cubeContentView.snp_makeConstraints { (make) in
//            make.center.equalTo(self.view.snp_center);
//            make.left.equalTo(20);
//            make.height.equalTo(self.cubeContentView.snp_width);
//        }
        //create particle emitter layer
        let emitter = CAEmitterLayer();
        emitter.frame = self.cubeContentView.bounds;
        self.cubeContentView.layer.addSublayer(emitter);
        //configure emitter
        emitter.renderMode = kCAEmitterLayerAdditive;
        emitter.emitterPosition = CGPoint(x: emitter.frame.size.width / 2.0, y: emitter.frame.size.height / 2.0);
        //create a particle template
        let cell = CAEmitterCell();
        cell.contents = UIImage(named: "snowman")?.cgImage;
        cell.birthRate = 150;
        cell.lifetime = 5.0;
        cell.color = UIColor(red: 1, green: 0.5, blue: 0.1, alpha: 1.0).cgColor;
        cell.alphaSpeed = -0.4;
        cell.velocity = 50;
        cell.velocityRange = 50;
        cell.emissionRange = CGFloat(M_PI) * 2.0;
        //add particle template to emitter
        emitter.emitterCells = [cell];
    }
    //TODO:火柴人（CAShapeLayer + UIBezierPath）
    func createMatchstick() -> Void {
        self.view.addSubview(self.cubeContentView);
//        self.cubeContentView.snp_makeConstraints { (make) in
//            make.center.equalTo(self.view.snp_center);
//            make.left.equalTo(20);
//            make.height.equalTo(self.cubeContentView.snp_width);
//        }
        
        //create path
        let path = UIBezierPath();
        path.move(to: CGPoint(x:75, y:100));
        path.addArc(withCenter: CGPoint(x:150, y:100), radius: 25, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true);
        path.move(to: CGPoint(x:150, y:125));
        path.addLine(to: CGPoint(x:150, y:175));
        path.addLine(to: CGPoint(x:125, y:225));
        path.move(to: CGPoint(x:150, y:175));
        path.addLine(to: CGPoint(x:175, y:225));
        path.move(to: CGPoint(x:100, y:150));
        path.addLine(to: CGPoint(x:200, y:150));
        //create shape layer
        let shapeLayer = CAShapeLayer();
        shapeLayer.strokeColor = UIColor.red.cgColor;
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.path = path.cgPath;
        //add it to our view
        self.cubeContentView.layer.addSublayer(shapeLayer);
    }
    //TODO:创建正方体（CATransform3D平移与选择）
    func createCubeUI() -> Void{
        self.view.addSubview(self.cubeContentView);
//        self.cubeContentView.snp_makeConstraints { (make) in
//            make.center.equalTo(self.view.snp_center);
//            make.left.equalTo(20);
//            make.height.equalTo(self.cubeContentView.snp_width);
//        }
        self .addFace(index: 0, transform: CATransform3DIdentity);
        //set up the container
        var perspective = CATransform3DIdentity;
        perspective.m34 = -1.0 / 500.0;
        self.cubeContentView.layer.sublayerTransform = perspective;
        //add cube face 1
        var transform = CATransform3DMakeTranslation(0, 0, CGFloat(cubeWidth/2));
        self.addFace(index: 0, transform: transform);
        //add cube face 2
        transform = CATransform3DMakeTranslation(CGFloat(cubeWidth/2), 0, 0);
        transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 0, 1, 0);
        self.addFace(index: 1, transform: transform);
        //add cube face 3
        transform = CATransform3DMakeTranslation(0, -CGFloat(cubeWidth/2), 0);
        transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 1, 0, 0);
        self.addFace(index: 2, transform: transform);
        //add cube face 4
        transform = CATransform3DMakeTranslation(0, CGFloat(cubeWidth/2), 0);
        transform = CATransform3DRotate(transform, CGFloat(-M_PI_2), 1, 0, 0);
        self.addFace(index: 3, transform: transform);
        //add cube face 5
        transform = CATransform3DMakeTranslation(-CGFloat(cubeWidth/2), 0, 0);
        transform = CATransform3DRotate(transform, CGFloat(-M_PI_2), 0, 1, 0);
        self.addFace(index: 4, transform: transform);
        //add cube face 6
        transform = CATransform3DMakeTranslation(0, 0, -CGFloat(cubeWidth/2));
        transform = CATransform3DRotate(transform, CGFloat(M_PI), 0, 1, 0);
        self.addFace(index: 5, transform: transform);
        
        perspective = CATransform3DRotate(perspective, CGFloat(-M_PI_4), 1, 0, 0);
        perspective = CATransform3DRotate(perspective, CGFloat(-M_PI_4), 0, 1, 0);
        self.cubeContentView.layer.sublayerTransform = perspective;
        
        
    }
    
    func addFace(index:Int, transform:CATransform3D) -> Void {
        let face = self.faces[index];
        self.cubeContentView.addSubview(face);
        
//        face.snp_makeConstraints(closure: { (make) in
//            make.center.equalTo(self.cubeContentView.snp_center);
//            make.height.equalTo(cubeWidth)
//            make.width.equalTo((face.snp_height));
//        })
        face.layer.transform = transform;
        self.addLightToFace(faceLayer: face.layer);//光亮和投影
    }
    
    //TODO:层的透视参数m34
    func perspectiveUI() -> Void {
        //        var transform = CGAffineTransformIdentity;
        //        print("\(transform)");
        //        transform.c = 0.5;
        //        self.browView.layer.setAffineTransform(transform);
        //        print("\(transform)");
        
        var transform3D = CATransform3DIdentity;
        transform3D.m34 = -1.0/500.0;//设置透视
        //        transform3D = CATransform3DRotate(transform3D, CGFloat(M_PI_4), 0, 1, 0);
        //        self.browView.layer.transform = transform3D;
        
        self.browView.layer.sublayerTransform = transform3D;
        let transform3D1 = CATransform3DRotate(transform3D, CGFloat(M_PI_4), 0, 1, 0);
        self.subView1.layer.transform = transform3D1;
        self.subView2.layer.transform = transform3D1;
    }
    
    //TODO:时钟
    func createClock() -> Void {
        let clock = UIView(frame: CGRect(x:0, y:0, width:300, height:300));
        clock.center = self.view.center;
        clock.backgroundColor = UIColor.red;
        self.view.addSubview(clock);
        let clockCenter = CGPoint(x:clock.frame.width/2, y:clock.frame.height/2);
        var center = clockCenter;
        self.hourPointer = UIView(frame: CGRect(x:0, y:0, width:20, height:80));
        self.hourPointer?.backgroundColor = UIColor.blue;
        self.hourPointer?.center = center;
        self.hourPointer?.layer.anchorPoint = CGPoint(x:0.5, y:1);
        clock.addSubview(self.hourPointer!);
        
        center = clockCenter;
        self.minutePointer = UIView(frame: CGRect(x:0, y:0, width:16, height:100));
        self.minutePointer?.backgroundColor = UIColor.brown;
        self.minutePointer?.center = center;
        self.minutePointer?.layer.anchorPoint = CGPoint(x:0.5, y:1);
        clock.addSubview(self.minutePointer!);
        
        center = clockCenter;
        self.secondPointer = UIView(frame: CGRect(x:0, y:0, width:12, height:120));
        self.secondPointer?.backgroundColor = UIColor.green;
        self.secondPointer?.center = center;
        self.secondPointer?.layer.anchorPoint = CGPoint(x:0.5, y:1);
        clock.addSubview(self.secondPointer!);
        self.hourPointer?.layer.zPosition = 1.0;
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CoreAnimationViewController.clockCountDown), userInfo: nil, repeats: true);
        self.clockCountDown();
    }
    //TODO:为layer写图片
    func mapImage() -> Void {
        let layerView = UIView(frame: CGRect(x:0, y:0, width:200, height:200));
        layerView.backgroundColor = UIColor.brown;
        layerView.center = self.view.center;
        self.view.addSubview(layerView);
        
        let snowmanImage:UIImage! = UIImage(named: "snowman");
        layerView.layer.contents = snowmanImage.cgImage;
        layerView.layer.contentsGravity = kCAGravityCenter;
        layerView.layer.contentsScale = snowmanImage.scale;

        /* The identity transform: [ 1 0 0 1 0 0 ]. */
        //        var transforms = CGAffineTransformIdentity;
        var transforms = __CGAffineTransformMake(1, 0, 0, 1, 0, 0);
//        transforms = CGAffineTransformScale(transforms, 0.5, 0.5);//缩放
//        transforms = CGAffineTransformTranslate(transforms, 200, 0);//平移
//        transforms = CGAffineTransformRotate(transforms, CGFloat(M_PI_4));//旋转
        
        //斜切
        transforms.c = -1;
        transforms.b = 0;
        
        layerView.layer.setAffineTransform(transforms);

        
//        let mapImage = UIImage(named: "map.bmp");
//        layerView.layer.contents = mapImage?.CGImage;
//        layerView.layer.contentsGravity = kCAGravityResizeAspect;
//        layerView.layer.contentsRect = CGRectMake(0.5, 0.5, 0.5, 0.5);
    }
    
    
    //MARK: - 代理方法

    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    func clockCountDown() -> Void {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!;
        let units:NSCalendar.Unit = [.hour, .minute, .second]
        let components = calendar.components(units, from: Date());
        let secAngle = Double(components.second!) / 60.0 * M_PI * 2.0;
        let minsAngle = (Double(components.minute!) + Double(components.second!) / 60.0) / 60.0 * M_PI * 2.0;
        let hoursAngle = (Double(components.hour!) + Double(components.minute!) / 60.0) / 12.0 * M_PI * 2.0;

        print("\(hoursAngle)===\(minsAngle)===\(secAngle)")
        self.hourPointer!.transform = CGAffineTransform(rotationAngle: CGFloat(hoursAngle));
        self.minutePointer!.transform = CGAffineTransform(rotationAngle: CGFloat(minsAngle));
        self.secondPointer!.transform = CGAffineTransform(rotationAngle: CGFloat(secAngle));
    }
    //MARK: - 其他私有方法
    //TODO:光亮和投影
    func addLightToFace(faceLayer:CALayer) -> Void {
        //add lighting layer
        let layer = CALayer();
        layer.frame = faceLayer.bounds;
        faceLayer.addSublayer(layer);
        //convert the face transform to matrix
        //(GLKMatrix4 has the same structure as CATransform3D)
        let transform = faceLayer.transform;
        let matrix4 = self.convertCATransform3D_To_GLKMatrix4(transform: transform);
        let matrix3 = GLKMatrix4GetMatrix3(matrix4);
        //get face normal
        var normal = GLKVector3Make(0, 0, 1);
        normal = GLKMatrix3MultiplyVector3(matrix3, normal);
        normal = GLKVector3Normalize(normal);
        //get dot product with light direction
        let light = GLKVector3Normalize(LIGHT_DIRECTION);
        let dotProduct = GLKVector3DotProduct(light, normal);
        //set lighting layer opacity
        let shadow = 1 + dotProduct - AMBIENT_LIGHT;
        let color = UIColor(white: 0, alpha: CGFloat(shadow));
        layer.backgroundColor = color.cgColor;
    }

    
    func convertCATransform3D_To_GLKMatrix4(transform:CATransform3D) -> GLKMatrix4 {
        let matrix = GLKMatrix4Make(Float(transform.m11), Float(transform.m12), Float(transform.m13), Float(transform.m14),
                                    Float(transform.m21), Float(transform.m22), Float(transform.m23), Float(transform.m24),
                                    Float(transform.m31), Float(transform.m32), Float(transform.m33), Float(transform.m34),
                                    Float(transform.m41), Float(transform.m42), Float(transform.m43), Float(transform.m44));
        
        return matrix;
    }
    //MARK: - 内存管理相关
    func swiftRootTableViewControllerDataInit(){
        
    }

    
}
