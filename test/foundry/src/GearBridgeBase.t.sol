pragma solidity 0.8.28;

import {Test} from "forge-std/src/Test.sol";
import {DeployLancaBridgeHarnessScript} from "../scripts/DeployLancaBridgeHarness.s.sol";
import {LancaBridgeHarness} from "../harnesses/LancaBridgeHarness.sol";
import {console} from "forge-std/src/console.sol";
import {ILancaBridge} from "contracts/bridge/interfaces/ILancaBridge.sol";
import {IConceroClient} from "concero/contracts/ConceroClient/interfaces/IConceroClient.sol";

contract LancaBridgeTestBase is Test {
    uint256 internal constant USDC_DECIMALS = 1e6;

    DeployLancaBridgeHarnessScript internal s_deployLancaBridgeHarnessScript;
    LancaBridgeHarness internal s_lancaBridge;
    address internal s_usdc = vm.envAddress("USDC_BASE");
    uint64 internal s_chainSelectorArb = uint64(vm.envUint("CL_CCIP_CHAIN_SELECTOR_POLYGON"));
    address internal s_lancaBridgeArb = makeAddr("arb lanca bridge");

    function setUp() public virtual {
        vm.createSelectFork(vm.envString("RPC_URL_BASE"), 26000933);

        s_deployLancaBridgeHarnessScript = new DeployLancaBridgeHarnessScript();
        s_lancaBridge = LancaBridgeHarness(s_deployLancaBridgeHarnessScript.run());

        vm.prank(s_deployLancaBridgeHarnessScript.getDeployer());
        s_lancaBridge.setLancaBridgeContract(s_chainSelectorArb, s_lancaBridgeArb);

        deal(s_usdc, s_deployLancaBridgeHarnessScript.getDeployer(), 10_000 * USDC_DECIMALS);
    }

    /* INTERNAL FUNCTIONS */

    function _getBaseLancaBridgeReq() internal returns (ILancaBridge.BridgeReq memory) {
        return
            ILancaBridge.BridgeReq({
                amount: 100 * USDC_DECIMALS,
                token: s_usdc,
                feeToken: s_usdc,
                receiver: makeAddr("receiver"),
                fallbackReceiver: makeAddr("receiver"),
                dstChainSelector: s_chainSelectorArb,
                dstChainGasLimit: 1_000_000,
                message: new bytes(0)
            });
    }

    function _getBaseConceroMessage() internal returns (IConceroClient.Message memory) {
        return
            IConceroClient.Message({
                id: keccak256("message id"),
                srcChainSelector: s_chainSelectorArb,
                sender: makeAddr("sender"),
                data: new bytes(300)
            });
    }
}
