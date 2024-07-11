//! Add your abstraction here!

pub const Pin = enum(u8) { // or whatever fits for the HAL
    _,

    /// Compile time lookup of a pin by name.
    pub fn get(comptime name: []const u8) Pin;

    /// Runtime lookup of a pin by name.
    pub fn resolve(name: []const u8) ?Pin;
};

pub const UART = struct {
    pub fn write_blockingly(uart: UART, chunk: []const u8) !usize;
    pub fn read_blockingly(uart: UART, chunk: []const u8) !usize;
};

pub const I2C_Host = struct {

    // low level:
    pub fn start(i2c: I2C_Host) !void;
    pub fn write_byte(i2c: I2C_Host, byte: u8) !I2C_Acknowledge;
    pub fn read_byte(i2c: I2C_Host, ack: I2C_Acknowledge) !u8;
    pub fn stop(i2c: I2C_Host) !void;
};

pub const I2C_Device = struct {
    //
};

pub const I2C_Acknowledge = enum { nak, ack };

pub const SPI_Host = struct {
    //
};

pub const SPI_Device = struct {
    //
};
