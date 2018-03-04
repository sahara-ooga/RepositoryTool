//
//  RepositoryTool.swift
//  RepositoryTool
//
//  Created by yogasawara@stv on 2018/03/04.
//  Copyright © 2018年 sunday carpenter. All rights reserved.
//

//: inspired by [Introducing repository pattern with swift.](https://gist.github.com/omayib/9f515b6d5a72802bc2e07673788a308d)

// MARK: Repository
public protocol Repository {
    associatedtype Element:RepositoryElement
}

public protocol SyncRepository:Repository{
    func find(of id:Element.Identifier) -> Element?
    func findAll(query:Query?) -> [Element]
    @discardableResult func save(_ elements:[Element]) -> Bool
    @discardableResult func delete(_ elements:[Element]) -> Bool
}

public protocol AsyncRepository:Repository{
    associatedtype DomainError:Error
    
    typealias SingleCompletion = (Result<Element?,DomainError>) -> Void
    typealias PluralCompletion = (Result<[Element],DomainError>) -> Void
    
    func find(of id:Element.Identifier, completion:SingleCompletion)
    func findAll(query:Query?, completion:PluralCompletion)
    func save(_ elements:[Element], completion:PluralCompletion)
    func delete(_ elements:[Element], completion:PluralCompletion)
}

// MARK: SortableRepository
public protocol SortableSyncRepository:SyncRepository where Element:ComparableRepositoryElement{
    func findAll(query:Query?, sort:Sort?) -> Bool
    @discardableResult func save(_ elements:[Element], sort:Sort?) -> Bool
}

public protocol SortableAsyncRepository:AsyncRepository where Element:ComparableRepositoryElement{
    func findAll(query:Query?, sort:Sort?, completion: PluralCompletion)
    func save(_ elements:[Element], sort:Sort?, completion:PluralCompletion)
}

//MARK: Repository Reference Util
public protocol RepositoryElement{
    associatedtype Identifier
    
    var id:Identifier {get}
}

public protocol ComparableRepositoryElement:RepositoryElement where Identifier: Comparable{
    
}

public enum Result<Element,SomeError:Error>{
    case success(Element)
    case failure(SomeError)
}

// Mark:Find Condition
//ToDo: Queryの満たすべき条件を考える
public protocol Query{ }

//ToDo: Sortの満たすべき条件を考える
public protocol Sort{ }

