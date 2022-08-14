import path from "path";
import {
  getCurrentVersion,
  getGithubReleaseInfo,
  getSha256,
  GithubReleaseInfo,
  parseOptions,
} from "./shared/release";
import fs from "fs";

const owner = "cryptomator";
const repo = "cryptomator";
const packageFolder = path.join(__dirname, "..", "packages", "cryptomator");
const nuspecPath = path.join(packageFolder, "cryptomator.nuspec");
const installPwshPath = path.join(
  packageFolder,
  "tools",
  "chocolateyinstall.ps1"
);

async function main(): Promise<void> {
  const options = parseOptions();
  const current = getCurrentVersion(nuspecPath);
  const latestRelease = await getGithubReleaseInfo(owner, repo);
  const latestVersion = latestRelease.data.tag_name;
  console.log("Latest version:", latestVersion);

  if (current !== latestVersion) {
    const downloadUrl = getDownloadUrl(latestRelease);
    if (downloadUrl === null) {
      console.log(`No .msi release for ${latestVersion}`);
      return;
    }

    const sha256 = await getSha256(downloadUrl);
    console.log("SHA256:", sha256);

    updatePackage(downloadUrl, sha256, latestVersion);
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
  installPwsh = installPwsh.replace(
    /\$url64bit \= .*/,
    `$url64bit = "${downloadUrl}"`
  );
  installPwsh = installPwsh.replace(
    /\$checksum64 \= .*/,
    `$checksum64 = '${sha}'`
  );
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

function getDownloadUrl(release: GithubReleaseInfo): string | null {
  const asset = release.data.assets.find((asset) =>
    asset.name.endsWith("-x64.msi")
  );
  if (!asset) {
    return null;
  }
  return asset.browser_download_url;
}

main();
