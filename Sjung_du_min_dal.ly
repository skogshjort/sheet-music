\version "2.26.0"

\header {
  title = "Sjung du min dal"
  composer = "arrangerad av Petrix"
}
Root = bes'
Mode = \major
TimeSignature = 3/4

ApplyRhythm = #(define-music-function
  (Rhythm Note)
  (ly:music? ly:music?)
  (make-sequential-music
    (map
      (lambda (Rhythm Note)
        (set! (ly:music-property Note   'duration) 
              (ly:music-property Rhythm 'duration))    
        (set! (ly:music-property Note   'articulations) 
              (ly:music-property Rhythm 'articulations))
        Note)
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

Text = \lyricmode                                          { sjung du  min dal  med   brin -- nan -- de  röst  tyst di -- na   he -- ta sång -- er   sjung mark -- ens gräs    å   su -- sa var  träd   sak -- ta om  dag -- en som  kom  -- mer   sjung käl -- la å    flod  sjung sten -- ar  å     jord    ge  oss  till  tröst di  -- na     sång -- er      å      sjung  du  min dal     å     brinn   i   din tro  på    fri -- het -- ens  dag  som         kom --  mer! }
Musik = $`(
  ((name "M")  (rytm ,Rytm)          (text ,Text) (music ,#{ c     d   e   g    c'    b       a      b   g     f    e     d    e (f) g  e       e    c     d       e   g       c'  b     a  b    g      f      e  d   e      d  b,   c       c     e     g      f  e    d     e     f       e   d     c       d   e    d     c     b,     c      d       d       e      g      f   e   d       e     f       e   d   c    d     e      d      e    d    b,          c       c    #}))
  ((name "S1") (rytm ,Rytm)          (text ,Text) (music ,#{ c     d   e   g    g     g       g      g   g     g    g     g    g (g) g  g       g    c     d       e   g       g   g     g  g    g      g      g  g   g      g  g    g       g     g     g      g  g    g     g     f       f   f     e       g   g    g     g     g      g      g       g       g      g      g   g   g       g     f       f   f   e    e     g      g      g    g    g           g       g    #}))
  ((name "S2") (rytm ,RytmStämmaTvå) (text ,Text) (music ,#{ c     c   c   c    c     b,      b,     b,  c     c    c     c    c (c) c  c       c    c     c       c   c       c   c     c  c    c      c      c  c   g,     g, g,   g,      g,    c     c      c  c    b,    b,    a,      a,  b,    c       c   c    c     c     c      c      b, (a,) g,      c      c      c   c   b,      b,    a,      a,  a,  g,   c     c      c      c    b,   g,          a, (g,) g,   #}))
)
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
          \new Staff \with { instrumentName = $(car (assq-ref Pair 'name)) shortInstrumentName = $(car (assq-ref Pair 'name)) } \relative \Root {
            \time \TimeSignature
            \key \Root \Mode
            \transpose c \Root { \ApplyRhythm $(car (assq-ref Pair 'rytm)) $(car (assq-ref Pair 'music)) }
          }
          \addlyrics $(car (assq-ref Pair 'text))
        #})
        (map (lambda (I) (list-ref Musik I)) Indexes)))
    >>
  #})

\score { \Parts $'(0 1 2) }
\pageBreak
\score { \Parts 0 }
\score { \Parts 1 }
\score { \Parts 2 }
