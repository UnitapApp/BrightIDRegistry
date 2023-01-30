import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers, network } from "hardhat";
import { deployRegistry } from "../scripts/deployers";
import { UserRegistry } from "../typechain-types";
import { expect } from "chai";
import { setNextBlockTimestamp } from "@nomicfoundation/hardhat-network-helpers/dist/src/helpers/time";
import { increaseTime } from "./timeUtils";

describe("RegistryTest", async () => {
  let registry: UserRegistry;
  let admin: SignerWithAddress;
  let setter: SignerWithAddress;
  let user: string;
  let nodeAddress: string;
  let verificationTimestamp: number;
  let verificationHash: string;
  let app: string;

  let sigR: string;
  let sigS: string;
  let sigV: number;

  async function setupRegistry() {
    registry = await deployRegistry(
      app,
      verificationHash,
      nodeAddress,
      300,
      admin.address,
      setter.address
    );
  }

  before(async () => {
    [admin, setter] = await ethers.getSigners();

    app = "unitapTest";
    verificationHash =
      "0x501d93d62115b06f5ceb1dd25f831dc7bbf0478ce81303c1b3a2172cdff6e465";
    user = "0xB10f8E218A9cD738b0F1E2f7169Aa3c0897F2d83";
    verificationTimestamp = 1672834200;
    nodeAddress = "0xb1d71F62bEe34E9Fc349234C201090c33BCdF6DB";
    sigR = "0xca5bf2a09abff8a3b154645e40b54a4b0c443c4ddef3a4a9967af1e94ddef422";
    sigS = "0x01dd9f94456a248183699798a0f9a175277f0154574c6cb64ee638226abc0d66";
    sigV = 28;

    await setupRegistry();
  });

  it("it should verify the user", async () => {
    await registry.verify(user, verificationTimestamp, sigR, sigS, sigV);

    const isVerified = await registry.isVerified(user);
    expect(isVerified).to.be.true;
  });

  it("should not be verified if epoch changed", async () => {
    await increaseTime(300);
    const isVerified = await registry.isVerified(user);
    expect(isVerified).to.be.false;
  });
});
