## YUL-ERC1155
**Yul implementation of the famous ERC1155 standard in Foundry**

## Usage

### Build

```shell
forge build
```
### Test

```shell
forge test --match-contract "ERC1155_FullSuitTest"
```
For a deeper understanding of the traces, you can run:

```shell
forge test -vvvvv forge test --match-contract "ERC1155_FullSuitTest"
```
### Gas Snapshots

```shell
$ forge snapshot
```
