from wtslog import Logger

INPUT_PATH: str = "./assets/bashAliases"
OUTPUT_PATH: str = "./_out/bashAliases"
LOG_PATH: str = "./_log/generateBashAliases.py.log"

outputLogger: Logger = Logger(LOG_PATH)

bash_aliases: dict = {}
bash_alias_lines: [str] = []

# Read the input file
with open(INPUT_PATH, "r") as default_alias_file:
    default_alias_lines = default_alias_file.read().strip().split("\n")
default_alias_lines = [l.strip() for l in default_alias_lines]

# Parse the input file
for default_alias_line in default_alias_lines:
    parts: [str] = default_alias_line.split(": ", 1)
    aliasName: str = parts[0]
    aliasValue: str = parts[1]
    bash_aliases[aliasName] = aliasValue

# Write aliases as bash commands
bash_alias_lines = [f"alias {a}=\"{b}\"" for (a,b) in bash_aliases.items()]
with open(OUTPUT_PATH, "w") as output_file:
    for inx, l in enumerate(bash_alias_lines):
        output_file.write(l)
        if inx != len(bash_alias_lines)-1:
            output_file.write("\n")
