# Measures

Type-safe units of measure for Lean 4. Prevents unit mismatch bugs at compile time with zero runtime overhead.

## Features

- **Compile-time dimension checking** - Adding meters to seconds is a type error
- **SI, Imperial, and custom units** - Comprehensive unit support
- **Zero runtime overhead** - Dimensions are tracked at the type level
- **Temperature offsets** - Correct handling of Celsius/Fahrenheit conversions

## Quick Start

```lean
import Measures

open Measures
open Measures.Units.SI
open Measures.Units.Imperial

-- Create quantities
def distance := 100.0 *: meter
def time := 9.58 *: second

-- Arithmetic with dimension tracking
def speed := distance /. time  -- Quantity Dimension.Velocity

-- Convert units
#eval distance.asUnit foot  -- ~328.084

-- This is a compile-time error:
-- def bad := distance + time  -- Type mismatch!
```

## Installation

Add to your `lakefile.lean`:

```lean
require measures from ".." / "measures"
```

## Building

```bash
lake build
lake test
```

## Unit Systems

### SI Units

```lean
open Measures.Units.SI

def length := 5.0 *: meter
def mass := 70.0 *: kilogram
def energy := 1000.0 *: joule

-- With prefixes
def distance := 42.0 *: kilometer
def small := 500.0 *: millimeter
```

### Imperial Units

```lean
open Measures.Units.Imperial

def height := 6.0 *: foot
def weight := 180.0 *: pound
def speed := 60.0 *: milePerHour
```

### Temperature

```lean
open Measures.Units.Temperature

def freezing := 0.0 *: celsius
def boiling := 212.0 *: fahrenheit

-- Convert
#eval freezing.asUnit fahrenheit  -- 32.0
#eval boiling.asUnit celsius      -- 100.0
```

### Angles

```lean
open Measures.Units.Angle

def rightAngle := 90.0 *: degree
#eval rightAngle.asUnit radian  -- ~1.5708
```

## Dimension Tracking

Dimensions are represented as integer exponents of the 7 SI base dimensions:

```lean
structure Dimension where
  length      : Int  -- meter
  mass        : Int  -- kilogram
  time        : Int  -- second
  current     : Int  -- ampere
  temperature : Int  -- kelvin
  amount      : Int  -- mole
  luminosity  : Int  -- candela
```

Arithmetic operations combine dimensions correctly:

```lean
-- Velocity = Length / Time
def velocity := (10.0 *: meter) /. (2.0 *: second)
-- velocity : Quantity { length := 1, time := -1, ... }

-- Force = Mass * Acceleration
def force := (5.0 *: kilogram) *. (9.8 *: meterPerSecondSquared)
-- force : Quantity { mass := 1, length := 1, time := -2, ... }
```

## Compound Units

Build complex units from simpler ones using operators:

```lean
open Measures.Units.SI

-- Create velocity unit from meter and second
def velocity := meter / second
def speed := 25.0 *: velocity  -- 25 m/s

-- Create derived units
def energyUnit := newton * meter  -- N·m = J
def work := 100.0 *: energyUnit

-- Unit powers
def area := meter.sq      -- m²
def volume := meter.cube  -- m³
def freq := second.recip  -- 1/s = Hz

-- Complex expressions
def forceUnit := kilogram * meter / (second * second)  -- kg·m/s² = N
```

## Custom Units

Define your own units easily:

```lean
def lightYear : Unit Dimension.Length :=
  Unit.scale "light-year" "ly" 9.461e15

def astronomicalUnit : Unit Dimension.Length :=
  Unit.scale "astronomical unit" "AU" 1.496e11

def distance := 4.24 *: lightYear
#eval distance.asUnit astronomicalUnit  -- ~268,000 AU
```

## API Reference

### Quantity Operations

- `q1 + q2` - Add (same dimension required)
- `q1 - q2` - Subtract (same dimension required)
- `q1 *. q2` - Multiply (dimensions combined)
- `q1 /. q2` - Divide (dimensions combined)
- `q.sq` - Square
- `q.cube` - Cube
- `q.sqrt` - Square root
- `q.recip` - Reciprocal
- `q * s` / `q / s` - Scalar multiplication/division

### Unit Conversions

- `value *: unit` - Create quantity in unit
- `q.asUnit unit` - Express quantity in unit

### Unit Operations

- `u1 * u2` - Multiply units (dimensions combine)
- `u1 / u2` - Divide units (dimensions combine)
- `u.sq` - Square a unit
- `u.cube` - Cube a unit
- `u.recip` - Reciprocal of a unit
- `u.pow n` - Raise unit to integer power
