/-
  Measures.Core.Unit

  The Unit type represents a unit of measurement with a specific dimension.
  It stores conversion factors to/from SI base units, and an optional offset
  for temperature scales.
-/

import Measures.Core.Dimension
import Measures.Core.Quantity

namespace Measures

/-- A unit of measurement with dimension `d`.

    Stores:
    - `name`: Full name (e.g., "meter")
    - `symbol`: Short symbol (e.g., "m")
    - `toSI`: Multiply by this to convert to SI base units
    - `fromSI`: Multiply SI value by this to get this unit (= 1/toSI)
    - `offset`: Additive offset for temperature scales (0 for most units) -/
structure Unit (d : Dimension) where
  name : String
  symbol : String
  toSI : Float
  fromSI : Float
  offset : Float := 0.0
  deriving Repr, Inhabited

namespace Unit

variable {d : Dimension}

/-! ## Construction -/

/-- Create a unit with a scale factor (no offset).
    The `fromSI` factor is computed as `1/toSI`. -/
def scale (name symbol : String) (factor : Float) : Unit d :=
  { name := name
  , symbol := symbol
  , toSI := factor
  , fromSI := 1.0 / factor
  , offset := 0.0 }

/-- Create a unit with both scale and offset (for temperature).
    Conversion: SI = (value + offset) * scale
    Reverse: value = SI / scale - offset -/
def scaleOffset (name symbol : String) (factor offset : Float) : Unit d :=
  { name := name
  , symbol := symbol
  , toSI := factor
  , fromSI := 1.0 / factor
  , offset := offset }

/-- Create an SI base unit (scale = 1, no offset). -/
def siBase (name symbol : String) : Unit d :=
  scale name symbol 1.0

/-! ## Derived Units -/

/-- Apply an SI prefix to a unit (e.g., kilo, milli).
    Returns a new unit with adjusted scale. -/
def withPrefix (u : Unit d) (prefixName prefixSymbol : String) (factor : Float) : Unit d :=
  { name := prefixName ++ u.name
  , symbol := prefixSymbol ++ u.symbol
  , toSI := u.toSI * factor
  , fromSI := u.fromSI / factor
  , offset := u.offset }

/-! ## Conversion Functions -/

/-- Create a quantity in this unit.
    Converts the value to SI base units internally. -/
def quantity (u : Unit d) (value : Float) : Quantity d :=
  if u.offset == 0.0 then
    { value := value * u.toSI }
  else
    -- For temperature: SI = (value + offset) * scale
    { value := (value + u.offset) * u.toSI }

/-- Express a quantity in this unit.
    Converts from SI base units to this unit's scale. -/
def fromQuantity (u : Unit d) (q : Quantity d) : Float :=
  if u.offset == 0.0 then
    q.value * u.fromSI
  else
    -- For temperature: value = SI / scale - offset
    q.value * u.fromSI - u.offset

/-! ## Display -/

instance : ToString (Unit d) where
  toString u := u.symbol

end Unit

/-! ## Infix Notation -/

/-- Create a quantity: `5.0 *: meter` -/
scoped infixl:75 " *: " => fun (v : Float) (u : Unit _) => Unit.quantity u v

namespace Quantity

variable {d : Dimension}

/-- Express a quantity in a specific unit: `distance.in' foot` -/
def in' (q : Quantity d) (u : Unit d) : Float := u.fromQuantity q

/-- Alias for `in'`: `distance.asUnit foot` -/
def asUnit (q : Quantity d) (u : Unit d) : Float := u.fromQuantity q

end Quantity

end Measures
