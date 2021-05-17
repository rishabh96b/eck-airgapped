# eck-airgapped
Deploy Elastic Cloud on airgapped K8s.

## Getting Started
1. Clone the repo `git clone https://github.com/rishabh96b/eck-airgapped.git`
2. Create image artifacts locally by running
```bash
~ cd eck-resources/
~ ./build-images.sh
```
4. Transfer the `eck-resources` folder to the bastion host using `scp`
```bash
scp -o StrictHostKeyChecking=accept-new ~/path-to/eck-airgapped/eck-resources $USER@$HOST:/path-to/eck-resources
```
3. Go inside the `eck-resouces` dir and run `./eck.sh`


### Commands
- `./eck.sh init --registry 10.0.0.1:5000`
  - This will get the registry and retag the docker images and push to local registry.
  - It will also parse the template files will the retagged images.
- `./eck.sh install operator`
  - Installs eck operator with default options
- `./eck.sh install elasticsearch`
  - Installs elasticsearch with default options
- `./eck.sh install kibana`
  - Installs kibana with default options
- `./eck.sh logs operator`
  - Show the logs for deployed eck operator
