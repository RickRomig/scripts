# Shellcheck Directives and Tips
1. Use `shellcheck -x` to check scripts that source other files.
2. Shellcheck directives (`# shellcheck disable=SCxxxx`)
	- A disable directive after the shebang, before any commands, will ignore the entire file.
	- A disable directive before a function ignores the entire function.
	- A disable directive just before a command ignores that instance.
3. **SC1091 Not following: (error message)**
	- Include `# shellcheck source=/home/rick/bin/functionlib` when sourcing the `functionlib` script.
	- Don't need to disable with `# shellcheck disable=SC1091` if using `shellcheck -x` to check script.
4. **SC2034 (warning): variable appears uunused**
	- If intentional or a throwaway variable:
		- Use `_` as a dummy variable or prefix the variable with `_`, for example `_discard`.
	- In select loops where `$REPLY` is used in the case structure instead of `$opt`:
		- `# shellcheck disable=SC2034`
5. **SC2317 Command appears to be unreachable**
	- ShellCheck may incorrectly believe that code is unreachable if it's invoked by variable name or in a trap.
		- `# shellcheck disable=SC2317 # Don't warn about unreachable commands in this function`
		- `# ShellCheck may incorrectly believe that code is unreachable if it's invoked by variable name or in a trap.`
	- Since unreachable commands may come in clusters, it's useful to use ShellCheck's file-wide or function-wide ignore directives.
