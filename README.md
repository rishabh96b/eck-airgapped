# eck-airgapped
Deploy Elastic Cloud on airgapped K8s.

### Commands
- `eck init --registry 10.0.0.1:5000`
  - This will get the registry and retag the docker images and push to local registry. 
  - It will also parse the template files will the retagged images.
- `eck install operator`
  - install command will install eck operator with default options
- `eck install elasticsearch`
  - install elasticsearch with default options
- `eck install kibana`
  - installs kibana with default options
- `eck logs operator`
  - show the logs for deployed eck operator
