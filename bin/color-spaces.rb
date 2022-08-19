#
#!/usr/bin/env ruby

puts "256 color mode\n\n";

# display back ground colors
for ($fgbg = 38; $fgbg <= 48; $fgbg +=10) {

    # first the system ones:
    puts "System colors:\n";

    for ($color = 0; $color < 8; $color++) {
        puts "\x1b[${fgbg};5;${color}m::";
    }
    puts "\x1b[0m\n";
    for ($color = 8; $color < 16; $color++) {
        puts "\x1b[${fgbg};5;${color}m::";
    }
    puts "\x1b[0m\n\n";

    # now the color cube
    puts "Color cube, 6x6x6:\n";
    for ($green = 0; $green < 6; $green++) {
        for ($red = 0; $red < 6; $red++) {
      for ($blue = 0; $blue < 6; $blue++) {
          $color = 16 + ($red * 36) + ($green * 6) + $blue;
          puts "\x1b[${fgbg};5;${color}m::";
      }
      puts "\x1b[0m ";
        }
        puts "\n";
    }

    # now the grayscale ramp
    puts "Grayscale ramp:\n";
    for ($color = 232; $color < 256; $color++) {
        puts "\x1b[${fgbg};5;${color}m::";
    }
    puts "\x1b[0m\n\n";

    }

    puts "Examples for the 3-byte color mode\n\n";

    for ($fgbg = 38; $fgbg <= 48; $fgbg +=10) {

    # now the color cube
    puts "Color cube\n";
    for ($green = 0; $green < 256; $green+=51) {
        for ($red = 0; $red < 256; $red+=51) {
      for ($blue = 0; $blue < 256; $blue+=51) {
                puts "\x1b[${fgbg};2;${red};${green};${blue}m::";
      }
      puts "\x1b[0m ";
        }
        puts "\n";
    }

    # now the grayscale ramp
    puts "Grayscale ramp:\n";
    for ($gray = 8; $gray < 256; $gray+=10) {
        puts "\x1b[${fgbg};2;${gray};${gray};${gray}m::";
    }
    puts "\x1b[0m\n\n";

}
