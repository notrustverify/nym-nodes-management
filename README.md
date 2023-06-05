# Nym nodes management


## How to run

_Ansible is an agentless automation tool that you install on a single host (referred to as the control node). From the control node, Ansible can manage an entire fleet of machines and other devices (referred to as managed nodes) remotely with SSH, Powershell remoting, and numerous other transports, all from a simple command-line interface with no databases or daemons required._

Requirements:
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), to not be installed on the server
* [SSH public key](https://git-scm.com/book/en/v2/Git-on-the-Server-Generating-Your-SSH-Public-Key), to be imported on the mixnode or gateway

## mixnode

| Variable | Default | Description |
|---|---|---|
| `WALLET_ADDRESS`  | Mandatory | Nym wallet address used to init the node |
| `NAME_MIXNODE`  | Mandatory  | Mixnode name (id) used when init the node  |
| `VERSION_DOWNLOAD`  | latest | Specify the mixnode version to update |
| `SERVICE_NAME_MIXNODE`  | `nym-mixnode` | Name of the systemd service file  |
| `WORKDIR`  | `/data/nym`  | Path where the nym-mixnode executable is |

### Examples
Specify a version to download

In `--extra-vars` set the version you want: `ansible-playbook playbooks/update-mixnode.yml -i inventory.yml --key-file=ansible-privkey --extra-vars="VERSION_DOWNLOAD=1.1.11"`


Default update: `ansible-playbook playbooks/update-mixnode.yml -i inventory.yml --key-file=ansible-privkey`


## gateway 


| Variable | Default | Description |
|---|---|---|
| `WALLET_ADDRESS`  | Mandatory | Nym wallet address used to init the node |
| `NAME_GATEWAY`  | Mandatory  | Gateway name (id) used when init the node  |
| `VERSION_DOWNLOAD`  | latest | Specify the gateway version to update to |
| `SERVICE_NAME_MIXNODE`  | `nym-gateway` | Name of the systemd service file  |
| `WORKDIR`  | `/data/nym`  | Path where the nym-gateway executable is |


### Examples:

Specify a version to download
In `--extra-vars` set the version you want: `ansible-playbook playbooks/update-gateway.yml -i inventory.yml --key-file=ansible-privkey --extra-vars="VERSION_DOWNLOAD=1.1.11"`

Default update: `ansible-playbook playbooks/update-gateway.yml -i inventory.yml --key-file=ansible-privkey`


## apt update

Requirement:
* Debian or Ubuntu OS

`ansible-playbook playbooks/apt-update.yml -i inventory.yml --key-file=ansible-privkey`



















