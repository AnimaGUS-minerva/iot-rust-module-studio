fn main() -> std::io::Result<()> {
    println!("src/bin/emu.rs::main(): ^^");

    mcu_emu::run_with_qemu("riot.esp32.bin")?;

    Ok(())
}