import { assert } from "ts-essentials";
import path from "path";
import {
  createNupkgAndUpload,
  getCurrentVersion,
  getGithubReleaseInfo,
  getSha256,
  GithubReleaseInfo,
  parseOptions,
} from "./shared/release";
import fs from "fs";

const owner = "Depressurizer";
const repo = "Depressurizer";
const packageFolder = path.join(__dirname, "..", "packages", "depressurizer");
const nuspecPath = path.join(packageFolder, "depressurizer.nuspec");
const installPwshPath = path.join(
  packageFolder,
  "tools",
  "chocolateyinstall.ps1"
);

async function main(): Promise<void> {
  const options = parseOptions();
  const current = getCurrentVersion(nuspecPath);
  const latestRelease = await getGithubReleaseInfo(owner, repo);
  const latestVersion = latestRelease.data.tag_name.replace("v", "");
  console.log("Latest version:", latestVersion);

  if (current !== latestVersion) {
    const downloadUrl = getDownloadUrl(latestRelease);
    const sha256 = await getSha256(downloadUrl);
    console.log("SHA256:", sha256);
    updatePackage(downloadUrl, sha256, latestVersion);
    await createNupkgAndUpload(packageFolder, options.upload);
  } else {
    console.log("No update available");
  }
}

function updatePackage(
  downloadUrl: string,
  sha: string,
  version: string
): void {
  let installPwsh = fs.readFileSync(installPwshPath, "utf8");
  installPwsh = installPwsh.replace(/\$url \= .*/, `$url = "${downloadUrl}"`);
  installPwsh = installPwsh.replace(/\$checksum \= .*/, `$checksum = '${sha}'`);
  fs.writeFileSync(installPwshPath, installPwsh);
  console.log("Updated chocolateyinstall.ps1");

  let nuspec = fs.readFileSync(nuspecPath, "utf8");
  nuspec = nuspec.replace(
    /<version>.*<\/version>/,
    `<version>${version}</version>`
  );
  fs.writeFileSync(nuspecPath, nuspec);
  console.log("Updated nuspec");
}

function getDownloadUrl(release: GithubReleaseInfo): string {
  const asset = release.data.assets.find((asset) =>
    asset.name.endsWith(".exe")
  );
  assert(asset);
  return asset.browser_download_url;
}

main();
