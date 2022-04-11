// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface IStargateRouter {
    function swap(
        uint16 _dstChainId,
        uint256 _srcPoolId,
        uint256 _dstPoolId,
        address payable _refundAddress,
        uint256 _amountLD,
        uint256 _minAmountLD,
        lzTxObj memory _lzTxParams,
        bytes calldata _to,
        bytes calldata _payload
    ) external payable;

    struct lzTxObj {
        uint256 dstGasForCall;
        uint256 dstNativeAmount;
        bytes dstNativeAddr;
    }
}

contract StargateBridge {
    using SafeERC20 for IERC20;

    function swap(address receiverAddress) public payable {
        _approveToken(
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            0x8731d54E9D02c286767d56ac03e8037C07e01e98,
            1000000000
        );

        IStargateRouter(0x8731d54E9D02c286767d56ac03e8037C07e01e98).swap{
            value: msg.value
        }(
            9, // send to Fuji (use LayerZero chainId)
            1, // source pool id
            2, // dest pool id
            payable(msg.sender), // refund adddress. extra gas (if any) is returned to this address
            1000000000, // quantity to swap
            5, // the min qty you would accept on the destination
            IStargateRouter.lzTxObj(0, 0, "0x"), // 0 additional gasLimit increase, 0 airdrop, at 0x address
            abi.encodePacked(receiverAddress), // the address to send the tokens to on the destination
            bytes("") // bytes param, if you wish to send additional payload you can abi.encode() them here
        );
    }

    function _approveToken(
        address _token,
        address _spender,
        uint256 _amount
    ) internal {
        if (IERC20(_token).allowance((address(this)), _spender) > 0) {
            IERC20(_token).safeApprove(_spender, 0);
            IERC20(_token).safeApprove(_spender, _amount);
        } else {
            IERC20(_token).safeApprove(_spender, _amount);
        }
    }
}
