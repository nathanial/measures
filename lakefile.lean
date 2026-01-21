import Lake
open Lake DSL

package measures where
  version := v!"0.1.0"
  leanOptions := #[
    ⟨`autoImplicit, false⟩,
    ⟨`relaxedAutoImplicit, false⟩
  ]

require crucible from git "https://github.com/nathanial/crucible" @ "v0.0.8"

@[default_target]
lean_lib Measures where
  roots := #[`Measures]

lean_lib MeasuresTests where
  globs := #[.submodules `MeasuresTests]

@[test_driver]
lean_exe measures_tests where
  root := `MeasuresTests.Main
