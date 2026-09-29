\version "2.26.0"

Title = "Sjung du min dal"
Composer = "arrangerad av Petrix"
Root = bes'
Mode = \major
TimeSignature = 3/4

Part = #(define-music-function
  (Name    NameShort Music     Lyrics)
  (string? string?   ly:music? ly:music?)
  #{
    \new Staff \with { instrumentName = $Name shortInstrumentName = $NameShort } \relative \Root {
        \time \TimeSignature
        \key \Root \Mode
        \transpose c \Root { $Music }
      }
      \addlyrics $Lyrics
  #}
)

% Helper function to copy duration + articulations from one NoteEvent to another NoteEvent
ApplyRhythmSingleEvent = #(define-music-function
  (Rhythm Note)
  (ly:music? ly:music?)
  (set! (ly:music-property Note   'duration) 
        (ly:music-property Rhythm 'duration))    
  (set! (ly:music-property Note   'articulations) 
        (ly:music-property Rhythm 'articulations))
  Note)

% Helper function to copy duration + articulations from a phrase to another
ApplyRhythm = #(define-music-function
  (Rhythm Note)
  (ly:music? ly:music?)
  (make-music 'SequentialMusic 'elements
    (map ApplyRhythmSingleEvent
      (ly:music-property Rhythm 'elements)
      (ly:music-property Note 'elements))))

Rytm = { c
    4.   8 4  2    4 4.   8 4  2.     4 4 4 4(4)4 2.  2.
    4  4   4  2    4 4.   8 4  2.     4 4 4 4 4 4 2.  2
  4 4.   8 4  2    4 4.   8 4  2.     4 4 4 4 4 4 2.  2
  4 4.   8 4  2    4 4.   8 4  2    4 4 4 4 2   4 2.  2.
}
RytmStämmaTvå = { c
    4.   8 4  2    4 4.   8 4  2.     4 4 4 4(4)4 2.  2.
    4  4   4  2    4 4.   8 4  2.     4 4 4 4 4 4 2.  2
  4 4.   8 4  2    4 4.   8 4  2.     4 4 4 4 4 4 2(4)2   % <<< lite annorlunda 
  4 4.   8 4  2    4 4.   8 4  2    4 4 4 4 2   4 2(4)2.  % <<< här på slutet
}

Musik = #(list
  (list "M"  #{ \ApplyRhythm \Rytm          {     c     d   e   g    c'    b       a      b   g     f    e     d    e (f) g  e       e    c     d       e   g       c'  b     a  b    g      f      e  d   e      d  b,   c       c     e     g      f  e    d     e     f       e   d     c       d   e    d     c     b,     c      d       d       e      g      f   e   d       e     f       e   d   c    d     e      d      e    d    b,          c       c    } #})
  (list "S1" #{ \ApplyRhythm \Rytm          {     c     d   e   g    g     g       g      g   g     g    g     g    g (g) g  g       g    c     d       e   g       g   g     g  g    g      g      g  g   g      g  g    g       g     g     g      g  g    g     g     f       f   f     e       g   g    g     g     g      g      g       g       g      g      g   g   g       g     f       f   f   e    e     g      g      g    g    g           g       g    } #})
  (list "S2" #{ \ApplyRhythm \RytmStämmaTvå {     c     c   c   c    c     b,      b,     b,  c     c    c     c    c (c) c  c       c    c     c       c   c       c   c     c  c    c      c      c  c   g,     g, g,   g,      g,    c     c      c  c    b,    b,    a,      a,  b,    c       c   c    c     c     c      c      b, (a,) g,      c      c      c   c   b,      b,    a,      a,  a,  g,   c     c      c      c    b,   g,          a, (g,) g,   } #})
) Text = \lyricmode                         {     sjung du  min dal  med   brin -- nan -- de  röst  tyst di -- na   he -- ta sång -- er   sjung mark -- ens gräs    å   su -- sa var  träd   sak -- ta om  dag -- en som  kom  -- mer   sjung käl -- la å    flod  sjung sten -- ar  å     jord    ge  oss  till  tröst di  -- na     sång -- er      å      sjung  du  min dal     å     brinn   i   din tro  på    fri -- het -- ens  dag  som         kom --  mer! }



\paper {
  score-system-spacing.basic-distance = #30
  page-count = #2
  left-margin  = #20
  right-margin = #15
}
\layout {
  margin-right.basic-distance = #0
  #(layout-set-staff-size 23)
  text-font-size = #7
  indent       = #0
  \context {
    \Score proportionalNotationDuration = #1/4
  }
  \context {
    \Staff
    \override InstrumentName.font-size = #7
    \override InstrumentName.font-series = #'bold
    \override InstrumentName.direction = #-1
    \override InstrumentName.padding = #1
  }
}

Parts = #(define-scheme-function
  (Indexes)
  (cheap-list?)
  #{
    \new StaffGroup <<
      $(make-simultaneous-music (map
        (lambda (Pair)#{
          \Part $(car Pair) $(car Pair) $(cadr Pair)  \Text
        #})
        (map (lambda (I) (list-ref Musik I)) Indexes)))
    >>
  #})

\markuplist {
  \fill-line {
    \line {}
    \line { \magnify #2.0 \bold \Title }
    \line {}
  }
  \fill-line {
    \line {}
    \line {}
    \line { \italic \Composer }
  }
}


\score { \Parts $'(0 1 2) }
\pageBreak
\score { \Parts 0 }
\score { \Parts 1 }
\score { \Parts 2 }
