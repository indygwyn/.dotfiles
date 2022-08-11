# purpose: converts Json to Yaml
# input: any Json
# output: json converted to yaml
def toYaml:
   def handleMultilineString($level):
      reduce ([match("\n+"; "g")]                       # find groups of '\n'
              | sort_by(-.offset))[] as $match
             (.; .[0:$match.offset + $match.length] +
                 "\n\("    " * $level)" +               # add one extra '\n' for every group of '\n's. Add indention for each new line
                 .[$match.offset + $match.length:]);

   def toYamlString($level):
      if type == "string"
      then handleMultilineString($level)
           | sub("'"; "''"; "g")           # escape single quotes
           | "'\(.)'"                      # wrap in single quotes
      else .
      end;

   def _toYaml($level):
      (objects | to_entries[] |
          if (.value | type) == "array" then
              "\(.key):", (.value | _toYaml($level))
          elif (.value | type) == "object" then
              "\(.key):", "\("    ")\(.value | _toYaml($level))"
          else
              "\(.key): \(.value | toYamlString($level))"
          end
      )
      // (arrays | select(length > 0)[] | [_toYaml($level)] |
          "  - \(.[0])", "\("    ")\(.[1:][])"
      )
      // .;

   _toYaml(1);
