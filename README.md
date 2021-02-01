# Robot localisation docker image
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/silvesterhsu/ros-gpu?style=plastic)

A Development environment based on ubuntu 20.04 with the LXDE desktop environment. It contains a deep learning development environments based on pyhton3 ( pytorch). Other framework can be easily be installed through `pip`. Besides, it has a friendly graphical interface and can also run python commands through the terminal.

Docker Link: [ROS GPU](https://hub.docker.com/r/silvesterhsu/ros_gpu)

Github Link: [ROS GPU](https://github.com/SilvesterHsu/docker-ros-gpu)

## LATEST `TAG` Update

### Noetic (recommend)

* `noetic-base`, `noetic-base-ubuntu20.04`
* `noetic-cuda11.0-runtime`, `noetic-cuda11.0-cudnn8-runtime`, `noetic-cuda11.0-cudnn8-runtime-ubuntu20.04`, `noetic-cuda11.0-runtime-ubuntu20.04`
* `noetic-cuda11.0-devel`, `noetic-cuda11.0-cudnn8-devel`, `noetic-cuda11.0-cudnn8-devel-ubuntu20.04`, `noetic-cuda11.0-devel-ubuntu20.04`
* `noetic-desktop`, `noetic-cuda11.0-desktop`, `noetic-desktop-ubuntu20.04`, `noetic-cuda11.0-desktop-ubuntu20.04`

### Melodic

* `melodic-base`, `melodic-base-ubuntu18.04`
* `melodic-desktop`, `melodic-desktop-ubuntu18.04`

## Why I build it?

* **Docker:** Use docker technology to avoid damage to the computer environment
  
  * No need to install ROS, CUDA, Python or any ML tools
  * Easy remote deployment
  * No need to worry about any damage, in any case, you can re-execute docker run this repository to restore as before
  
* **UI:** Provide a completed Linux UI interface for easy operation
  * Can remotely connect to its desktop through a **Browser !!!**
  
    > Run on machine A (has GPU), and connect to its desktop in machine B (no GPU) through a browser. (ipad browser also supports)

  * Contains full ROS, you can easily start RViz. And use it as usual

  * Contains terminal inside, you can easily start `jupyter`
  
  * Contains file system, you can easily change and move files
  
* **Remote:** Provide **Pycharm remote debugging**, as smooth as local debugging

  * Enjoy the high performance of the server
  * Can remotely connect to its python environment through a local Pycharm
  * Remote debugging

## What's in it?
* Python 3
* CUDA 11.0.3
* Cudnn 8.0.4.30
* Pytorch 1.7.0 (GPU supported)
* ROS (Build for pyhton3)

> The **versions** above can be edited in the `Dockerfile`, then the image needs to be built.

## Which systems can use it？
* Windows (GPU not supported)
* Mac OS
* Linux

**Make GPU available to docker:**
According to [Nvidia guidance](https://github.com/NVIDIA/nvidia-docker), for first-time users of Docker 19.03 and GPUs, continue with the instructions for getting started below.
```bash
# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

## How does it look?

<img src="https://tva1.sinaimg.cn/large/00831rSTgy1gdf3nee2t5j31hc0u0ty7.jpg" width = "100%" />

<img src="https://tva1.sinaimg.cn/large/008eGmZEgy1gmmzi72djij31hc0u0h0j.jpg" width = "100%" />

> VNC is turned on automatically by default, however Jupyter notebook will not started by default.

## How to use?
**Quickstart** tutorial is also given [here](https://gist.github.com/SilvesterHsu/d27159a392b8f4eb54c7846e09dca6e8).

Suppose, we have 2 computers, **Local Machine** and **Remote Server** with ip `xxxx.xxxx.xxxx.xxxx`. If you use a computer as both Local Machine and Remote Server, replace the ip `xxxx.xxxx.xxxx.xxxx` with `127.0.0.1` in the below tutorial.

> In my example, I use a Macbook as the **Local Machine**. Besides, I choose Blade notebook as the **Remote Server** with ip `192.168.3.53`. I am able to operate the **ROS Desktop** through `192.168.3.53:6080` in Chrome Browser. And debug code in the Pycharm on my MacBook.

### Step 1: Run docker container [on Remote Server]

```bash
docker run -it --name ros --restart=always --gpus all --shm-size=32G -p $PORT:6606 -p $PORT:8888 -p $PORT:80 -p $PORT:22 -v "$PWD":/notebooks silvesterhsu/ros_gpu:"$TAG"
```
`$PORT`: Port mapping. It is the port that needs to link the local to the image. In docker, jupyter will open port 8888 as a web access. If the local port 8888 is not occupied, it is recommended to use 8888. Similarly, 6006 is the port of tensorboard , 80 is the port of browser and 22 is the port for pycharm debugging.

> For Pycharm debug, pls add `-p $PORT:22` for debug port.

`$PWD`: File mapping. Project work path

`$TAG`: For the time being, only latest and slim, if not filled in, the latest version is downloaded by default. The ARM version may be available in the future.

> Essential to add `--shm-siz` to set up shared memory size!!! Otherwise, pytorch's multi-threaded Dataloader cannot work.

**Example:**
```bash
docker run -it --name ros --restart=always --gpus all --shm-size=32G -p 6006:6606 -p 8888:8888 -p 6080:80 -p 8022:22 -v ~/new_project:/notebooks silvesterhsu/ros_gpu:noetic-desktop-ubuntu20.04
```
**Note:** Once you can access the desktop of the container through the step 2, please **ignore all the output of this step and close the terminal**. Because we use VNC as the suspended object of the container, it will run continuously in the background.

### Step 2: Access through browser and vnc viewer [on Local Machine]

There are 2 way to connect to the **ROS desktop**.

**Easy access via browser** (recommended)

Browse http://xxxx.xxxx.xxxx.xxxx:6080/  to connect to the desktop inside this repository.

**Access via VNC**
Forward VNC service port 5900 to host by adding `-p 5900:5900` in the docker run.

VNC password is also supported. Set by environment variables `-e VNC_PASSWORD=passwd`.
### Optional: Start a Jupyter notebook [on Local Machine]

**Jupyter Icon** (recommended)

Double-click the Jupyter icon on the desktop of the web http://xxxx.xxxx.xxxx.xxxx:6080/. Once jupyter start, browse http://xxxx.xxxx.xxxx.xxxx:8888/ on your local machine. 

> By default, a warning will pop up asking how to open it. You can choose `Execute`.
>
> How to permanently turn off reminders: 
>
> 1. Open `file manager` in the lower left corner
> 2. Choose `Edit` --> `Preferences`
> 3. Click `Don't ask options on launch executable file`
> 4. Warning will never pop up when you start Jupyter or RViz

### Optional: Terminal [on Remote Server]
Connect via `docker exec -it ros /bin/bash`.

**Note:** if you use docker `exec` to connect, you need to load the **ROS environment** first by

```bash
source /opt/ros/noetic/setup.bash
```

### Optional: Pycharm debug (new!!!) [on Local Machine]

Through port **`22`**, Pycharm can be connected to the python environment inside the docker container. Compared with the limited internal docker connection of pycharm, we adopted a more applicable **remote connection**.

#### Stage 1. Add `22` port mapping  [on Remote Server]

There are 2 ways to add port mapping,

> Move to **Stage 2**,  if you already created a container with 22 port mapping.

* Add 22 port mapping **when creating the container (easy)**

  If you haven't run the ros container, use `-p $port:22` to map the container port `22` to machine's port `$port`.

  For example, use local port `8022` to map to the `22` port inside a container.

```shell
docker run -it --name ros --restart=always --gpus all --shm-size=32G -p 6006:6606 -p 8888:8888 -p 6080:80 -p 8022:22 -v ~/new_project:/notebooks silvesterhsu/ros_gpu:noetic-desktop-ubuntu20.04
```

* Add 22 port mapping **after creating the container** 

  If you already run a container, it's best to update the iptables manually. The easiest way is to save the iptable and modify the backup file, and finally change the iptable through the backup file.

  **Save iptable rule:**

  ```shell
  sudo iptables-save > ~/iptables.rules
  ```

  **Inspect the internal IP address**

  ```shell
  docker inspect ros | grep IPAddress
  ```

  > Here `ros` is my container's name. If you define your own ros container's name, pls replace the `ros`  to inspect the container's IP address

  For example,

  ```shell
  # seel @ seel-Blade-Pro in ~ [13:51:13] 
  $ docker inspect ros | grep IPAddress                         
              "SecondaryIPAddresses": null,
              "IPAddress": "172.17.0.4",
                      "IPAddress": "172.17.0.4",
  ```

  **Modify file:**

  ```shell
  nano ~/iptables.rules
  ```
  
  and add rules to the ip of ros container

  For example, I add the following for my `"IPAddress": "172.17.0.4"`

  ```shell
  -A POSTROUTING -s 172.17.0.4/32 -d 172.17.0.4/32 -p tcp -m tcp --dport 22 -j MASQUERADE

  -A DOCKER ! -i docker0 -p tcp -m tcp --dport 8022 -j DNAT --to-destination 172.17.0.4:22

  -A DOCKER -d 172.17.0.4/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport 22 -j ACCEPT
  ```
  
  > The iptable is completely different on different computers and systems, so please add them according to different situations
  
  **Change iptable rule:**
  
  ```shell
  sudo iptables-restore < ~/iptables.rules
  ```


#### Stage 2. Install `pycharm_remote` [on ROS Desktop]

Get to the ROS Desktop first (browse http://xxxx.xxxx.xxxx.xxxx:6080/). If not, turn to **Step 2**. 

Run the commond below in the **terminator** to install `pycharm_remote` automatically.

```shell
wget -O - http://jupi.ink:83/ros/install_pycharm_remote.sh | bash
```

#### Stage 3. Run `pycharm_reomte` [on ROS Desktop]

Double click the `pycharm_reomte` icon on the remote desktop.

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gn8e17qxxwj301s01smx5.jpg)

Once it started, everything on the Remote Server is ready. And press any key to exit.

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gn84vmxfzfj30kf03djrt.jpg)

#### Stage 4. Configure Pycharm for your project [on Local Machine]

**Note:** Make sure you already launch `pycharm_reomte` and start it.

There are only 4 steps to configure pycharm:

* Set ssh connection (After finishing, no need to do in the future)

* Create remote Python interpreter  (After finishing, no need to do in the future)

* Add ROS lib to Python interpreter  (After finishing, no need to do in the future)

* Select remote Python interpreter for your project (Do it for each project)

  

1. Open Pycharm to set ssh connection

   * Pycharm > Preferences > Tools > SSH Configuration > Add

   * Change the `host` into your service IP address. If you run ROS container and Pycharm in the same machine, change it into `127.0.0.1` for connection.
   * Change the `port` to the port used to map the `22` port. For example, when creating the ROS container with `-p 8022:22`, then the port here should be `8022`
   * The default username is `root`, and the password is `ShARC`
   * After configuration, you can *test connection* and save the configure

   ![](https://tva1.sinaimg.cn/large/008eGmZEgy1gn85vqhiurj30rp0k2tba.jpg)

2. Connect to remote Python interpreter

   * Pycharm > Preferences > Project > Python Interpreter
   * Click ![](https://tva1.sinaimg.cn/large/008eGmZEgy1gn879gkw9ej300k00mjra.jpg) to show all Python Interpreters, and select "add" to add new python interpreter
   * Select the existing server configuration
   ![](https://tva1.sinaimg.cn/large/008eGmZEgy1gn87bdzc43j30nq06q3zk.jpg)
   * Click next to map the project path to ROS container's path `/notebooks`, and finish interpreter configuration
     ![](https://tva1.sinaimg.cn/large/008eGmZEgy1gn891rjabjj30ng05tq3m.jpg)
   * File synchronization will start automatically. To view remote files, Tools > Deployment > Browse Remote Host
   ![](https://tva1.sinaimg.cn/large/008eGmZEgy1gn86rkdctfj313z0fatcc.jpg)
   
3. Add ROS lib to Python interpreter

   * Show the paths for the remote interpreter
   
   ![](https://tva1.sinaimg.cn/large/008eGmZEgy1gn8bcw8841j30he0grgn0.jpg)
   
   * Add ROS path `/opt/ros/noetic/lib/python3/dist-packages` into python interpreter 
     
   
   ![](https://tva1.sinaimg.cn/large/008eGmZEgy1gn8c63jdtlj30hc06174k.jpg)
   
4. Select remote Python interpreter for your project
   
   * Edit Run/Debug Configurations

   ![](https://tva1.sinaimg.cn/large/008eGmZEgy1gn8bjtmw91j313z06mjth.jpg)
   
   * Select "Remote Python" in the Python interpreter
   
   ![](https://tva1.sinaimg.cn/large/008eGmZEgy1gn8bmds992j30jx03ljrr.jpg)
   
   * And run the code below for test
   
     ```python
     import torch #test torch with cuda
     import tf #test ros tf
     import rospy #test ros rospy
     
     print([torch.cuda.get_device_name(i) for i in range(torch.cuda.device_count())]) #check GPUs
     
     def print_hi(name):
         print(f'Hi, {name}')
     
     if __name__ == '__main__':
         print_hi('PyCharm')
     ```
   
     


## Remote usage for Sheffield student

### Lab GPU sever
For a Lab GPU server with ip `xxxx.xxxx.xxxx.xxxx`

1. connect to the server through `ssh name@xxxx.xxxx.xxxx.xxxx`

2. Run docker to create new repository for yourself `docker run -it --name ros_$YOURNAME --restart=always --gpus all --shm-size=32G -p $TensorboardPORT:6606 -p $JupyterPORT:8888 -p $VNCPORT:80 -v -p $PycharmPORT:22 $PWD:/notebooks silvesterhsu/ros_gpu:noetic-desktop-ubuntu20.04`

   > Replace \$YOURNAME, \$TensorboardPORT, \$JupyterPORT, \$VNCPORT,$PycharmPORT, \$PWD to avoid port conflicts when used by multiple students

3. Visit the Lab GPU server through **browser !!!**
	
	* Remote Desktop: `xxxx.xxxx.xxxx.xxxx:$VNCPORT`
	* Jupyter: `xxxx.xxxx.xxxx.xxxx:$JupyterPORT`
	* TensorBoard: `xxxx.xxxx.xxxx.xxxx:$TensorboardPORT`
	* Pycharm: `xxxx.xxxx.xxxx.xxxx:$PycharmPORT`

