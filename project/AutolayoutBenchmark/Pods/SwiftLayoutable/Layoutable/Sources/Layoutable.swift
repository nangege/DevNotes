//
//  ConstraintAble.swift
//  Cassowary
//
//  Created by Tang,Nan(MAD) on 2018/4/2.
//  Copyright © 2018年 nange. All rights reserved.
//
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Cassowary

/// abstraction for constraint layout Item
/// any object conform to Layoutable can use constraint to caculate frame
public protocol Layoutable: class{

  var layoutManager: LayoutManager{ get }
  
  var superItem: Layoutable? { get }
  var subItems: [Layoutable]{ get }
  var layoutRect: CGRect { get set}
  
  /// like layoutSubviews in UIView
  /// this method will be called after layout pass
  /// frame of this item is determined
  func layoutSubItems()
  
  /// override point for add new constraint
  /// do not use this if not needed
  func updateConstraint()
  
  /// contentSize of node like,just like intrinsicContentSize in UIKit
  var itemIntrinsicContentSize: CGSize { get }
  
  /// contentSize of node, unlike intrinsicContentSize, this time width of node is determined
  /// this method is used to adjust height of this item
  /// such as text item, if numberOfLines is 0, we need maxWidth to determine number of lines and text height
  /// - Parameter maxWidth: maxWidth of this node
  /// - Returns: size of content
  func contentSizeFor(maxWidth: Value) -> CGSize
}

// public function
extension Layoutable{
  
  public var allConstraints: [LayoutConstraint]{
    return Array(layoutManager.installedConstraints) +  Array(layoutManager.pinedConstraints)
  }
  
  public var fixedWidth: Bool{
    set{ layoutManager.fixedWidth = fixedWidth }
    get{ return layoutManager.fixedWidth }
  }
  
  public var layoutNeedsUpdate: Bool{
    set{ layoutManager.layoutNeedsUpdate = newValue}
    get{ return layoutManager.layoutNeedsUpdate }
  }
  
  /// disable cassowary Layout Enginer
  /// - Parameter disable: if set to true, all cassowary related code will return immediately
  /// it is useful when you want to use cached frame to Layout node, rather than caculate again
  public func disableLayout(_ disable: Bool = true){
    layoutManager.enabled = !disable
    subItems.forEach{ $0.disableLayout(disable)}
  }
  
  /// just like layutIfNeeded in UIView
  /// call this method will caculate and update frame immediately
  /// be careful, don't call this if layout hierarchy is not ready
  public func layoutIfEnabled(){
    
    if !layoutManager.enabled{ return }
    
    let item = ancestorItem
    
    /// for newly added Layoutable object
    /// if item is added after a layout pass,we need to add constraints to solver
    if let solver = item.layoutManager.solver{
      item.updateSolverIfNeeded(solver)
    }else{
      let solver = LayoutEngine.solveFor(item)
      solver.autoSolve = false
      item.addConstraintsTo(solver)
      try? solver.solve()
      solver.autoSolve = true
    }
    item.layoutFirstPass()
    item.layoutSecondPass()
    updateLayout()
  }
  
  /// layout info of the current node hierarchy
  /// provide for case of layout cache
  public var layoutValues: LayoutValues{
    var cache = LayoutValues()
    if layoutManager.isConstraintValidRect{
      cache.frame = layoutManager.layoutRect
    }else{
      cache.frame = layoutRect
    }
    cache.subLayout = subItems.map{ $0.layoutValues }
    return cache
  }
  
  /// layout node hierarchy with frame
  ///
  /// - Parameter layout: layout hierarchy from this root node
  /// - make sure node hierarchy is exactly the same when you get this layoutValues
  public func apply(_ layout: LayoutValues){
    layoutRect = layout.frame
    for (index, node) in subItems.enumerated(){
      node.apply(layout.subLayout[index])
    }
  }
  
  
  /// used for cleaning constraints for removed item
  //  this function will remove all constraints for this item and it's subitems from current solver
  /// and break all constraints with item's supernode
  /// - Parameter item: item from which to break
  public func recursivelyReset(from item: Layoutable){
    layoutManager.solver = nil
    while let constraint = layoutManager.installedConstraints.popFirst() {
      constraint.remove()
      if let secondItem = constraint.secondAnchor?.item{
        if secondItem.ancestorItem === item{
          addConstraint(constraint)
          secondItem.layoutManager.pinedConstraints.insert(constraint)
        }
      }else{
        addConstraint(constraint)
      }
    }
    
    let pinnedToBeRemoved = layoutManager.pinedConstraints.filter{ $0.firstAnchor.item.ancestorItem !== item }
    pinnedToBeRemoved.forEach{ $0.remove() }
    subItems.forEach{ $0.recursivelyReset(from: item)}
  }
  
  public func setContentHuggingPriorty(for axis: LayoutAxis, priorty: LayoutPriority){
    switch axis {
    case .horizontal:
      layoutManager.contentSizeConstraints.xAxis.huggingPriorty = priorty
    case .vertical:
      layoutManager.contentSizeConstraints.yAxis.huggingPriorty = priorty
    }
  }
  
  public func contentHuggingPriorty(for axis: LayoutAxis) -> LayoutPriority{
    switch axis {
    case .horizontal:
      return layoutManager.contentSizeConstraints.xAxis.huggingPriorty
    case .vertical:
      return layoutManager.contentSizeConstraints.yAxis.huggingPriorty
    }
  }
  
  public func setContentCompressionPriorty(for axis: LayoutAxis, priorty: LayoutPriority){
    switch axis {
    case .horizontal:
      layoutManager.contentSizeConstraints.xAxis.compressionPriorty = priorty
    case .vertical:
      layoutManager.contentSizeConstraints.yAxis.compressionPriorty = priorty
    }
  }
  
  public func contentCompressionPriorty(for axis: LayoutAxis) -> LayoutPriority{
    switch axis {
    case .horizontal:
      return layoutManager.contentSizeConstraints.xAxis.compressionPriorty
    case .vertical:
      return layoutManager.contentSizeConstraints.yAxis.compressionPriorty
    }
  }
}

// MARK: - public property
extension Layoutable{
  public var left: XAxisAnchor{
    return XAxisAnchor(item: self, attribute: .left)
  }
  
  public var right: XAxisAnchor{
    return XAxisAnchor(item: self, attribute: .right)
  }
  
  public var top: YAxisAnchor{
    return YAxisAnchor(item: self, attribute: .top)
  }
  
  public var bottom: YAxisAnchor{
    return YAxisAnchor(item: self, attribute: .bottom)
  }
  
  public var width: DimensionAnchor{
    return DimensionAnchor(item: self, attribute:.width)
  }
  
  public var height: DimensionAnchor{
    return DimensionAnchor(item: self, attribute:.height)
  }
  
  public var centerX: XAxisAnchor{
    return XAxisAnchor(item: self, attribute: .centerX)
  }
  
  public var centerY: YAxisAnchor{
    return YAxisAnchor(item: self, attribute: .centerY)
  }
  
  public var size: SizeAnchor{
    return SizeAnchor(item: self)
  }
  
  public var center: PositionAnchor{
    return PositionAnchor(item: self, attributes: (.centerX,.centerY))
  }
  
  public var topLeft: PositionAnchor{
    return PositionAnchor(item: self, attributes: (.top,.left))
  }
  
  public var topRight: PositionAnchor{
    return PositionAnchor(item: self, attributes: (.top,.right))
  }
  
  public var bottomLeft: PositionAnchor{
    return PositionAnchor(item: self, attributes: (.bottom,.left))
  }

  public var bottomRight: PositionAnchor{
    return PositionAnchor(item: self, attributes: (.bottom,.right))
  }
  
  /// left and right
  public var xSide: XSideAnchor{
    return XSideAnchor(item: self)
  }
  
  /// top and bottom
  public var ySide: YSideAnchor{
    return YSideAnchor(item: self)
  }
  
  /// top, left, right, bottom
  public var edge: EdgeAnchor{
    return EdgeAnchor(item: self)
  }
  
}


// MARK: - internal function
extension Layoutable{
  
  func addConstraint(_ constraint: LayoutConstraint){
    layoutManager.addConstraint(constraint)
  }
  
  func removeConstraint(_ constraint: LayoutConstraint){
    layoutManager.removeConstraint(constraint)
  }
  
  func removeConstraints(_ constraints: [LayoutConstraint]){
    constraints.forEach {
      self.removeConstraint($0)
    }
  }
  
  /// find common super item with another LayoutItem
  /// - Parameter item: item to find common superNode with
  /// - Returns: first super node for self and node
  func commonSuperItem(with item: Layoutable?) -> Layoutable?{
    
    guard let item = item else{
      return self
    }
    
    // most common use case
    if superItem === item{
      return item
    }else if self === item || item.superItem === self{
      return self
    }else if superItem === item.superItem{
      return superItem
    }
    
    var depth1 = depth
    var depth2 = item.depth
    
    var superItem1: Layoutable = self
    var superItem2 = item
    
    while depth1 > depth2 {
      superItem1 = superItem1.superItem!
      depth1 -= 1
    }
    
    while depth2 > depth1 {
      superItem2 = superItem2.superItem!
      depth2 -= 1
    }
    
    while !(superItem1 === superItem2) {
      if superItem1.superItem == nil{
        return nil
      }
      superItem1 = superItem1.superItem!
      superItem2 = superItem2.superItem!
    }
    
    return superItem1
  }

}

// MARK: - private function
extension Layoutable{
  
  private var depth: Int{
    if let item = superItem{
      return item.depth + 1
    }else{
      return 1
    }
  }
  
  private func updateLayout(){
    // need to be optimized
    if layoutManager.isConstraintValidRect{
      layoutRect = layoutManager.layoutRect
    }
    subItems.forEach{ $0.updateLayout() }
  }
  
  private func addConstraintsTo(_ solver: SimplexSolver){
    layoutManager.addConstraintsTo(solver)
    subItems.forEach { $0.addConstraintsTo(solver) }
  }
  
  private var ancestorItem: Layoutable{
    if let superItem = superItem{
      return superItem.ancestorItem
    }
    return self
  }
  
  private func updateAllConstraint(){
    updateConstraint()
    layoutManager.updateConstraint()
  }
  
  private func updateSolverIfNeeded(_ solver: SimplexSolver){
    if layoutManager.solver !== solver{
      addConstraintsTo(solver)
      return
    }
    subItems.forEach{ $0.updateSolverIfNeeded(solver)}
  }
  
  private func layoutFirstPass(){
    if layoutNeedsUpdate{
      if !layoutManager.translateRectIntoConstraints{
        var size = CGSize(width: InvalidIntrinsicMetric, height: 0)
        if !layoutManager.fixedWidth{
          size = itemIntrinsicContentSize
        }
        layoutManager.updateSize(size)
      }
    }else if layoutManager.isRectConstrainted{
      layoutManager.updateRect(layoutRect)
      /// a little weird here, when update size or origin,some constraints will be add to this item
      /// this item's translateRectIntoConstraints will be set to false
      /// correct it here. need a better way.
      layoutManager.translateRectIntoConstraints = true
    }
    updateAllConstraint()
    subItems.forEach { $0.layoutFirstPass() }
  }
  
  /// second layout pass is used to adjust contentSize height
  /// such as TextNode,at this time ,width for textNode is determined
  /// so we can know how manay lines this text should have
  private func layoutSecondPass(){
    if layoutManager.sizeNeedsUpdate && !layoutManager.translateRectIntoConstraints{
      var size = contentSizeFor(maxWidth: layoutManager.layoutRect.size.width)
      if layoutManager.fixedWidth{
        size = CGSize(width: InvalidIntrinsicMetric, height: size.height)
      }
      
      if size != InvaidIntrinsicSize{
        layoutManager.updateSize(size)
      }
    }
    
    subItems.forEach{ $0.layoutSecondPass()}
    layoutNeedsUpdate = false
  }
  
}
