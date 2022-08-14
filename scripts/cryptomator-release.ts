import { Octokit } from "@octokit/rest";
import path from "path";
import {
  getCurrentVersion,
  getGithubReleaseInfo,
  getSha256,
  GithubReleaseInfo,
  parseOptions,
} from "./shared/release";

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
  } else {
    console.log("No update available");
  }
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
