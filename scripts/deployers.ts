import { ethers } from "hardhat";

export async function deployRegistry(
  app: string,
  verificationHash: string,
  nodeAddress: string,
  admin: string,
  setter: string
) {
  const Registry = await ethers.getContractFactory("Registry");

  const args = [app, verificationHash, nodeAddress, admin, setter];

  //@ts-ignore
  const registry = await Registry.deploy(...args);

  await registry.deployed();

  console.log("Registry deployed to:", registry.address);
}
