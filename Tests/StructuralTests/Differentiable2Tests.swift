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

import Dispatch
import XCTest

@testable import StructuralCore
@testable import StructuralExamples

extension Point3: Differentiable2 {
    public typealias TangentVector = StructuralRepresentation.TangentVector
}

struct LabeledPoint3 {
    @NoDerivative
    var label: String
    var value: Point3

    init(_ label: String, _ value: Point3) {
        self.label = label
        self.value = value
    }
}

extension LabeledPoint3: Structural {
    public typealias StructuralRepresentation =
        StructuralStruct<
            LabeledPoint3,
            StructuralCons<
                StructuralProperty<LabeledPoint3, String, NoDerivative<String>>,
                StructuralCons<
                    StructuralProperty<LabeledPoint3, Point3, Point3>,
                    StructuralEmpty
                >
            >
        >

    // swift-format-ignore
    public var structuralRepresentation: StructuralRepresentation {
        get {
            return StructuralStruct(LabeledPoint3.self,
                StructuralCons(StructuralProperty(\LabeledPoint3.label, "label", NoDerivative(wrappedValue: label)),
                    StructuralCons(StructuralProperty(\LabeledPoint3.value, "value", value),
                        StructuralEmpty()
                    )
                )
            )
	    }
	    set {
	        self.label = newValue.properties.value.value.wrappedValue
	        self.value = newValue.properties.next.value.value
	    }
    }

    public init(structuralRepresentation: StructuralRepresentation) {
        self.label = structuralRepresentation.properties.value.value.wrappedValue
        self.value = structuralRepresentation.properties.next.value.value
    }
}

extension LabeledPoint3: Differentiable2 {
    public typealias TangentVector = StructuralRepresentation.TangentVector
}

final class Differentiable2Tests: XCTestCase {
    func testPoint3() {
        let direction: Point3.TangentVector =
            DifferentiableCons(
                1, DifferentiableCons(2, DifferentiableCons(3, DifferentiableEmpty())))

        var point = Point3(_1: 10, _2: 20, _3: 30)
        point.move(along: direction)
        XCTAssertEqual(point._1, 11)
        XCTAssertEqual(point._2, 22)
        XCTAssertEqual(point._3, 33)
    }

    func testLabeledPoint3() {
        let direction: Point3.TangentVector =
            DifferentiableCons(
                1, DifferentiableCons(2, DifferentiableCons(3, DifferentiableEmpty())))
        let labeledDirection: LabeledPoint3.TangentVector =
            DifferentiableCons(
                DifferentiableEmpty(), DifferentiableCons(direction, DifferentiableEmpty()))

        var labeledPoint = LabeledPoint3("mylabel", Point3(_1: 10, _2: 20, _3: 30))
        labeledPoint.move(along: labeledDirection)
        XCTAssertEqual(labeledPoint.label, "mylabel")
        XCTAssertEqual(labeledPoint.value._1, 11)
        XCTAssertEqual(labeledPoint.value._2, 22)
        XCTAssertEqual(labeledPoint.value._3, 33)
    }

    static var allTests = [
        ("testPoint3", testPoint3),
        ("testLabeledPoint3", testLabeledPoint3),
    ]
}
