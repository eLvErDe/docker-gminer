# nvidia-docker image for GMiner Equihash (BEAM, BTG) / CuckooCycle (AE, SWAP, GRIN29, GRIN31) miner

This image build [GMiner] from its [GitHub].
It requires a CUDA compatible docker implementation so you should probably go
for [nvidia-docker].

## Build images

```
git clone https://github.com/eLvErDe/docker-gminer
cd docker-gminer
docker build -t gminer .
```

## Publish it somewhere

```
docker tag gminer docker.domain.com/mining/gminer:latest
docker push docker.domain.com/mining/gminer:latest
```

## Test it (using dockerhub published image)

```
nvidia-docker pull acecile/gminer-cuda
nvidia-docker run -it --rm acecile/gminer-cuda /root/miner --help
```

An example command line to mine using GRIN31 on grinmint.com (replace email and password):
Check gminer's [examples] for more.
```
nvidia-docker run -it --rm --name gminer acecile/gminer /root/miner --algo grin31 --server eu-west-stratum.grinmint.com --port 3416 --user <valid-email@address> --pass <random-password> --api 4068 --cuda=1 --templimit=95 --color=0 --watchdog=1
```

Ouput will looks like:
```
+----------------------------------------------------------------+
|                          GMiner v1.36                          |
+----------------------------------------------------------------+
Algorithm:          Cuckatoo 31 "Grin"
Stratum server:     
  host:             stratum://eu-west-stratum.grinmint.com:3416
  user:             valid-email@address
  password:         random-password
Power calculator:   on
Color output:       off
Watchdog:           on
API:                http://127.0.0.1:4068
Log to file:        off
Selected devices:   GPU0
Intensity:          100 
Temperature limits: 95C 
------------------------------------------------------------------
15:00:59 Connected to eu-west-stratum.grinmint.com:3416
15:00:59 Authorized on Stratum Server
15:00:59 New Job: 14 Difficulty: 4
15:00:59 Started Mining on GPU0: ASUS GeForce GTX 1080 Ti 11GB
15:01:14 New Job: 15 Difficulty: 4
15:01:29 New Job: 16 Difficulty: 4
15:01:29 Temperature: GPU0 45C
15:01:29 Speed: GPU0 0.60 G/s
15:01:29 Accepted Shares: GPU0 0
15:01:29 Rejected Shares: GPU0 0
15:01:29 Fidelity: GPU0 0.000
15:01:29 Power: GPU0 141W 0.00 G/W
15:01:29 Total Speed: 0.60 G/s Fidelity: 0.000 Shares Accepted: 0 Rejected: 0 Power: 141W 0.00 G/W
```

## Background job running forever

```
nvidia-docker run -dt --restart=unless-stopped -p 4068:4068 --name gminer acecile/gminer /root/miner --algo grin31 --server eu-west-stratum.grinmint.com --port 3416 --user <valid-email@address> --pass <random-password> --api 4068 --cuda=1 --templimit=95 --color=0 --watchdog=1
```

You can check the output using `docker logs gminer -f`


You can check CUDA usage on the host by running `nvidia-smi` there:

```
Tue Apr  2 17:05:15 2019       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 390.87                 Driver Version: 390.87                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 108...  On   | 00000000:82:00.0 Off |                  N/A |
| 31%   66C    P2   118W / 185W |   7466MiB / 11178MiB |    100%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0     28612      C   /root/miner                                 7455MiB |
+-----------------------------------------------------------------------------+
```

[GMiner]: https://bitcointalk.org/index.php?topic=5034735.0
[GitHub]: https://github.com/develsoftware/GMinerRelease
[nvidia-docker]: https://github.com/NVIDIA/nvidia-docker
[example]: https://bitcointalk.org/index.php?topic=5034735.0
