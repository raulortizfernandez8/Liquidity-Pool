//SPDX-License-Identifier: MIT
// Forge test -vvvv --fork-url https://arb1.arbitrum.io/rpc --match-test nombredelafuncionparatestear
pragma solidity 0.8.28;

import "../lib/forge-std/src/Test.sol";
import "../src/LiquidityPool.sol";

contract LiquidityPoolTest is Test{

    LiquidityPool liquipool;
    address V2Routeraddress_ = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24; // This can be found in Uniswap docs.
    address UniswapFactoryaddress_ = 0xf1D7CC64Fb4452F05c498126312eBE29f30Fbcf9;
    address userWithUSDT = 0xab04AA25533401977F8E0350A9b9B1D7f145f69c; // This address contains USDT
    address USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // This is the USDT address
    address DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // This is the DAI address
    function setUp() public{
        liquipool = new LiquidityPool(V2Routeraddress_,UniswapFactoryaddress_,USDT,DAI);
    }   
    function testDeployedCorrectly() public view{
        assert(liquipool.addressV2Router02() == V2Routeraddress_);
        assert(liquipool.addressUniswapFactory() == UniswapFactoryaddress_);
    }
    function testSwapToken() public{
        vm.startPrank(userWithUSDT);

        uint256 amountIn = 3*1e6; // USDT has 6 decimals
        uint256 amountOutMin = 0; // DAI has 18 decimals.
        address [] memory path = new address[](2);
        path[0]= USDT;
        path[1]=DAI;
        uint256 deadline = block.timestamp + 10000;

        IERC20(USDT).approve(address(liquipool),amountIn);
        uint256 balanceBeforeUSDT = IERC20(USDT).balanceOf(userWithUSDT);
        uint256 balanceBeforeDAI = IERC20(DAI).balanceOf(userWithUSDT);
        
        uint256 output = liquipool.swapTokens(amountIn, amountOutMin, path, userWithUSDT,deadline);
        IERC20(DAI).transfer(userWithUSDT, output);
        uint256 balanceAfterUSDT = IERC20(USDT).balanceOf(userWithUSDT);
        uint256 balanceAfterDAI = IERC20(DAI).balanceOf(userWithUSDT);
        assert(balanceBeforeUSDT==balanceAfterUSDT+amountIn);
        assertGt(balanceAfterDAI,balanceBeforeDAI);
        vm.stopPrank();
    }
    function testAddLiquidityUSDT() public{
         vm.startPrank(userWithUSDT);

            uint256 amountIn = 3*1e6; // USDT has 6 decimals
            uint256 amountOutMin = 1*1e18; // DAI has 18 decimals.
            uint256 amountAMin = 0;
            uint256 amountBMin = 0;
            address [] memory path = new address[](2);
            path[0]= USDT;
            path[1]=DAI;
            uint256 deadline = block.timestamp + 10000;
            IERC20(USDT).approve(address(liquipool),amountIn);
            liquipool.addLiquidityUSDT(path,amountIn,amountOutMin,amountAMin,amountBMin,deadline);
            vm.stopPrank();
    }
    function testAddLiquidity() public{
         vm.startPrank(userWithUSDT);

            uint256 amountInTokenA = 1*1e6; // USDT has 6 decimals
            uint256 amountInTokenB = 1*1e18; // DAI has 18 decimals.
            uint256 amountAMin = 0;
            uint256 amountBMin = 0;
            address [] memory path = new address[](2);
            path[0]= USDT;
            path[1]=DAI;
            uint256 deadline = block.timestamp + 10000;
            IERC20(USDT).approve(address(liquipool),amountInTokenA);
            IERC20(DAI).approve(address(liquipool),amountInTokenB);
            liquipool.addLiquidity(amountInTokenA,amountInTokenB,amountAMin,amountBMin,deadline);
            vm.stopPrank();
    }
      function testRemoveLiquidity() public{
         vm.startPrank(userWithUSDT);

            uint256 amountIn = 3*1e6; // USDT has 6 decimals
            uint256 amountOutMin = 1*1e18; // DAI has 18 decimals.
            uint256 amountAMin = 0;
            uint256 amountBMin = 0;
            address [] memory path = new address[](2);
            path[0]= USDT;
            path[1]=DAI;
            uint256 deadline = block.timestamp + 10000;
            IERC20(USDT).approve(address(liquipool),amountIn);
            liquipool.addLiquidityUSDT(path,amountIn,amountOutMin,amountAMin,amountBMin,deadline);
            address pair = IFactory(UniswapFactoryaddress_).getPair(USDT,DAI);
            uint256 lpTokens = IERC20(pair).balanceOf(userWithUSDT);
            uint256 USDTBefore = IERC20(USDT).balanceOf(userWithUSDT);
            uint256 DAIBefore = IERC20(DAI).balanceOf(userWithUSDT);
            IERC20(pair).approve(address(liquipool), lpTokens);
            liquipool.removeLiquidity(lpTokens, amountAMin, amountBMin, deadline);
            uint256 USDTAfter = IERC20(USDT).balanceOf(userWithUSDT);
            uint256 DAIAfter = IERC20(DAI).balanceOf(userWithUSDT);
            assertGt(USDTAfter , USDTBefore,"The USDT balance has not increased");
            assertGt(DAIAfter , DAIBefore,"The DAI balance has not increased");
            vm.stopPrank();
    }

}
