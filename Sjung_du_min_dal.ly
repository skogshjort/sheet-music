\version "2.26.0"

\header {
  title = "Sjung du min dal"
  composer = "arrangerad av Petrix"
}

Root = a'
Mode = \major
TimeSignature = 6/4

Part = #(
  define-music-function
  (Music)
  (ly:music?)
  #{
    \relative \Root {
        \time \TimeSignature
        \key \Root \Mode
        \transpose c \Root {

          #Music
        
        }
      }
  #}
)

Skip = #(define-music-function
  (Note)
  (ly:music?)
  (set!
          (ly:music-property Note   'skip_me) 
          #t
        )
  Note
)

% Helper function to copy duration + articulations from one NoteEvent to another NoteEvent
ApplyRhythmSingleEvent = #(define-music-function
  (Rhythm Note)
  (ly:music? ly:music? )
    
        (set!
          (ly:music-property Note   'duration) 
          (ly:music-property Rhythm 'duration)
        )    
        (set!
          (ly:music-property Note   'articulations) 
          (ly:music-property Rhythm 'articulations)
        )

        Note

    )
  

% Helper function to copy duration + articulations from a phrase to another
ApplyRhythm = #(define-music-function
  (Rhythm Note)
  (ly:music? ly:music?)
  (make-music 'SequentialMusic 'elements
    (map ApplyRhythmSingleEvent
      (ly:music-property Rhythm 'elements)
      (ly:music-property Note 'elements)
    )
  )
)

Rytm = { c
    4.   8 4  2    4 4.   8 4  2.     4 4 4 4(4) 4 2.  2.
    4  4   4  2    4 4.   8 4  2.     4 4 4 4 4 4 2.  2
  4 4.   8 4  2    4 4.   8 4  2.     4 4 4 4 4 4 2.  2
  4 4.   8 4  2    4 4.   8 4  2    4 4 4 4 2   4 2.  2.
}
RytmStämmaTvå = { c
    4.   8 4  2    4 4.   8 4  2.     4 4 4 4(4)4 2.  2.
    4  4   4  2    4 4.   8 4  2.     4 4 4 4 4 4 2.  2
  4 4.   8 4  2    4 4.   8 4  2.     4 4 4 4 4 4 2(4) 2
  4 4.   8 4  2    4 4.   8 4  2    4 4 4 4 2   4 2(4)2.
}

Melodi    = \Part \ApplyRhythm \Rytm          {     c     d   e   g    c'    b       a      b   g     f    e     d    e (f) g  e       e    c     d       e   g       c'  b     a  b    g      f      e  d   e      d  b,   c       c     e     g      f  e    d     e     f       e   d     c       d   e    d     c     b,     c      d       d       e      g      f   e   d       e     f       e   d   c    d     e      d      e    d    b,          c       c    }
StämmaEtt = \Part \ApplyRhythm \Rytm          {     c     d   e   g    g     g       g      g   g     g    g     g    g (g) g  g       g    c     d       e   g       g   g     g  g    g      g      g  g   g      g  g    g       g     g     g      g  g    g     g     f       f   f     e       g   g    g     g     g      g      g       g       g      g      g   g   g       g     f       f   f   e    e     g      g      g    g    g           g       g    }
StämmaTvå = \Part \ApplyRhythm \RytmStämmaTvå {     c     c   c   c    c     b,      b,     b,  c     c    c     c    c (c) c  c       c    c     c       c   c       c   c     c  c    c      c      c  c   g,     g, g,   g,      g,    c     c      c  c    b,    b,    a,      a,  b,    c       c   c    c     c     c      c      b, (a,) g,      c      c      c   c   b,      b,    a,      a,  a,  g,   c     c      c      c    b,   g,          a, (g,) g,   }
Text = \lyricmode                             {     sjung du  min dal  med   brin -- nan -- de  röst  tyst di -- na   he -- ta sång -- er   sjung mark -- ens gräs    å   su -- sa vart träd   sak -- ta om  dag -- en som  kom  -- mer   sjung käl -- la å    flod  sjung sten -- ar  å     jord    ge  oss  till  tröst di  -- na     sång -- er      å      sjung  du  min dal     å     brinn   i   din tro  på    fri -- het -- ens  dag  som         kom --  mer! }


\score {
  <<

    \new Staff \with { instrumentName = "Melodi" } \Melodi
    \addlyrics \Text
    \new Staff \with { instrumentName = "Stämma 1" } \StämmaEtt
    \addlyrics \Text
    \new Staff \with { instrumentName = "Stämma 2" } \StämmaTvå

  
  >>
  \layout {}
  \midi {}
}