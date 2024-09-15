# Experimental!
Dim ← 128_128
Sigma ← 1.9
Initial ← 0.1

N ← /×Dim

# Energy map of single pixel
Energy ← ↻¯⊙comptime(
  °⍉⇡Dim
  /+×.-⌵⤚-÷2Dim  # toroidal distance
  ⁿ⊙e¯÷×2×.Sigma # gaussian
)

# Build energy map
EMap ← ×√N◌°ℂ⍜(
  ⍉fft⍉fft
| ×comptime(⍉fft⍉fft Energy 0_0)
)

Argmax ← ⊢⊚=/↥⊸♭
Argmin ← ⊢⊚=/↧⊸♭

# initial binary pattern
<Initial∵⋅⚂°△Dim
⊃(∘|÷⊙1¬|EMap)
⊙◌⍥(
  ◡(Argmax ×⊙◌)
  ⊃(⍜⊡⋅0|⍜⊡⋅1 ⊙⋅∘|-Energy ⊙⋅⋅∘)
  ◡(Argmin ×⋅∘)
  ⊃(⍜⊡⋅1|⍜⊡⋅∞ ⊙⋅∘|+Energy ⊙⋅⋅∘)
)∞

# ? binary pattern, energy map

# Phase 1 - make dither array (ordered binary pattern)
⧻⊸⊚
⊃(
  ⋅⊙∘
| ⋅⋅⊙°0 ⍥(
    Argmax ◡×
    ⊃(
      ⍜⊡⋅0           # remove the tightest cluster
    | -Energy ⊙⋅∘    # subtract energy
    | ⍜⊡⋅∘ ⊙⋅⋅⊙⟜(-1) # update indices
    )
  ) ⤚⊙⊙⊙(↯Dim0)
| +1
)
# ? binary pattern, energy map, dither array, index

# Phase 2 - fill voids until 50% full
-⊙(⌊÷2N) ⧻⊸⊚ # iteration count
⍜⊙(÷⊙1¬)⍥(
  Argmin ◡×
  ⊃(⍜⊡⋅∞|+Energy ⊙⋅∘|⍜⊡⋅∘ ⊙⋅⋅⊙⟜(+1))
)
# ? binary pattern, energy map, dither array, index

# Phase 3 -  fill all clusters of zeroes
⊃(
  -⊙N⧻⊚     # iteration count
| ⟜EMap⊙◌ ¬ # flip binary pattern
)

⋅⋅⊙(°1= +1N) ⍥(
  Argmax ◡×
  ⊃(⍜⊡⋅0|-Energy ⊙⋅∘|⍜⊡⋅∘ ⊙⋅⋅⊙⟜(+1))
)
÷N-1
