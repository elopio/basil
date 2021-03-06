#! /usr/bin/env bash

# Enable command logging.
set -x

NETWORK=$1
INJECT_ZOS=$2
OWNER=$3

# Util to trace accounts.
# echo "console.log(web3.eth.accounts)" | truffle console --network $NETWORK
# exit

# -----------------------------------------------------------------------
# Project setup and first implementation of an upgradeable Basil.sol
# -----------------------------------------------------------------------

# Clean up zos.* files
rm -f zos.json
rm -f zos.$NETWORK.json

# Compile all contracts.
rm -rf build && npx truffle compile

# Initialize project
# NOTE: Creates a zos.json file that keeps track of the project's details
zos init Basil 0.0.1

# Register Basil.sol in the project as an upgradeable contract.
zos add Basil

# Deploy all implementations in the specified network.
# NOTE: Creates another zos.<network_name>.json file, specific to the network used, which keeps track of deployed addresses, etc.
zos push --from $OWNER --network $NETWORK --skip-compile

# Request a proxy for the upgradeably Basil.sol
# NOTE: A dapp could now use the address of the proxy specified in zos.<network_name>.json
zos create Basil --from $OWNER --init --args $OWNER --network $NETWORK

# Disable command logging
set +x
