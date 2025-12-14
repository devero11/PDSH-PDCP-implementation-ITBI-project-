# Reimplementation of PDSH/PDCP as a bash script

!!! Limited functionality, work in progress !!!

# Setup
  
`copyVM`
  
The script `./copyVM` creates a speficied amount copies of a specified VM image.
The clones are indexed from `1` to `n`. In case the script is called multiple times the index continues from the last clone.
  
```bash
    ./copyVM -i path/to/image -n 10

```
  
  
  
`-i` : VM image location  
`-n` : number of clones  
  
  
 <br> 
  
`startVMs`  
  
The script `./startVMs` starts up all the VMs in a specified directory.  
It also allows for the setup of a `bridge network` and `taps` for each VM node.  

!!! Important  
  
To ensure each VM node gets assigned a `static ip` automatically you must have a `dhcp server` running on your `bridge network`.  
The script does not include etc/hosts mappings for each node(not planned for now sorry :3)   
The `bridge network` is not persistent.  
  
```bash
    ./startVMs -d directory -ns -b bridgeName

```
  
  
`-d` : nodes location  
`-ns` : bridge network setup(if ommited, manual setup will be needed for each node)   
`-b` : bridge network name(if ommited, defaults to `megatron`)  
  
    
  
  
# Implementations
