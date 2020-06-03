// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// A type that can be converted to and from its structural representation.
public protocol Structural {
    /// A structural representation for `Self`.
    associatedtype StructuralRepresentation

    /// Creates an instance from the given structural representation.
    init(structuralRepresentation: StructuralRepresentation)

    /// A structural representation of `self`.
    var structuralRepresentation: StructuralRepresentation { get }
}

/// Structural representation of a heterogeneous list cons cell.
public struct StructuralCons<Value, Next> {
    public var value: Value
    public var next: Next

    public init(_ value: Value, _ next: Next) {
        self.value = value
        self.next = next
    }
}

/// Structural representation of an empty heterogeneous list cons cell.
public struct StructuralEmpty {
    public init() {}
}
