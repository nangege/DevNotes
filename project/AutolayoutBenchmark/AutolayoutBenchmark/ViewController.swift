//
//  ViewController.swift
//  AutolayoutBenchmark
//
//  Created by nangezao on 2018/10/17.
//  Copyright © 2018 Tang Nan. All rights reserved.
//

import UIKit
import Panda
import Layoutable

struct LayoutData {
  var left: CGFloat = 0
  var top: CGFloat = 0
  var leftIndex: Int = 0
  var rightIndex = 0
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    measureTime {
      nodeLayout(150)
      autoLayout(150)
    }
    for count in [5,10,20,30,40,50,60,70,80,90,100]{
      
      print("ViewCount: \(count)")
      
      let datas:[LayoutData] =  (1..<(count + 1)).map{  LayoutData(left: CGFloat(arc4random()%20),
                                                                   top: CGFloat(arc4random()%20),
                                                                   leftIndex: Int(arc4random()/2)%$0,
                                                                   rightIndex: Int(arc4random()/2)%$0)}
      
      var nodeConstraints =  [LayoutConstraint]()
      var appleConstraints = [NSLayoutConstraint]()
      var inWindowAppleConstraints = [NSLayoutConstraint]()
      var systemSizeFitConstraints = [NSLayoutConstraint]()
      var systemSizeFitInWindowConstraints = [NSLayoutConstraint]()
      
      var node = ViewNode ()
      var layoutView = UIView()
      var inWindowLayoutView = UIView()
      var systemSizeFitView = UIView()
      var systemSizeFitInWindowView = UIView()
      
      let constants = (0..<count*2).map{ _ in return CGFloat(arc4random()%20) }
      
      measureTime(desc: "Autolayout") {
        (layoutView, appleConstraints) = autoLayout(count,datas: datas)
      }

      measureTime(desc: "InWindow Autolayout") {
        (inWindowLayoutView, inWindowAppleConstraints) = autolayoutInWindow(count,datas: datas)
      }

      measureTime(desc: "systemSizeFit") {
        (systemSizeFitView, systemSizeFitConstraints) = systemSizeFitAutoLayout(count,datas: datas)
      }

      measureTime(desc: "InWindow systemSizeFit") {
        (systemSizeFitInWindowView, systemSizeFitInWindowConstraints) = systemSizeFitInWindowAutoLayout(count,datas: datas)
      }

      measureTime(desc: "Panda Layout") {
        (node,nodeConstraints) = nodeLayout(count,datas: datas)
      }

      measureTime(desc: "Apple Nestlayout") {
        nestAutoLayout(count)
      }
      
      measureTime(desc: "Panda NestLayout") {
        nestNode(count)
      }
      
      measureTime(desc: "Node constant") {
        zip(nodeConstraints, constants).forEach({ (constraint,constant) in
          constraint.constant = constant
        })
        node.layoutIfEnabled()
      }
      
      measureTime(desc: "Apple constant") {
        zip(appleConstraints, constants).forEach({ (constraint,constant) in
          constraint.constant = constant
        })

        layoutView.setNeedsLayout()
        layoutView.layoutIfNeeded()
      }

      measureTime(desc: "Apple In Window constant") {
        zip(inWindowAppleConstraints, constants).forEach({ (constraint,constant) in
          constraint.constant = constant
        })

        inWindowLayoutView.setNeedsLayout()
        inWindowLayoutView.layoutIfNeeded()
      }

      measureTime(desc: "SystemFitSize constant") {
        zip(systemSizeFitConstraints, constants).forEach({ (constraint,constant) in
          constraint.constant = constant
        })

        systemSizeFitView.setNeedsLayout()
        systemSizeFitView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      }

      measureTime(desc: "SystemFitSize In Window constant") {
        zip(systemSizeFitInWindowConstraints, constants).forEach({ (constraint,constant) in
          constraint.constant = constant
        })

        systemSizeFitInWindowView.setNeedsLayout()
      systemSizeFitInWindowView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      }
      
      print("=============================================")
      print("")
    }
  }
  
  func nestNode(_ viewCount: Int = 100) {
    let node = ViewNode()
    var nodes = [ViewNode]()
    node.size == (640,480)

    for index in 0..<viewCount{
      var superNode = node
      if nodes.count > 0{
        superNode = nodes[index - 1]
      }
      let newNode = ViewNode()
      superNode.addSubnode(newNode)
      newNode.edge == superNode.edge.insets((1,1,1,1))
      nodes.append(newNode)
    }
    node.disableAutoUpdate(true)
    node.layoutIfEnabled()
//    node.logRect()
  }
  
  @discardableResult
  func nodeLayout(_ viewCount: Int = 100,datas: [LayoutData] = []) -> (ViewNode,[LayoutConstraint]){
    var constraints = [LayoutConstraint]()
    let node = ViewNode()
    var nodes = [ViewNode]()
    node.size == (320.0,640.0)
    for index in 0..<viewCount{
      var leftNode = node
      var rightNode = node
      if nodes.count != 0{
        if datas.isEmpty{
          let left = Int(arc4random()/2)%nodes.count
          let right = Int(arc4random()/2)%nodes.count
          leftNode = nodes[left]
          rightNode = nodes[right]
        }else{
          leftNode = nodes[datas[index - 1].leftIndex]
          rightNode = nodes[datas[index - 1].rightIndex]
        }
      }
      
      let newNode = ViewNode()
      node.addSubnode(newNode)
      
      newNode.left >= node.left
      newNode.right <= node.right
      
      newNode.top >= node.top + 20
      newNode.bottom <= node.bottom - 20
      
      var c1: LayoutConstraint!
      var c2: LayoutConstraint!
      if datas.isEmpty{
        c1 = newNode.left == leftNode.left + CGFloat(arc4random()%20) ~ .strong
        c2 = newNode.top == rightNode.top + CGFloat(arc4random()%20) ~ .strong
      }else{
        c1 = newNode.left == leftNode.left + datas[index].left ~ .strong
        c2 = newNode.top == rightNode.top + datas[index].top ~ .strong
      }
      
      constraints.append(c1)
      constraints.append(c2)
      nodes.append(newNode)
    }
    node.disableAutoUpdate(true)
    node.layoutIfEnabled()
    return (node,constraints)
  }
  
  func pureAutolayout(_ viewCount: Int = 100,datas: [LayoutData] = []) -> (UIView,[NSLayoutConstraint]){
    let node = UIView()
    node.translatesAutoresizingMaskIntoConstraints = false
    var nodes = [UIView]()
    var constraints = [NSLayoutConstraint]()
    node.widthAnchor.constraint(equalToConstant: 320).isActive = true
    node.heightAnchor.constraint(equalToConstant: 640).isActive = true
    
    for index in 0..<viewCount{
      var leftNode: UIView = node
      var rightNode: UIView = node
      if nodes.count != 0{
        if !datas.isEmpty{
          leftNode = nodes[datas[index - 1].leftIndex]
          rightNode = nodes[datas[index - 1].rightIndex]
        }else{
          let left = Int(arc4random()/2)%nodes.count
          let right = Int(arc4random()/2)%nodes.count
          leftNode = nodes[left]
          rightNode = nodes[right]
        }
      }
      
      let newNode = UIView()
      newNode.translatesAutoresizingMaskIntoConstraints = false
      node.addSubview(newNode)
      
      NSLayoutConstraint.activate([
        newNode.leftAnchor.constraint(greaterThanOrEqualTo:node.leftAnchor , constant: 0),
        newNode.rightAnchor.constraint(lessThanOrEqualTo: node.rightAnchor),
        
        newNode.topAnchor.constraint(greaterThanOrEqualTo: node.topAnchor, constant: 20),
        newNode.bottomAnchor.constraint(lessThanOrEqualTo: node.bottomAnchor,constant: -20)])
      
      var c1: NSLayoutConstraint!
      var c2: NSLayoutConstraint!
      if !datas.isEmpty{
        c1 = newNode.leftAnchor.constraint(equalTo: leftNode.leftAnchor,constant: datas[index].left)
        c2 = newNode.topAnchor.constraint(equalTo: rightNode.topAnchor, constant: datas[index].top)
      }else{
        c1 = newNode.leftAnchor.constraint(equalTo: leftNode.leftAnchor,constant: CGFloat(arc4random()%20))
        c2 = newNode.topAnchor.constraint(equalTo: rightNode.topAnchor, constant: CGFloat(arc4random()%20))
      }
      
      c1.priority = .defaultHigh
      c2.priority = .defaultHigh
      constraints.append(c1)
      constraints.append(c1)
      NSLayoutConstraint.activate([c1,c2])
      
      nodes.append(newNode)
    }
    return (node,constraints)
  }
  
  @discardableResult
  func autoLayout(_ viewCount: Int = 100,datas: [LayoutData] = []) -> (UIView,[NSLayoutConstraint]){
    let (node, constraints) = pureAutolayout(viewCount,datas: datas)
    node.layoutIfNeeded()
    return (node,constraints)
  }
  
  @discardableResult func autolayoutInWindow(_ viewCount: Int,datas: [LayoutData] = []) -> (UIView,[NSLayoutConstraint]){
    let (node, constraints) = pureAutolayout(viewCount,datas: datas)
    UIApplication.shared.delegate?.window??.addSubview(node)

    node.layoutIfNeeded()
    return (node,constraints)
  }
  
  @discardableResult
  func systemSizeFitAutoLayout(_ viewCount: Int = 100,datas: [LayoutData] = []) -> (UIView,[NSLayoutConstraint]){
    let (node, constraints) = pureAutolayout(viewCount,datas: datas)
    node.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    return (node,constraints)
  }
  
  @discardableResult
  func systemSizeFitInWindowAutoLayout(_ viewCount: Int = 100,datas: [LayoutData] = []) -> (UIView,[NSLayoutConstraint]){
    let (node, constraints) = pureAutolayout(viewCount,datas: datas)
    UIApplication.shared.delegate?.window??.addSubview(node)
    node.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    return (node,constraints)
  }
  
  func nestAutoLayout(_ viewCount: Int = 100) {
    
    var nodes = [UIView]()
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    container.widthAnchor.constraint(equalToConstant: 640).isActive = true
    container.heightAnchor.constraint(equalToConstant: 480).isActive = true

    for index in 0..<viewCount{
      var superNode = container
      if nodes.count != 0{
        superNode = nodes[index - 1]
      }
      let node = UIView()
      superNode.addSubview(node)
      node.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        node.leftAnchor.constraint(equalTo:superNode.leftAnchor , constant: 1),
        node.rightAnchor.constraint(equalTo: superNode.rightAnchor, constant: -1),
        
        node.topAnchor.constraint(equalTo: superNode.topAnchor, constant: 1),
        node.bottomAnchor.constraint(equalTo: superNode.bottomAnchor,constant: -1)])
      
      nodes.append(node)
    }
    container.layoutIfNeeded()
  }

}

extension Layoutable{
  func logRect(){
    print(layoutRect)
    subItems.forEach { $0.logRect()}
  }
}

@discardableResult func measureTime(desc: String? = nil,action:()->()) -> Double{
  let renderStart = CFAbsoluteTimeGetCurrent()
  action()
  let renderEnd = CFAbsoluteTimeGetCurrent()
  let renderTime = (renderEnd - renderStart)*100000/100
  if let desc = desc{
    print("\(desc) : \(renderTime)")
  }
  return renderTime
}

