# Experimental!
Dim ← 256_256
Seed ← 0

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
FormatTime ← (
  ⊙"hms" [⌊⊃÷◿60 ⊓⌊⁅⊃÷◿60]
  ⍚(⨬$"__"⋅⋅""⊸=0)
  /◇(⊂⊂)@\s ▽⊸≡≠□""
)

# initial binary pattern
&p"Start"
⍜now(
  <Initial↯Dim[◌⍥genN Seed]
  ⊃(∘|÷⊙1¬|EMap)
  ⊙◌⍥(
    ◡(Argmax ×⊙⋅∘)
    ⊃(⍜⊡⋅0|⍜⊡⋅1 ⊙⋅∘|-Energy ⊙⋅⋅∘)
    ◡(Argmin ×⋅⊙∘)
    ⊃(⍜⊡⋅1|⍜⊡⋅∞ ⊙⋅∘|+Energy ⊙⋅⋅∘)
  )∞
)

# Phase 1 - make dither array (ordered binary pattern)
# ? binary pattern, energy map
&p$"Phase 1 - _"FormatTime
⍜now(
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
)

# Phase 2 - fill voids until 50% full
# ? binary pattern, energy map, dither array, index
&p$"Phase 2 - _"FormatTime
⍜now(
  -⊙(⌊÷2N) ⧻⊸⊚ # iteration count
  ⍜⊙(÷⊙1¬)⍥(
    Argmin ◡×
    ⊃(
      ⍜⊡⋅∞
    | +Energy ⊙⋅∘
    | ⍜⊡⋅∘ ⊙⋅⋅⊙⟜(+1)
    )
  )
)

# Phase 3 -  fill all clusters of zeroes
# ? binary pattern, energy map, dither array, index
&p$"Phase 3 - _"FormatTime
⍜now(
  ⊃(
    -⊙N⧻⊚     # iteration count
  | ⟜EMap⊙◌ ¬ # flip binary pattern
  )
  ⋅⋅⊙(°1= +1N) ⍥(
    Argmax ◡×
    ⊃(
      ⍜⊡⋅0
    | -Energy ⊙⋅∘
    | ⍜⊡⋅∘ ⊙⋅⋅⊙⟜(+1)
    )
  )
  ÷N-1
)

&p$"Writing - _"FormatTime
&fwa $"./_x_.png"°⊟Dim img "png"

&p"Done"
