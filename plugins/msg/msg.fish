#    __ _  ___ ___ _
#   /  ' \(_-</ _ `/
#  /_/_/_/___/\_, /
#            /___/ v0.1.0
#
# NAME
#      msg - technicolor message printer
#
# SYNOPSIS
#      msg [-sn] @<fg:bg> [style]<text>[style]
#
# OPTIONS
#      -s
#          Do not separate arguments with spaces.
#      -n
#          Do not output a newline at the end of the message.
#
# STYLES
#      _text_                 Bold
#      __text__               Underline
#      ___text___             Bold and Underline
#      /directory/            Directories
#      [url]                  Links
#      \n                     Line Break
#      \t                     Tab Space
#
#      @<fg:bg> fg=bg=RGB|RRGGBB|name|random
#        RGB value can be any three to six hex digit or color name.
#        e.g, @0fb, @tomato, @random, @error, @ok.
#
# AUTHORS
#      @bucaran (Jorge Bucaran)
#
# v. 0.1.0
# /
set --global msg_color_fg   FFFFFF
set --global msg_color_bg   normal
set --global msg_style_url  00FF00 $msg_color_bg -u
set --global msg_style_dir  FFA500 $msg_color_bg -u
set --global msg_color_err  FF0000
set --global msg_color_ok   00FA9A

function msg -d "Technicolor printer."
  set -l reset (set_color normal)(set_color $msg_color_fg)
  set -l fg $msg_color_fg
  set -l bg $msg_color_bg
  # Set style, fg/bg colors and reset. Note this function
  # modifies variables in the parent scope.
  # @params [<fg>] [<bg>] [<style>]
  function --no-scope-shadowing msg._.set.color
    [ (count $argv) -gt 0 ]
      and set fg $argv[1]
    [ (count $argv) -gt 1 ]
      and set bg $argv[2]
    # Resets color as a side effect.
    set_color -b $bg
    set_color $fg
    [ (count $argv) -gt 2 ]
      and set_color $argv[3]
    set bg $msg_color_bg
    set fg $msg_color_fg
  end

  # Default " " whitespace between strings, skip with -s.
  set -l ws " "
  # Default \n after message, skip with -n.
  set argv $argv \n
  switch $argv[1]
    case -s\* -n\*
      msg._.str.has s $argv[1]
        and set ws ""
      msg._.str.has n $argv[1]
        and set -e argv[-1]
      set -e argv[1]
  end

  for token in $argv
    switch $token
      case ___\*___\* __\*__\* _\*_\* \[\*\]\* \/\*\/\*
        set -l left   _ # Begin of style
        set -l right  _ # End of style
        set -l color $fg $bg -o
        switch $token
          case ___\*___\* __\*__\* _\*_\*
            msg._.str.has __ $token
              and set color[3] -u
              and set left __
              and msg._.str.has ___ $token
                and set color[3] -uo
                and set left ___
          case \[\*\]\*
            set color $msg_style_url
            set left [ ]
            set right ]
          case \/\*\/\*
            set color $msg_style_dir
            set left \/
            set right $left
        end
        # Extract text inside left and right separators.
        echo -n (msg._.set.color $color)(msg._.str.grab $left $token)$reset
        # Extract string after separator from the right.
        echo -n (printf $token | sed "s/^.*\\$right\(.*\)/\1/")$ws

      case @\*
        set fg (printf $token | cut -c 2-)  # @fg[:bg] → fg[:bg]
        set bg (printf $fg | cut -d: -f 2)  # fg:bg    → fg|bg
        set fg (printf $fg | cut -d: -f 1)  # fg:bg    → fg
        [ $bg = $fg ]
          and not msg._.str.has : $token
            and set bg $msg_color_bg
        set fg (msg._.get.color $fg)
        set bg (msg._.get.color $bg)

      case \*
        set -l space $ws
        switch $token
          case \n\* \t\* # No space after \n \t
            set space ""
          case \\\[\* \\\/\* \\\_\* # Escape \\[text] and \\/text/
            set token (printf $token | sed "s/^\\\//")
        end
        echo -en (msg._.set.color)$token$reset
        [ -z $ws -o $argv[-1] = $token ]
          or echo -n $space
    end
  end
end

# True if substring exists in string.
# @params <substring> <string>
function msg._.str.has
  printf $argv[2] | grep -q $argv[1]
end

# Extract string between left and right separators of variable length.
# @params <left-sep> [<right-sep>] <string>
function msg._.str.grab
  set -l left   $argv[1]
  set -l right  $argv[1]
  set -l string $argv[2]

  [ (count $argv) -gt 2 ]
    and set right $argv[2]
    and set string $argv[3]

  set -l len (printf $left | awk '{print length}')
  # Match inside of outermost left and right separators (included).
  # Trim off left and right separators.
  printf $string | sed "s/[^\\$left]*\(\\$left.*\\$right\)*/\1/g" | \
                   sed "s/^.\{$len\}\(.*\).\{$len\}\$/\1/"
end

# Print a random RRGGBB hexadecimal color.
function msg._.random.color
  printf "%02x%02x%02x" (math (random) "%" 255) \
                        (math (random) "%" 255) \
                        (math (random) "%" 255)
end

# Translate color names to valid RRGGBB hexadecimal value.
# @params <color|random>
function msg._.get.color
  [ (count $argv) -lt 1 ]
    and printf $msg_color_fg
  switch $argv[1]
    case success ok
      printf "%s\n" $msg_color_ok
    case error
      printf "%s\n" $msg_color_err
    case random
      msg._.random.color
   	case maroon
      printf 800000
   	case d\*red
      printf 8B0000
   	case brown
      printf A52A2A
   	case firebrick
      printf B22222
   	case crimson
      printf DC143C
   	case red
      printf FF0000
   	case tomato
      printf FF6347
   	case coral
      printf FF7F50
   	case indianred
      printf CD5C5C
   	case l\*coral
      printf F08080
   	case d\*salmon
      printf E9967A
   	case salmon
      printf FA8072
   	case l\*salmon
      printf FFA07A
   	case orangered
      printf FF4500
   	case d\*orange
      printf FF8C00
   	case orange
      printf FFA500
   	case gold
      printf FFD700
   	case d\*goldenrod
      printf B8860B
   	case goldenrod
      printf DAA520
   	case palegoldenrod
      printf EEE8AA
   	case d\*khaki
      printf BDB76B
   	case khaki
      printf F0E68C
   	case olive
      printf 808000
   	case yellow
      printf FFFF00
   	case yellowgreen
      printf 9ACD32
   	case d\*olivegreen
      printf 556B2F
   	case olivedrab
      printf 6B8E23
   	case lawngreen
      printf 7CFC00
   	case chartreuse
      printf 7FFF00
   	case greenyellow
      printf ADFF2F
   	case d\*green
      printf 006400
   	case green
      printf 008000
   	case forestgreen
      printf 228B22
   	case lime
      printf 00FF00
   	case limegreen
      printf 32CD32
   	case l\*green
      printf 90EE90
   	case palegreen
      printf 98FB98
   	case d\*seagreen
      printf 8FBC8F
   	case mediumspringgreen
      printf 00FA9A
   	case springgreen
      printf 00FF7F
   	case sea green
      printf 2E8B57
   	case mediumaquamarine
      printf 66CDAA
   	case mediumseagreen
      printf 3CB371
   	case l\*seagreen
      printf 20B2AA
   	case d\*slategray
      printf 2F4F4F
   	case teal
      printf 008080
   	case d\*cyan
      printf 008B8B
   	case aqua
      printf 00FFFF
   	case cyan
      printf 00FFFF
   	case l\*cyan
      printf E0FFFF
   	case d\*turquoise
      printf 00CED1
   	case turquoise
      printf 40E0D0
   	case mediumturquoise
      printf 48D1CC
   	case paleturquoise
      printf AFEEEE
   	case aquamarine
      printf 7FFFD4
   	case powderblue
      printf B0E0E6
   	case cadetblue
      printf 5F9EA0
   	case steelblue
      printf 4682B4
   	case cornflowerblue
      printf 6495ED
   	case deepskyblue
      printf 00BFFF
   	case dodgerblue
      printf 1E90FF
   	case l\*blue
      printf ADD8E6
   	case skyblue
      printf 87CEEB
   	case l\*skyblue
      printf 87CEFA
   	case midnightblue
      printf 191970
   	case navy
      printf 000080
   	case d\*blue
      printf 00008B
   	case mediumblue
      printf 0000CD
   	case blue
      printf 0000FF
   	case royalblue
      printf 4169E1
   	case blueviolet
      printf 8A2BE2
   	case indigo
      printf 4B0082
   	case d\*slateblue
      printf 483D8B
   	case slateblue
      printf 6A5ACD
   	case mediumslateblue
      printf 7B68EE
   	case mediumpurple
      printf 9370DB
   	case d\*magenta
      printf 8B008B
   	case d\*violet
      printf 9400D3
   	case d\*orchid
      printf 9932CC
   	case mediumorchid
      printf BA55D3
   	case purple
      printf 800080
   	case thistle
      printf D8BFD8
   	case plum
      printf DDA0DD
   	case violet
      printf EE82EE
   	case magenta fuchsia
      printf FF00FF
   	case orchid
      printf DA70D6
   	case mediumvioletred
      printf C71585
   	case palevioletred
      printf DB7093
   	case deeppink
      printf FF1493
   	case hotpink
      printf FF69B4
   	case l\*pink
      printf FFB6C1
   	case pink
      printf FFC0CB
   	case antiquewhite
      printf FAEBD7
   	case beige
      printf F5F5DC
   	case bisque
      printf FFE4C4
   	case blanchedalmond
      printf FFEBCD
   	case wheat
      printf F5DEB3
   	case cornsilk
      printf FFF8DC
   	case lemonchiffon
      printf FFFACD
   	case l\*goldenrodyellow
      printf FAFAD2
   	case l\*yellow
      printf FFFFE0
   	case saddlebrown
      printf 8B4513
   	case sienna
      printf A0522D
   	case choco chocolate
      printf D2691E
   	case peru
      printf CD853F
   	case sandybrown
      printf F4A460
   	case burlywood
      printf DEB887
   	case tan
      printf D2B48C
   	case rosybrown
      printf BC8F8F
   	case moccasin
      printf FFE4B5
   	case navajowhite
      printf FFDEAD
   	case peach peachpuff
      printf FFDAB9
   	case rose mistyrose
      printf FFE4E1
   	case lavenderblush
      printf FFF0F5
   	case linen
      printf FAF0E6
   	case oldlace
      printf FDF5E6
   	case papaya papayawhip
      printf FFEFD5
   	case seashell
      printf FFF5EE
   	case mintcream
      printf F5FFFA
   	case slategray
      printf 708090
   	case l\*slategray
      printf 778899
   	case l\*steelblue
      printf B0C4DE
   	case lavender
      printf E6E6FA
   	case floralwhite
      printf FFFAF0
   	case aliceblue
      printf F0F8FF
   	case ghostwhite
      printf F8F8FF
   	case honeydew
      printf F0FFF0
   	case ivory
      printf FFFFF0
   	case azure
      printf F0FFFF
   	case snow
      printf FFFAFA
   	case black
      printf 000000
   	case dimgray dimgrey
      printf 696969
   	case gray grey
      printf 808080
   	case d\*gray d\*grey
      printf A9A9A9
   	case silver
      printf C0C0C0
   	case l\*gray l\*grey
      printf D3D3D3
   	case gainsboro
      printf DCDCDC
   	case whitesmoke
      printf F5F5F5
   	case white
      printf FFFFFF
    case "*"
      printf $argv[1]
  end
end

function msg._.test
  set -l dot @random:random "  "
  for 1 in (seq 6)
    set dot $dot $dot
  end
  msg -s @black:yellow "    Loading ...  " $dot @success
  msg _msg_ the @yellow:red technicolor __printer__!\
      \n A _brave_ new __line__.\
      \n [http://github.com/oh-my-fish] @red → \\[url]\
      \n /dir/ect/to/ri/es/ @red → \\/directories/
end
