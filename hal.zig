//! Add your abstraction here!

pub const Pin = enum(u8) { // or whatever fits for the HAL
    _,

    /// Compile time lookup of a pin by name.
    pub fn get(comptime name: []const u8) Pin;

    /// Runtime lookup of a pin by name.
    pub fn resolve(name: []const u8) ?Pin;

    /// The corresponding UART instance this pin can be configured to.
    /// - However... What happens when multiple Uarts can be routed to the same pin?
    /// - There's an argument this function shouldn't exist, and it's on the user
    ///   to correctly configure the corresponding pins before using the UART driver,
    ///   and specify the correct Uart instance themselves.
    pub fn to_uart_instance(self: Pin) !uart.Instance;
};

// Pretending we're in uart.zig
pub const uart = struct {

    // Seems like a useful abstraction instead of limiting via a "uN" integer type,
    // there's usually a very reasonable number of UARTs on any one chip so this
    // enum shouldn't be too tedious to populate by hand.
    pub const Instance = enum {
        uart0,
        uart1,
        uart2,
    };

    /// Configuration parameters only relevant to operating the Uart in "dma" mode
    pub const DmaConfig = struct {
        dma_channel: u8,
        // Imagine other relevant params
    };

    /// Configuration parameters only relevant to some other weird Uart mode I haven't thought of
    pub const OtherSpecialConfig = struct {};

    /// I don't love the name, but one possible way to allow extendability
    /// for special configuration modes that go beyond "vanilla" uart usage
    pub const ExtendedConfig = union(enum) {
        dma: DmaConfig,
        other: OtherSpecialConfig,
    };

    pub const Parity = enum {
        none,
        odd,
        even,
    };

    /// Common configuration parameters to all Uart use cases
    pub const Configuration = struct {
        baud_rate: u32,
        parity: Parity,
        stop_bit: bool,
        // Use your imagination for other params :)

        // Allows specific configurations for something like DMA, etc.
        mode_specific: ?ExtendedConfig,
    };

    pub const UART = struct {
        instance: Instance,

        /// What is yall's opinion on this piece of boilerplate?
        /// Pros:
        /// - blocks users from calling write_blockingly/read_blockingly with an error
        ///   if they try to use the HAL without calling init()
        /// Cons:
        /// - There are some edge cases where some users might want to do their own low level config
        ///   themselves at register level, and skip calling init() but still use write_blockingly/read_blockingly
        /// - But if this is the case, would they be using the HAL to begin with...?
        initialized: bool,

        /// Should put the UART peripheral into a state where it's ready to call methods that actually
        /// do something (write some bytes, read some bytes, whatever)
        pub fn init(self: *UART, config: Configuration) !void {

            // Various Uart register writes
            // ...
            //
            self.initialized = true;
        }

        pub fn deinit(self: *UART) void {
            // Returns UART peripheral registers to "reset" state
            self.initialized = false;
        }

        pub fn write_blockingly(uart: UART, chunk: []const u8) !usize;
        pub fn read_blockingly(uart: UART, chunk: []const u8) !usize;
    };
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
