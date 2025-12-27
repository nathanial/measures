# Roadmap

A prioritized list of potential improvements, new features, code cleanup opportunities, and enhancements for the Measures library.

---

## Feature Proposals

### [Priority: High] Compound Unit Construction and Parsing

**Description:** Add support for constructing compound units at runtime and/or parsing unit strings like "m/s" or "kg*m/s^2".

**Rationale:** Currently, users must manually define every compound unit they need. The ability to construct or derive units programmatically would greatly improve flexibility and reduce boilerplate. This is especially useful for configuration files or user input scenarios.

**Affected Files:**
- `Measures/Core/Unit.lean` - Add `Unit.mul` and `Unit.div` operations
- New file: `Measures/Units/Parser.lean` (optional string parsing)

**Estimated Effort:** Medium

**Dependencies:** None

---

### [Priority: High] Pretty Printing with Unit Symbols

**Description:** Enhance `Quantity.toString` to display values with their unit symbols (e.g., "5.0 m" instead of just "5.0").

**Rationale:** The current `toString` implementation only outputs the raw numeric value, which loses important context. Users expect to see quantities with their units for debugging and display purposes.

**Affected Files:**
- `Measures/Core/Quantity.lean` - `toString` function (line ~81-83)
- May require storing unit information or adding a `format` function with explicit unit parameter

**Estimated Effort:** Small

**Dependencies:** None

---

### [Priority: High] Type-Safe Unit Arithmetic

**Description:** Add operations to multiply and divide `Unit` types to produce new derived units with correct dimensions.

**Rationale:** The library allows quantity multiplication/division with dimension tracking, but there is no equivalent for units. Users should be able to write `let velocity := meter / second` to create a velocity unit.

**Affected Files:**
- `Measures/Core/Unit.lean` - Add `HMul` and `HDiv` instances for `Unit`

**Estimated Effort:** Medium

**Dependencies:** None

---

### [Priority: Medium] Dimensioned Numeric Types Beyond Float

**Description:** Support numeric types other than `Float` (e.g., `Nat`, `Int`, `Rat` from mathlib, or arbitrary precision types).

**Rationale:** `Float` has precision limitations. Scientific computing may require exact rational arithmetic or integer quantities (e.g., counting molecules with moles).

**Affected Files:**
- `Measures/Core/Quantity.lean` - Generalize from `Float` to `(n : Type) [Numeric n]`
- All arithmetic operations would need adjustment

**Estimated Effort:** Large

**Dependencies:** May benefit from mathlib's numeric hierarchy

---

### [Priority: Medium] Monad Instance for Dimensionless Quantities

**Description:** Provide `Functor`, `Applicative`, and `Monad` instances for `Quantity Dimension.one`.

**Rationale:** Dimensionless quantities are essentially wrapped numbers. Adding these instances would enable familiar functional programming patterns and composition.

**Affected Files:**
- `Measures/Core/Quantity.lean` - Add typeclass instances

**Estimated Effort:** Small

**Dependencies:** None

---

### [Priority: Medium] Compile-Time Dimension Mismatch Error Messages

**Description:** Improve error messages when dimension mismatches occur to show human-readable dimension names.

**Rationale:** Current type errors show raw `Dimension` structure comparisons. Messages like "Cannot add Length and Time" would be far more helpful than structural mismatches.

**Affected Files:**
- `Measures/Core/Dimension.lean` - Add custom `ToString` or elaborator hints
- Potentially add macro-level diagnostics

**Estimated Effort:** Medium

**Dependencies:** Understanding of Lean 4 elaboration and error reporting

---

### [Priority: Medium] Physical Constants Module

**Description:** Add a module with commonly used physical constants (speed of light, Planck's constant, gravitational constant, etc.) as typed quantities.

**Rationale:** Physics and engineering applications frequently need these constants. Providing them with correct dimensions would be valuable and demonstrate the library's type safety.

**Affected Files:**
- New file: `Measures/Constants.lean`

**Estimated Effort:** Small

**Dependencies:** None

---

### [Priority: Medium] Currency Units

**Description:** Add support for currency as a dimension with common currency units.

**Rationale:** Financial calculations benefit from dimensional analysis (e.g., price per unit, cost per kilowatt-hour). Currency is not an SI dimension but is a common use case.

**Affected Files:**
- `Measures/Core/Dimension.lean` - May need to add a `currency` field or use a separate dimension system
- New file: `Measures/Units/Currency.lean`

**Estimated Effort:** Medium

**Dependencies:** Design decision on whether to extend SI dimensions or create parallel system

---

### [Priority: Low] Data/Information Units

**Description:** Add units for digital information (bits, bytes, kilobytes, etc.).

**Rationale:** Information is technically dimensionless but has its own unit system. This is useful for computing applications.

**Affected Files:**
- New file: `Measures/Units/Data.lean`

**Estimated Effort:** Small

**Dependencies:** None

---

### [Priority: Low] Custom Dimension System

**Description:** Allow users to define custom dimensions beyond the 7 SI base dimensions.

**Rationale:** Some domains have additional base quantities (e.g., currency, information, count). A mechanism for user-defined dimensions would increase flexibility.

**Affected Files:**
- `Measures/Core/Dimension.lean` - Major redesign to support extensibility

**Estimated Effort:** Large

**Dependencies:** Significant design work needed

---

### [Priority: Low] Uncertainty/Error Propagation

**Description:** Track measurement uncertainty alongside values and propagate errors through arithmetic operations.

**Rationale:** Real-world measurements have uncertainties. Automatic error propagation would be valuable for scientific applications.

**Affected Files:**
- New file: `Measures/Uncertainty.lean`
- May need parallel `QuantityWithError` type

**Estimated Effort:** Large

**Dependencies:** None

---

## Code Improvements

### [Priority: High] DecidableEq Instance for Quantity

**Current State:** `Quantity` only has `BEq` but lacks `DecidableEq`.

**Proposed Change:** Add `DecidableEq` instance to enable propositional equality proofs and use in `if` expressions without `decide`.

**Benefits:** Better integration with Lean's type system, enables more idiomatic Lean code.

**Affected Files:**
- `Measures/Core/Quantity.lean`

**Estimated Effort:** Small

---

### [Priority: High] Hashable Instance for Quantity and Dimension

**Current State:** `Dimension` and `Quantity` lack `Hashable` instances.

**Proposed Change:** Add `Hashable` instances to enable use in `HashMap` and `HashSet`.

**Benefits:** Enables efficient lookup tables indexed by dimensions or quantities.

**Affected Files:**
- `Measures/Core/Dimension.lean`
- `Measures/Core/Quantity.lean`

**Estimated Effort:** Small

---

### [Priority: Medium] Use Simp Lemmas for Dimension Arithmetic

**Current State:** Dimension arithmetic is defined but lacks simp lemmas for compile-time normalization.

**Proposed Change:** Add `@[simp]` lemmas proving properties like `d.mul Dimension.one = d`, `d.mul d.inv = Dimension.one`, etc.

**Benefits:** Enables Lean's simplifier to automatically prove dimension equalities, reducing need for explicit casts.

**Affected Files:**
- `Measures/Core/Dimension.lean`

**Estimated Effort:** Medium

**Dependencies:** May require decidable equality proofs

---

### [Priority: Medium] Lawful Typeclass Instances

**Current State:** `Add`, `Mul`, etc. instances are provided but without proof of associativity, commutativity, etc.

**Proposed Change:** Add `LawfulAdd`, `LawfulMul` style instances with proofs.

**Benefits:** Enables use with generic algorithms that require lawful typeclasses, better integration with mathlib.

**Affected Files:**
- `Measures/Ops/Arithmetic.lean`
- `Measures/Core/Dimension.lean`

**Estimated Effort:** Medium

---

### [Priority: Medium] Float Wrapper for Numeric Safety

**Current State:** Quantities directly use `Float` which allows NaN and Infinity without explicit handling.

**Proposed Change:** Consider adding predicates or a wrapper type that validates values, or at least document behavior for edge cases.

**Benefits:** Clearer semantics for invalid values, potential for safer numeric operations.

**Affected Files:**
- `Measures/Core/Quantity.lean`

**Estimated Effort:** Medium

---

### [Priority: Low] Inline Annotations for Performance

**Current State:** Core operations lack `@[inline]` annotations.

**Proposed Change:** Add `@[inline]` or `@[always_inline]` to hot-path functions like `Unit.quantity`, `Unit.fromQuantity`, arithmetic operations.

**Benefits:** Better runtime performance by avoiding function call overhead.

**Affected Files:**
- `Measures/Core/Quantity.lean`
- `Measures/Core/Unit.lean`
- `Measures/Ops/Arithmetic.lean`

**Estimated Effort:** Small

---

### [Priority: Low] Specialize via Typeclass for Float Operations

**Current State:** All operations use `Float` directly.

**Proposed Change:** Define a typeclass for numeric operations and provide a `Float` instance, allowing future extension to other numeric types.

**Benefits:** Prepares codebase for supporting multiple numeric types without breaking changes.

**Affected Files:**
- New file: `Measures/Core/Numeric.lean`
- `Measures/Core/Quantity.lean`

**Estimated Effort:** Medium

---

## Code Cleanup

### [Priority: High] Unused Precision Parameter in toString

**Issue:** `Quantity.toString` accepts a `precision` parameter but ignores it.

**Location:** `/Measures/Core/Quantity.lean` line 81

**Action Required:** Either implement precision formatting or remove the parameter to avoid confusion.

**Estimated Effort:** Small

---

### [Priority: Medium] Duplicated approxEq Helper in Tests

**Issue:** The `approxEq` function is defined identically in both `ArithmeticTests.lean` and `ConversionTests.lean`.

**Location:**
- `/MeasuresTests/ArithmeticTests.lean` line 16
- `/MeasuresTests/ConversionTests.lean` line 18

**Action Required:** Extract to a shared test utilities module or use `Quantity.approxEq` directly.

**Estimated Effort:** Small

---

### [Priority: Medium] Duplicated Pi Constant

**Issue:** Pi is defined in multiple places:
- `Measures/Units/Angle.lean` line 17
- `MeasuresTests/ConversionTests.lean` line 22

**Location:** See above

**Action Required:** Consider exporting a single pi constant from the library (possibly in a `Measures.Constants` module).

**Estimated Effort:** Small

---

### [Priority: Medium] Inconsistent Unit Definition Patterns

**Issue:** SI.lean uses `siBase` and prefix functions, while other unit files use direct `scale` calls. Temperature.lean duplicates `kelvin` that is also in SI.lean.

**Location:**
- `/Measures/Units/SI.lean`
- `/Measures/Units/Temperature.lean` line 27 (duplicates SI.kelvin)
- `/Measures/Units/Time.lean` line 18 (duplicates SI.second), lines 47-59 (duplicates SI millisecond etc.)

**Action Required:** Either consolidate duplicates or document the intentional separation. Consider having Temperature.lean and Time.lean import and re-export from SI.lean.

**Estimated Effort:** Small

---

### [Priority: Low] Missing Module Documentation

**Issue:** Some files lack top-level module documentation explaining their purpose and usage.

**Location:** Several unit test files have minimal documentation.

**Action Required:** Add consistent module-level docstrings following the pattern in core files.

**Estimated Effort:** Small

---

### [Priority: Low] Inconsistent Comment Style

**Issue:** Mix of `/-! ... -/` section comments and `/-- ... -/` doc comments without clear pattern.

**Location:** Throughout codebase

**Action Required:** Establish and apply consistent documentation style guidelines.

**Estimated Effort:** Small

---

## Missing Unit Coverage

### [Priority: High] Molar Units and Chemistry

**Issue:** Despite having `Amount` dimension (mole), there are no units for:
- Molar mass (g/mol)
- Molarity (mol/L)
- Avogadro's number

**Affected Files:**
- New file: `Measures/Units/Chemistry.lean`

**Estimated Effort:** Small

---

### [Priority: Medium] Electrical Units Beyond Basics

**Issue:** Missing common electrical units:
- Siemens (conductance, 1/Ohm)
- Millihenry, microhenry
- Millifarad, microfarad, nanofarad, picofarad
- Electron volt (energy)

**Affected Files:**
- `Measures/Units/SI.lean` - Add to existing electrical section

**Estimated Effort:** Small

---

### [Priority: Medium] Radiation and Nuclear Units

**Issue:** No units for:
- Becquerel (radioactivity)
- Gray (absorbed dose)
- Sievert (equivalent dose)

**Affected Files:**
- `Measures/Units/SI.lean` or new file

**Estimated Effort:** Small

---

### [Priority: Medium] Photometric Units

**Issue:** Despite having `Luminosity` dimension, missing:
- Lumen (luminous flux)
- Lux (illuminance)

**Affected Files:**
- `Measures/Units/SI.lean`
- `Measures/Dimensions.lean` - Add `LuminousFlux` and `Illuminance` dimensions

**Estimated Effort:** Small

---

### [Priority: Low] Astronomical Units

**Issue:** Missing common astronomical units:
- Astronomical unit (AU)
- Light-year
- Parsec
- Solar mass

**Affected Files:**
- New file: `Measures/Units/Astronomical.lean`

**Estimated Effort:** Small

---

### [Priority: Low] CGS Units

**Issue:** Some scientific fields still use CGS units:
- Dyne (force)
- Erg (energy)
- Gauss (magnetic field)
- Poise (viscosity)

**Affected Files:**
- New file: `Measures/Units/CGS.lean`

**Estimated Effort:** Small

---

### [Priority: Low] Cooking/Recipe Units

**Issue:** Beyond basic volume units, missing:
- Pinch, dash (informal but used)
- Metric cup (250 mL)
- Imperial cooking measurements

**Affected Files:**
- `Measures/Units/Imperial.lean` or new file

**Estimated Effort:** Small

---

## API Improvements

### [Priority: High] Operator Overloading for Float * Quantity

**Current State:** `Float * Quantity` is not supported, only `Quantity * Float`.

**Proposed Change:** Add `HMul Float (Quantity d) (Quantity d)` instance.

**Benefits:** More natural syntax: `2.0 * distance` instead of `distance * 2.0`.

**Affected Files:**
- `Measures/Ops/Arithmetic.lean`

**Estimated Effort:** Small

---

### [Priority: High] Direct Unit Conversion Function

**Current State:** Converting between units requires: `(value *: unit1).asUnit unit2`

**Proposed Change:** Add `convert : Float -> Unit d -> Unit d -> Float` for direct conversion without intermediate quantity.

**Benefits:** Cleaner syntax for simple conversions: `convert 100.0 celsius fahrenheit`

**Affected Files:**
- `Measures/Core/Unit.lean`

**Estimated Effort:** Small

---

### [Priority: Medium] Quantity Formatting with Specified Unit

**Current State:** No way to format a quantity with a specific unit and symbol.

**Proposed Change:** Add `format : Quantity d -> Unit d -> String` that returns e.g., "100.5 km".

**Benefits:** Clean output for user interfaces and logging.

**Affected Files:**
- `Measures/Core/Quantity.lean` or `Measures/Core/Unit.lean`

**Estimated Effort:** Small

---

### [Priority: Medium] Quantity Rounding Functions

**Current State:** No built-in rounding support.

**Proposed Change:** Add `round`, `floor`, `ceiling`, `truncate` functions that preserve dimensions.

**Benefits:** Common operations for display and calculations.

**Affected Files:**
- `Measures/Core/Quantity.lean`

**Estimated Effort:** Small

---

### [Priority: Medium] List/Array Operations

**Current State:** Only `sum` and `avg` for lists.

**Proposed Change:** Add `minList`, `maxList`, `median`, `variance`, `stdDev` for statistical operations on quantity lists.

**Benefits:** Common operations for data analysis with dimensional safety.

**Affected Files:**
- `Measures/Ops/Arithmetic.lean`

**Estimated Effort:** Medium

---

### [Priority: Medium] Linear Interpolation

**Current State:** No interpolation support.

**Proposed Change:** Add `lerp : Quantity d -> Quantity d -> Float -> Quantity d` for linear interpolation between two quantities.

**Benefits:** Common operation in physics simulations and graphics.

**Affected Files:**
- `Measures/Ops/Arithmetic.lean`

**Estimated Effort:** Small

---

### [Priority: Low] Alternative Infix Operators

**Current State:** Uses `*.` and `/.` which may conflict with some notations.

**Proposed Change:** Consider alternative operators or make current ones configurable via scoped notations.

**Benefits:** Better compatibility with other libraries.

**Affected Files:**
- `Measures/Ops/Arithmetic.lean`

**Estimated Effort:** Small

---

## Documentation Improvements

### [Priority: High] README with Examples

**Issue:** No README.md file with comprehensive examples and getting-started guide.

**Action Required:** Create README.md with:
- Installation instructions
- Quick start examples
- Common use cases
- API overview

**Estimated Effort:** Medium

---

### [Priority: Medium] API Reference Documentation

**Issue:** While individual functions have doc comments, there is no centralized API reference.

**Action Required:** Either generate documentation using doc-gen4 or create a manual API reference.

**Estimated Effort:** Medium

---

### [Priority: Medium] Tutorial: Building Custom Units

**Issue:** No documentation on how users should define their own units.

**Action Required:** Add a tutorial or example file showing custom unit definition patterns.

**Estimated Effort:** Small

---

### [Priority: Low] Temperature Handling Guide

**Issue:** Temperature offset handling is subtle and can be confusing (absolute vs. difference).

**Action Required:** Add detailed documentation explaining the temperature model and common pitfalls.

**Estimated Effort:** Small

---

## Test Coverage Gaps

### [Priority: High] Temperature Delta Units

**Issue:** `kelvinDelta`, `celsiusDelta`, `fahrenheitDelta` units in Temperature.lean have no tests.

**Action Required:** Add tests verifying temperature difference calculations work correctly.

**Estimated Effort:** Small

---

### [Priority: Medium] Angle Utility Functions

**Issue:** `normalizePositive` and `normalizeSigned` in Angle.lean have no tests.

**Action Required:** Add tests for angle normalization edge cases.

**Estimated Effort:** Small

---

### [Priority: Medium] Edge Cases

**Issue:** No tests for edge cases like:
- Division by zero quantities
- NaN/Infinity handling
- Very large/small values (overflow)
- Empty list operations (sum, avg)

**Action Required:** Add comprehensive edge case tests.

**Estimated Effort:** Medium

---

### [Priority: Medium] Comparison Operations

**Issue:** `Comparison.lean` operations (`lt`, `le`, `gt`, `ge`, `inRange`, `clamp`) have minimal or no dedicated tests.

**Action Required:** Add tests for comparison operations.

**Estimated Effort:** Small

---

### [Priority: Low] All Units Roundtrip Tests

**Issue:** Only meter-foot and kilogram-pound roundtrips are tested.

**Action Required:** Add roundtrip conversion tests for all unit pairs to catch conversion factor errors.

**Estimated Effort:** Medium

---
