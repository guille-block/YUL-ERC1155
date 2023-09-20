object "Example_ERC1155" {
  code {
    datacopy(0, dataoffset("Runtime"), datasize("Runtime"))
    return(0, datasize("Runtime"))
  }
  object "Runtime" {
    // Return the calldata
    code {
      switch shr(0xe0, calldataload(0x00))
      case 0x00fdd58e /*balanceOf()*/{
        calldatacopy(0x20, 0x04, 0x20)
        mstore(0x00, keccak256(0x00,0x40))
        calldatacopy(0x20, 0x24, 0x20)
        mstore(0x00, sload(keccak256(0x00,0x40)))
        return(0x00, 0x20)
      }
      case 0x4e1273f4 /*balanceOfBatch*/ {
        balanceBatch()
      }
      case 0xe985e9c5 /*isApprovedForAll*/ {
        mstore(0x00, 0x01)
        calldatacopy(0x20, 0x04, 0x20)
        mstore(0x00, keccak256(0x00,0x40))
        calldatacopy(0x20, 0x24, 0x20)
        mstore(0x00, sload(keccak256(0x00,0x40)))
        return(0x00, 0x20)
      }
      case 0x40c10f19 /*mint*/ {
        mint()
      }
      case 0xa22cb465 /*setApprovalForAll*/ {
        mstore(0x00, 0x01)
        mstore(0x20, caller())
        mstore(0x00, keccak256(0x00,0x40))
        calldatacopy(0x20, 0x04, 0x20)
        sstore(keccak256(0x00,0x40), calldataload(0x24))
        logApproval(calldataload(0x04),calldataload(0x24))
        returnTrue()
      } case 0xf242432a /*safeTransferFrom*/{
        /*Operator check*/
        let operator := operatorCheck(0x04)
        safeTransfer(0x04, 0x24, 0x44, 0x64)
        /*emit event*/
        let sigHash:= 0xc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62
        mstore(0x00, calldataload(0x44))
        mstore(0x20, calldataload(0x64))
        logTransfer(sigHash, calldataload(0x04), calldataload(0x04), calldataload(0x24), 0x00, 0x40)
        callBack(add(calldataload(0x84), 0x04), calldataload(0x24))
        returnTrue()
      } case 0x2eb2c2d6 /*safeBatchTransferFrom*/{
        /*Operator check*/
        let operator := operatorCheck(0x04)
        let fromOffset := 0x04
        let toOffset := 0x24

        let idsOffset := add(calldataload(0x44), 0x04)
        let valuesOffset := add(calldataload(0x64), 0x04)
        let sizeIds := calldataload(idsOffset)
        let sizeValues := calldataload(valuesOffset)
        let freeMemoryForIds := 0xc0
        let freeMemoryForValues := add(0xe0, mul(sizeIds, 0x20))
        lengthCheck(sizeIds, sizeValues)

        for {let i:= 0} lt(i,sizeIds) {i := add(i,1)} {
          let idOffset := add(add(idsOffset, 0x20), mul(i, 0x20))
          let valueOffset := add(add(valuesOffset, 0x20), mul(i, 0x20))
          safeTransfer(fromOffset, toOffset, idOffset, valueOffset)
          freeMemoryForIds := add(freeMemoryForIds, 0x20)
          freeMemoryForValues := add(freeMemoryForValues, 0x20)
          mstore(freeMemoryForIds, calldataload(idOffset))
          mstore(freeMemoryForValues, calldataload(freeMemoryForValues))
        }
        mstore(0x80, 0x40)
        mstore(0xa0, add(mul(sizeIds, 0x20),0x60))
        mstore(0xc0, sizeIds)
        mstore(add(0xe0, mul(sizeIds, 0x20)), sizeValues)
        let sigHash := 0x4a39dc06d4c0dbc64b70af90fd698a233a518aa5d07e595d983b8c0526c8f7fb
        logTransfer(sigHash, calldataload(fromOffset), calldataload(fromOffset), calldataload(toOffset), 0x80, add(add(sizeValues, sizeIds), 0x80))
        callBack(add(calldataload(0x84), 0x04), calldataload(0x24))
        returnTrue()
      } case 0x01ffc9a7 {
        switch shr(0xe0, calldataload(0x04))
        case 0xd9b67a26 {
          mstore(0x00, 0x01)
          return(0x00, 0x01)
        } default {
          return(0x00, 0x20)
        }
      } default {
          revert(0, 0)
      }

      function mint() {
        calldatacopy(0x20, 0x04, 0x20)
        mstore(0x00, keccak256(0x00, 0x40))
        calldatacopy(0x20, 0x24, 0x20)
        let slot := keccak256(0x00, 0x40)
        sstore(slot, add(sload(slot), 1))
        returnTrue()
      }

      function balanceBatch() {
        let addressOffset := add(calldataload(0x04), 0x04)
        let idsOffset := add(calldataload(0x24), 0x04)
        
        let sizeAddresses := calldataload(addressOffset)
        let sizeIds := calldataload(addressOffset)
        lengthCheck(sizeAddresses, sizeIds)

        let freeMemory := 0x80
        let addressMem
        let IdMem

        for { let i := 0 } lt(i, sizeAddresses) { i := add(i, 1) } {
          mstore(0x00, 0x00)
          addressMem := calldataload(add(add(addressOffset, 0x20), mul(i, 0x20)))
          mstore(0x20, addressMem)
          mstore(0x00, keccak256(0x00, 0x40))
          IdMem := calldataload(add(add(idsOffset, 0x20), mul(i, 0x20)))
          mstore(0x20, IdMem)
          let value := sload(keccak256(0x00, 0x40))
          mstore(freeMemory, add(mload(freeMemory), 1))
          mstore(add(add(mul(i, 0x20), 0x20), freeMemory), value)
        }
        mstore(sub(freeMemory, 0x20), 0x20)
        return(sub(freeMemory, 0x20), add(mul(sizeAddresses, 0x20), 0x40))
      }

      function safeTransfer(fromOffset, toOffset, idsOffset, valueOffset) {
        
        /*fix mem and get value*/
        mstore(0x00, 0x00)
        let amount := calldataload(valueOffset)
        /*from check*/
        calldatacopy(0x20, fromOffset, 0x20)
        mstore(0x00, keccak256(0x00, 0x40))
        calldatacopy(0x20, idsOffset, 0x20)
        let slotFrom := keccak256(0x00, 0x40)
        let valPreFrom := sload(slotFrom)
        let valNewFrom := sub(valPreFrom,amount)
        underFlow(valPreFrom, valNewFrom)
        /*to check*/
        mstore(0x00, 0x00)
        calldatacopy(0x20, toOffset, 0x20)
        mstore(0x00, keccak256(0x00, 0x40))
        calldatacopy(0x20, idsOffset, 0x20)
        let slotTo := keccak256(0x00, 0x40)
        let valPreTo := sload(slotTo)
        let valNewTo := add(valPreTo,amount)
        overFlow(valPreTo,valNewTo)
        /*update values*/
        sstore(slotFrom, valNewFrom)
        sstore(slotTo, valNewTo)
      }

      function logApproval(operator, val) {
        let sigHash:= 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31
        mstore(0x00, val)
        log3(0x00, 0x20, sigHash, caller(), operator)
      }

      function logTransfer(sigHash, operator, from, to, dataOffset, dataSize) {
        log4(dataOffset, dataSize, sigHash, operator, from, to)
      }

      function operatorCheck(fromOffset) -> operator {

        let from := calldataload(fromOffset)
        mstore(0x00, 0x01)
        mstore(0x20, from)
        mstore(0x00, keccak256(0x00, 0x40))
        mstore(0x20, caller())
        
        if iszero(add(eq(caller(), from), sload(keccak256(0x00, 0x40)))) {
          revert(0x00, 0x00)
        }

        operator := caller()
      }

      function returnTrue() {
        mstore(0x00, 0x01)
        return(0x00, 0x20)
      }

      function lengthCheck(i, j) {
        //check no zero length
        if iszero(i) {
          revert(0x00, 0x00)
        }
        //check no zero length
        if iszero(j) {
          revert(0x00, 0x00)
        }
        //check matching length
        if iszero(eq(i, j)) {
          revert(0x00, 0x00)
        }
      }

      function overFlow(i,j) {
        if iszero(lt(i,j)) {
          revert(0x00, 0x00)
        }
      }

      function underFlow(i, j) {
         if iszero(gt(i,j)) {
          revert(0x00, 0x00)
        }
      }

      function callBack(dataOffset, to) {
        if gt(extcodesize(to), 0) {
          let sizeByteData := calldataload(dataOffset)
          mstore(0x00, calldataload(add(dataOffset, 0x20)))
          calldatacopy(0x04, 0x04, sub(calldatasize(), 0x04))
          let success := call(gas(), to, 0x00, 0x00, calldatasize(), 0x00, 0x00)
          let expectedData
          switch shr(0xe0, calldataload(0x00))
          case 0xf242432a/*single*/{
            expectedData := 0xf23a6e6100000000000000000000000000000000000000000000000000000000
          }
          case 0x2eb2c2d6 /*batch*/{
            expectedData := 0xbc197c8100000000000000000000000000000000000000000000000000000000
          }
            
          switch success 
          case 1 {
            
            returndatacopy(0x00, 0x00, returndatasize())
            let returnedData := mload(0x00)
            if iszero(eq(returnedData, expectedData)) {
              revert(0x00, 0x00)
            }
          } 
          case 0 {
            revert(0x00, 0x00)
          }
        }
      }
    }
  }
}