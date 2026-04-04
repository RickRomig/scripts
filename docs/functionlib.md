# functionlib

### Introduction
1. **Functionlib** is a library of functions that can be incorporated into Bash scripts.
2. This library can be incorporated by sourcing it at the beginning of your script before variables or functions are declared.
   `. /home/user/bin/functionlib` or `. functionlib`
3. You may place this library anywhere in your executable path. Suitable locations might be:
   * `/home/user/bin/functionlib` (Recommended)
   * `/home/user/.local/bin/functionlib`
   * `/usr/local/bin/functionlib` (available to all users on the system)
4. The path to the function library may be omitted as long as it is in your executable path. If it's in a location not in your path, it must be hard-coded. Using environmental variables such as `$HOME` or `$USER` will not work.
5. This library has been tested using Bash with various Debian-based Linux distributions, specifically Debian, Linux Mint, Ubuntu, MX Linux, antiX, Peppermint, and Linux Lite. The functions should work in any distribution based on Debian or Ubuntu.
6. Some functions may not be POSIX compliant and may not work in shell enviroments other than Bash.
### Global variables
Global variables are available to the script sourcing the function library.
| Variable | Purpose |
| -------- | ------  |
| TRUE=0   | Used by functions that return true or false. |
| FALSE=1  | Used by functions that return true or false. |
| LOCALNET | Used by the `valid_ip` function and in scripts. This variable represents the first three octets of a private Class C network (192.168.1.0). Change as required for your own network.  Will detect networks used in virtual machines using 10.0.2.0/24 and 192.168.122.0/24 (Gnome Boxes and Virt-Manager). |
| RED_ERROR | Displays "ERROR" in red text. |
| RED_WARNING | Displays "WARNING" in red text. |
### Error Codes
Several personalized error (exit) codes are listed for common error conditions.
### Colors
1. Global variables set to the escape sequences for text attributes, text (foreground) colors, and background colors.
2. Lowercase colors indicate foreground color and uppercase indicates background colors.
3. The color variables should be inclosed in curly brackets to separate them from the text, for instance, `echo "${red}some text.${normal}"`
4. When used as variables in printf statements, brackets are not necessry, ie., `printf "%sSome text%s\n" "$red" "$normal"`
### Functions
Documentation for the functions are contained in this directory.

Richard B. "Rick" Romig, *The Luddite Geek*
04 April 2026
* [Gitea](http://192.168.0.16:3000/)
* [GitHub](https://github.com/RickRomig/)
* [Rick's Tech Stuff](https://ricktech.wordpress.com)
* **Email:** [rick.romig@gmail.com](mailto:rick.romig@gmail.com) or [rick.romig@mymetronet.net](mailto:rick.romig@mymetronet.net)

### DISCLAIMER

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL I BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS AND SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
