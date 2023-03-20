fn main() {
    let version_output = std::process::Command::new("rustc")
        .arg("--version")
        .output()
        .expect("failed to get rustc version");

    println!("cargo:rustc-env=TOOLCHAIN_VERSION={}", String::from_utf8(version_output.stdout).unwrap());
}
