import * as chaiAsPromised from "chai-as-promised";
import * as chaiBignumber from "chai-bignumber";
import * as dirtyChai from "dirty-chai";

export function configureChai(chai: any): void {
  chai.config.includeStack = true;
  chai.use(chaiBignumber());
  chai.use(chaiAsPromised);
  chai.use(dirtyChai);
}

export async function advanceEvmTime(seconds: number): Promise<void> {
    await web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [seconds], id: 123});
    await web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", id: 123});
}