//SPDX-License-Identifier: MIT
// For testing in Arbytrum: Forge test -vvvv --fork-url https://arb1.arbitrum.io/rpc --match-test

pragma solidity 0.8.28;

import "../src/IV2Router02.sol";
import "../src/IFactory.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
contract LiquidityPool {
    using SafeERC20 for IERC20;

    address public addressV2Router02; // Router address where the functions are.
    address public addressUniswapFactory;
    address USDT;
    address DAI; 

    event SwapTokens(address tokenIn,address tokenOut,uint256 amountIn,uint256 amountOut);
    event AddLiquidity(uint256 amountAIn, uint256 amountBIn,uint256 lpTokens);
    event RemoveLiquidity(uint256 amountDAI, uint256 amountUSDT);
    constructor(address addressV2Router02_, address addressUniswapFactory_,address USDT_, address DAI_){
        addressV2Router02 = addressV2Router02_;
        addressUniswapFactory = addressUniswapFactory_;
        USDT = USDT_;
        DAI = DAI_;
    }
    function swapTokens(uint256 amountIn_,uint256 amountOutMin_,address[] memory path_,address to_,uint256 deadline_) public returns(uint256){
        // We need to send the token to the contract to be swapped.
        IERC20(path_[0]).safeTransferFrom(msg.sender, address(this), amountIn_); // We dont need to approve nothing here. The sender will aprove this contract in the moment the function is called.
        IERC20(path_[0]).approve(addressV2Router02, amountIn_);
        uint256[] memory amountOut= IV2Router02(addressV2Router02).swapExactTokensForTokens(amountIn_, amountOutMin_, path_, to_, deadline_);
        uint256 outputAmount = amountOut[amountOut.length-1];
        
        emit SwapTokens(path_[0], path_[path_.length-1], amountIn_, amountOut[amountOut.length-1]);
        return outputAmount;
    }
    function addLiquidityUSDT(address[] memory path_,uint256 amountIn_,uint256 amountOutMin_,uint amountAMin_,uint amountBMin_,uint deadline_) external{
        // Add 1 token and swapp the half as we must have both tokens to add the liquidity.
        // With the following line I add the USDT part that will be included in the pool.
        IERC20(USDT).safeTransferFrom(msg.sender, address(this), amountIn_/2);
        // The other half which will be swapped for DAI is transferred within the swapTokens function.
        uint256 swappedAmount = swapTokens(amountIn_/2,amountOutMin_,path_,address(this),deadline_);
        // Add liquidity to receive LP Tokens
        IERC20(USDT).approve(addressV2Router02, amountIn_/2);
        IERC20(DAI).approve(addressV2Router02, swappedAmount);
        (,,uint amountLpTokens) = IV2Router02(addressV2Router02).addLiquidity(USDT, DAI, amountIn_/2, swappedAmount, amountAMin_, amountBMin_, msg.sender, deadline_);  
        emit AddLiquidity(amountIn_/2, swappedAmount, amountLpTokens);
    }
    function addLiquidity(uint256 amountInTokenA_,uint256 amountInTokenB_,uint amountAMin_,uint amountBMin_,uint deadline_) external{
        // With the following line I add the USDT part that will be included in the pool.
        IERC20(USDT).safeTransferFrom(msg.sender, address(this), amountInTokenA_);
        IERC20(DAI).safeTransferFrom(msg.sender, address(this), amountInTokenB_);
        // Add liquidity to receive LP Tokens
        IERC20(USDT).approve(addressV2Router02, amountInTokenA_);
        IERC20(DAI).approve(addressV2Router02, amountInTokenB_);
        (,,uint amountLpTokens) = IV2Router02(addressV2Router02).addLiquidity(USDT, DAI, amountInTokenA_, amountInTokenB_, amountAMin_, amountBMin_, msg.sender, deadline_);  
        emit AddLiquidity(amountInTokenA_, amountInTokenB_, amountLpTokens);
    }
    function removeLiquidity(uint liquidity_, uint amountAMin_,uint amountBMin_, uint deadline_) external{
        address pairAdress = IFactory(addressUniswapFactory).getPair(USDT,DAI);
        IERC20(pairAdress).safeTransferFrom(msg.sender, address(this), liquidity_);
        IERC20(pairAdress).approve(addressV2Router02, liquidity_);
        (uint amountUSDT,uint amountDAI) = IV2Router02(addressV2Router02).removeLiquidity(USDT, DAI, liquidity_, amountAMin_, amountBMin_, msg.sender, deadline_);
        emit RemoveLiquidity(amountDAI/1e18, amountUSDT/1e6);
    }

}