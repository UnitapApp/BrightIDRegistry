import { ethers } from "hardhat";
import { UserRegistry } from "../typechain-types";

export async function deployRegistry(
  app: string,
  verificationHash: string,
  nodeAddress: string,
  verificationPeriod: number,
  admin: string,
  setter: string
): Promise<UserRegistry> {
  const Registry = await ethers.getContractFactory("UserRegistry");

  const args = [
    app,
    verificationHash,
    nodeAddress,
    verificationPeriod,
    admin,
    setter,
  ];

  //@ts-ignore
  const registry = await Registry.deploy(...args);

  await registry.deployed();

  console.log("Registry deployed to:", registry.address);

  return registry;
}
