import path from "path";
import fs from "fs";
import { XMLParser } from "fast-xml-parser";
import { Octokit } from "@octokit/rest";
import { assert } from "ts-essentials";
import crypto from "crypto";
import fetch from "node-fetch";
import { program } from "commander";
import { execSync } from "child_process";

export function parseOptions(): {
  upload: boolean;
} {
  program.option("--upload", "Upload the new chocolatey package");
  program.parse(process.argv);
  const options = program.opts();
  return options as any;
}

export async function createNupkgAndUpload(
  packageFolder: string,
  shouldUpload: boolean
) {
  console.log("Creating nupkg...");
  execSync("choco pack", {
    cwd: packageFolder,
  });
  if (shouldUpload) {
    console.log("Uploading nupkg...");
    assert(process.env.CHOCOLATEY_API_KEY, "Need an API key to upload");
    execSync(`choco push --api-key ${process.env.CHOCOLATEY_API_KEY}`, {
      cwd: packageFolder,
    });
  }
}

export async function getSha256(download_url: string): Promise<string> {
  console.log("Downloading installer...");
  const response = await fetch(download_url, {});
  const buffer = await response.arrayBuffer();
  const input = Buffer.from(buffer);
  return crypto.createHash("sha256").update(input).digest("hex");
}

export function getCurrentVersion(nuspecPath: string): string {
  const parser = new XMLParser();

  // synchronously read the file contents
  const nuspecString = fs.readFileSync(nuspecPath, "utf8");
  const nuspec = parser.parse(nuspecString);
  const currentVersion = nuspec.package.metadata.version;
  console.log(`Current version: ${currentVersion}`);

  return currentVersion;
}

const octokit = new Octokit({});
export type GithubReleaseInfo = Awaited<
  ReturnType<typeof octokit.repos.getLatestRelease>
>;
export async function getGithubReleaseInfo(owner: string, repo: string) {
  return await octokit.repos.getLatestRelease({
    owner,
    repo,
  });
}
