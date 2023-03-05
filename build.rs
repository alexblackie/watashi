fn main() {
    let version_output = std::process::Command::new("rustc")
        .arg("--version")
        .output()
        .expect("failed to get rustc version");

    let head_commit = std::process::Command::new("git")
        .arg("rev-parse")
        .arg("--short")
        .arg("HEAD")
        .output()
        .expect("failed to get HEAD commit");

    println!("cargo:rustc-env=TOOLCHAIN_VERSION={}", String::from_utf8(version_output.stdout).unwrap());
    println!("cargo:rustc-env=HEAD_COMMIT={}", String::from_utf8(head_commit.stdout).unwrap());
}
