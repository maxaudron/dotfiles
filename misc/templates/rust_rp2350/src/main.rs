#![no_std]
#![no_main]

use rp235x_hal as hal;

use defmt_rtt as _;
#[cfg(all(target_arch = "arm", target_os = "none"))]
use panic_probe as _;

/// Tell the Boot ROM about our application
#[unsafe(link_section = ".start_block")]
#[used]
pub static IMAGE_DEF: hal::block::ImageDef = hal::block::ImageDef::secure_exe();

/// External high-speed crystal on the Raspberry Pi Pico 2 board is 12 MHz.
/// Adjust if your board has a different frequency
const XTAL_FREQ_HZ: u32 = 12_000_000u32;

#[rtic::app(device = crate::hal::pac)]
mod app {
    use super::*;
    use defmt::info;

    #[shared]
    struct Shared {}

    #[local]
    struct Local {}

    #[init()]
    fn init(c: init::Context) -> (Shared, Local) {
        info!("program start");

        unsafe {
            hal::sio::spinlock_reset();
        }

        // ------------------------------------
        // Setup core hardware

        let mut resets = c.device.RESETS;
        let mut watchdog = hal::watchdog::Watchdog::new(c.device.WATCHDOG);
        let sio = hal::Sio::new(c.device.SIO);

        // External high-speed crystal on the pico board is 12Mhz
        let clocks = hal::clocks::init_clocks_and_plls(
            crate::XTAL_FREQ_HZ,
            c.device.XOSC,
            c.device.CLOCKS,
            c.device.PLL_SYS,
            c.device.PLL_USB,
            &mut resets,
            &mut watchdog,
        )
        .ok()
        .unwrap();

        let mut timer = hal::Timer::new_timer0(c.device.TIMER0, &mut resets, &clocks);

        let pins = Pins::new(
            c.device.IO_BANK0,
            c.device.PADS_BANK0,
            sio.gpio_bank0,
            &mut resets,
        );

        info!("core initialization finished");
        (Shared {}, Local {})
    }
}

hal::bsp_pins!(
    Gpio32 { name: mux_enable },
    Gpio31 { name: mux_s0 },
    Gpio30 { name: mux_s1 },
    Gpio29 { name: mux_s2 },
    Gpio33 { name: led },
    Gpio44 { name: mux1_com },
    Gpio43 { name: mux2_com },
    Gpio42 { name: mux3_com },
    Gpio41 { name: mux4_com },
    Gpio34 { name: d_cs },
    Gpio35 { name: d_dc },
    Gpio36 { name: d_rst },
    Gpio37 { name: d_sda },
    Gpio38 { name: d_scl },
    Gpio4 { name: i2c_sda },
    Gpio5 { name: i2c_sdl },
    Gpio6 { name: i2c_sda_acc },
    Gpio7 { name: i2c_sdl_acc },
    Gpio8 { name: handedness },
);

/// Program metadata for `picotool info`
#[unsafe(link_section = ".bi_entries")]
#[used]
pub static PICOTOOL_ENTRIES: [hal::binary_info::EntryAddr; 5] = [
    hal::binary_info::rp_cargo_bin_name!(),
    hal::binary_info::rp_cargo_version!(),
    hal::binary_info::rp_program_description!(c"Hall Effect Firmware"),
    hal::binary_info::rp_cargo_homepage_url!(),
    hal::binary_info::rp_program_build_attribute!(),
];
