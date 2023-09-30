# for loops
```bash
for i in 'seq 1 10'; do echo "$i"; done

for i in $(seq 10); do   echo "$i"; done

for i in {1..10}; do echo "$i"; done

for i in {0..20..2}; do echo "$i"; done

for i in "$(spinner[@])"; do echo -ne "\r$i"; sleep 0.2; done

for rcpkg in "$(dpkg -l | awk `/^rc/ {print $2}`)"; do sudo apt-get remove --purge "$rcpkg"; done

for (( i=0; i <= 10; i++ )); do echo "$i"; done

for (( i=0; i <= "$bs_level"; i++ )); do echo -n "*"; done

for (( i=0; i<=$1; i++ ))
do
  echo "C-style for loop:" $i
done

for i in {1..4}
do
  echo "For loop with a range:" $i
done

for i in "zero" "one" "two" "three"
do
  echo "For loop with a list of words:" $i
done

website="How To Geek"

for i in $website
do
  echo "For loop with a collection of words:" $i
done
```