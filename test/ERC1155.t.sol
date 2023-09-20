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

contract ERC1155_transfer is Test, ERC1155_deploy, ERC1155_events {
    address bob = address(1);
    address alice = address(2);

    function setUp() public virtual override {
        super.setUp();
        erc1155.mint(bob,0);
    }

    function test_balance() public {
        assertEq(erc1155.balanceOf(bob, 0), 1);
    }

    function test_transfer() public {
        vm.prank(bob);
        vm.expectEmit(true, true, true, false);
        emit TransferSingle(bob, bob, alice, 0, 1);
        erc1155.safeTransferFrom(bob, alice, 0, 1, "");
        assertEq(erc1155.balanceOf(bob, 0), 0);
        assertEq(erc1155.balanceOf(alice, 0), 1);
    }

    function test_batchTransfer() public {
        erc1155.mint(bob,1);
        
        uint256[] memory ids = new uint256[](2);
        ids[0] = 0;
        ids[1] = 1;

        uint256[] memory quants = new uint256[](2);
        quants[0] = 1;
        quants[1] = 1;
        vm.prank(bob);
        vm.expectEmit(true, true, true, false);
        emit TransferBatch(bob, bob, alice, ids, quants);
        erc1155.safeBatchTransferFrom(bob, alice, ids, quants, "");
        //set expected results
        address[] memory addresses = new address[](4);
        addresses[0] = bob;
        addresses[1] = alice;
        addresses[2] = bob;
        addresses[3] = alice;

        uint256[] memory test_ids = new uint256[](4);
        test_ids[0] = 0;
        test_ids[1] = 0;
        test_ids[2] = 1;
        test_ids[3] = 1;

        uint256[] memory results = new uint256[](4);
        results[0] = 0;
        results[1] = 1;
        results[2] = 0;
        results[3] = 1;

        assertEq(erc1155.balanceOfBatch(addresses, test_ids), results);
    }
}

