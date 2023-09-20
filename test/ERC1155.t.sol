pragma solidity >=0.8;
import "forge-std/Test.sol";
import "./lib/YulDeployer.sol";
import "../src/ERC1155_NFT.sol";
import "../src/ERC1155_Receiver.sol";

interface ERC1155_events {
    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    event URI(string _value, uint256 indexed _id);
}

interface Example_ERC1155 {}

contract ERC1155_deploy is Test {
    ERC1155_NFT public erc1155;

    YulDeployer yulDeployer = new YulDeployer();

    function setUp() public virtual {
        erc1155 = ERC1155_NFT(yulDeployer.deployContract("Example_ERC1155"));
    }
}
