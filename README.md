# Robot localisation docker image
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/silvesterhsu/ros-gpu?style=plastic)

A Development environment based on ubuntu 20.04 with the LXDE desktop environment. It contains a deep learning development environments based on pyhton3 ( pytorch). Other framework can be easily be installed through `pip`. Besides, it has a friendly graphical interface and can also run python commands through the terminal.

Docker Link: [ROS GPU](https://hub.docker.com/r/silvesterhsu/ros_gpu)

Github Link: [ROS GPU](https://github.com/SilvesterHsu/docker-ros-gpu)

## LATEST `TAG` Update

### Noetic

* `noetic-base`, `noetic-base-ubuntu20.04`
* `noetic-cuda11.0-runtime`, `noetic-cuda11.0-cudnn8-runtime`, `noetic-cuda11.0-cudnn8-runtime-ubuntu20.04`, `noetic-cuda11.0-runtime-ubuntu20.04`
* `noetic-cuda11.0-devel`, `noetic-cuda11.0-cudnn8-devel`, `noetic-cuda11.0-cudnn8-devel-ubuntu20.04`, `noetic-cuda11.0-devel-ubuntu20.04`
* `noetic-desktop`, `noetic-cuda11.0-desktop`, `noetic-desktop-ubuntu20.04`, `noetic-cuda11.0-desktop-ubuntu20.04`

### Melodic

* `melodic-base`, `melodic-base-ubuntu18.04`
* `melodic-desktop`, `melodic-desktop-ubuntu18.04`

## Why I build it?

* **Docker:** Use docker technology to avoid damage to the computer environment
  
  * No need to install ROS, CUDA, Python and any ML tools
  * Easy remote deployment
  * No need to worry about any damage, in any case, you can re-execute docker run this repository to restore as before
* **UI:** Provide a completed Linux UI interface for easy operation
  * Can remotely connect to its desktop through a **Browser !!!**
  
    > Run on machine A (has GPU), and connect to its desktop in machine B (no GPU) through a browser. (ipad browser also supports)

  * Contains full ROS, you can easily start RViz. And use it as usual.

  * Contains terminal inside, you can easily start `jupyter`
  
  * Contains file system, you can easily change files.

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

### Step 1: Use docker for quick start
```bash
docker run -it --name ros --restart=always --gpus all --shm-size=32G -p $PORT:6606 -p $PORT:8888 -p $PORT:80 -v "$PWD":/notebooks silvesterhsu/ros_gpu:"$TAG"
```
`$PORT`: Port mapping. It is the port that needs to link the local to the image. In docker, jupyter will open port 8888 as a web access. If the local port 8888 is not occupied, it is recommended to use 8888. Similarly, 6006 is the port of tensorboard and 80 is the port of browser.

`$PWD`: File mapping. Project work path

`$TAG`: For the time being, only latest and slim, if not filled in, the latest version is downloaded by default. The ARM version may be available in the future.

> Essential to add `--shm-siz` to set up shared memory size!!! Otherwise, pytorch's multi-threaded Dataloader cannot work.

**Example:**
```bash
docker run -it --name ros --restart=always --gpus all --shm-size=32G -p 6006:6606 -p 8888:8888 -p 6080:80 -v ~/new_project:/notebooks silvesterhsu/ros_gpu:noetic-desktop-ubuntu20.04
```
### Step 2: Access through browser and vnc viewer

**Easy access via browser** (recommended)

Browse http://127.0.0.1:6080/ to connect to the desktop inside this repository.

**Access via VNC**
Forward VNC service port 5900 to host by adding `-p 5900:5900` in the docker run.

VNC password is also supported. Set by environment variables `-e VNC_PASSWORD=passwd`.
### Step 3: Start a Jupyter notebook (optional)

**Jupyter Icon** (recommended)

Double-click the Jupyter icon on the desktop. And browse http://127.0.0.1:8888/

> By default, a warning will pop up asking how to open it. You can choose `Execute`.
>
> How to permanently turn off reminders: 
>
> 1. Open `file manager` in the lower left corner
> 2. Choose `Edit` --> `Preferences`
> 3. Click `Don't ask options on launch executable file`
> 4. Warning will never pop up when you start Jupyter or RViz

**Terminal**


You can connect via `docker exec -it ros /bin/bash`, or use the *Terminator* in the graphical interface to start jupyter.
```bash
jupyter notebook --ip=0.0.0.0 --allow-root
```
**Note:** if you use docker to connect, you need to load the **ROS environment** first by
```bash
source /opt/ros/noetic/setup.bash
```
### Step 4: Terminal (optional)
Connect via `docker exec -it ros /bin/bash`.



## Remote usage for Sheffield student

### Lab GPU sever
For a Lab GPU server with ip `xxxx.xxxx.xxxx.xxxx`

1. connect to the server through `ssh name@xxxx.xxxx.xxxx.xxxx`

2. Run docker to create new repository for yourself `docker run -it --name ros_$YOURNAME --restart=always --gpus all --shm-size=32G -p $TensorboardPORT:6606 -p $JupyterPORT:8888 -p $VNCPORT:80 -v $PWD:/notebooks silvesterhsu/ros_gpu:noetic-desktop-ubuntu20.04`

   > Replace \$YOURNAME, \$TensorboardPORT, ​\$JupyterPORT, ​\$VNCPORT,  ​\$PWD to avoid conflicts when used by multiple students

3. Visit the Lab GPU server through **browser !!!**
	
	* Remote Desktop: `xxxx.xxxx.xxxx.xxxx:$VNCPORT`
	* Jupyter: `xxxx.xxxx.xxxx.xxxx:$JupyterPORT`
	* TensorBoard: `xxxx.xxxx.xxxx.xxxx:$TensorboardPORT`