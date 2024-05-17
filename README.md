# scripts

## Description

This repository contains Bash scripts I use on my local network, along with support files, templates, and documentation.

## Function Library

The `functionlib` script is a collection of commonly used functions which I use in most of my scripts. To use, simply source it near the begining of the script. Since I use Shellcheck as my linter, I include directives to tell Shellcheck the location of the script and to disable the error message it gives about it. To use it, place the following code directory beneath the header information:
```bash
## Shellcheck Directives ##
# shellcheck source=/home/rick/bin/functionlib
# shellcheck disable=SC1091 # Disabling SC1091 is not required if using shellcheck -x to check syntax.

## Source function library ##

if [[ -x "$HOME/bin/functionlib" ]]; then
  source "$HOME/bin/functionlib"
else
  printf "\e[91mERROR:\e[0m functionlib not found!\n" >&2
  exit 1
fi
```

## Directories

### files

Support files called by scripts. These files include sed scripts, audio files, and files to be appended or prepended to other files.

### functions

Supporting documentation for the functions contained in the `functionlib` collection of functions and functions in my `.bash_aliases` file. The directory also contains examples of routines I commonly use in my scripts.

### snippets

Code snippets and code examples.

### Templates

- Templates script and source code files, scripts, C/C++ source code, and open-source licenses.
- ASCII art images for `neofetch`.

## Disclaimer
THIS SOFTWARE IS PROVIDED BY THE AUTHOR “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL The AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#### Rick Romig (*The Luddite Geek*)
##### 17 May 2024