/-
  Tests for Quantity operations.
-/

import Measures
import Crucible

namespace MeasuresTests.QuantityTests

open Crucible
open Measures
open Measures.Units.SI

testSuite "Quantity Construction"

test "create quantity with unit" := do
  let q := 5.0 *: meter
  q.value ≡ 5.0

test "zero quantity" := do
  let z : Quantity Dimension.Length := Quantity.zero
  z.value ≡ 0.0

test "pure creates dimensionless" := do
  let q := Quantity.pure 3.14
  q.value ≡ 3.14

testSuite "Quantity Predicates"

test "isZero" := do
  let z : Quantity Dimension.Length := Quantity.zero
  ensure (z.isZero) "zero should be zero"
  let nonzero := 1.0 *: meter
  ensure (!nonzero.isZero) "1m should not be zero"

test "isPositive and isNegative" := do
  let pos := 5.0 *: meter
  let neg := (-5.0) *: meter
  let zero : Quantity Dimension.Length := Quantity.zero
  ensure (pos.isPositive) "positive should be positive"
  ensure (!pos.isNegative) "positive should not be negative"
  ensure (neg.isNegative) "negative should be negative"
  ensure (!neg.isPositive) "negative should not be positive"
  ensure (!zero.isPositive) "zero should not be positive"
  ensure (!zero.isNegative) "zero should not be negative"

testSuite "Quantity Basic Operations"

test "negation" := do
  let q := 5.0 *: meter
  let neg := q.neg
  neg.value ≡ (-5.0)

test "absolute value" := do
  let neg := (-5.0) *: meter
  let absVal := neg.abs
  absVal.value ≡ 5.0

test "scalar multiplication" := do
  let q := 5.0 *: meter
  let doubled := q.smul 2.0
  doubled.value ≡ 10.0

test "scalar division" := do
  let q := 10.0 *: meter
  let halved := q.sdiv 2.0
  halved.value ≡ 5.0

testSuite "Quantity Display"

test "toString" := do
  let q := 42.0 *: meter
  ensure (q.toString.length > 0) "toString should produce output"

#generate_tests

end MeasuresTests.QuantityTests
