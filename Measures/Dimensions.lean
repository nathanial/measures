/-
  Measures.Dimensions

  Common dimension constants for the 7 SI base dimensions
  and frequently used derived dimensions.
-/

import Measures.Core.Dimension

namespace Measures

namespace Dimension

/-! ## SI Base Dimensions -/

/-- Length dimension (meter). -/
def Length : Dimension := { length := 1 }

/-- Mass dimension (kilogram). -/
def Mass : Dimension := { mass := 1 }

/-- Time dimension (second). -/
def Time : Dimension := { time := 1 }

/-- Electric current dimension (ampere). -/
def Current : Dimension := { current := 1 }

/-- Thermodynamic temperature dimension (kelvin). -/
def Temperature : Dimension := { temperature := 1 }

/-- Amount of substance dimension (mole). -/
def Amount : Dimension := { amount := 1 }

/-- Luminous intensity dimension (candela). -/
def Luminosity : Dimension := { luminosity := 1 }

/-! ## Derived Mechanical Dimensions -/

/-- Area (m²). -/
def Area : Dimension := { length := 2 }

/-- Volume (m³). -/
def Volume : Dimension := { length := 3 }

/-- Velocity (m/s). -/
def Velocity : Dimension := { length := 1, time := -1 }

/-- Acceleration (m/s²). -/
def Acceleration : Dimension := { length := 1, time := -2 }

/-- Force (N = kg·m/s²). -/
def Force : Dimension := { mass := 1, length := 1, time := -2 }

/-- Energy / Work (J = kg·m²/s²). -/
def Energy : Dimension := { mass := 1, length := 2, time := -2 }

/-- Power (W = kg·m²/s³). -/
def Power : Dimension := { mass := 1, length := 2, time := -3 }

/-- Pressure (Pa = kg/(m·s²)). -/
def Pressure : Dimension := { mass := 1, length := -1, time := -2 }

/-- Frequency (Hz = 1/s). -/
def Frequency : Dimension := { time := -1 }

/-- Momentum (kg·m/s). -/
def Momentum : Dimension := { mass := 1, length := 1, time := -1 }

/-- Angular velocity (rad/s = 1/s, dimensionless angle). -/
def AngularVelocity : Dimension := { time := -1 }

/-- Density (kg/m³). -/
def Density : Dimension := { mass := 1, length := -3 }

/-! ## Derived Electromagnetic Dimensions -/

/-- Electric charge (C = A·s). -/
def Charge : Dimension := { current := 1, time := 1 }

/-- Voltage / Electric potential (V = kg·m²/(A·s³)). -/
def Voltage : Dimension := { mass := 1, length := 2, time := -3, current := -1 }

/-- Electric resistance (Ω = kg·m²/(A²·s³)). -/
def Resistance : Dimension := { mass := 1, length := 2, time := -3, current := -2 }

/-- Capacitance (F = A²·s⁴/(kg·m²)). -/
def Capacitance : Dimension := { mass := -1, length := -2, time := 4, current := 2 }

/-- Inductance (H = kg·m²/(A²·s²)). -/
def Inductance : Dimension := { mass := 1, length := 2, time := -2, current := -2 }

/-- Magnetic flux (Wb = kg·m²/(A·s²)). -/
def MagneticFlux : Dimension := { mass := 1, length := 2, time := -2, current := -1 }

/-- Magnetic field strength (T = kg/(A·s²)). -/
def MagneticField : Dimension := { mass := 1, time := -2, current := -1 }

/-! ## Aliases for Readability -/

abbrev Dimensionless := Dimension.one
abbrev Speed := Velocity
abbrev Work := Energy

end Dimension

end Measures
