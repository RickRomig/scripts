# dots-spin

### Dots

1.  **Purpose:** Display dots as a background process while waiting for an action to complete.

2. **Function**

   ```bash
   dots() {
     while true; do echo -n "."; sleep 0.2; done &
     trap 'kill $!' SIGTERM SIGKILL
   }
   ```

3. **Usage**

   ```bash
   echo -n "Copying files"
   dots
   # dots &
   # pid=$!
   tput civis
   for i in `seq 1 10`; do sleep 1; done
   # for i in $(seq 1 10)
   # kill $pid
   kill $!
   echo ""
   tput cnorm
   ```



### spin

1. **Purpose**: Display a spinning character as a background process while waiting for an action to complete.

2. **Function**

   ```bash
   spin()
   {
     spinner=( '|' '/' '-' '\' )
     while true; do
       for i in "${spinner[@]}"; do echo -ne "\r$i"; sleep 0.2; done &
       trap 'kill $!' SIGTERM SIGKILL
     done
   }
   ```

3. **Usage**

   ```bash
   echo "Copying files"
   spin
   # spin &
   # pid=$!
   tput civis
   for i in `seq 1 10`; do sleep 1; done
   # for i in $(seq 1 10)
   # kill $pid
   kill $!
   echo ""
   tput cnorm
  ```
