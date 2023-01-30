import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";

describe("RegistryTest", async () => {
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

  before(async () => {
    [admin, setter] = await ethers.getSigners();

    app = "unitapTest";
    verificationHash =
      "0x501d93d62115b06f5ceb1dd25f831dc7bbf0478ce81303c1b3a2172cdff6e465";
    user = "0xB10f8E218A9cD738b0F1E2f7169Aa3c0897F2d83";
    verificationTimestamp = 1672834200;

    sigR = "0xca5bf2a09abff8a3b154645e40b54a4b0c443c4ddef3a4a9967af1e94ddef422";
    sigS = "0x01dd9f94456a248183699798a0f9a175277f0154574c6cb64ee638226abc0d66";
    sigV = 28;
  });
});
